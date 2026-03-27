# Solution architecture

### Overview

OpenCRVS is a core component of a country's **Digital Public Infrastructure (DPI)**. It is designed primarily as an **internal, staff-facing civil registration system**, supporting registrars and government officials in recording vital events such as births and deaths.

This document outlines the key **solution architecture requirements** for implementing OpenCRVS, with guidance for technical project managers. Each section links to deeper technical documentation where applicable.

***

### 1. Interoperable role within Digital Public Infrastructure

OpenCRVS is not a standalone system. It is part of a broader ecosystem of interoperable national systems.

#### Key Characteristics

* Internal-facing system for civil registration authorities
* Provides **standardised APIs** for interoperability
* Supports integration with:
  * Self-service portals (citizen applications)
  * National ID systems
  * Health systems (birth and death notifications - ICD10/ICD11 cause of death certification)
  * Social protection systems
  * Verifiable credentials

#### DPI Context Diagram

👉 Technical documentation:

* OpenCRVS API documentation
* Interoperability guides

***

### 2. Interoperability & Data Exchange Layer

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

### 3. Verifiable Credentials & Public Key Infrastructure

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

👉 Technical documentation:

* OpenCRVS VC implementation guide

***

### 4. Hosting infrastructure & Environment Requirements

A robust hosting strategy is critical to ensure system reliability, data integrity, and operational continuity.

#### Mandatory Environments

The following environments are **non-negotiable**:

1. **QA (Quality Assurance)**
2. **Staging (Pre-Production)**
3. **Production**
4. **Backup Environment**

#### Infrastructure Considerations

**Connectivity & Security**

* Assess data centre connectivity and redundancy
* Ensure secure network architecture
* **VPN access is essential** for secure system administration and integration

**Data Security**

* Evaluate whether **disk encryption** is required based on:
  * National regulations
  * Hosting environment (cloud vs on-premise)
  * Threat model

**Storage Planning**

Storage requirements must be calculated based on:

* Population size
* Expected registration volume
* Document storage (attachments, certificates)

**Backup Strategy**

Backup approach should be selected based on scale:

* Incremental backups for large datasets
* Full backups for smaller deployments

**Disaster Recovery**

Considerations include:

* Recovery time objectives (RTO)
* Recovery point objectives (RPO)
* Cost vs resilience trade-offs

👉 Technical documentation:

* OpenCRVS deployment guide
* OpenCRVS installation guide
* Backup and disaster recovery best practices



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



