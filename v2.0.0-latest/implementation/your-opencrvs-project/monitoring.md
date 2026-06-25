# Monitoring

### 1. Introduction

Monitoring is an essential operational activity for every OpenCRVS implementation. Effective monitoring enables support teams to identify and resolve issues before they affect users, helping to maximise system availability and minimise service disruption.

This page provides a high-level overview of monitoring and alerting within OpenCRVS. The [technical monitoring guidance](../../technical/guides/monitoring.md) explains how to configure monitoring tools, create alerts and investigate operational issues.

**Where this sits:** Monitoring begins immediately after Go-live and continues throughout the lifetime of the system as part of routine operations and support.

***

### 2. Why monitoring matters

Operating a national civil registration system requires continuous oversight of both the application and the infrastructure on which it runs.

Many operational issues develop gradually before users notice them. Examples include increasing disk usage, failing services, repeated authentication attempts or application errors. Monitoring allows support teams to detect these conditions early and take corrective action before they become service outages.

Monitoring should therefore form part of the responsibilities of all operational support teams.

***

### 3. Monitoring OpenCRVS

OpenCRVS provides monitoring capabilities that allow support teams to observe both system health and application behaviour.

At a high level, monitoring consists of:

**Monitor infrastructure health** — ensure that servers and supporting services remain healthy by monitoring system logs, resource utilisation, storage capacity and security-related events.

**Monitor application behaviour** — identify application errors and exceptions as users experience them, allowing issues to be investigated before they become widespread.

**Respond to alerts** — configure automated notifications so that operational teams are informed whenever predefined conditions are met, allowing timely investigation and resolution.

**Investigate incidents** — use historical logs and diagnostic information to determine the cause of issues and verify that corrective actions have resolved them.

***

### 4. Monitoring tools

OpenCRVS provides recommended tools to support operational monitoring.

**Kibana** provides operational visibility into the infrastructure and OpenCRVS services. It can be configured to send automated email alerts for conditions such as:

* server and application log events
* failed SSH login attempts and other security events
* disk space exhaustion
* service failures
* other infrastructure health indicators

Kibana also provides searchable historical logs for each OpenCRVS service, allowing support teams to investigate incidents over a configurable retention period.

**Sentry** monitors application errors from the user's perspective. It captures software exceptions and performance issues as they occur, enabling support teams to identify defects, understand their impact and prioritise corrective action.

Together, these tools provide a comprehensive view of both infrastructure health and user experience.

***

### 5. Operational responsibilities

Monitoring is only effective when alerts are acted upon. Project teams should establish operational procedures that define:

* who receives alerts
* how incidents are prioritised and escalated
* expected response and resolution times
* how incidents are investigated and documented
* how recurring issues are analysed and permanently resolved

Monitoring should be considered an integral part of the L1-L3 support process, helping teams detect problems early, maintain service availability and continually improve the reliability of the OpenCRVS deployment.

***

### 6. Resources and support

Understand [operational support](operational-support.md) service level expectations

Technical [monitoring guides](../../technical/guides/monitoring.md)
