# Solution architecture

### Overview

OpenCRVS is a core component of a country's **Digital Public Infrastructure (DPI)**. It is designed primarily as an **internal, staff-facing civil registration system**, supporting registrars and government officials in recording vital events such as births and deaths.

This document outlines the key **solution architecture requirements** for implementing OpenCRVS, with guidance for technical project managers. Each section links to deeper technical documentation where applicable.

***

### OpenCRVS' role within Digital Public Infrastructure

OpenCRVS is part of a broader ecosystem of interoperable national systems that holistically provide end-to-end services to citizens.

#### Key Characteristics

* Internal-facing system for civil registration authorities for use in office & at counter services.
* Provides **standardised APIs** for interoperability with a recommended data exchange layer such as XRoad or OpenFN or direct integrations if such a layer doesnt exist.
* OpenCRVS APIs supports integration with:
  * Self-service portals (citizen applications)
  * National ID systems
  * KYC
  * Payment and reconciliation gateways
  * Messaging and notification services
  * Health systems (birth and death notifications - ICD10/ICD11 cause of death certification)
  * Social protection systems
  * Legal and educational infrastructure
  * Statistics
  * Public Key Infrastructure enabling "verifiable credentials"

#### OpenCRVS within a Government System Architecture

TODO: diagram

***

### Interoperability & Data Exchange Layer

While OpenCRVS exposes APIs for direct integration, **a dedicated data exchange layer is strongly recommended**.

#### Why a Data Exchange Layer?

A middleware or interoperability layer provides:

* Automation of data flows
* Transformation and mapping between systems
* Audit trails and observability
* Decoupling between systems
* Improved scalability and maintainability

Countries should implement and manage a separate interoperability platform such as:

* OpenFN
* X-Road
* OpenHIM

These platforms act as **Digital Public Goods (DPGs)** designed specifically for secure system-to-system communication.

***

### Verifiable Credentials & Public Key Infrastructure

OpenCRVS includes capabilities to **issue Verifiable Credentials (VCs)** such as digital birth certificates.

#### Important Considerations

* OpenCRVS is **not a Public Key Infrastructure (PKI) solution**
* It does not manage:
  * Root certificate authorities
  * Trust registries
  * Key lifecycle management

#### Requirements for VC Implementation

To fully utilise VC functionality, countries must:

* Establish a national PKI strategy, **or**
* Partner with trusted external providers

This includes:

* Key management policies
* Trust frameworks
* Governance for credential issuance and verification

***

### Summary

Implementing OpenCRVS requires careful alignment with national digital infrastructure strategy. Key architectural principles include:

* Treating OpenCRVS as part of a broader DPI ecosystem
* Using a dedicated interoperability layer
* Planning for PKI when implementing verifiable credentials
* Ensuring robust, secure, and scalable hosting environments

A well-designed architecture will ensure interoperability, scalability, and long-term sustainability of civil registration services.

***

### Further Reading

* CDPI Digital Public Infrastructure principles



