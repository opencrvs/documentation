# Business Rules

### 1. Introduction

In OpenCRVS, **business rules** express how civil registration should work in a specific country. They translate **legislation and policy** into concrete system behaviour, such as:

* What information must be captured on a declaration.
* Who is allowed to validate or register a record.
* When senior approval is required.
* When a certificate can be issued or a correction made.

Business rules ensure that every registration follows the same logic, regardless of where it is completed or who processes it.

***

### 2. What business rules can control

OpenCRVS supports configuration of many types of business rules. At a high level, they can control:

* **Forms and data**
  * Which fields are mandatory or optional.
  * When specific supporting documents are required.
  * Which values are allowed (for example, minimum ages, valid date ranges).
* **Workflows and approvals**
  * Which actions are available at each status (for example, Notify, Declare, Validate, Register, Correct).
  * When an additional review or senior approval is required (for example, late registration).
  * When a declaration can be rejected, archived, or escalated.
* **Roles, scopes, and jurisdiction**
  * Which roles can create, edit, validate, register or print records etc.
  * Which records a user can act on, based on their jurisdiction.
* **Outputs and post-registration steps**
  * When certificates or certified copies can be printed.
  * When corrections can be requested or applied.
  * When additional notes or data (for example, cause of death) can be added after registration.

These rules are implemented using a combination of **forms**, **actions**, **flags**, **scopes**, and **workqueues**.

***

### 3. Example business rules

The examples below illustrate the kinds of rules that can be configured. The exact rules vary by country.

#### 3.1 Declaration form rules

* All mandatory questions must be completed before a declaration can be submitted.
* A specific supporting document is required when a condition is met (for example, marriage certificate required for legitimation).
* Mother’s age must be above a configured minimum at the time of birth registration.
* Bride’s and groom’s ages must be above a configured minimum at the time of marriage registration.
* Informant’s identity and signature (or equivalent) must be captured.
* Certain fields can be prepopulated (for example, notifier’s name and role when a hospital official logs in).
* Place of event must be within the user’s allowed jurisdiction when declaring or notifying.

#### 3.2 Registration workflow rules

* Allow incomplete submissions (**Notified** status) to be completed later by another user.
* Require validation by a Registration Agent before final registration.
* Allow a Registration Agent or Registrar to reject a declaration for correction.
* Require senior approval for specific scenarios (for example, late registrations).
* Require a health administrator to attest a death before registration at the local office.
* Require a Registrar to review potential duplicates before registration.
* Restrict registration to specific roles (for example, Registrar only).
* Allow or disallow edits by certain roles at particular statuses.
* Enable escalation to higher-level offices for review and opinion.
* Ensure users can only act on records within their jurisdiction.

#### 3.3 Printing and certification rules

* Require capture of requester’s details and identity before issuing a certificate or certified copy.
* Use a specific certificate template for first issuance.
* Allow different templates for re-issuance (for example, full certificate vs extract vs certified copy).

#### 3.4 Correction rules

* Require capture of requester’s details and identity before processing a correction.
* Allow correction requests to be submitted by a Registration Agent and approved by a Registrar.
* Permit direct corrections by a Registrar in defined scenarios.
* Require senior approval for sensitive corrections (for example, changing a child’s date of birth).

#### 3.5 Post-registration and access rules

* Allow additional information to be added after registration (for example, cause of death when confirmed later).
* ~~Allow notes to be added for audit or operational purposes.~~
* ~~Restrict search and record access based on where the event occurred, was declared, or was registered.~~
* ~~Restrict access to protected or sensitive records to specially permissioned users.~~

***

### 4. From legislation to configuration

In practice, configuring business rules in OpenCRVS involves:

1. **Reviewing legislation and policy** — understanding legal requirements for each event type.
2. **Identifying rules** — listing conditions, approvals, and constraints that must be enforced.
3. **Mapping to configuration** — applying those rules using forms, actions, flags, scopes, and workqueues.
4. **Testing and iteration** — validating that real cases behave as expected.

This approach allows countries to encode their civil registration laws into OpenCRVS in a transparent, testable way, while still benefiting from a common product foundation.
