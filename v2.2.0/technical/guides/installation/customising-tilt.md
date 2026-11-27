# Customising Tilt

This page explains how to add your own resources to the local environment, for example a companion application, an extra Helm chart or an optional OpenCRVS service, without editing the Tilt files that come with your country configuration.

If you have not used Tilt yet, read [Working with Tilt](working-with-tilt.md) first.

### Why a separate file

The `Tiltfile` and the files in `tilt/` (`common.tilt`, `lib.tilt`, `opencrvs.tilt` and `tilt/examples/`) are maintained by OpenCRVS and replaced when you upgrade. Changes you make in them are lost or cause merge conflicts.

Put everything that is specific to your country in `tilt/custom.tilt` instead. The `Tiltfile` includes this file after OpenCRVS is set up, so it can add to, but does not change, what OpenCRVS deploys. Upgrades leave `tilt/custom.tilt` and `tilt/helm/` unchanged.

| Path                | Owner       | Purpose                                                              |
| ------------------- | ----------- | -------------------------------------------------------------------- |
| `Tiltfile`          | OpenCRVS    | Builds your country configuration and deploys OpenCRVS.              |
| `tilt/*.tilt`       | OpenCRVS    | Shared Tilt logic.                                                   |
| `tilt/examples/`    | OpenCRVS    | Default Helm values. Do not edit.                                    |
| `tilt/helm/`        | You         | Overrides of the default Helm values.                                |
| `tilt/custom.tilt`  | You         | Extra Tilt resources, such as additional applications and Helm charts. |

### Enable your customisation

The `Tiltfile` ends with an include of `tilt/custom.tilt`, which Tilt skips when the file does not exist:

```python
if os.path.exists('./tilt/custom.tilt'):
  include('./tilt/custom.tilt')
```

To start customising, create `tilt/custom.tilt` and run `tilt up`. Tilt reloads the file whenever you save it.

{% hint style="info" %}
Relative paths inside `tilt/custom.tilt` resolve from the `tilt/` directory, as in the other `.tilt` files. To refer to a directory next to your `src/` folder, use `../`, for example `../my-app`.
{% endhint %}

### Add an application

This example builds an application from the `my-app` directory of your repository, deploys it with its own Helm chart next to OpenCRVS and exposes it in the Tilt UI.

```python
# tilt/custom.tilt

app_image = "my-org/my-app"
app_tag = "local"
app_namespace = os.getenv("MY_APP_NAMESPACE", "opencrvs-dev")
app_hostname = os.getenv("MY_APP_HOSTNAME", "opencrvs.localhost")

def setup_my_app():
  # Build the image from ../my-app. Tilt rebuilds it when the files change.
  docker_build(
    "{}:{}".format(app_image, app_tag),
    "../my-app",
    dockerfile="../my-app/Dockerfile",
    network="host",
    ignore=["**/node_modules", "**/dist"],
  )

  # Deploy the Helm chart with the image that was just built
  k8s_yaml(helm(
    "../my-app/chart",
    name="my-app",
    namespace=app_namespace,
    set=[
      "image.name={}".format(app_image),
      "image.tag={}".format(app_tag),
      "hostname={}".format(app_hostname),
    ],
  ))

  # Show it in the Tilt UI, in its own group, and open port 3069 on your computer
  k8s_resource("my-app", port_forwards=["3069:80"], labels=["6.My-app"])

setup_my_app()
```

Things to keep in mind:

* **The image name and tag must match the chart.** Tilt replaces an image in the rendered Kubernetes manifests only when the name matches the one you build.
* **Group your resources.** The Tilt UI uses groups `1.OpenCRVS` to `5.Traefik`. You may add application to any of the existing groups or create new label.
* **Route through Traefik.** If your chart creates a Traefik `IngressRoute`, put it in a resource of its own that waits for `traefik`, because the route needs the Traefik CRDs:

```python
k8s_resource(
  objects=["my-app:ingressroute"],
  new_name="my-app-ingress-route",
  resource_deps=["traefik"],
  labels=["5.Traefik"],
)
```

### Use a Helm chart from another repository

If the chart of your application lives in another Git repository, for example your infrastructure repository, check out only the `charts` directory once, the same way the `Tiltfile` does for the OpenCRVS Core charts:

```python
charts_dir = ".my-app-charts"
charts_repo_url = "https://github.com/my-org/my-infrastructure.git"
charts_ref = os.getenv("MY_APP_CHARTS_REF", "main")
charts_marker = "{}/.tilt-ref-{}".format(charts_dir, charts_ref.replace("/", "_"))

# Tilt re-evaluates this file on every reload, so clone only once per ref
if not os.path.exists(charts_marker):
  local("""
    set -e
    rm -rf {dir}
    git clone --depth 1 --filter=blob:none --sparse --branch {ref} {url} {dir}
    git -C {dir} sparse-checkout set charts
    touch {marker}
  """.format(dir=charts_dir, ref=charts_ref, url=charts_repo_url, marker=charts_marker))

chart_path = "{}/charts/my-app".format(charts_dir)
if not os.path.exists("{}/Chart.yaml".format(chart_path)):
  fail("Chart not found in {}, delete {} and reload Tilt to clone it again".format(chart_path, charts_dir))
```

Then pass `chart_path` to `helm()` as in the previous example. Add the checkout directory to `.gitignore` (for example `tilt/.my-app-charts`), as it is downloaded again on demand. To fetch the chart again, delete the directory or change the ref variable.

Use `git -C <directory>` for commands that run inside the checkout, and `set -e` at the start of the script. A failed clone then never runs Git inside your country configuration repository.

### Override the chart values

Keep chart values that differ between developers in environment variables, with a default that works for everyone, like `MY_APP_HOSTNAME` above. For values that are the same for your whole team, add an optional values file for your chart and pass it to `helm()` only when it exists:

```python
app_values = []
if os.path.exists("./helm/my-app/values.yaml"):
  app_values.append("./helm/my-app/values.yaml")

k8s_yaml(helm("../my-app/chart", name="my-app", namespace=app_namespace, values=app_values))
```

This keeps your overrides next to the ones for OpenCRVS, in `tilt/helm/`.
