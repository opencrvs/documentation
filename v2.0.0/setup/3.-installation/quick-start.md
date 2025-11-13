# Quick start

{% hint style="info" %}
Quickstart scenario allows to run OpenCRVS with Farajaland demo data locally on kubernetes cluster like docker-desktop or minikube.
{% endhint %}

### Hardware requirements

* 16G RAM
* 8 CPU (at least Intel 8th generation)
* 100G free storage space

### Software requirements for this demo

* [ ] `kubectl`: Kubernetes command-line tool. see [Documentation](https://kubernetes.io/docs/tasks/tools/).
* [ ] `helm`: a template engine and command-line tool for managing Kubernetes manifests. [Learn more](https://helm.sh/).
* [ ] Kubernetes cluster:
  * [ ] [Docker Desktop with Kubernetes](https://www.docker.com/) for MacOS and Windows users
  * [ ] [Minikube](https://minikube.sigs.k8s.io/docs/start) for Linux users

Check how to configure local Kubernetes cluster at [Docker engine and Kubernetes cluster](3.1-set-up-a-development-environment/3.1.1-install-the-required-dependencies.md#docker-engine-and-kubernetes-cluster)

{% hint style="info" %}
Quick start guide does not cover prerequisites installation. OpenCRVS team has limited capacity to test different configurations. Feel free to submit an issue on GitHub if something doesn't work in your hardware or software setup. Check GitHub repository for additional examples and hints: [opencrvs/infrastructure/examples](https://github.com/opencrvs/infrastructure/tree/develop/examples)
{% endhint %}

## Step by step

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

**4. After installation visit** [**http://opencrvs.localhost**](http://opencrvs.localhost)

{% hint style="info" %}
Next steps:

* Run fully functional local development environment, see [here](3.1-set-up-a-development-environment/)
* Read more about advanced configurations options available here and for [Dependencies helm chart](../dependencies/)
* Check GitHub infrastructure repository [Configuration options](http://github.com/opencrvs/infrastructure/tree/develop/charts/opencrvs-services#configuration-options) table to get brief overview of options available within helm chart. Copy and modify `examples/localhost/opencrvs-services/values.yaml` to suit your needs.
{% endhint %}
