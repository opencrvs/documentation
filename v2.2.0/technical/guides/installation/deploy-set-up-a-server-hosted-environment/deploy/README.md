# Deploy

This deployment guide covers deployment processes for the following components:

* OpenCRVS Dependencies: Datastores, Monitoring
* OpenCRVS Core and Country config template: Core components and Configuration container

All OpenCRVS images except the country configuration template are hosted in the [GitHub container registry](https://github.com/orgs/opencrvs/packages?ecosystem=container).

Before you deploy, make sure that your country configuration image is published to your container registry. See [Publish image to container registry](../../publish-image-to-container-registry.md).

{% hint style="warning" %}
We strongly recommend that you have enabled an [approval](../create-a-github-environment/approval-process-for-production-environments.md) process for all deployment scripts to **production** and **staging** environments.
{% endhint %}
