# Running Dependencies deployment

{% hint style="warning" %}
A deployment to a **staging** environment is not permitted unless a **production** environment exists in the GitHub environment. Please ensure a **production** environment is configured before proceeding with any **staging** deployment.
{% endhint %}

### Preparation steps

This section explains how to deploy OpenCRVS dependencies grouped in 3 helm charts:

* **Ingress controller:** [Traefik](https://doc.traefik.io/traefik/) helm chart
* **Datastores** (via the [OpenCRVS dependencies Helm chart](https://github.com/opencrvs/opencrvs-core/tree/v2.1.0/charts/dependencies)):
  * PostgreSQL
  * Elasticsearch
  * Redis
  * MinIO
* **Tracing:** [OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-helm-charts) helm chart. It receives traces from OpenCRVS services, Traefik and NGINX and forwards them to Elastic APM. It is installed only when `environments/<env>/opentelemetry/values.yaml` exists.

Environment configuration script (`yarn environment:init`) prepared configuration files (`values.yaml`) for deployment with default parameters. Navigate to `environments` folder inside infrastructure repository and review configuration files.

Here is an example directory structure for a **development** environment:

```
environments/
├── development
│   ├── inventory.yml
│   ├── dependencies
│   │   ├── values.override.yaml
│   │   └── values.yaml
│   ├── opencrvs-services
│   │   ├── values.override.yaml
│   │   └── values.yaml
│   ├── opentelemetry
│   │   └── values.yaml
│   └── traefik
│       ├── values.override.yaml
│       └── values.yaml
└── README.md
```

A default configuration, created by the `yarn environment:init` script, is sufficient for inital deployments, but sometimes you may need to adjust TLS / SSL configuration or tweak some properties like static storage, etc. Put such changes in `environments/<env>/<chart>/values.override.yaml` (e.g. `environments/<env>/traefik/values.override.yaml`): `values.yaml` files are regenerated every time `yarn environment:init` runs.

### Run dependencies deployment

1. Navigate to GitHub Actions within `infrastructure` repository
2. Select "Deploy Dependencies" action
3. Select "Target environment" from dropdown menu, all environments created at [Create a GitHub Environment](../create-a-github-environment/) step should be listed here.
4. Click "Run workflow" button

### Verification steps

* Verify workflow was completed successfully
* Verify resources are up and running after deployment:
  * `kubectl get namespaces` : You should see 2 new namespaces created (`traefik`, `opencrvs-deps-<env>`).\
    NOTE: Check how to run `kubectl` at [Kubernetes cluster access](../../advanced-topics/kubernetes-cluster-access.md).
  * `kubectl get pods -n traefik`: Make sure traefik pod is up and running
  *   `kubectl get pods -n opencrvs-deps-<environment>` : make sure datastores are up and running.\
      Example output: If monitoring is enabled, you will also see filebeat, metricbeat, kibana, apm-server and opentelemetry-collector pods.

      ```
      NAME                             READY   STATUS      RESTARTS     AGE
      elasticsearch-0                  1/1     Running     0            8d
      minio-0                          1/1     Running     0            8d
      postgres-0                       1/1     Running     0            8d
      redis-0                          1/1     Running     0            8d
      ```
* Verify that **MinIO** and **Kibana** are available:
  * Kibana URL: `https://kibana.<your domain>`\
    Username and password are stored as Kubernetes secret `elasticsearch-opencrvs-users` in `opencrvs-deps-<environment>` namespace.
  * MinIO URL: `https://minio.<your domain>` . Username and password are stored as Kubernetes secret `minio-opencrvs-users` in `opencrvs-deps-<environment>` namespace.

> NOTE: Credentials are stored at GitHub secrets or can be fetched namespace `opencrvs-deps-<env>`.
