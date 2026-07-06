# MOSIP Overview

{% embed url="https://youtu.be/mUrXeuOjQZE?si=5BW217DrYOz5OU1n" %}

{% hint style="warning" %}
Watch the video above to see a successful configuration of components that are all explained in this section
{% endhint %}

#### Introduction

OpenCRVS integration with MOSIP follows a very similar technical process as followed for configuring integration with any other National ID system.

For registration, the same API endpoints are configured. "In-form authentication and verification" uses QR Code scanning or eSignet. All integration behaviour is driven by country-level configuration in the [opencrvs-integrationland](https://github.com/opencrvs/opencrvs-integrationland) repository.

From a back-end perspective, integration logic is split across two layers:

* **Country configuration** ([opencrvs-integrationland](https://github.com/opencrvs/opencrvs-integrationland)) — Contains business logic: eligibility rules, data mapping, event handlers. This is where you customise MOSIP behaviour.
* [**mosip-api**](https://github.com/opencrvs/mosip/tree/main/packages/mosip-api) **middleware** — A reusable Docker component that handles low-level communication with MOSIP services (Packet Manager, eSignet, ID Auth SDK, WebSub). Deploy as-is; no code changes needed.

#### Detailed flow diagrams

To understand the business process around the technical integration between OpenCRVS and MOSIP that is currently available, refer to this Figjam flow diagram:

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=0-1&t=tJj8mP3hENcpXbBI-1" %}

#### `@opencrvs/mosip` library

In order to make life as easy as possible for developers who wish to configure the MOSIP integration, we have abstracted away all the non-customisable logic into an NPM library and created mock servers for both MOSIP and E-Signet.

{% embed url="https://github.com/opencrvs/mosip/releases" %}

Check out this repo and follow the README to run the middleware and mocks alongside your local instance of OpenCRVS. See [mock-identities.json](https://github.com/opencrvs/mosip/blob/release-v2.0.0/docs/mock-identities.json) for both eSignet & ID Auth mock identities.&#x20;

#### mosip-api middleware

The mosip-api middleware is a critical component that must be deployed. This is explained further in the following sections.

{% embed url="https://github.com/opencrvs/mosip/tree/main/packages/mosip-api" %}

#### Example country configuration: opencrvs-integrationland

The [opencrvs-integrationland](https://github.com/opencrvs/opencrvs-integrationland) repository provides a fully operational country configuration that implements the MOSIP integration. You can follow exactly how we have configured the full business logic by reading the code.

Key files:

| Purpose                                   | File                                                                                                                                      |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| MOSIP eligibility logic & form helpers    | [`src/events/mosip.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/mosip.ts)                     |
| MOSIP birth & death registration handlers | [`src/api/registration/index.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/registration/index.ts) |
| Birth correction action handler           | [`src/api/events/handler.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/events/handler.ts)         |
| Route definitions                         | [`src/index.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/index.ts)                                   |
| Environment variables                     | [`src/environment.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/environment.ts)                       |
| Constants                                 | [`src/constants.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/constants.ts)                           |
| Form pages (birth)                        | [`src/events/birth/forms/pages/`](https://github.com/opencrvs/opencrvs-integrationland/tree/release-v2.0.0/src/events/birth/forms/pages)  |
| Form pages (death)                        | [`src/events/death/forms/pages/`](https://github.com/opencrvs/opencrvs-integrationland/tree/release-v2.0.0/src/events/death/forms/pages)  |

#### Mocks

* [mosip-mock](https://github.com/opencrvs/mosip/tree/main/packages/mosip-mock)
* [esignet-mock](https://github.com/opencrvs/mosip/tree/main/packages/esignet-mock)

The following sections will delve into the configuration points in more detail.
