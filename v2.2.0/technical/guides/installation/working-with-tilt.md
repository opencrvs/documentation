# Working with Tilt

This page explains how to use [Tilt](https://tilt.dev/) day to day, once `tilt up` is running.

If you have not started OpenCRVS yet, follow the [Quick Start](quick-start.md) first.

### Where things run

Tilt builds two images from your country configuration, `opencrvs/ocrvs-countryconfig:local` and `opencrvs/ocrvs-countryconfig:local-assets`, and downloads the OpenCRVS Core Helm charts into `.opencrvs-core-charts`. It deploys into these namespaces:

| Namespace           | Contents                                                     |
| ------------------- | ------------------------------------------------------------ |
| `traefik`           | Traefik, which serves OpenCRVS at `opencrvs.localhost`       |
| `opencrvs-deps-dev` | Dependencies: Elasticsearch, MinIO, Redis and PostgreSQL     |
| `opencrvs-dev`      | OpenCRVS Core services and your country configuration        |

OpenCRVS Core services use the official published Docker images for the configured release, only your country configuration is built locally.

### The Tilt UI

Open the Tilt UI at [http://localhost:10350](http://localhost:10350). Resources are grouped as follows:

| Group            | Resources                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------- |
| `1.OpenCRVS`     | OpenCRVS services: `auth`, `client`, `countryconfig`, `documents`, `events`, `gateway`, `login` |
| `2.Data-tasks`   | Tasks you run manually: `data-seed`, `data-cleanup`, `clean-&-seed`                          |
| `3.Jobs`         | Jobs that run automatically: `postgres-on-deploy`, `data-migration`, `data-migration-analytics`, `elasticsearch-reindex` |
| `4.Dependencies` | `elasticsearch`, `minio`, `redis`, `postgres`                                               |
| `5.Traefik`      | Traefik and its routes                                                                      |

Select a resource to see its logs and status. A green resource is running or has completed; a red resource has failed, and its logs show why. To restart a resource, select it and use the trigger (↻) button.

Dependencies start first, then the jobs in `3.Jobs`, then the OpenCRVS services. OpenCRVS is ready when all resources in `1.OpenCRVS` are green.

### Develop your country configuration

Tilt watches your country configuration directory:

* Changes in `src/` are synced into the running `countryconfig` container, without rebuilding the image.
* Changes to `package.json`, the lockfile (`pnpm-lock.yaml`) or `Dockerfile` rebuild the image and redeploy `countryconfig`.
* Changes in `assets/` (Metabase, PostgreSQL, Elasticsearch and deployment assets) rebuild the assets image.

Watch the `countryconfig` logs in the Tilt UI to check that your changes were applied.

### Seed and reset data

A new environment has no data. The tasks in `2.Data-tasks` do not run automatically: select a task and use the trigger (↻) button, or run it from your terminal, for example `tilt trigger data-seed`.

| Task           | What it does                                                                                       |
| -------------- | -------------------------------------------------------------------------------------------------- |
| `data-seed`    | Seeds an empty environment with the reference data from your country configuration.               |
| `data-cleanup` | Deletes all data.                                                                                  |
| `clean-&-seed` | Deletes all data, re-runs the migration jobs and seeds again. Use it to reset your environment completely. |

Data seeding installs the reference data that OpenCRVS needs: application settings, users, roles, locations, statistics and certificates. OpenCRVS reads this data from your country configuration. You can seed an environment only once: to seed again, for example after you change your locations or users, run `clean-&-seed`.

Seeding uses a temporary superuser, created by the data migrations that run when OpenCRVS starts. At the end of seeding, the superuser is deactivated. On server environments, GitHub Actions workflows seed the data instead. You will learn about them when you [deploy to a server](deploy-set-up-a-server-hosted-environment/README.md).

### Access services

* OpenCRVS: [http://opencrvs.localhost](http://opencrvs.localhost), see [Log in to OpenCRVS locally](log-in-to-opencrvs-locally.md) for test users
* Tilt UI: [http://localhost:10350](http://localhost:10350)

The local environment runs in non-secure mode: there is no authentication on Redis and Elasticsearch, and these default credentials are used:

* MinIO: `minioadmin` / `minioadmin`
* PostgreSQL: `postgres` / `postgres`

Monitoring (Kibana) and dashboards (Metabase) are not deployed locally.

To connect to a dependency from your computer, for example with a database client, forward its port with `kubectl`:

```bash
kubectl port-forward -n opencrvs-deps-dev svc/postgres 5432:5432        # PostgreSQL
kubectl port-forward -n opencrvs-deps-dev svc/elasticsearch 9200:9200   # Elasticsearch
kubectl port-forward -n opencrvs-deps-dev svc/redis 6379:6379           # Redis
kubectl port-forward -n opencrvs-deps-dev svc/minio 3536:3536           # MinIO console, http://localhost:3536
```

Keep the command running while you use the connection.

To inspect resources directly:

```bash
kubectl get pods -n opencrvs-dev
kubectl get pods -n opencrvs-deps-dev
kubectl logs -n opencrvs-dev deployment/countryconfig
```

### Configure the environment

#### Override Helm values

Use `tilt/helm/dependencies/values.yaml` and `tilt/helm/opencrvs-services/values.yaml` to override the default values of the Helm charts. They are applied on top of the defaults in `tilt/examples/`. Upgrades replace `tilt/examples/` but leave `tilt/helm/` unchanged, so keep your changes in `tilt/helm/`.

#### Change the OpenCRVS Core version

Set these environment variables before `tilt up`:

| Variable                  | Default         | Description                                                                 |
| ------------------------- | --------------- | --------------------------------------------------------------------------- |
| `OPENCRVS_CORE_IMAGE_TAG` | `v2.1.0`        | Tag of the OpenCRVS Core Docker images.                                     |
| `OPENCRVS_CORE_REF`       | `release/2.1.0` | Branch or tag of [opencrvs-core](https://github.com/opencrvs/opencrvs-core) to download the Helm charts from. |

For example:

```bash
OPENCRVS_CORE_IMAGE_TAG=v2.1.0 OPENCRVS_CORE_REF=v2.1.0 tilt up
```

Keep both variables on the same release. Tilt downloads the charts again when `OPENCRVS_CORE_REF` changes. To download them again for the same ref, delete the `.opencrvs-core-charts` directory.

#### Kubernetes engine

Tilt detects your engine from the current `kubectl` context. To override the detection, set `LOCAL_K8S=minikube` (Traefik as a NodePort on port 30080) or `LOCAL_K8S=orbstack` (Traefik as a `LoadBalancer` on port 80). See [Prerequisites](prerequisites.md#start-a-local-kubernetes-cluster).

### Stop Tilt

Press `Ctrl+C` in the terminal where `tilt up` runs. This stops Tilt, but OpenCRVS keeps running in the cluster. Run `tilt up` again to continue.

To remove everything Tilt deployed, run in your country configuration directory:

```bash
tilt down
```

To stop or remove the cluster itself, see [Stop or remove the cluster](prerequisites.md#stop-or-remove-the-cluster).

### Troubleshooting

| Problem | Solution |
| ------- | -------- |
| `elasticsearch` or other services keep restarting | The cluster does not have enough resources. Give it at least 8 CPUs and 12 GB of memory, see [Prerequisites](prerequisites.md). |
| [http://opencrvs.localhost](http://opencrvs.localhost) does not open | Check that all `1.OpenCRVS` resources are green and that nothing else uses port 80 on your computer. Check traefik pod health and service node port. |
| `opencrvs.localhost` or a subdomain does not resolve | Google Chrome resolves `*.localhost` names to your computer by itself. Other browsers and tools use your system's DNS, and some setups, such as corporate DNS, a VPN or WSL, do not resolve these names. Use Chrome, or add the names to your hosts file, see below. |
| The Tilt UI does not open, or `tilt up` reports that port 10350 is in use | Another program, or another `tilt up`, uses port 10350. Stop it and run `tilt up` again. |
| `Something went wrong while cloning infrastructure repository!` | Tilt could not download the Helm charts. Check your internet connection and that `OPENCRVS_CORE_REF` exists, delete `.opencrvs-core-charts`, then run `tilt up` again. |
| `No pnpm-lock.yaml or yarn.lock found` | Run `tilt up` in your country configuration directory, which contains the lockfile. |
| A data task fails | Open its logs in the Tilt UI. If the environment was already seeded, run `clean-&-seed` instead of `data-seed`. |

#### Add OpenCRVS names to your hosts file

If `opencrvs.localhost` does not resolve, add this line to `/etc/hosts` (macOS, Ubuntu and WSL) or `C:\Windows\System32\drivers\etc\hosts` (Windows, edit as administrator):

```
127.0.0.1 opencrvs.localhost register.opencrvs.localhost login.opencrvs.localhost gateway.opencrvs.localhost countryconfig.opencrvs.localhost minio.opencrvs.localhost minio-console.opencrvs.localhost
```

On Windows, the browser runs on Windows, so edit the Windows hosts file even if you use WSL.
