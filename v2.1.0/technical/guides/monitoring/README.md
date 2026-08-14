# Monitoring

### 1. Introduction

{% hint style="info" %}
All key OpenCRVS components support the OpenTelemetry tracing standard starting from version 2.1, enabling seamless integration with cloud providers such as AWS, Azure, and GCP, as well as managed monitoring solutions such as Datadog and New Relic.
{% endhint %}

{% hint style="info" %}
**Server-hosted environments only** — These tools are only available for server-hosted environments and are not part of the development environment.
{% endhint %}

Monitoring helps keep an OpenCRVS installation healthy, reliable, and performant by providing visibility into infrastructure, application performance, and system behavior.

OpenCRVS includes pre-installed tools for monitoring and debugging live installations. The  [Elastic Stack](https://www.elastic.co/elastic-stack) collects metrics, logs, and alerts, while [Kibana](https://www.elastic.co/kibana) provides access to this observability data.

By default, monitoring and logging data is retained for the last 30 days.

This page gives you brief overview how to use preconfigured monitoring solution.

Additional reading:

* For more information how to setup monitoring please visit helm chart documentation [README.md](https://github.com/opencrvs/opencrvs-core/blob/develop/charts/dependencies/README.md)
* Additional information how to manage disk space for Elasticsearch check [elasticsearch-disk-management.md](../installation/advanced-topics/elasticsearch-disk-management.md "mention")

### 2. Monitoring features

OpenCRVS monitoring provides the following core capabilities:

* **Reading and searching application logs** — view detailed logs from all services to debug issues and understand system behaviour.
* **Infrastructure performance insights** — monitor disk space, CPU, and memory usage to know when to scale up.
* **Application Performance Monitoring (APM)** — track service performance, detect bottlenecks, and identify errors.
* **Automated alerting** — receive notifications for application errors and infrastructure health issues.
* **Request tracing** — follow requests through multiple services to understand the full lifecycle.

***

### 3. Getting started with Kibana

Once the environment is installed, the monitoring suite can be accessed using the `kibana.<your_domain>` URL.

#### Login credentials

The login credentials from [GitHub environment creation process](../installation/deploy-set-up-a-server-hosted-environment/create-a-github-environment/):

* `KIBANA_USERNAME` and `KIBANA_PASSWORD`&#x20;
* username "elastic" and `ELASTICSEARCH_SUPERUSER_PASSWORD`.

### 4. Monitoring tools

OpenCRVS uses several specialized tools as part of the monitoring stack:

#### 4.1 Metricbeat

Metricbeat gets installed on all host machines in your infrastructure. Its sole purpose is to collect data about the network, the host machines, and the Docker environment. The data is stored in the OpenCRVS Elasticsearch database.

This data can be viewed by navigating to **Observability** → **Metrics** and selecting either **Inventory** or **Metrics Explorer**. The data can be visualized, grouped, and filtered in these views.

#### 4.2 Application Performance Monitoring (APM)

The OpenCRVS monitoring stack comes with a pre-installed Application Performance Monitoring tool (APM). This tool collects performance metrics, errors, and HTTP request information from each of the services in the OpenCRVS stack.

You can find this tool in Kibana by navigating to **Observability** → **APM** → **Services**. This tool can be used to:

* Catch anomalies such as errors happening inside the services
* Detect bottlenecks in the architecture
* Identify which services should be scaled up

### 5. Monitoring topics

The following pages provide detailed guidance on specific monitoring topics:

#### [application-logs.md](application-logs.md "mention")

Learn how to access, search, and trace application logs to debug issues and understand system behavior.

#### [infrastructure-health.md](infrastructure-health.md "mention")

Monitor critical infrastructure metrics such as disk space, CPU usage, and memory consumption to proactively manage resources.

#### [routine-monitoring.md](routine-monitoring.md "mention")

Establish daily monitoring practices and understand the built-in alerts to maintain a healthy installation.

#### [setting-up-alerts.md](setting-up-alerts.md "mention")

Configure custom alerts to notify you when critical conditions occur, ensuring rapid response to issues.

***

### 6. Read more

* [elasticsearch-disk-management.md](../installation/advanced-topics/elasticsearch-disk-management.md "mention")
* [OpenCRVS Dependencies and monitoring helm chart README.md](https://github.com/opencrvs/opencrvs-core/blob/develop/charts/dependencies/README.md)
* [Kibana — your window into Elastic](https://www.elastic.co/guide/en/kibana/current/introduction.html#introduction)
* [Application Performance Monitoring (APM)](https://www.elastic.co/observability/application-performance-monitoring)
