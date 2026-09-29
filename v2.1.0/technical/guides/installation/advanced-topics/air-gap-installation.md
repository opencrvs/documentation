# Air-gap installation

### Overview

Running the `opencrvs-services` and `dependencies` Helm charts without outbound internet access has two independent requirements:

* Every container image must come from a registry the cluster can reach.
* The Postgres and MinIO backup/restore jobs must not need to install packages at deploy time.

### Pulling images from a private registry

**OpenCRVS-published images**

`platform.repository` (default `ghcr.io/opencrvs`) and `platform.imagePullSecrets` (a Kubernetes Secret of type `kubernetes.io/dockerconfigjson`) control every OpenCRVS service image on the `opencrvs-services` chart - `auth` (`ocrvs-auth`), `client` (`ocrvs-client`), `documents` (`ocrvs-documents`), `gateway` (`ocrvs-gateway`), `login` (`ocrvs-login`), `events` (`ocrvs-events`), `data_migration` (`ocrvs-migration`), `data_seed` (`ocrvs-data-seeder`) - and the shared `utilities` helper image used by init containers and one-off jobs on **both** charts (`ghcr.io/opencrvs/ocrvs-utilities`).

Point `platform.repository` at your mirror and every one of these resolves against it without further per-service overrides.

```yaml
# opencrvs-services chart values.override.yaml
platform:
  repository: myregistry.example.com/opencrvs
  imagePullSecrets:
    - name: myregistry-pull-secret

# dependencies chart values.override.yaml
utilities:
  image:
    repository: myregistry.example.com/opencrvs/ocrvs-utilities
platform:
  imagePullSecrets:
    - name: myregistry-pull-secret
```

**Third-party images**

These are not published by OpenCRVS and have no chart-wide override - each ships from its own vendor registry (`docker.elastic.co`, Docker Hub) or from an OpenCRVS mirror on `ghcr.io`, so each needs its own `image.repository` (and `.tag`, if the mirrored tag differs):

**`dependencies` chart**

| Service       | Default image                                   |
| ------------- | ----------------------------------------------- |
| Postgres      | `postgres`                                      |
| Elasticsearch | `docker.elastic.co/elasticsearch/elasticsearch` |
| APM Server    | `docker.elastic.co/apm/apm-server`              |
| Kibana        | `docker.elastic.co/kibana/kibana`               |
| Metricbeat    | `docker.elastic.co/beats/metricbeat`            |
| Filebeat      | `docker.elastic.co/beats/filebeat`              |
| Logstash      | `docker.elastic.co/logstash/logstash`           |
| Elastalert    | `jertel/elastalert2`                            |
| MinIO         | `ghcr.io/opencrvs/minio`                        |
| Redis         | `redis`                                         |

**`opencrvs-services` chart**

| Service            | Default image       | Notes                                                                    |
| ------------------ | ------------------- | ------------------------------------------------------------------------ |
| `minio.image`      | `ghcr.io/opencrvs/minio-mc` | Client image used by one-off jobs that configure MinIO buckets/policies. |
| `postgres.image`   | `postgres`          | Used by the backup, restore, data cleanup and analytics migration jobs.  |
| `dashboards.image` | `metabase/metabase` | Only pulled when `dashboards.enabled: true`.                             |

```yaml
# dependencies chart values.override.yaml
postgres:
  image:
    repository: myregistry.example.com/postgres
elasticsearch:
  image:
    repository: myregistry.example.com/elasticsearch
minio:
  image:
    repository: myregistry.example.com/minio
```

**Charts and images deployed by the infrastructure workflows**

The GitHub Actions workflows in the infrastructure repository also pull Helm charts and images that are not part of the two charts above. Mirror them as well, and adjust the chart sources in `.github/workflows/deploy-dependencies.yml` and `.github/workflows/deploy-opencrvs.yml`:

| Component                 | Default source                                                                                                  |
| ------------------------- | --------------------------------------------------------------------------------------------------------------- |
| OpenCRVS Helm charts      | `oci://ghcr.io/opencrvs/opencrvs-dependencies-chart`, `oci://ghcr.io/opencrvs/opencrvs-services`                 |
| Traefik                   | Helm chart `oci://ghcr.io/traefik/helm/traefik`, image from Docker Hub                                           |
| OpenTelemetry Collector   | Helm chart from `https://open-telemetry.github.io/opentelemetry-helm-charts`, image `otel/opentelemetry-collector-k8s` |
| MOSIP integration (if used) | `ghcr.io/opencrvs/mosip-api`, `ghcr.io/opencrvs/mosip-mock`, `ghcr.io/opencrvs/esignet-mock`                     |

{% hint style="info" %}
Check each chart's `values.yaml` for the exact tag pinned to every image. All images must already exist in the private registry before deploying - neither chart falls back to a public registry once an override is set.
{% endhint %}

### Postgres Preinstalling backup/restore utility packages

Postgres backup/restore jobs install required utilities at runtime with `apt-get` when they are missing from the base image. In an air-gapped environment this installation step fails because package repositories are not reachable, even once the base image itself is pulled from a private registry.

To support installation without internet connectivity, build custom image from the default postgres image and preinstall the required packages: `openssh-client`, `rsync`, `pgbackrest`

Postgres Dockerfile:

```dockerfile
FROM postgres:17.6
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
      openssh-client \
      rsync \
      pgbackrest=2.59.0* \
    && rm -rf /var/lib/apt/lists/*

```

### MinIO Preinstalling backup/restore utility packages

MinIO backup/restore jobs also install utilities at runtime, with `apk`. Build a custom image from the default MinIO image (`ghcr.io/opencrvs/minio`) and preinstall the required packages: `bash`, `curl`, `openssl`, `openssh`, `jq`, `rsync`, `minio-client`, `coreutils`

After publishing the custom images, point the `dependencies` chart to them:

```yaml
# dependencies chart values.override.yaml
postgres:
  image:
    repository: myregistry.example.com/postgres-with-backup-tools
    tag: 17.6-custom
minio:
  image:
    repository: myregistry.example.com/minio-with-backup-tools
    tag: release.2025-06-13t11-33-47z-custom
```

### Configuration options

| Value                        | Chart                               | Description                                                                                      |
| ---------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------ |
| `platform.repository`        | `opencrvs-services`                 | Default repository for every OpenCRVS service image.                                             |
| `platform.imagePullSecrets`  | `opencrvs-services`, `dependencies` | Pod-level image pull secret(s) for the configured private registry.                              |
| `utilities.image.repository` | `dependencies`                      | Repository for the shared `ocrvs-utilities` helper image (init containers, backup/restore jobs). |
| `<service>.image.repository` | `opencrvs-services`, `dependencies` | Per-service override, required for every third-party image.                                      |
| `countryconfig.image.name`   | `opencrvs-services`                 | Full image path - not combined with `platform.repository` when it contains `/`.                  |

For the complete reference, see:

* [`charts/opencrvs-services/values.yaml`](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/charts/opencrvs-services/values.yaml)
* [`charts/dependencies/README.md`](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/charts/dependencies/README.md#air-gap-installation)

Once all configuration completed and custom Postgres and MinIO images are published, please follow regular deployment steps.
