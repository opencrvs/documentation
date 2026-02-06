---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/technology/interoperability/national-id/mosip
---

# MOSIP

{% embed url="https://youtu.be/mUrXeuOjQZE?si=5BW217DrYOz5OU1n" %}

{% hint style="warning" %}
Watch the video above to see a successful configuration of components that are all explained in this section
{% endhint %}

### Introduction

OpenCRVS integration with MOSIP follows a very similar technical process as followed for configuring integration with any other National ID system. &#x20;

For registration, the same API endpoints are configured, "in-form authentication and verification" uses QR Code scanning or E-Signet.

In order to make MOSIP integration easier from a back-end perspective, we supply a [**mosip-api** ](https://github.com/opencrvs/mosip/tree/v1.9.0/packages/mosip-api)middleware component, which should be deployed in the OpenCRVS stack using a docker-compose configuration.  The middleware allows you to configure the required business logic for interacting with the MOSIP Packet Manager API according to your needs.

### Detailed flow diagrams

To understand the business process around the technical integration between OpenCRVS and MOSIP that is currently available, refer to this Figjam flow diagram:

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=0-1&t=tJj8mP3hENcpXbBI-1" %}

### opencrvs/mosip library

In order to make life as easy as possible for developers who wish to configure the MOSIP integration, we have abstracted away all the non-customisable logic into an NPM library and created mock servers for both MOSIP and E-Signet.

{% embed url="https://github.com/opencrvs/mosip/releases" %}

Checkout this repo and follow the README to run the middleware and mocks alongside your local instance of OpenCRVS.

### mosip-api middleware

The mosip-api middleware is a critical component that must be deployed.  This is explained further in the following sections.

{% embed url="https://github.com/opencrvs/mosip/tree/main/packages/mosip-api" %}

### Example countryconfig

We also provide an example, forked country configuration that uses this library.  You can follow exactly how we have configured the full business logic by reading the code.

{% embed url="https://github.com/opencrvs/opencrvs-countryconfig-mosip/releases" %}

### Mocks:

{% embed url="https://github.com/opencrvs/mosip/tree/main/packages/mosip-mock" %}

{% embed url="https://github.com/opencrvs/mosip/tree/main/packages/esignet-mock" %}

The following sections will delve into the configuration points in more detail.
