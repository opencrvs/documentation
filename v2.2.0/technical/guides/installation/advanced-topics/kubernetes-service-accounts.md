# Kubernetes service accounts

### Overview

The `opencrvs-services` Helm chart creates a dedicated Kubernetes `ServiceAccount` for each OpenCRVS workload and sets the matching `serviceAccountName` on its pods.

On managed Kubernetes (e.g. AWS EKS, Google GKE, Azure AKS) you can map these service accounts to cloud identities (IAM roles, workload identities). Access to managed components such as PostgreSQL, Redis or object storage can then be granted to particular pods only, instead of to every virtual machine in the cluster, which significantly reduces the attack surface.

{% hint style="info" %}
No configuration is required for the default OpenCRVS installation. Service accounts are created automatically; annotate them only if you use cloud identity mapping.
{% endhint %}

### Default service accounts

Service account names match workload names:

* `auth`
* `client`
* `countryconfig`
* `dashboards`, when `dashboards.enabled` is `true`
* `documents`
* `events`
* `gateway`
* `login`
* `data-cleanup`, when `data_cleanup.enabled` is `true`
* `on-db-restore-cronjob`, when `on_restore_cronjob.enabled` is `true`

Helm pre/post deployment jobs share one service account, `deployment-jobs`. This includes validation, datastore setup, data migration, data seed and Elasticsearch reindex jobs.

### Annotating service accounts

Global annotations apply to all workload service accounts:

```yaml
# opencrvs-services chart values.override.yaml
service_account:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/opencrvs-default
```

Workload-specific annotations override global annotations with the same key:

```yaml
# opencrvs-services chart values.override.yaml
auth:
  service_account:
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/opencrvs-auth
```

Annotations for the deployment jobs service account:

```yaml
# opencrvs-services chart values.override.yaml
deployment_jobs:
  service_account:
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/opencrvs-deployment-jobs
```

### Using existing service accounts

If service accounts are managed outside of the chart, set `service_account.create` to `false` and create matching service accounts in the namespace. A custom name can be set per workload:

```yaml
# opencrvs-services chart values.override.yaml
service_account:
  create: false

auth:
  service_account:
    name: existing-auth-service-account
```

### Configuration options

| Value                                              | Default           | Description                                                                                           |
| -------------------------------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------- |
| `service_account.create`                           | `true`            | Create one ServiceAccount per workload.                                                               |
| `service_account.annotations`                      | `{}`              | Annotations applied to all workload ServiceAccounts.                                                  |
| `service_account.automount_service_account_token`  | `true`            | Controls `automountServiceAccountToken` on ServiceAccounts and pods. Can be overridden per workload.  |
| `<workload>.service_account.name`                  | workload name     | Custom ServiceAccount name for one workload.                                                          |
| `<workload>.service_account.annotations`           | `{}`              | Annotations for one workload's ServiceAccount.                                                        |
| `deployment_jobs.service_account.name`             | `deployment-jobs` | ServiceAccount shared by Helm pre/post deployment jobs.                                               |
| `deployment_jobs.service_account.annotations`      | Helm hook annotations | Annotations for the deployment jobs ServiceAccount.                                               |

For the complete reference, see [`charts/opencrvs-services/README.md`](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/charts/opencrvs-services/README.md#service-accounts).
