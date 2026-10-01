# Quick Start

Before you start, install the required tools and start a local Kubernetes cluster, see [Prerequisites](prerequisites.md).

### Create a country configuration

{% tabs %}
{% tab title="Run with Node" %}
```bash
npm create @opencrvs/countryconfig@latest <project-name>
```
{% endtab %}
{% tab title="Run with docker" %}
If you don't have Node.js installed, run the same command with Docker.
Modify `<project-name>` before running:
```bash
docker run --rm -it \
  -v "$PWD":/work -w /work \
  --user "$(id -u):$(id -g)" -e HOME=/tmp \
  node:22 npx --yes @opencrvs/create-countryconfig@latest <project-name>
```

`--user` makes the created files belong to you instead of `root`.
{% endtab %}
{% endtabs %}

This command creates two directories: `<project-name>-countryconfig`, a country configuration package with a minimal example configuration, and `<project-name>-infrastructure`, for deploying to servers. It asks for your organisation name and country code first.

### Run local development environment

Go to your country configuration directory:

```bash
cd <path>/<project-name>-countryconfig
```

Start the development environment:

```bash
tilt up
```

Open the Tilt UI at [http://localhost:10350](http://localhost:10350).

Wait until all resources in the `1.OpenCRVS` group are green. The first `tilt up` downloads all OpenCRVS Core images, so it can take a long time, depending on your internet connection. Later starts are much faster. Follow the progress in each resource's logs.

Then run the data seed task from the Tilt UI:

1. Open [http://localhost:10350](http://localhost:10350)
2. Find the `2.Data-tasks` section
3. Run the `data-seed` or `clean-&-seed` resource
4. Wait until the job completes

### Log in

Open OpenCRVS at [http://opencrvs.localhost](http://opencrvs.localhost) and log in with a test user, for example username `k.mweene` and password `test`. If you are asked for an authentication code, use `000000`.

For all test users, see [Log in to OpenCRVS locally](log-in-to-opencrvs-locally.md).

That's it! 🎉

### Next steps

Read [Working with Tilt](working-with-tilt.md) to learn how to use the Tilt UI, reload your changes, reset data and access OpenCRVS services.
