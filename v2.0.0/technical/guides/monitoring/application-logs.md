# Application logs

### 1. Introduction

All services in the OpenCRVS architecture emit logs that can be observed in real-time. Application logs provide detailed information about system behavior, HTTP requests and responses, informational events, and errors.

The most common use case for viewing logs is debugging an issue with the installation. The logs from each service are collected automatically by Filebeat and sent to Kibana for developers and maintainers to easily access.

**What logs contain:**

* HTTP requests and responses
* Informational logging (for example, countryconfig service sending 2FA email)
* Errors that have happened as part of requests
* System events and state changes

{% hint style="info" %}
- This document covers only basics, for more information how to work with Kibana please visit official website: [https://www.elastic.co/guide/en/kibana/8.19/index.html](https://www.elastic.co/guide/en/kibana/8.19/index.html)
- Discover is not covered on this page, please visit official documentation
{% endhint %}

### 2. Application logs

To access the logs of a specific service, first log in to Kibana and navigate to **Observability** → **APM** → Service Inventory, open up the service you want to observe:

* For Kubernetes clusters with multiple OpenCRVS instances (environments) use "Environment" filter to choose your environment
* Search log items by providing a time range

<figure><img src="../../../.gitbook/assets/image (13).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (14).png" alt=""><figcaption><p>Screenshot shows traefik service access logs. View logs for particular environment by narroving down results in "Environment" selector. Use date/time range to select logs for specific interval, use "Actions" to view more details from the log.</p></figcaption></figure>

### 3. Traces view

Another way of finding a specific request is by finding it through the **Observability** → **APM** → **Traces** or Switch to Transactions tab under selected service.

In this view, you can:

* See all requests that happened in the selected time interval grouped by the type of the request
* View average timings and error rates for each request type
* See trace samples of all actual requests made during the specified time interval

<figure><img src="../../../.gitbook/assets/image (15).png" alt=""><figcaption><p>All incoming requests go through Traefik ingress controller, almost always it will be on the top of the list. On the screenshot all transactions that took longer then 1 second (1000000us) are shown.</p></figcaption></figure>

#### Using the traces view

By clicking on the request type you are interested in observing, you can see:

* Average timings for that request type
* Error rates
* Trace samples at the bottom of the page showing all actual requests made during the specified time interval

This is especially useful for:

* Figuring out in which service the request fails
* Detecting bottlenecks in the architecture

<figure><img src="../../../.gitbook/assets/image (17).png" alt=""><figcaption><p>Transaction information is useful to identify particular service latency</p></figcaption></figure>

By clicking on **Investigate** → **Trace logs** you can navigate back to the logs view to see all logs corresponding to the selected request.
