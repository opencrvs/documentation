# Functional Architecture

### 1. Introduction

The OpenCRVS **functional architecture** provides a generic model for understanding how the application works, so that it can be configured to support the specific civil registration needs of any country.

This section:

* Defines the **core concepts and vocabulary** used throughout the documentation.
* Describes the main **functional modules** (Events, Records, Workflows, Access, Aggregate Data, Interoperability).
* Summarises the **record lifecycle** from notification to certification.
* Clarifies the boundary between **configuration** and **customisation**.

The focus here is on the **functional model**, not infrastructure or deployment.

***

### << DIAGRAM >>

### 2. Audience

The functional architecture is intended for:

* **Product owners** defining the civil registration solution.
* **Business analysts** translating law and policy into requirements.
* **Solution architects** designing how OpenCRVS fits into the wider ecosystem.
* **Implementation teams** configuring and operating OpenCRVS for a country.

***

### 3. Core concepts and vocabulary

OpenCRVS uses a consistent set of concepts across modules:

* **Event** – a civil registration event type such as birth, death, marriage, etc.
* **Record** – the data instance for a single event.
* **Notification** – a preliminary capture of event details that may form the basis of a formal declaration.
* **Declaration** – a formal statement that an event has taken place.
* **Registration** – the process by which an event record is reviewed and legally registered.
* **Certified copy / certificate** – an official document representing a registered event.
* **Informant** – the person who formally reports the event.
* **Workflow** – the ordered steps and rules that govern a record through its lifecycle.
* **Status** – the state of a record in the workflow (for example, Draft, Notified, Declared, Registered).
* **Action** – a user or system operation that changes a record or its status (for example, Notify, Declare, Validate, Register, Correct, Issue certificate).
* **Form** – the structured data capture for an event, defined by fields, conditional logic, and validations.
* **Business rule** – a configurable rule that validates data or controls workflow behaviour.
* **Administrative unit** – the organisational unit responsible for services for a specific area.
* **User / role** – the authenticated user and their permission set.

These concepts underpin the modules described below.

***

### 4. Functional modules

The functional architecture is organised into a small set of modules. Each module has its own documentation section with more detail.

#### 4.1 Events module

Defines **what** can be registered.

Includes:

* **Types** – event catalogue and type-specific behaviour.
* **Forms** – event forms and validation rules for Notify/Declare, Correct, and other actions.
* **Business rules** – rules that control eligibility, late registration, approvals, and other event-specific behaviour.
* **UINs** – unique identifiers associated with events and persons (for example, Tracking ID, Registration number, National ID integration).

#### 4.2 Workflows module

Describes **how records move through the system and how users interact with them**.

Includes:

* **Administrative structure**
* **Users** – roles, scopes, jurisdictions, and workqueue access.
* **Actions** – configured operations that users can perform on records.
* **Workqueues** – pre-filtered lists of records that require action.
* **Jurisdictions** -
* **Offline working** – assignment, Outbox, and sync behaviour.
* **Deduplication** – detection and review of potential duplicate records.
* **Comms** – SMS/email notifications linked to actions.

#### 4.3 Records module

Describes **how a single event record is represented and evolves over time**.

Includes:

* **Record data** – the journaled data model for event content and action metadata.
* **Statuses** – lifecycle states such as Draft, Notified, Declared, Registered, Corrected.
* **Flags** – additional workflow markers (for example, late-registration, pending-attestation, protected) that complement status.
* **Certificates** – outputs generated from registered records.
* **Verifiable Credentials** – outputs generated from registered records.
* **Protected data** – mechanisms for hiding sensitive records or fields from general search.
* **Audit** – immutable history of actions taken on records.

#### 4.4 Search module

...

#### 4.5 Access module

Describes **who can do what and see which data**.

Includes:

* **User management** – user accounts, roles, assignment to offices.
* **Applications**
* **Security** – authentication, 2FA, screen lock PIN, and audit of security-relevant actions.

#### 4.6 Aggregate Data module

Describes **how operational data is aggregated for performance and statistics**.

Includes:

* **Performance views** – operational dashboards (for example, workload, timeliness, rejection and correction rates).
* **Vital statistics export** – structured outputs for vital statistics production.
* **Person centricity** – person-level views linking multiple records where identifiers permit.

#### 4.7 Interoperability module

Describes **how OpenCRVS exchanges data with other systems**.

Includes:

* **Inbound APIs** – receiving notifications or data from external systems (for example, health, ID).
* **Outbound APIs** – exposing events, certificates, and statistics to other systems.
* **Event notifications & verifiable credentials** – pushing structured updates and reusable proofs beyond OpenCRVS.

#### 4.8 Legacy data module

...

***

### ~~5. Lifecycle model~~

~~Each event type has a **state machine** that describes how records move through the system.~~

~~A typical flow is:~~

> ~~**Draft → Notified → Declared → Registered**~~

~~with auxiliary flows for:~~

* ~~**Editing** – editing a declared record~~
* ~~**Correction** – correcting data after registration through a governed process.~~
* ~~**Archiving -** archiving erroneous or invalid declarations.~~
* ~~**Revocation** – revoking erroneous or invalid registrations.~~
* ~~**Re‑issue** – issuing replacement certificates or additional certified copie~~s.

~~**Business rules** determine:~~

* ~~Which actions are available in each status.~~
* ~~Who can perform those actions (role, scope, jurisdiction).~~
* ~~Which flags are set or cleared when actions complete.~~

***

### 6. Configuration vs customisation

Country implementations should meet requirements primarily through the **configuration package**, which covers:

* Event types, forms, and validation rules.
* Business rules and workflows.
* Roles, scopes, and administrative structure.
* Certificates, communications, and aggregate data views.
* Deduplication logic and offline behaviour.

Custom code should be considered only when configuration cannot reasonably meet a requirement. When customisation is necessary, it should:

* Follow the core architecture patterns.
* Minimise divergence from the standard product.
* Be designed so that future upgrades remain feasible.

***

### 7. Cross‑cutting concerns

Several concerns apply across all modules:

* **Security and privacy** – role-based access, audit trails for all changes, data minimisation, field-level validation, and configurable retention policies.
* **Offline and synchronisation** – predictable sync behaviour, idempotent writes, and conflict resolution when devices come back online.
* **Internationalisation and localisation** – support for multiple languages and country-specific formatting.
* **Accessibility and usability** – consistent, usable interfaces for all user types.
* **Logging, monitoring, and performance** – observability of system health and adherence to performance expectations.

Together, these modules and cross‑cutting concerns form the OpenCRVS functional architecture that other documentation sections build on.
