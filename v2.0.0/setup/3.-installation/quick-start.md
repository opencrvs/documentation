
> Quickstart scenario allows to run OpenCRVS with Farajaland demo data locally on kubernetes cluster like docker-desktop or minikube.

## Hardware requirements
- 16G RAM
- 8 CPU (at least Intel 8th generation)
- 100G free storage space

## Software requirements

**Check how to configure local Kubernetes cluster at [Docker engine and Kubernetes cluster](3.1-set-up-a-development-environment/3.1.1-install-the-required-dependencies.md#docker-engine-and-kubernetes-cluster)**

| Tool       | Description |
| ---------- | ----------- |
| Kubernetes | For macOS and Windows users, we recommend Docker Desktop with Kubernetes, [Learn more](https://www.docker.com/); for Linux users, we recommend Minikube, [Learn more](https://minikube.sigs.k8s.io/docs/start). More information about setting up Kubernetes can be found in the [Docker engine with Kubernetes cluster](#docker-engine-with-kubernetes-cluster) section. |
| kubectl    | Kubernetes command-line tool. [Documentation](https://kubernetes.io/docs/tasks/tools/). |
| helm       | Helm, a template engine for managing Kubernetes manifests. [Learn more](https://helm.sh/). |

**NOTE:**
- Quick start guide does not cover prerequisites installation.
- OpenCRVS team has limited capacity to test different configurations. Feel free to submit an issue on GitHub if something doesn't work in your hardware or software setup.
- Check GitHub repository for additional examples and hints: [opencrvs/infrastructure](https://github.com/opencrvs/infrastructure)

> **Before running commands make sure:**
> - [ ] kubernetes cluster is running on your PC/laptop
> - [ ] `helm` and `kubectl` are installed
> - [ ] context for `kubectl` is set to local cluster.

# Step by step

**1. Install Traefik Ingress Controller**

```
helm upgrade --install traefik oci://ghcr.io/traefik/helm/traefik \
    --namespace traefik \
    --create-namespace \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/traefik/values.yaml
```

**2. Install the OpenCRVS Dependencies Chart (Database & Storage Components)**

OpenCRVS requires supporting services (MongoDB, Postgres, MinIO, InfluxDB, Elasticsearch, Redis):

```
helm upgrade --install opencrvs-deps oci://ghcr.io/opencrvs/opencrvs-dependencies-chart \
    --namespace "opencrvs-deps-dev" \
    --create-namespace \
    --atomic \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/dependencies/values.yaml
```

**3. Install OpenCRVS Chart**

> NOTE: Timeout (`--timeout`) is set to 1 hour to avoid helm install failure on slow internet connection.

```
helm upgrade --install opencrvs oci://ghcr.io/opencrvs/opencrvs-services \
    --timeout 1h \
    --namespace "opencrvs-dev" \
    --create-namespace \
    --atomic \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/opencrvs-services/values.yaml
```

**4. After installation visit [http://opencrvs.localhost](http://opencrvs.localhost)**

> ➡️ Next steps:
> - Run fully functional local development environment, see [here](./3.1-set-up-a-development-environment/README.md)
> - Read more about advanced configurations options available here and for [Dependencies helm chart](../dependencies/README.md)
> - Check GitHub infrastructure repository [Configuration options](http://github.com/opencrvs/infrastructure/tree/develop/charts/opencrvs-services#configuration-options) table to get brief overview of options available within helm chart. Copy and modify `examples/localhost/opencrvs-services/values.yaml` to suit your needs.
