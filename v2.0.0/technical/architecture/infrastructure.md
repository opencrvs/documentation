# Infrastructure

### Introduction

OpenCRVS is designed to run on **Kubernetes** and is typically deployed within **government-owned or government-approved infrastructure**. This deployment model supports **data sovereignty**, allowing countries to retain full control over sensitive civil registration data while meeting national security and compliance requirements.

The infrastructure used to deploy OpenCRVS is maintained separately from the application code in the **OpenCRVS Infrastructure** repository:

**Repository:** [https://github.com/opencrvs/infrastructure](https://github.com/opencrvs/infrastructure)

This repository contains the automation, deployment templates, and operational tooling required to provision, configure, upgrade, and maintain OpenCRVS environments.

***

### Infrastructure philosophy

Deploying and operating Kubernetes clusters consistently is a complex task. Rather than requiring every implementation partner to build and maintain their own deployment tooling, OpenCRVS provides a fully automated deployment framework.

The infrastructure has been designed around the principles of:

* Infrastructure as Code
* Repeatable, automated deployments
* Continuous Integration and Continuous Deployment (CI/CD)
* Standardised environments across all countries
* Minimal manual intervention

We strongly recommend using the provided automation rather than performing manual deployments or customising the deployment process unless absolutely necessary.

***

### Deployment automation

OpenCRVS infrastructure is deployed using a combination of modern DevOps technologies including:

* **GitHub Actions** for CI/CD pipelines
* **GitHub Self-Hosted Runners** for executing deployments within secure government networks
* **Ansible** for server provisioning and configuration
* **Helm** for Kubernetes application deployment and upgrades
* Kubernetes manifests and supporting automation scripts

Together these components provide automated provisioning, upgrades, application deployment, backup operations, certificate management, and many day-to-day operational tasks.

Our deployment scripts are designed to be executed from **GitHub Actions workflows** and assume this operating model.

***

### Deployment architecture

OpenCRVS provides a **reference deployment architecture** that enables countries to get up and running quickly using a standard set of components. This architecture has been used across multiple country implementations and is fully supported by the deployment automation.

A typical reference deployment includes:

* Kubernetes cluster
* GitHub Self-Hosted Runner
* Container registry
* PostgreSQL
* Elasticsearch
* Object storage
* Monitoring and logging components

This reference architecture is suitable for most initial deployments and provides a solid foundation for production use.

***

#### Scaling over time

As adoption grows and operational requirements become more demanding, countries may choose to increase disk space, decouple or replace individual infrastructure components.

Examples include:

* Moving databases onto dedicated high-availability database clusters
* Using an enterprise container registry instead of Dockerhub
* Replacing object storage with an existing government storage platform
* Scaling Kubernetes worker nodes independently to meet increasing demand

The OpenCRVS deployment automation supports this evolution, allowing infrastructure to mature without requiring changes to the application itself.

The exact production architecture should be determined according to the country's requirements for availability, scalability, security, disaster recovery, and operational support. The reference architecture provides a supported starting point, while larger deployments can progressively adopt more enterprise-grade infrastructure as needed.

***

### Country responsibilities

While OpenCRVS provides the deployment automation and application infrastructure, several external dependencies must be provided by the country implementation team before deployment can begin.

These typically include:

* Network infrastructure
* [VPN](https://documentation.opencrvs.org/technical/guides/installation/advanced-topics/why-vpn)
* DNS configuration
* TLS certificates
* SMTP email service

These services are considered prerequisites for a successful implementation and are outside the scope of the OpenCRVS infrastructure repository.

Read more:

[Preparation steps](../guides/installation/deploy-set-up-a-server-hosted-environment/preparation-steps/)

***

### Use the automation

The infrastructure repository has been developed and tested across multiple country deployments and continues to evolve as new features and operational improvements are added.

Implementation partners should use the supplied automation wherever possible. Following the standard deployment approach ensures:

* Faster deployments
* Easier upgrades
* Reduced operational risk
* Consistent environments across countries
* Better support from the OpenCRVS community

Manual deployments or significant modifications to the automation should only be undertaken where there is a clear technical or organisational requirement, as they may complicate future upgrades and support.

***

### Further reading:

* [Deploy: Set-up a server hosted environment](../guides/installation/deploy-set-up-a-server-hosted-environment/)
* [Advanced topics: Firewall config, TLS, disk space & SSH management](../guides/installation/advanced-topics/)
* [Preparation steps, including network diagram](../guides/installation/deploy-set-up-a-server-hosted-environment/preparation-steps/)
* [Automation to configure a Github environment](../guides/installation/deploy-set-up-a-server-hosted-environment/create-a-github-environment/)
* [Ansible automations to provision servers](../guides/installation/deploy-set-up-a-server-hosted-environment/provisioning-servers/)
* [Github self-hosted runners used when deploying](../guides/installation/deploy-set-up-a-server-hosted-environment/deploy/)
* [Advanced topics: Why VPN?](https://documentation.opencrvs.org/technical/guides/installation/advanced-topics/why-vpn)
