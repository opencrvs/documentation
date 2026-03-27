# Requirements

### 1. Introduction

OpenCRVS ships with an example country configuration called **Farajaland**. Farajaland is not a real country; it is a teaching and demonstration example used to show how civil registration business rules can be translated into OpenCRVS configuration.

This page summarises the **key civil registration business rules** for Farajaland, focused on births. These rules drive how events are declared, validated, registered, printed, corrected, and revoked.

***

### 2. Declarations

#### 2.1 Who can submit declarations

* **Notifications** (incomplete declarations) can be submitted by a **Community Leader** and saved in **Notified / Incomplete** status.
* **Declarations** (complete submissions) can be submitted by:
  * Community Leaders
  * Health facilities
  * Registration Agents
  * Registrars

#### 2.2 Channel-specific rules

* If a declaration is submitted from a **health facility**:
  * The **Hospital Official name** must be **pre‑populated** on the declaration.
* For overseas births declared at an **embassy**:
  * Declarations can be submitted by an **Embassy Official**.
  * The **Registrar General** is responsible for registering these declarations.

#### 2.3 Use of identity systems

* **E‑signet** can be used to authenticate parents and informant details with the Farajaland National ID system and populate the form.
* An **ID QR code** can be scanned to populate parents’ and informant’s details and validate them with the Farajaland National ID system on submission.

#### 2.4 Validation and late declarations

* All declarations submitted by a **Community Leader** or **Health Facility** must be **validated by a Registration Agent** before registration.
* **Late registrations** (births that occurred more than 1 year ago) require **approval by the Provincial Registrar**.

#### 2.5 Data requirements

* **Mother and father details** are **optional** fields.
* If the informant is a **legal guardian**, proof of assigned responsibility or an **“acquired child” court document** is required.
* The **informant’s signature** is **required** on the declaration.

#### 2.6 Editing and archiving declarations

* **Edits** to a declaration can be made by a **Registration Agent** or **Registrar**.
  * The informant’s signature **does not need** to be re‑captured after edits.
* **Declarations can be archived** by Registration Agents and Registrars
* Declarations can be **saved as Draft** to be continued by the same user at a later date.

#### 2.7 Identifiers

* **Tracking number** logic: an 8‑digit randomly generated numeric string.

***

### 3. Duplicate detection

#### 3.1 Business rules for duplicates

* Automatic checks are run to detect potential **duplicate records** based on:
  * Exact or near‑exact matches on key data (for example, child’s name and date of birth, mother’s details), and
  * Business rules around implausible changes to the child’s age.
* Potential duplicates are **reviewed by the Registrar**, who decides whether to:
  * **Mark as duplicate** (archive the new declaration), or
  * **Mark as not a duplicate** (allow the declaration to proceed).

For technical details of the matching logic, see the **Deduplication** documentation.

***

### 4. Escalation

#### 4.1 Escalation paths

*   **Registration Agents** and **Registrars** can **escalate a record** to the:

    * **Provincial Registrar**, or
    * **Registrar General**

    when they have a question or need higher‑level approval beyond the standard late‑registration rule.

    manual va auto eacalations

    Add how on declare of late the record is auto Escalated to the provincial registrar

    Add how they can respond to escalation with feedback

Escalation rules in Farajaland illustrate how country‑specific supervisory structures can be reflected in OpenCRVS workflows.

***

### 5. Registration

#### 5.1 Preconditions for registration

* All **mandatory fields** on the declaration form must be completed before a record can be registered.

#### 5.2 Registration details

* **Registration number** logic: `YYYY` + 8‑digit randomly generated numeric string.
* At least **one parent must be a Farajaland citizen** for a **UIN** (Unique Identification Number) to be created for the child.

#### 5.3 Special rule for offline drives

* A **Registrar** can print a certificate **in advance of registration** to support offline registration drives. Registration is then completed and synchronised once connectivity is available.

***

### 6. Print and issue

#### 6.1 Output types

Farajaland defines two birth output templates:

* **Certificate** – the primary certificate issued after registration.
* **Certified copy** – an additional certified copy of the registered event.

#### 6.2 Issuance rules

* A **Certificate must be issued first** before a certified copy can be requested.
* **Certified copies** can be printed in advance of issuance for collection by the informant at a later date.
* Issuance of a certified copy that was printed in advance must always be formally recorded on the record when it is handed to the informant.

#### 6.3 Fees

* First **Certificate** = **free**.
* **Certified copies** = **$10** (or equivalent local currency).

***

### 7. Corrections

#### 7.1 Scope of corrections

* All fields in the birth declaration can be **corrected** through the configured Correction workflow.

#### 7.2 Approval rules

* A correction to the **child’s date of birth** requires **approval by the Provincial Registrar**.

#### 7.3 Roles in the correction process

* A **Registration Agent** can **submit a correction request**.
* A **Registrar** can **review correction requests** and approve or reject them.

#### 7.4 Sharing corrections with National ID

* Any corrections to the **child’s biographical data** (Name, Date of birth, Sex) must be **shared with the Farajaland National ID system**, so that the person’s national identity record remains consistent.

***

### 8. Revocation

#### 8.1 Revocation rules

* If a birth record is **revoked**, this change must be **shared with the Farajaland National ID system** so that the child’s **UIN can be deactivated**.

This ensures that revoked civil registration records are consistently reflected across linked systems.

***

### 9. Using Farajaland as a reference

These Farajaland rules are **illustrative**, not prescriptive. They show how:

* Legal and policy decisions (for example, who can declare, how late registrations are handled, how many free certificates are allowed) map onto OpenCRVS configuration.
* Business requirements around identity systems and fees can be integrated with registration workflows.

When configuring OpenCRVS for a real country, use Farajaland as a starting point and adapt each rule to match national legislation, policy, and operational practice.
