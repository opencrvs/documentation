# Architecture

<mark style="background-color:$warning;">This page is an overview to Architecture</mark> \
\ <mark style="background-color:$warning;">Exsiting content here. Copy where relevane tinto sub sections</mark>

### 1. Introduction

OpenCRVS is built using a **modular, event-driven microservices architecture** designed for scalability, configurability, and data sovereignty. The technical architecture enables countries to deploy OpenCRVS in on-premise private tier 2/3 data centres using included configurations, ensuring that civil registration data remains under national control.

This section describes:

* The core architectural principles and technology choices.
* Infrastructure components (databases, orchestration, networking).
* Microservices structure and organisation.
* Client application architecture.
* Deployment and hosting considerations.

For detailed guidance on server hosting and network architecture, visit the [setup documentation](../../../v1.9.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment).

***

### 2. Architectural principles

OpenCRVS architecture is designed to deliver a **low total cost of ownership** while meeting the unique requirements of civil registration systems in low-resource settings.

**Core principles:**

* **Modularity** — each component is independently scalable and replaceable.
* **Data sovereignty** — all data can be hosted on-premise in national infrastructure.
* **Offline capability** — frontline staff can work without connectivity and sync when online.
* **Standards-based** — use of open standards for interoperability and integration.
* **Single codebase** — TypeScript and JavaScript across backend and frontend reduce maintenance overhead.
* **Configurability over customisation** — most country requirements can be met through configuration rather than code changes.

***

### 3. Infrastructure components

#### 3.1 Container orchestration

**Docker Swarm** is the default orchestration platform for OpenCRVS deployments as of version 1.9.

Docker Swarm was chosen in 2018 because, at the time, dependencies supporting bare-metal installations for Kubernetes architectures were in their infancy and difficult to understand. Many countries cannot legally support international data storage of citizen data on a public cloud, so were dependent on something quick and easy to install in a tier 2 data centre.

Docker Swarm enables:

* Simple deployment and management in tier 2/3 data centres.
* Independent scaling of each microservice container.
* Rapid upskilling for system administrators.
* Low operational complexity compared to alternatives.

**Kubernetes available in OpenCRVS 2.0**

Since 2018, Kubernetes bare-metal tooling has advanced significantly. The work-in-progress **Kubernetes** installation will be easier to use and configure. As of OpenCRVS 1.9, Docker Swarm remains the supported deployment mechanism.

#### 3.2 Databases

OpenCRVS uses multiple database technologies, each optimised for specific purposes:

**PostgreSQL**

* Stores event registration data.
* Provides transactional integrity and relational queries.
* Primary data store for all registered records.

**Elasticsearch**

* Industry-standard NoSQL document-oriented real-time search engine.
* Enables lightning-fast, intelligent civil registration record searches.
* Supports "fuzzy" search parameters for imprecise queries.
* Powers de-duplication management to ensure data integrity.
* Used with Kibana for application and server health monitoring.

**MongoDB** (legacy)

* Some legacy code in OpenCRVS 1.9 still uses MongoDB.
* This dependency will be deprecated in future releases.

**InfluxData** (legacy)

* Used in some legacy monitoring components.
* This dependency will be deprecated in future releases.

#### 3.3 Object storage

**Minio**

* Amazon S3-compatible object store.
* Stores supporting documentation attachments (images, scanned documents).
* Can be deployed on-premise for data sovereignty.

#### 3.4 Business intelligence

**Metabase**

* Default BI tool for analytics and performance dashboards.
* Can be substituted with any BI tool that connects to PostgreSQL.
* Provides pre-configured operational views (workload, timeliness, completion rates).

#### 3.5 Security and networking

**LetsEncrypt**

* Automatic SSL certificate configuration and renewal.
* Ensures encrypted communication between clients and servers.

**SMS 2-Factor Authentication**

* Built-in 2FA for all user authentication.
* Configurable SMS gateway integration.

**Monitoring**

* Kibana for external server and application health monitoring.
* Real-time visibility into system performance and errors.

***

### 4. Microservices architecture

The core of OpenCRVS is a **monorepo** organised using **Lerna**. Each package represents a single Node.js microservice. Following the microservice model of one service per container, every package is independently scalable in a single Docker container.

#### 4.1 Technology stack

All microservices are written in **TypeScript** (a strictly typed superset of JavaScript that compiles to JavaScript).

**Benefits of TypeScript:**

* Type safety reduces runtime errors.
* Improved developer experience with better tooling and autocomplete.
* Easier refactoring and maintenance.
* Single language across frontend and backend.

#### 4.2 Microservice principles

Each microservice in OpenCRVS:

* Has **no knowledge** of other services or business requirements in the application.
* Exposes its capabilities via **JWT-secured APIs**.
* Can be **scaled independently** based on load.
* Is **deployed in its own container** for isolation and resilience.

This architecture enables continuous evolution of business requirements without tightly coupling components.

#### 4.3 Inter-service communication

Services communicate via:

* **HTTP APIs** secured with JWT tokens.
* **Event-driven messaging** for asynchronous workflows.
* Well-defined contracts that enable independent service evolution.

#### 4.4 Business logic extensibility

**HTTP hooks** allow implementers to programmatically extend backend business logic without modifying core services. This supports country-specific requirements while preserving upgradeability.

***

### 5. Client application architecture

OpenCRVS client applications are built using **React** and **Progressive Web Application (PWA)** technology.

#### 5.1 Progressive Web Applications

PWA technology enables:

* **Offline functionality** — users can work without connectivity and sync later.
* **Native mobile features** — camera access, push notifications, home screen installation.
* **Single codebase** — no separate web and mobile codebases to maintain.
* **No app store overhead** — updates deploy instantly without app store releases.

#### 5.2 Offline capability

In remote areas, registrars can save a configurable number of registrations offline on their mobile phone using Chrome's **IndexedDB**.

Offline architecture uses **Workbox** to:

* Cache application assets for offline access.
* Queue record updates for later synchronisation.
* Resolve conflicts when devices reconnect.

#### 5.3 Technology stack

**React**

* Component-based UI framework.
* Enables reusable, testable interface components.
* Large ecosystem and community support.

**TypeScript**

* Type safety across frontend codebase.
* Shared types with backend services.
* Improved developer experience.

***

### 6. Content management

OpenCRVS provides **standards-based multi-language content management** to support countries with multiple official languages.

Features include:

* Translation management for all user-facing text.
* Language-specific formatting (dates, numbers, addresses).
* Configurable default and fallback languages.

***

### 7. Automated testing and delivery

OpenCRVS includes an **automated continuous integration, delivery, and testing suite** that enables:

* Rapid identification of regressions.
* Automated quality gates before deployment.
* Repeatable, predictable releases.
* Confidence in upgrades and configuration changes.

***

### 8. Deployment architecture

#### 8.1 Hosting requirements

OpenCRVS can be deployed:

* **On-premise** in tier 2 or tier 3 data centres.
* **Cloud-hosted** on any infrastructure provider (AWS, Azure, GCP, etc.).
* **Hybrid** configurations combining on-premise and cloud components.

For detailed server specifications and setup guidance, see the [installation documentation](../../../v1.9.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment).

#### 8.2 Scalability

Each microservice can be scaled independently by:

* Adding additional container instances.
* Distributing load across multiple nodes.
* Tuning resource allocation per service.

#### 8.3 Network architecture

The deployment includes:

* Load balancing and reverse proxy.
* Internal service mesh for inter-service communication.
* External API gateway for integrations.
* Firewall and network segmentation for security.

***

### 9. Visual architecture overview

…

***

### 10. Related documentation

For more detail on specific aspects of the OpenCRVS architecture, see:

* **Functional Architecture** — the functional model, modules, and record lifecycle
* **Security** — authentication, authorisation, and data protection
* **Non-functional requirements** — performance targets and system quality attributes
* **Integrations** — inbound and outbound APIs for interoperability
