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
  * [ ] [Minikube](https://minikube.sigs.k8s.io/docs/start) for Windows, MacOS and Linux users. Recommended way, all documentation was written using minikube.
  * [ ] [Docker Desktop with Kubernetes](https://www.docker.com/) for MacOS and Windows users
  * [ ] Any other way to run Kubernetes cluster locally will work as well.

Check how to configure local Kubernetes cluster at [Docker engine and Kubernetes cluster](3.1-set-up-a-development-environment/3.1.1-install-the-required-dependencies.md#docker-engine-and-kubernetes-cluster)

{% hint style="info" %}
Quick start guide does not cover prerequisites installation. OpenCRVS team has limited capacity to test different configurations. Feel free to submit an issue on GitHub if something doesn't work in your hardware or software setup. Check for more information: [#docker-engine-and-kubernetes-cluster](3.1-set-up-a-development-environment/3.1.1-install-the-required-dependencies.md#docker-engine-and-kubernetes-cluster "mention")
{% endhint %}

## Step by step

**1. Start minikube cluster:**

```
minikube start --cpus=8 --memory=12g --ports=80:30080
```

Example output: Minikube on MacBook m1 with docker driver

```
minikube start --cpus=8 --memory=12g --ports=80:30080
😄  minikube v1.37.0 on Darwin 26.2 (arm64)
...
🔥  Creating docker container (CPUs=8, Memory=12288MB) ...
🐳  Preparing Kubernetes v1.34.0 on Docker 28.4.0 ...
...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

Make sure you kubernetes cluster is up and running:

```
kubectl config current-context
```

Example output:

```
minikube
```

**2. Install Traefik Ingress Controller**

```
helm upgrade --install traefik oci://ghcr.io/traefik/helm/traefik \
    --namespace traefik \
    --create-namespace \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/traefik/values.yaml
```

Use `kubectl` and `helm` to verify Traefik installation by running following command:

```
kubectl get pods -n traefik
helm ls -n traefik
```

Example output:

```
# kubectl get pods -n traefik
NAME                       READY   STATUS    RESTARTS   AGE
traefik-6d5f7c564b-v7n8m   1/1     Running   0          84s

# helm ls -n traefik
NAME            NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
opencrvs-deps   opencrvs-deps-dev       1               2026-02-05 13:19:32.614673 +0200 EET    pending-install opencrvs-dependencies-chart-0.2.7       1.9.5 
```

**3. Install the OpenCRVS Dependencies Chart (Database & Storage Components)**

OpenCRVS requires supporting services (MongoDB, Postgres, MinIO, InfluxDB, Elasticsearch, Redis):

```
helm upgrade --install opencrvs-deps oci://ghcr.io/opencrvs/opencrvs-dependencies-chart \
    --namespace "opencrvs-deps-dev" \
    --create-namespace \
    --atomic \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/dependencies/values.yaml
```

Use `kubectl` and `helm` to verify Dependencies installation by running following command:

```
kubectl get pods -n opencrvs-deps-dev
helm ls -n opencrvs-deps-dev
```

Example output:

```
# kubectl get pods -n opencrvs-deps-dev
NAME              READY   STATUS    RESTARTS   AGE
elasticsearch-0   1/1     Running   0          3m22s
influxdb-0        1/1     Running   0          3m22s
minio-0           1/1     Running   0          3m22s
mongodb-0         1/1     Running   0          3m22s
postgres-0        1/1     Running   0          3m22s
redis-0           1/1     Running   0          3m22s

# helm ls -n opencrvs-deps-dev
NAME            NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
opencrvs-deps   opencrvs-deps-dev       1               2026-02-05 13:19:32.614673 +0200 EET    deployed        opencrvs-dependencies-chart-0.2.7       1.9.5
```

**4. Install OpenCRVS Chart**

Following command will deploy all OpenCRVS services (components) in default configuration and perform data seeding. No additional steps are needed:

```
helm upgrade --install opencrvs oci://ghcr.io/opencrvs/opencrvs-services \
    --timeout 1h \
    --namespace "opencrvs-dev" \
    --create-namespace \
    --atomic \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/opencrvs-services/values.yaml
```

{% hint style="info" %}
Timeout (`--timeout`) is set to 1 hour to avoid helm install failure on slow internet connection. Kubernetes needs to pull all OpenCRVS images, on 100Mb/s connection that takes 10 minutes or less.

OpenCRVS don't provide ARM images for each minor release. If you are MacBook M-series user please use OpenCRVS versions from `examples/localhost/opencrvs-services/values.yaml` (defaults)
{% endhint %}

Use `kubectl` and `helm` to verify Dependencies installation by running following command:

```
kubectl get jobs -n opencrvs-dev
kubectl get pods -n opencrvs-dev
helm ls -n opencrvs-dev
```

Example output: All jobs should have `STATUS` value `Complete`. All pods should have `STATUS` value  `Running`. Some pods may have `RESTARTS` counter greater then 0, it's fine if `READY` has value `1/1` for `Running` pods or if pod `STATUS` is `Complete`.

```
# kubectl get job -n opencrvs-dev
NAME                       STATUS     COMPLETIONS   DURATION   AGE
data-migration             Complete   1/1           3m57s      14m
data-migration-analytics   Complete   1/1           10s        10m
data-seed                  Complete   1/1           40s        73s
elasticsearch-reindex      Complete   1/1           19s        32s
influxdb-on-deploy         Complete   1/1           5s         15m
postgres-on-deploy         Complete   1/1           14s        14m
# kubectl get pods -n opencrvs-dev
NAME                             READY   STATUS      RESTARTS        AGE
auth-6495b94dbb-kjsz4            1/1     Running     0               12m
client-78f55b7b-jd7x7            1/1     Running     1 (6m26s ago)   12m
data-seed-md8wm                  0/1     Completed   0               3m3s
events-76d68c8c89-lgn6p          1/1     Running     4 (5m56s ago)   12m
gateway-f59bdc8ff-gv7dm          1/1     Running     0               12m
hearth-867c54498d-c4wtc          1/1     Running     0               12m
# ... OUTPUT TRUNCATES ...

# helm ls -n opencrvs-deps-dev
NAME            NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
opencrvs-deps   opencrvs-deps-dev       1    
```

**4. After installation visit** [**http://opencrvs.localhost**](http://opencrvs.localhost)

{% hint style="info" %}
Next steps:

* Run fully functional local development environment, see [here](3.1-set-up-a-development-environment)
* Install OpenCRVS on the server, see [3.3-set-up-a-server-hosted-environment](3.3-set-up-a-server-hosted-environment/ "mention")
* Read more about advanced configurations options available here and for [Dependencies helm chart](dependencies/)
* Check GitHub infrastructure repository [Configuration options](http://github.com/opencrvs/infrastructure/tree/develop/charts/opencrvs-services#configuration-options) table to get brief overview of options available within helm chart. Copy and modify `examples/localhost/opencrvs-services/values.yaml` to suit your needs.
{% endhint %}
