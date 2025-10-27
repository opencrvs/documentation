# Quickstart

Quickstart scenario allows to run OpenCRVS with Farajaland demo data locally on kubernetes cluster like docker-desktop or minikube.

> NOTE: Before running commands make sure `helm` and `kubectl` are installed and kubernetes context is set to local cluster.

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
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/dependencies/values-dev.yaml
```

**3. Install OpenCRVS Chart**

> NOTE: Timeout (`--timeout`) is set to 1 hour to avoid helm install failure on slow internet connection.

```
helm upgrade --install opencrvs oci://ghcr.io/opencrvs/opencrvs-services \
    --timeout 1h \
    --namespace "opencrvs-dev" \
    --create-namespace \
    --atomic \
    -f https://raw.githubusercontent.com/opencrvs/infrastructure/refs/heads/develop/examples/localhost/opencrvs-services/values-dev.yaml
```

[Configuration options](#configuration-options) table gives brief overview of options available within helm chart. Copy and modify `examples/localhost/opencrvs-services/values.yaml` to suit your needs.

**4. Seed data**

Populate initial demo data

```
helm get values opencrvs --namespace "opencrvs-dev" \
    | helm template -f - \
        --set data_seed.enabled=true \
        --namespace "opencrvs-dev" \
        -s templates/data-seed-job.yaml \
        oci://ghcr.io/opencrvs/opencrvs-services \
    | kubectl apply --namespace "opencrvs-dev" -f -
```

**5. After installation visit http://opencrvs.localhost**

> ➡️ Next steps:
> - Run fully functional local development environment, see [here](./3.1-set-up-a-development-environment/README.md)
> - Read more about advanced configurations options available here and for [Dependencies helm chart](../dependencies/README.md)
