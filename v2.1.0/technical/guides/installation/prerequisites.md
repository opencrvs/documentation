# Prerequisites

This page explains how to prepare your computer and start a local Kubernetes cluster. When the cluster is running, continue with the [Quick Start](quick-start.md).

### Hardware requirements

| Resource        | Minimum | Recommended |
| --------------- | ------- | ----------- |
| RAM             | 16 GB   | 32 GB       |
| CPUs            | 8       | 8 or more   |
| Free disk space | 30 GB   | 50 GB       |

The Kubernetes cluster needs at least 8 CPUs and 12 GB of memory. With less, services such as Elasticsearch may fail to start. On a 16 GB computer this leaves only 4 GB for your operating system, Docker and browser, so close other applications while OpenCRVS runs.

OpenCRVS itself takes about 13 GB of disk space: Docker images, Helm charts and data. The tools on this page, including the Kubernetes engine, take about 8 GB more. The recommended 50 GB leaves room for image rebuilds and test data.

### Operating system

* **Ubuntu**: 24.04+ (LTS).
* **macOS**: 15+
* **Windows**: 10+, use [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/install) with an Ubuntu distribution, and run the commands on this page in the WSL terminal, except where a step says to use PowerShell. The OpenCRVS Tilt setup runs shell scripts that need a Linux shell.

You need admin rights on your computer.

### Software requirements

| Tool                                                               | Description                                                                                                       |
| ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| [Git](https://git-scm.com/downloads)                               | Used by Tilt to download the OpenCRVS Core Helm charts.                                                           |
| [Docker](https://docs.docker.com/get-started/get-docker/)          | Builds the country configuration image locally.                                                                   |
| [kubectl](https://kubernetes.io/docs/tasks/tools/)                 | Kubernetes command-line tool.                                                                                     |
| Kubernetes                                                         | Local Kubernetes cluster. See [Start a local Kubernetes cluster](#start-a-local-kubernetes-cluster) below.        |
| [Helm](https://helm.sh/docs/intro/install/)                        | Used by Tilt to render and deploy the OpenCRVS Helm charts.                                                       |
| [Tilt](https://docs.tilt.dev/install.html)                         | Manages the local development environment.                                                                        |
| [Node.js](https://nodejs.org/en/download) 22 (optional)            | Runs `npm create @opencrvs/countryconfig`, which creates your country configuration. Without Node.js, you can run the same command with Docker, see [Quick Start](quick-start.md). If you install Node.js, we recommend [nvm](https://github.com/nvm-sh/nvm). |
| [Google Chrome](https://www.google.com/chrome)                     | OpenCRVS is a [progressive web application](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps), and PWAs work best in Chrome. |

### Start a local Kubernetes cluster

Choose one Kubernetes engine:

| Operating system | Recommended engine        |
| ---------------- | ------------------------- |
| Ubuntu           | Minikube                  |
| macOS            | Docker Desktop or OrbStack |
| Windows          | Docker Desktop            |

OpenCRVS is served at [http://opencrvs.localhost](http://opencrvs.localhost) on port 80 and the Tilt UI at [http://localhost:10350](http://localhost:10350), so ports 80 and 10350 on your computer must be free. You don't need to set up DNS: Google Chrome resolves `opencrvs.localhost` and its subdomains to your computer by itself. If they do not resolve, see [Troubleshooting](working-with-tilt.md#troubleshooting). Tilt detects your engine from the current `kubectl` context: on Minikube it exposes Traefik (the OpenCRVS ingress) as a NodePort on port 30080, on other engines as a `LoadBalancer` service on port 80.

{% tabs %}
{% tab title="Minikube (Ubuntu)" %}
1. Install [Minikube](https://minikube.sigs.k8s.io/docs/start/). Make sure you can [run Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
2. Start Minikube with enough resources. `--ports=80:30080` makes Traefik's NodePort available on port 80 of your computer:

   ```bash
   minikube start \
     --driver=docker \
     --cpus=8 \
     --memory=12g \
     --ports=80:30080
   ```

   If Minikube was already running with other values, delete it first with `minikube delete`, then start it again.
3. Check that `kubectl` points to Minikube:

   ```bash
   kubectl config current-context
   ```

   Expected output: `minikube`
{% endtab %}

{% tab title="Docker Desktop (macOS, Windows)" %}
1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2. Give Docker Desktop enough resources:
   * **macOS**: in **Settings > Resources > Advanced**, set **CPU limit** to at least 8 and **Memory limit** to at least 12 GB.
   * **Windows**: Docker Desktop uses the WSL 2 backend, and WSL controls the resources. Set `memory=12GB` and `processors=8` in the `[wsl2]` section of `%UserProfile%\.wslconfig`, then run `wsl --shutdown` in PowerShell. In **Settings > Resources > WSL integration**, enable integration with your Ubuntu distribution.
3. In the **Kubernetes** view of the Docker Desktop Dashboard, select **Create cluster**, choose **Kubeadm**, then select **Create**. Kubeadm lets the cluster use the images that Tilt builds locally; kind does not. In older Docker Desktop versions, go to **Settings > Kubernetes**, select **Enable Kubernetes**, then **Apply & restart**. Wait until Kubernetes shows as running.
4. Switch `kubectl` to Docker Desktop and check it. On Windows, if WSL reports that the `docker-desktop` context does not exist, first copy the Windows kubeconfig into WSL: `mkdir -p ~/.kube && cp /mnt/c/Users/<your-windows-user>/.kube/config ~/.kube/config`.

   ```bash
   kubectl config use-context docker-desktop
   kubectl config current-context
   ```

   Expected output: `docker-desktop`
{% endtab %}

{% tab title="OrbStack (macOS)" %}
1. Install [OrbStack](https://orbstack.dev/).
2. In OrbStack **Settings > System**, set the memory limit to at least 12 GB (the default is at most 8 GB), and make sure the CPU limit allows at least 8 CPUs.
3. In OrbStack **Settings > Kubernetes**, enable Kubernetes.
4. Switch `kubectl` to OrbStack and check it:

   ```bash
   kubectl config use-context orbstack
   kubectl config current-context
   ```

   Expected output: `orbstack`
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Other local Kubernetes engines, such as kind, k3d or MicroK8s, may also work. Make sure that:

* Docker images you build locally are available to the cluster.
* Traefik is reachable on port 80 of your computer, through a `LoadBalancer` or NodePort service. To use the NodePort setup on another engine, start Tilt with `LOCAL_K8S=minikube tilt up`, and map port 80 to port 30080 yourself.
* `opencrvs.localhost` and its subdomains (for example `login.opencrvs.localhost`) resolve to your computer.
{% endhint %}

### Check your setup

Run these commands. Each one must print a version, and `kubectl get nodes` must show your node as `Ready`:

```bash
docker version
kubectl version --client
helm version
tilt version
git --version
node --version          # optional, must be v22
kubectl config current-context
kubectl get nodes
```

* [ ] Docker, kubectl, Helm, Tilt and Git are installed
* [ ] `kubectl config current-context` shows your engine: `minikube`, `docker-desktop` or `orbstack`
* [ ] The cluster node is `Ready`
* [ ] The cluster has at least 8 CPUs and 12 GB of memory
* [ ] Ports 80 and 10350 are free

Your local Kubernetes environment is ready. Continue with the [Quick Start](quick-start.md) to create your country configuration and start OpenCRVS with `tilt up`.

### Stop or remove the cluster

Stop Tilt first, see [Stop Tilt](working-with-tilt.md#stop-tilt). Then, to free up resources, stop or remove the cluster:

* **Minikube**: `minikube stop` stops the cluster; `minikube delete` removes it.
* **Docker Desktop**: in the **Kubernetes** view, select **Stop** to stop and remove the cluster, or use **Reset cluster** to remove all its resources. In older versions, clear **Enable Kubernetes** in **Settings > Kubernetes**.
* **OrbStack**: in **Settings > Kubernetes**, disable Kubernetes.
