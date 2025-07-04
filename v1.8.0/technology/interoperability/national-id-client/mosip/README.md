---
description: >-
  Interoperating with MOSIP and E-Signet, OpenSource DPG solutions for National
  ID and digital identity verification
---

# MOSIP

{% embed url="https://youtu.be/mUrXeuOjQZE?si=5BW217DrYOz5OU1n" %}

### Introduction

OpenCRVS integration with MOSIP follows a very similar technical process for configruing integration with any National ID system. &#x20;

For registration, the same API endpoints are configured in the same way, but we additionally supply a [**mosip-api** ](https://github.com/opencrvs/mosip/tree/v1.8.0/packages/mosip-api)middleware which converts the payloads into those that are understood by the MOSIP Packet Manager API.

In-form authentication and verification uses E-Signet and the [**mosip-api** ](https://github.com/opencrvs/mosip/tree/v1.8.0/packages/mosip-api)middleware is also used to retrieve and decode the information returned.



### Example set-up, using our NPM repository

In order to make life as easy as possible for developers who wish to configure the MOSIP integration, we have abstracted away all the interoperability and form component logic into an NPM repository.

{% embed url="https://github.com/opencrvs/mosip/releases/tag/v1.8.0" %}

We habve also provided an example, forked country configuration that uses this repository.  You can follow exactly how we have configured the full business logic by reading the code.

{% embed url="https://github.com/opencrvs/opencrvs-countryconfig-mosip/releases/tag/v1.8.0" %}

### MOSIP & E-Signet mock

The NPM repository contains a mock of the MOSIP Packet Manager API endpoints used by OpenCRVS, and a mock of the E-Signet backend to ease the development process.  Any developer can start up these mocked servers and develop an integration against them. &#x20;

{% embed url="https://github.com/opencrvs/mosip/tree/v1.8.0/packages/mosip-mock" %}

{% embed url="https://github.com/opencrvs/mosip/tree/v1.8.0/packages/esignet-mock" %}

The following sections will delve into the configuration points in more detail.
