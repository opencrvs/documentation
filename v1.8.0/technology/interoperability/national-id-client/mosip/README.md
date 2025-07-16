---
description: >-
  Interoperating with MOSIP and E-Signet, OpenSource DPG solutions for National
  ID and digital identity verification
---

# MOSIP

{% embed url="https://youtu.be/mUrXeuOjQZE?si=5BW217DrYOz5OU1n" %}

### Introduction

OpenCRVS integration with MOSIP follows a very similar technical process as followed for configuring integration with any other National ID system. &#x20;

For registration, the same API endpoints are configured, "in-form authentication and verification" uses QR Code scanning or E-Signet.

In order to make MOSIP integration easier from a back-end perspective, we supply a [**mosip-api** ](https://github.com/opencrvs/mosip/tree/v1.8.0/packages/mosip-api)middleware component, which should be deployed in the OpenCRVS stack using a docker-compose configuration.  The middleware allows you to configure the required business logic for interacting with the MOSIP Packet Manager API according to your needs.

### Detailed flow diagrams

To understand the business process around the technical integration between OpenCRVS and MOSIP that is currently available, refer to this Figjam flow diagram:

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=0-1&t=tJj8mP3hENcpXbBI-1" %}

### Backlog

The following integrations between OpenCRVS and MOSIP are in development.  Should you require them in your country, we welcome contrbutions to this effort.  Please get in touch.

* Revoke a birth or death registration (a substantial legal procedure)
* In-form authentication and verification upon certificate issuance to guarantee the identity of the receiving party.
* Registration correction integration
* Name change integration

### Example set-up, using our NPM repository

In order to make life as easy as possible for developers who wish to configure the MOSIP integration, we have abstracted away all the non-customisable logic into an NPM library.

{% embed url="https://github.com/opencrvs/mosip/releases/tag/v1.8.0" %}

We also provide an example, forked country configuration that uses this library.  You can follow exactly how we have configured the full business logic by reading the code.

{% embed url="https://github.com/opencrvs/opencrvs-countryconfig-mosip/releases/tag/v1.8.0" %}

### MOSIP & E-Signet mocks for development

The library contains a mock of the MOSIP Packet Manager API endpoints used by OpenCRVS, and a mock of the E-Signet backend to ease the development process.  Any developer can start up these mocked servers and develop an integration against them. &#x20;

{% embed url="https://github.com/opencrvs/mosip/tree/v1.8.0/packages/mosip-mock" %}

{% embed url="https://github.com/opencrvs/mosip/tree/v1.8.0/packages/esignet-mock" %}

The following sections will delve into the configuration points in more detail.
