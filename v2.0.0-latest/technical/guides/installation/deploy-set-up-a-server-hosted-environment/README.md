---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.3-set-up-a-server-hosted-environment
---

# Deploy: Set-up a server-hosted environment

In this chapter, you will learn how to create and configure the infrastructure and all required components for an OpenCRVS deployment using GitHub Actions workflows.

These workflows guide you through the installation and configuration of OpenCRVS on servers

The **essential** [**preparation steps**](preparation-steps/) guide you through the following:

* Provision servers (virtual machines) & VPN.
* Configure DNS and obtain SSL certificates.
* Set up an SMTP server.
* Create the required accounts:
  * GitHub organisation
  * Docker Hub
  * 1Password (or another secrets manager)
  * Optional: other services such as Slack and Sentry

#### Fork the required repositories

If you have not already done so in the [Quick Start](../quick-start.md), fork the [countryconfig](https://github.com/opencrvs/opencrvs-countryconfig) repository and configure its CI process to push images to your container registry. See [**Fork and build the countryconfig repo**](../set-up-github-and-dockerhub-accounts.md)

Fork the [infrastructure](https://github.com/opencrvs/infrastructure) repository.

{% hint style="info" %}
The country configuration repository contains an [infrastructure](https://github.com/opencrvs/opencrvs-countryconfig/tree/develop/infrastructure) folder which supports: **Backwards compatibility for OpenCRVS versions 1.9 and below still using DockerSwarm.  Docker Swarm will be deprecated in 2.1.**  [**MIGRATE TO KUBERNETES IN TIME!**](migration-from-docker-swarm-guide.md)
{% endhint %}

All steps are described in detail in this chapter.

**Once the preparation steps are complete,** proceed with the installation steps **in order, starting with creating a Github environment**.
