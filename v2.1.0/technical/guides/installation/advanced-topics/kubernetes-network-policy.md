# Kubernetes Network Policy

### Overview

{% hint style="info" %}
Requires a CNI provider that enforces NetworkPolicy (e.g. Calico, Cilium).
{% endhint %}

Network traffic between OpenCRVS pods is restricted using Kubernetes `NetworkPolicy` resources. This document gives an overview of the Kubernetes `NetworkPolicy` configuration shipped with the OpenCRVS services and dependencies Helm charts.

The following configuration is applied by default:

* NetworkPolicy is enabled by default (`network_policy.enabled`).
* Ingress and egress traffic are restricted by default (`network_policy.<ingress|egress>_mode`).
* Each Helm chart (`dependencies`, `opencrvs-services`) has its own configuration for ingress and egress policy.
* Every pod can always reach other pods in its own namespace (`allow_same_namespace`).
* NetworkPolicy resources are recreated on every `helm upgrade`, so the cluster always matches `values.yaml`.

### Ingress / egress modes

Each Helm chart exposes `network_policy.ingress_mode` and `network_policy.egress_mode`, configurable globally and per service:

| Mode      | Behavior                                                                                                                        |
| --------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `deny`    | Nothing allowed beyond same-namespace / `allowed_namespaces` / explicit rules.                                                  |
| `private` | Additionally allow RFC1918 private ranges (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`); the public internet stays blocked. |
| `full`    | No restriction.                                                                                                                 |

Default posture per chart:

| Chart               | `ingress_mode` | `egress_mode` |
| ------------------- | -------------- | ------------- |
| `dependencies`      | `private`      | `deny`        |
| `opencrvs-services` | `deny`         | `private`     |

`opencrvs-services` ships with `egress_mode: private` rather than `deny` so the application can reach the `dependencies` chart and other in-VPC services without every deployment having to configure `allowed_namespaces` up front.

{% hint style="info" %}
The table above shows the chart defaults. Environments created with `yarn environment:init` use a stricter configuration: the generated `values.yaml` files set `ingress_mode: deny` and `egress_mode: deny` on **both** charts, together with `allowed_namespaces` pointing at each other's namespace (see Cross-namespace access). Hardening steps 1-3 below are therefore already applied on these environments.
{% endhint %}

### Public entry points

The following services are allowed to accept connections from any private subnet:

* `client`
* `gateway`
* `login`
* `countryconfig`
* `dashboards`

Every other service accepts ingress only from its own namespace.

The MOSIP integration chart (`opencrvs-mosip`) is usually deployed into the same namespace as `opencrvs-services`. It ships a `mosip-allow-all` NetworkPolicy that exempts `mosip-api`, `mosip-mock` and `esignet-mock` from the default-deny policy.

### Cross-namespace access

The `dependencies` chart (Postgres, Elasticsearch, Redis, MinIO) and `opencrvs-services` chart are typically deployed to separate namespaces. `network_policy.allowed_namespaces` grants one half of that access per chart:

```mermaid
flowchart LR
  subgraph SVC ["opencrvs-services namespace"]
    A[auth / gateway / events / ...]
  end
  subgraph DEP ["dependencies namespace"]
    B[(Postgres / Elasticsearch / Redis / MinIO)]
  end
  A -- "egress: allowed_namespaces: opencrvs-deps-{env}" --> B
  B -. "ingress: allowed_namespaces: opencrvs-{env}" .-> A
```

`{env}` in this diagram refers to the environment name (e.g. `production`, `qa`)

{% hint style="info" %}
Both sides are configured by default while running `yarn environment:init`.&#x20;

Setting `allowed_namespaces` on only one chart opens that chart's side of the connection but not the other — traffic still won't flow until both are set.
{% endhint %}

Configuration example for `allowed_namespaces`:

```yaml
# dependencies chart values.override.yaml
network_policy:
  allowed_namespaces:
    - opencrvs-production

# opencrvs-services chart values.override.yaml
network_policy:
  allowed_namespaces:
    - opencrvs-deps-production
```

### Hardening

Recommended for production:

1. Set `egress_mode: deny` on the `opencrvs-services` chart (ships as `private`).
2. Set `ingress_mode: deny` on the `dependencies` chart (ships as `private`).
3. Set `network_policy.allowed_namespaces` on both charts, pointing at each other's namespace (see above).
4. Countryconfig service has `egress_mode: full` for SMTP/SMS provider integrations) and replace it with a `custom_rules` entry scoped to known IPs
5. Deployment jobs (`deployment_jobs`) have `egress_mode: full`. Apply same `custom_rules` as for countryconfig.
6. Build custom Postgres image with pgbackrest and other utilities, see [#postgres-preinstalling-backup-restore-utility-packages](air-gap-installation.md#postgres-preinstalling-backup-restore-utility-packages "mention") and set `postgres.network_policy.rules: []`

{% hint style="info" %}
Check "Custom rules" section for more information
{% endhint %}

### Backup and restore server

When backup or restore is enabled, the `dependencies` chart allows Postgres and MinIO to connect to the backup server over SSH (TCP port 22) only. The rule is built from `backup.host` / `restore.host` (set from the `BACKUP_HOST` / `RESTORE_HOST` GitHub environment variables) as a `/32` IP block, because Kubernetes NetworkPolicy cannot match hostnames. **`BACKUP_HOST` and `RESTORE_HOST` must be IP addresses.**

### Cloud-native deployments

* By default, egress to internal (RFC1918 private) IP addresses is allowed under `egress_mode: private` — this covers pod IPs, Service ClusterIPs, and node IPs on any standard cluster network, including managed Kubernetes offerings.
* If Postgres (or another datastore) runs as a managed cloud service reachable over a **public IP** (e.g. AWS RDS, Cloud SQL, Azure Database) rather than an in-cluster address, the private-range rule does not cover it. Add an explicit `custom_rules` entry scoped to that service's IP:

```yaml
postgres:
  network_policy:
    custom_rules:
      - name: allow-managed-postgres-egress
        policyTypes:
          - Egress
        egress:
          - to:
              - ipBlock:
                  cidr: <public-ip>/32
            ports:
              - protocol: TCP
                port: 5432
```

### Custom rules

`<service>.network_policy.rules`/`custom_rules` entries use the same syntax as a Kubernetes `NetworkPolicy` `spec` (`policyTypes`, `ingress`, `egress`) — only `podSelector` is generated automatically from the service's `app_label`. See the [NetworkPolicy API reference](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/network-policy-v1/) for the full syntax.

```yaml
countryconfig:
  network_policy:
    custom_rules:
      - name: allow-sms-provider-egress
        policyTypes:
          - Egress
        egress:
          - to:
              - ipBlock:
                  cidr: <sms-provider-ip>/32
            ports:
              - protocol: TCP
                port: 443
      - name: allow-smtp-egress
        policyTypes:
          - Egress
        egress:
          - to:
              # Replace with the SMTP server's actual IP/CIDR — NetworkPolicy
              # can only match IPs, not hostnames like smtp.example.com.
              - ipBlock:
                  cidr: 203.0.113.10/32
            ports:
              - protocol: TCP
                port: 587 # submission (STARTTLS) — use 465 for SMTPS, or 25 if the provider requires it
```

### Configuration options

Reference for the `opencrvs-services` chart:

| Value                                                   | Default   | Description                                                                      |
| ------------------------------------------------------- | --------- | -------------------------------------------------------------------------------- |
| `network_policy.enabled`                                | `true`    | Render NetworkPolicy resources.                                                  |
| `network_policy.ingress_mode`                           | `deny`    | `deny` / `private` / `full`, see above.                                          |
| `network_policy.egress_mode`                            | `private` | `deny` / `private` / `full`, see above.                                          |
| `network_policy.allow_same_namespace`                   | `true`    | Allow pods in the same namespace to reach each other.                            |
| `network_policy.allowed_namespaces`                     | `[]`      | Namespaces OpenCRVS pods are allowed to reach (egress), e.g. the dependencies namespace — see Cross-namespace access. |
| `network_policy.annotations` / `labels`                 | `{}`      | Extra annotations/labels on every generated NetworkPolicy. Can be overridden per service.                         |
| `<service>.network_policy.ingress_mode` / `egress_mode` | global    | Per-service override, same modes. Unset values inherit the global setting. Chart defaults: `ingress_mode: private` for `client`, `gateway`, `login`, `countryconfig` and `dashboards`; `egress_mode: full` for `countryconfig`; `ingress_mode: deny` / `egress_mode: full` for `deployment_jobs`. |
| `<service>.network_policy.rules` / `custom_rules`       | `[]`      | Explicit NetworkPolicy rules for one service.                                                                     |

For the complete reference, see:

* [`charts/dependencies/README.md`](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/charts/dependencies/README.md#network-policies)
* [`charts/opencrvs-services/README.md`](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/charts/opencrvs-services/README.md#network-policies)
