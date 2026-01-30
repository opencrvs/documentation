---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.5-setup-dns-a-records
---

# 4.3.2 TLS / SSL & DNS

{% embed url="https://youtu.be/eb1aeFstOGg" %}

Watch the videos above to understand the OpenCRVS network and how TLS is configured in OpenCRVS servers

### Domain A records

Using your domain management system, A records will need to be created for all the services which are publicly exposed for **qa, production & staging** environments.

Either use a wildcard or create individual A records for your chosen environment's domain name, with a TTL of 1 hour that forwards the URL to your **manager server node's** external IP address.

#### Option 1: Wildcard required A Records:

{% hint style="info" %}
A total of 6 A Records are required for this option, 2 for each environment's domain: **qa, production & staging**
{% endhint %}

_\<your\_domain>_

_\*.\<your\_domain>_

#### Option 2: Individual A Records:

{% hint style="info" %}
A total of 42 A Records are required for this option, 14 for each environment's domain: **qa, production & staging**
{% endhint %}

_\<your\_domain>_

_auth.\<your\_domain>_

_config.\<your\_domain>_

_countryconfig.\<your\_domain>_

_documents.\<your\_domain>_

_metabase.\<your\_domain>_

_minio.\<your\_domain>_

_minio-console.\<your\_domain>_

_ui-kit.\<your\_domain>_

_gateway.\<your\_domain>_

_kibana.\<your\_domain>_

_login.\<your\_domain>_

_register.\<your\_domain>_

_webhooks.\<your\_domain>_

### TLS / SSL certificates

There are a number of ways you can configure TLS / SSL certificates for OpenCRVS. The options are explained in subsequent pages and all methods must be compatible with [Traefik](https://doc.traefik.io/traefik/https/overview/).

A free approach is to use LetsEncrypt. However LetsEncrypt certificates must validate and refresh every 3 months. When installing OpenCRVS behind a VPN, your VPN and DNS settings must be configured to enable this, and some techniques may not work in your network.

Alternatively you could consider purchasing a long term SSL certificate and manually replacing the static .crt & .key files every 1, 2 or 3 years depending on it's lifetime. The SSL certificates that you purchase must support the subdomains and each environment's domain: **qa, production & staging.** You may opt for a single, multi-domain, wildcard SSL certificate that covers all of your domains regardless of the number of subdomain levels. You need to pay close attention to your domain to understand which SSL certificate to purchase.

The following "recipes" are not meant to be exhaustive, but simply describe some examples you may wish to follow. Every country will have unique network, domain name & management considerations to pay attention to.

For each recipe, search the [docker-compose.{YOUR ENVIRONMENT}-deploy.yml](https://github.com/opencrvs/opencrvs-countryconfig/tree/develop/infrastructure) files for each environment to find the block below. In this block, you can amend configurations for each individual environment: **qa, production & staging.** Alternatively, you can remove each individual block and have a single block in [docker-compose-deploy.yml](https://github.com/opencrvs/opencrvs-countryconfig/blob/dfbf4c6a0b2962015d152c2adb4a0f8bc6038bdd/infrastructure/docker-compose.deploy.yml#L13) that will apply a generic approach applied to all environments.

```
traefik:
```
