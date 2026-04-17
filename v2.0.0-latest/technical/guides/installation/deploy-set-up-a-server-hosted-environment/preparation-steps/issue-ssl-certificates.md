# Issue SSL Certificates

There are a number of ways you can configure TLS / SSL certificates for OpenCRVS. The options are explained in detail in the [Advance topics > TLS/SSL Configuration for traefik](../../advanced-topics/tls-ssl-configuration-for-traefik/) section. All methods must be compatible with [Traefik](https://doc.traefik.io/traefik/https/overview/).

At a high-level, here is a brief intro to the subject.



**Free LetsEncrypt certificates**

A free approach is to use LetsEncrypt. However LetsEncrypt certificates must validate and refresh every 3 months.&#x20;

{% hint style="info" %}
The OpenCRVS installation script will automatically configure Traefik to obtain and use dynamic Let's Encrypt SSL certificates for you that automatically refresh.

**This automated option is available for testing and demonstration purposes, and not for production environments.** &#x20;

The server must be accessible from the public internet for this automated process to work.  Therefore, as the server is not behind a VPN, the approach isnt suitable in production.
{% endhint %}

When installing OpenCRVS behind a VPN, **required for production and staging environments**, it's technically possible to create and refresh static LetsEncrypt certs every 3 months, with different approaches for certifcate validation via your DNS server.

For more information see official documentation [https://letsencrypt.org/docs/challenge-types/](https://letsencrypt.org/docs/challenge-types/)



**Purchasing long term certificates**

Most government networks require you to purchase or use a long term SSL certificate per environment, and manually replacing the static .crt & .key files every 1, 2 or 3 years depending on it's lifetime.&#x20;

Some governments have their own public key infrastructure to issue these static certs.&#x20;

The SSL certificates that you obtain must support the [DNS](configure-dns.md) subdomains for each environment's individual domain: **qa, production & staging.** &#x20;

You may opt for a single, wildcard SSL certificate for each domain.&#x20;



**Technical guide**

For detailed technical guidance on how to configure the various options in helm charts read [Advance topics > TLS/SSL Configuration for traefik](../../advanced-topics/tls-ssl-configuration-for-traefik/)
