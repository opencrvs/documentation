# Standards

### 1. Introduction

OpenCRVS sits at the intersection of three standards landscapes — civil registration, Digital Public Infrastructure, and general web/software engineering. This page lists the standards the platform conforms to or aligns with, separated by domain so adopters can map them against national procurement and architecture requirements.

***

### 2. Civil registration & social protection

* **UN Guidelines for Civil Registration.** OpenCRVS implements the civil registration process as set out in the UN guidelines.
* **Digital Convergence Initiative (DCI).** OpenCRVS is a Standards Committee Member of the DCI and co-authored the _CRVS and SP-MIS Interfaces_ standard. The platform interoperates with social protection systems such as OpenSPP via these interfaces.
* **G2P Connect** (Centre for Digital Public Infrastructure). G2P Connect specifications are used in the interoperable middleware that delivers the DCI CRVS↔SP-MIS interfaces above.

OpenCRVS is designed as a core component of Digital Public Infrastructure and is committed to adopting open digital government data standards as the DPI standards ecosystem matures.

***

### 3. APIs & data exchange

* **REST** is the API style for all core APIs. OpenAPI documentation is published at [documentation.opencrvs.org/v2.0/technical/apis/core-apis](https://documentation.opencrvs.org/v2.0/technical/apis/core-apis).
* **Webhook payloads** sent to country configuration and other downstream consumers are a bespoke OpenCRVS schema.
*   **Versioning.** Releases follow a semantic-versioning shape — `MAJOR.MINOR.PATCH` — with the following guarantees:

    | Bump  | Backwards-compatible to country config? | Manual data migration? | Cadence  |
    | ----- | --------------------------------------- | ---------------------- | -------- |
    | Patch | Yes                                     | Never                  | Frequent |
    | Minor | May break country-config contracts      | Never                  | Regular  |
    | Major | May break country-config contracts      | Possible               | Rare     |

    Minor versions can require country configuration updates, but data migrations are reserved for major versions only. This lets implementing teams plan country-config changes against minors and reserve heavier engineering capacity for the rarer majors.

***

### 4. Data formats

| Concern        | Standard                              |
| -------------- | ------------------------------------- |
| Date-time      | ISO 8601                              |
| Plain dates    | `YYYY-MM-DD` (ISO 8601 calendar date) |
| Languages      | BCP 47 language tags, e.g. `fi-FI`    |
| Currency codes | ISO 4217                              |
| Translations   | ICU MessageFormat                     |

***

### 5. Authentication & authorisation

* **JWT** is used for session tokens, signed with **RS256** (RSA + SHA-256). The signing key is loaded from the filesystem at service startup, and the matching public key is published at the `/.well-known` endpoint so downstream services can verify tokens without sharing secrets.
* **Two-factor authentication** is required for sign-in. The 2FA delivery channel is country-configurable — SMS, email, or any transport the country wishes to wire up.
* **Role-based access control.** Roles and the actions they may perform are defined by country configuration; the core enforces them on every action.

***

### 6. Password storage

* **bcrypt** with a work factor of **10 rounds**.

***

### 7. Audit logging

OpenCRVS maintains two complementary audit trails:

* **Event action log.** Every change to a civil registry record is itself an immutable action persisted to PostgreSQL. This is the journal of record for births, deaths, marriages and any other country-configured event. See the [data architecture page](https://documentation.opencrvs.org/v2.0/technical/architecture/data-architecture) for details.
* **User and administrative audit log.** A separate audit stream captures user-lifecycle and administrative events that are not record changes — user creation, deactivation and reactivation, profile edits, login and logout, password changes (self-service, reset, admin-initiated), email and phone number changes, invitation resends and username reminders. These records are persisted to PostgreSQL alongside the event log.

Tamper-evident hashing of audit entries is on the roadmap rather than in the current release.

***

### 8. Transport & at-rest encryption

OpenCRVS treats transport security and at-rest encryption as **deployment-layer concerns**. The platform does not pin specific TLS versions or key-management systems in code; it expects the operator to terminate TLS at the ingress, enforce encrypted connections to managed PostgreSQL, MongoDB and S3-compatible storage, and configure disk/volume encryption and KMS-managed keys according to local policy.

This is a deliberate choice: it keeps OpenCRVS portable across the cloud and on-premise environments that different country deployments require, and lets each country meet its own data-residency and key-custody mandates. Recommended deployment configurations are covered in the operations documentation.

***

### 9. Internationalisation

* **Translation framework:** [react-intl](https://formatjs.io/docs/react-intl/) (part of FormatJS) on the web client.
* **Message syntax:** ICU MessageFormat, supporting pluralisation, gender, and nested formatting.
* **Translation source:** strings live in the country configuration repository as CSV and are loaded by the client. This keeps localisation fully in the hands of the implementing country, alongside form definitions and other country-specific configuration.

***

### 10. Licensing & governance

* **Licence:** [Mozilla Public License 2.0 (MPL-2.0)](https://www.mozilla.org/MPL/2.0/) for the core codebase.
