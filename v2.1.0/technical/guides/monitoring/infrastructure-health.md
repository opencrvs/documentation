# Infrastructure health

### 1. Introduction

OpenCRVS monitoring tools let you measure and view critical metrics such as available disk space, used memory, and total CPU load. This information can be used to proactively increase available resources when demand increases.

These metrics are collected by a tool called [Metricbeat](https://www.elastic.co/beats/metricbeat) and stored in Elasticsearch.

### 2. Common infrastructure metrics

The following list summarises the most important infrastructure metrics to monitor:

* CPU usage
* RAM usage
* Network RX/TX
* Disk usage usage / IOPs

Navigate to **Observability > Infrastructure > Hosts**:

<figure><img src="../../../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

### 3. Kubernetes metrics

Navigate to **Observability > Infrastructure > Infrastructure inventory**:

1. Change "Show" selector to "Kubernetes"
2. Change Presentation view to "Table"
3. From dropdown choose metric

<figure><img src="../../../.gitbook/assets/image (34).png" alt=""><figcaption></figcaption></figure>

### 4. Accessing metrics from Explorer

To view infrastructure metrics, log in to Kibana and navigate to **Observability** → **Metrics** → **Metrics Explorer**.

In this view, you can:

* See current usage of different resources
* Group metrics by host, service, or other dimensions
* Filter and visualize data over time

### 5. Available disk space

To see the amount of available disk space, navigate to **Metrics Explorer** (Observability → Metrics → Metrics Explorer).

You can see the current usage of different storage devices by selecting:

* **Value:** Max of `system.filesystem.used.pct`
* **Grouped by:** `host.hostname` and `system.filesystem.device_name`

#### Filtering for encrypted data storage

The default installation of OpenCRVS uses an encrypted disk for data storage on all nodes named `/dev/mapper/cryptfs`.

You can filter the listed devices to only show these disks by using the following search clause:

`system.filesystem.device_name : "/dev/mapper/cryptfs"`

### 6. CPU usage

To monitor CPU usage:

* **Value:** Average of \[`system.process.cpu.total](<http://system.process.cpu.total>).pct`
* **Grouped by:** `host.hostname`

This shows you the average CPU load across all processes on each host. Use a 24-hour timeframe to identify patterns and peak usage periods.

***

### 6. Memory usage

To monitor memory usage:

* **Value:** `average(system.memory.actual.used.pct)`
* **Grouped by:** `host.name`

This shows you memory usage per Host

Example for Kubernetes container filtered by namespace:

* Metric: `kubernetes.container.memory.usage.bytes`
* group per: `container.name`&#x20;
* Filter by: `kubernetes.namespace`

<figure><img src="../../../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>



***

### 7. Read more

* [Host metrics](https://www.elastic.co/guide/en/observability/master/host-metrics.html)
