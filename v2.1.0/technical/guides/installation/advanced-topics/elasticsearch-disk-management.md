# Elasticsearch disk management

### General information

By default, OpenCRVS deploys an Elasticsearch instance that is shared by the application and observability services. Elasticsearch data is stored on the same disk partition as other persistent services, such as PostgreSQL and MinIO, under `/data`.

In many environments, this disk partition is encrypted and has limited available space. Observability data, especially monitoring metrics and application logs, can require significantly more storage over time. As a rough estimate, monitoring data for a single-node environment can use approximately 5 GB per month. Logging storage is harder to estimate because it depends on several factors, including the number of active users, the number of registrations processed each day, enabled log levels, and retention settings.

As the system grows, Elasticsearch may require more disk space than was allocated during the initial setup. This guide explains how to reconfigure Elasticsearch so that it stores its indices on an additional disk partition or external folder.

### Storage options for Elasticsearch

#### Option 1: Use a dedicated Elasticsearch host

OpenCRVS can be configured to use an external Elasticsearch datastore instead of the Elasticsearch service deployed with the default OpenCRVS stack. This is the recommended approach when you want to run Elasticsearch on a dedicated host or managed infrastructure.

For setup instructions, see [Deploy OpenCRVS with external data stores](deploy-opencrvs-with-external-data-stores.md#elasticsearch).

#### Option 2: Use a dedicated disk partition for Elasticsearch data

This option keeps Elasticsearch deployed as part of the OpenCRVS dependencies chart, but moves its persistent data directory to a separate disk partition or mounted folder.

Use this approach when the server has enough CPU and memory for Elasticsearch, but the default `/data` partition does not have enough space for Elasticsearch indices, logs, and monitoring data.

Before starting, make sure Elasticsearch is using `host_path` storage type, check helm chart values (`storage_type` or `elasticsearch.storage_type`).&#x20;

1. Attach the new disk or volume to the server.
2.  Mount the disk to a directory on the host, for example:

    ```
    /data2/elasticsearch
    ```
3.  Scale down the Elasticsearch StatefulSet to stop Elasticsearch before moving its data.&#x20;

    ```
    kubectl scale statefulset elasticsearch --replicas=0 -n opencrvs-dev-<environment>
    ```
4.  Copy the existing Elasticsearch data from the default location to the new mount point:

    ```
    rsync -rpv /data/elasticsearch /data2/elasticsearch
    ```
5.  Update `values.override.yaml` for the appropriate environment and set the new host data path. The path is configured with `elasticsearch.host_data_path`, as described in the [dependencies chart README](https://github.com/opencrvs/opencrvs-core/blob/release/2.0.1/charts/dependencies/README.md#elasticsearch):

    ```
    elasticsearch:
      host_data_path: /data2/elasticsearch
    ```
6. Redeploy the OpenCRVS dependencies Helm chart.

After deployment, Elasticsearch will mount the new host path and continue storing its data on the dedicated disk partition.

#### Option 3: Reduce logs storage by Helm chart

OpenCRVS allows you to reduce Elasticsearch storage usage by lowering the retention period for observability data. This is configured in the dependencies Helm chart values.

Use this option when Elasticsearch is running correctly, but disk usage is growing because logs or metrics are retained for longer than required.

Example configuration

Update the environment `values.override.yaml` file:

```
monitoring:
  logs:
    retention_days: 14
  metrics:
    retention_days: 14
```

This example keeps application logs and monitoring metrics for 14 days. After that, Elasticsearch Index Lifecycle Management (ILM) deletes the old indices automatically.

You can configure logs and metrics independently:

```
monitoring:
  logs:
    retention_days: 7
  metrics:
    retention_days: 30
```

In this example:

* Application logs are retained for 7 days.
* Monitoring metrics are retained for 30 days.

Redeploy the OpenCRVS dependencies Helm chart after changing these values.

Reducing retention lowers the amount of disk space used by Elasticsearch over time. This is usually the simplest way to control observability storage growth without moving Elasticsearch data to another disk.

However, shorter retention also means older logs and metrics will no longer be available in Kibana after they are deleted. This may affect troubleshooting, audit investigations, and historical performance analysis.

Before reducing retention, consider how long your team needs to keep logs for operational support and incident investigation. For production environments, avoid setting retention too low unless there is another system collecting or archiving logs.

