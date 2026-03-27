# Monitoring

### 1. Introduction

Monitoring is essential for maintaining a healthy, reliable, and performant OpenCRVS installation. The OpenCRVS monitoring suite provides comprehensive visibility into infrastructure health, application performance, and system behavior.

OpenCRVS comes with a pre-installed suite of tools for monitoring and debugging a live installation. The [Elastic Stack](https://www.elastic.co/elastic-stack) is used to monitor the infrastructure, applications, and dependencies, and also for sending alerts on application errors and system health. All of these tools are accessed using [Kibana](https://www.elastic.co/kibana), a free and open user interface that lets you access all your Elasticsearch data, including metrics, logs, and other monitoring information.

\<aside> ℹ️

**Server-hosted environments only** — These tools are only available for server-hosted environments and are not part of the development environment.

\</aside>

***

### 2. Monitoring features

OpenCRVS monitoring provides the following core capabilities:

* **Reading and searching application logs** — view detailed logs from all services to debug issues and understand system behavior.
* **Infrastructure performance insights** — monitor disk space, CPU, and memory usage to know when to scale up.
* **Application Performance Monitoring (APM)** — track service performance, detect bottlenecks, and identify errors.
* **Automated alerting** — receive notifications for application errors and infrastructure health issues.
* **Request tracing** — follow requests through multiple services to understand the full lifecycle.

***

### 3. Getting started with Kibana

Once the environment is installed, the monitoring suite can be accessed using the `kibana.<your_domain>` URL.

#### Login credentials

The login credentials are the ones you used as `KIBANA_USERNAME` and `KIBANA_PASSWORD` as part of the [deployment](../../../v1.9.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.6-deploy-automated-and-manual), or the username "elastic" and `ELASTICSEARCH_SUPERUSER_PASSWORD`.

***

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

#### 4.3 Logstash

Logstash receives log entries in [GELF format](https://docs.graylog.org/docs/gelf) from all OpenCRVS services and writes them into the Elasticsearch database.

These logs can be viewed in real-time from **Observability** → **Logs** → **Stream** or through APM.

\<aside> ⏰

**Log retention** — By default, OpenCRVS stores all logs for three days before they are removed.

\</aside>

***

### 5. Monitoring topics

The following pages provide detailed guidance on specific monitoring topics:

#### [Application logs](https://www.notion.so/Application-logs-5ba9f9becf264795b1e37ec92fb017bf?pvs=21)

Learn how to access, search, and trace application logs to debug issues and understand system behavior.

#### [Infrastructure health](https://www.notion.so/Infrastructure-health-99780f13f8514e5c9370d977253803cd?pvs=21)

Monitor critical infrastructure metrics such as disk space, CPU usage, and memory consumption to proactively manage resources.

#### [Routine monitoring](https://www.notion.so/Routine-monitoring-f4a3af731bf94edea755b4fa4db4f8ee?pvs=21)

Establish daily monitoring practices and understand the built-in alerts to maintain a healthy installation.

#### [Setting up alerts](https://www.notion.so/Setting-up-alerts-8fdb6ad7f78144d1adac3a2439d1c9e9?pvs=21)

Configure custom alerts to notify you when critical conditions occur, ensuring rapid response to issues.

***

### 6. Read more

* [Kibana — your window into Elastic](https://www.elastic.co/guide/en/kibana/current/introduction.html#introduction)
* [Application Performance Monitoring (APM)](https://www.elastic.co/observability/application-performance-monitoring)
