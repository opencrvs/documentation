---
description: An introduction describing how OpenCRVS interoperates
---

# Interoperability

OpenCRVS has been technically architected from conception to interoperate with other e-Gov systems in a standardised, safe and secure way.

Various APIs exist for different consumers and business use cases.  The interoperability documentation is structured around theses use cases.



### APIs requiring OAuth client credentials

OpenCRVS OAuth API client credentials are required in order for a trusted external system to integrate with OpenCRVS for the following use cases:

Performing a [R**ecord search**](create-a-client/record-search-clients.md) of the OpenCRVS database either directly using ur GraphQL Gateway or via a DCI standard middleware.

Submitting an [**"Event Notification"**](create-a-client/event-notification-clients.md) **in FHIR** from healthcare systems

Subscribing to event [**Webhooks**](create-a-client/webhook-clients.md) for status updates on a processing event



### APIs for system administrators

An API exists for system administrators to perform management of OpenCRVS reference data, specifically administrative structure, civil registration offices and health facilities on a running OpenCRVS instance in production.

This is the [FHIR Location API](./#apis-for-system-administrators) and a National System Administrators JWT is used as an authentication mechanism for these APIs.



### National ID

Integrating with an external [National ID ](national-id-client.md)system is a complex topic with multiple, optional use cases available.  A dedicated section on National ID integration exists to cover:

* Authentication and verification of informants / parents details with NID / external systems during event form completion - online / offline.
* Generation of a National ID for a citizen at birth registration
* Informing a National ID system that an individual is deceased at death registration
* Specifics when selecting MOSIP as the integrating National ID system



### Interoperability Roadmap

Our interoperability roadmap currently incudes:

* Extension of the Event Notification and Webhook APIs to support a "Self-service" civil registration portal front end.  Simplified payloads with and without FHIR
* Verifiable credentials



