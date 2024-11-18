---
description: Table in recommendation order
---

# 🏅 Options for resolving an HTTPS certificate



<table><thead><tr><th width="274">Option</th><th width="161" data-type="checkbox">Production ready</th><th width="110" data-type="rating" data-max="5">Difficulty</th><th data-type="checkbox">Automatic renewal</th></tr></thead><tbody><tr><td><a href="https://letsencrypt.org/docs/challenge-types/#dns-01-challenge">Let's encrypt with DNS-01 challenge <br>(OpenCRVS >=1.4.0)</a></td><td>true</td><td>2</td><td>true</td></tr><tr><td>Country-provided HTTPS certificate</td><td>true</td><td>3</td><td>false</td></tr><tr><td>Certificates manually generated with Let's Encrypt</td><td>true</td><td>4</td><td>false</td></tr><tr><td>A domain name that only exists for the VPN users, self-signed certificate</td><td>true</td><td>5</td><td>true</td></tr><tr><td><a href="https://letsencrypt.org/docs/challenge-types/#http-01-challenge">Let's Encrypt with HTTP-01 challenge <br>(OpenCRVS &#x3C;1.4.0)</a></td><td>false</td><td>1</td><td>true</td></tr></tbody></table>



## Limitations per approach

### Let's encrypt with DNS-01 challenge (OpenCRVS >=1.4.0)

1. Country needs to use a DNS provider listed [here](https://doc.traefik.io/traefik/https/acme/#providers).
2. Application servers need to be able to make requests to the public internet.

Easiest option to maintain in the long term. Easy to configure.

### Country-provided HTTPS certificate

1. Typically costs \~$100-200 per year

Some knowledge of certificates and confirmation chains required. Needs to be renewed every year or so. This is the typical solution for government software.

### Certificates manually generated with Let's Encrypt

1. Certificate needs to be manually renewed every 3 months.

Somewhat easy to generate the certificates using `certbot` using other provider instead of LE makes more sense thus **not recommended.**

### A domain name that only exists for the VPN users, self-signed certificate

1. Requires an infrastructure expert

Another common option in governmental software.

### Let's Encrypt with HTTP-01 challenge (OpenCRVS <1.4.0)

1. Requires the application HTTP server to be available in the public internet

**Not recommended.**

