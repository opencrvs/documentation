# APIs

## IN PROGRESS

### 1. Introduction

**APIs** are REST APIs that enable external systems to send data and requests **into** OpenCRVS. These APIs support integration with health facilities, civil registration offices, citizen portals, and other systems that need to create, search, or manage civil registration records.

APIs enable:

* **Health facilities** to send birth and death notifications
* **Citizens via public portals** to declare vital events and request the status of applications
* **External systems** to request certificates and corrections

OpenCRVS Inbound APIs are available with two authentication methods:

**System-Authenticated APIs //// Public?** — Actions attributed to an automated client using client credentials. Appears as system-initiated actions in OpenCRVS. Used for programmatic integrations where external systems perform actions on behalf of the system (e.g., health facility notifications, external portals).

**User-Authenticated APIs** //// **Internal** ??— Actions attributed to a specific logged-in user using user tokens. Appears as human-initiated actions in OpenCRVS. Used when applications need actions attributed to a specific user with their permissions and audit trail (e.g., mobile apps acting on behalf of authenticated users).

The choice depends on whether the action should appear in OpenCRVS as system-initiated or human-initiated. For example, a companion app could use either approach depending on whether it authenticates users individually or uses system credentials.

**This documentation focuses primarily on System-Authenticated APIs**, which provide stable, versioned integration points for System Integrators (SIs) and external systems.

***

### 2. Feature Overview

Inbound APIs provide comprehensive integration capabilities for civil registration workflows.

#### Core capabilities

With Inbound APIs, OpenCRVS supports:

* **Event lifecycle management** — Create, declare, validate, register, and archive vital events
* **Search and retrieval** — Search records by any declaration field (name, date, location, registration number, or any other configured field)
* **Workflow actions** — Perform actions like validate, reject, register, and print certificates
* **Corrections** — Request, approve, and reject corrections to registered records
* **User management** — Create and manage user accounts, roles, and permissions
* **System configuration** — Retrieve application config, forms, and location data
* **Document management** — Upload and manage supporting documents
* **Integration management** — Register and manage external system integrations

#### ~~Access control~~

~~APIs are controlled by:~~

* **\~\~Authentication method** — System credentials (client tokens) or user credentials (user tokens)\~\~
* **\~\~System permissions** — Client permissions configured for system-authenticated access\~\~
* **\~\~User scopes** — Permission-based access for user-authenticated APIs\~\~
* **\~\~Jurisdiction constraints** — User access limited by administrative area (user-authenticated APIs only)\~\~

***

### 3. System-Authenticated APIs or Public APIs..?

The following sections document **System-Authenticated API operations** that are guaranteed to remain consistent and available between OpenCRVS versions. These are the primary integration points for System Integrators (SIs) and external systems.

**Stability guarantee**: System-Authenticated APIs will maintain backwards compatibility. Any breaking changes will be communicated in advance and follow a deprecation process.

#### 3.1 Notification

API for creating and notifying vital event records.

| **Operation**  | **Description**                         |
| -------------- | --------------------------------------- |
| Action: Create | Create a new vital event record         |
| Action: Notify | Submit a notification for a vital event |

#### 3.2 Search

APIs for searching and retrieving civil registration records.

| **Operation**                | **Description**                                            |   |
| ---------------------------- | ---------------------------------------------------------- | - |
| Search for event record      | Search for vital event records by tracking ID              |   |
| Search for event record data | Search for vital event records by tracking id and field id |   |

#### 3.2 Documents

for uploading and managing supporting documents.

| **Operation** | **Description** |   |
| ------------- | --------------- | - |
| Doucument…    | …               |   |
|               |                 |   |

***

### 4. User-Authenticated APIs

Remove if not actaully recommended!!

\<aside> ⚠️

**Stability considerations for external integrations**

User-Authenticated APIs are **not guaranteed to remain consistent between versions**. They can change without notice or be removed entirely in future releases. Using User-Authenticated APIs for external integrations has similar implications to forking OpenCRVS core, as it creates technical debt and upgrade complications.

**We strongly recommend using System-Authenticated APIs for external integrations.** User-Authenticated APIs are documented here for reference and should primarily be used by first-party OpenCRVS clients (like the PWA) or with the understanding that they may require updates when upgrading OpenCRVS versions.

\</aside>

#### 4.1 Events (User-Authenticated)

User-Authenticated APIs for managing vital event records. These are subject to change without notice.

| **Operation**              | **Notes**                    |
| -------------------------- | ---------------------------- |
| Get event by ID            | Requires user authentication |
| Action: Delete event       | Requires user authentication |
| List user drafts           | Requires user authentication |
| Create draft               | Requires user authentication |
| Action: Declare            | Requires user authentication |
| Action: Validate           | Requires user authentication |
| Action: Reject record      | Requires user authentication |
| Action: Archive            | Requires user authentication |
| Action: Accept archive     | Requires user authentication |
| Action: Reject archive     | Requires user authentication |
| Action: Register           | Requires user authentication |
| Action: Print certificate  | Requires user authentication |
| Action: Assign record      | Requires user authentication |
| Action: Unassign record    | Requires user authentication |
| Action: Request correction | Requires user authentication |
| Action: Approve correction | Requires user authentication |
| Action: Reject correction  | Requires user authentication |
| List events                | Requires user authentication |
| Import event               | Requires user authentication |

#### 4.2 Users (User-Authenticated)

User-Authenticated APIs for managing user accounts and authentication.

| **Operation**                     | **Notes**                    |
| --------------------------------- | ---------------------------- |
| Create user                       | Requires user authentication |
| Get user by ID                    | Requires user authentication |
| Get user by mobile number         | Requires user authentication |
| Search users                      | Requires user authentication |
| Update user details               | Requires user authentication |
| Fetch user audit for user         | Requires user authentication |
| Verify user's password            | Requires user authentication |
| Verify user's password by user id | Requires user authentication |
| Verify security answer            | Requires user authentication |
| Activate user                     | Requires user authentication |
| Change password                   | Requires user authentication |
| Change avatar                     | Requires user authentication |
| Change email                      | Requires user authentication |
| Change phone                      | Requires user authentication |
| Reset password                    | Requires user authentication |
| Resend invite                     | Requires user authentication |
| Username SMS reminder             | Requires user authentication |
| Verify user                       | Requires user authentication |

#### 4.3 Integrations (User-Authenticated)

User-Authenticated APIs for managing external system integrations.

| **Operation**                     | **Notes**                    |
| --------------------------------- | ---------------------------- |
| Register a new integration system | Requires user authentication |
| List integration systems          | Requires user authentication |
| Fetch system                      | Requires user authentication |
| Get system roles                  | Requires user authentication |
| Informant SMS notifications       | Requires user authentication |
| Reactivate system                 | Requires user authentication |
| Deactivate system                 | Requires user authentication |
| Register system                   | Requires user authentication |
| Refresh system secret             | Requires user authentication |
| Update permissions                | Requires user authentication |
| Delete system                     | Requires user authentication |

#### 4.4 Notification (User-Authenticated)

User-Authenticated APIs for sending system-wide notifications.

| **Operation**           | **Notes**                    |
| ----------------------- | ---------------------------- |
| Send email to all users | Requires user authentication |

#### 4.5 Config (User-Authenticated)

User-Authenticated APIs for retrieving system configuration and reference data.

| **Operation**          | **Notes**                    |
| ---------------------- | ---------------------------- |
| Get application config | Requires user authentication |
|                        |                              |
|                        |                              |

#### 4.6 Location (User-Authenticated)

User-Authenticated APIs for managing administrative location data.

| **Operation**   | **Notes**                    |
| --------------- | ---------------------------- |
| Fetch locations | Requires user authentication |
| Create location | Requires user authentication |
| Update location | Requires user authentication |
| Fetch location  | Requires user authentication |

#### 4.7 Documents (User-Authenticated)

User-Authenticated APIs for uploading and managing supporting documents.

| **Operation**   | **Notes**                    |
| --------------- | ---------------------------- |
| Document upload | Requires user authentication |
| Delete document | Requires user authentication |

***

### 5. Common Integration Patterns

The following examples illustrate typical integration workflows using Inbound APIs.

#### Health facility notification workflow

1. Health Facility system creates event notification via `Action: Create` (System-Authenticated API)
2. Health facility system submits notification via `Action: Notify` including id of office to submit notification to

#### Citizen portal notification workflow

1. Citizen creates event via `Action: Create`
2. System selects location ID of registration office
3. Citizen submits notification via `Action: Notify`
4. …
5. Citizen receive status update via ..??

#### ~~External system integration workflow~~

1. ~~External system registers via Register integration system~~
2. ~~System subscribes to webhooks for registration events~~
3. ~~System receives webhook notifications when events are registered~~
4. ~~System calls Get event by ID to retrieve full record details~~

## National ID

#### Why integrate OpenCRVS with National ID?

Civil registration provides the source of truth for any vital event that occurs in a country. Civil registration can inform a National ID system when a birth occurs and therefore instigate the generation of a National ID for the child at birth. At the point of death, a civil registration system can inform the National ID system that the person is deceased, thus preventing fraudulent usage of a National ID of a deceased person.

The partnership of Civil Registration and National ID is what collectively constitutes the foundational identity infrastructure of a nation.

[Bridging the Identity Gap: Integrating Civil Registration and National Identity Systems](http://prod-website-903390823.ap-south-1.elb.amazonaws.com/mosip16.9/bridging-the-identity-gap-integrating-civil-registration-and-national-identity-systems)

#### Which National ID systems can OpenCRVS interoperate with?

OpenCRVS is agnostic regarding which National ID system it integrates with. This section is first organised around the main business use cases.

As of OpenCRVS v1.8.0, OpenCRVS has a production ready integration library dedicated to interoperating with [MOSIP](https://www.mosip.io/) and [E-Signet](https://docs.esignet.io/), fellow OpenSource Digital Public Goods. A dedicated section exists that builds on the same agnostic integration points specifically for integrating with MOSIP.

In the past, OpenCRVS has delivered proof-of-concept (not production ready) integrations with [INGroupe](https://ingroupe.com/) and [OSIA standard](https://secureidentityalliance.org/osia) National ID systems

#### Existing National ID integration functionality

Currently OpenCRVS supports the following default National ID integration functionality:

* Authenticating and verifying the identity of informants and parents during the event application process both offline and online.
* Configurable rules to determine whether or not a civil registration event should or should not integrate with a National ID system at the point of registration.
* Integration with a National ID system at the point of registration synchronously and asynchronously
