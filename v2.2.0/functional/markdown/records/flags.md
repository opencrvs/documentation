# Flags

### 1. Introduction

In OpenCRVS, **flags** are labels attached to records that describe important workflow conditions or states that do **not** require a new record status.

Flags are used to:

* Indicate that extra steps are needed (for example, senior approval required, pending attestation, correction requested).
* Control which **actions** appear in the record action menu.
* Drive **workqueues** so that the right users see the right records (for example, “Ready to attest”, “Pending corrections”).

Flags work alongside **statuses**:

* Status describes the main lifecycle stage (Draft, Notified, Declared, Registered, Archived).
* Flags capture additional, often temporary, conditions within that status.

***

### 2. Feature overview

Flags capture important workflow conditions **within** a status, so you can add rich business rules without changing the core status model.

#### Core capabilities

With flags, OpenCRVS supports:

* **Fine-grained workflow states** inside a status (for example, Declared + `pending-attestation`, Registered + `correction-requested`).
* **Gating of actions** based on the presence or absence of one or more flags.
* **Sequencing of steps** by adding and removing flags as actions complete.
* **Targeted workqueues** that surface exactly the records a team needs to see.
* **Country-specific business rules** without introducing new statuses.

Flags are:

* **Composable** — multiple flags can apply to the same record.
* **Temporary or long-lived** — some flags are cleared quickly (for example, `pending-attestation`), others may remain for audit (for example, `rejected`).
* **Configuration-driven** — defined entirely via configuration, alongside actions, scopes, and workqueues.

***

### 3. What flags can control

Flags can be used in configuration to:

* **Gate actions**
  * Make an action available only when a specific flag is present (for example, “Approve late registration” only when `late-registration-approval-required` is set).
* **Sequence workflow steps**
  * Add or remove flags as actions are completed, ensuring steps happen in the correct order (for example, pending-attestation → attested → validated → registered).
* **Drive workqueues**
  * Filter queues by status + flags (for example, Declared + `pending-attestation`).
* **Highlight special handling**
  * Mark records that require extra care (for example, potential duplicate, correction requested, protected record).

Flags are always configured in combination with **Actions**, **Scopes**, and **Workqueues**.

***

### 4. Example flags

Common examples of flags include:

* `potential-duplicate` — declaration has potential duplicate matches and requires review.
* `pending-attestation` — declaration requires attestation (for example, by a health administrator) before further processing.
* `attested` — attestation step has been completed.
* `validated` — validation step has been completed.
* `correction-requested` — a correction has been requested and awaits review.
* `rejected` — declaration has been rejected
* `late-registration-approval-required` — late registration that requires approval from a senior registrar.

You can define additional flags to match country-specific business rules, as long as they are backed by clear actions and workqueues.

***

### 5. Worked example: death attestation

The example below shows how flags can enforce a required **attestation** step for hospital-declared deaths.

#### Business requirement:

1. If a **Hospital Officer** declares a death, a **Health Administrator** must first attest the record.
2. A **Registration Agent** may only validate the death after attestation.
3. A **Registrar** may only register the death after it has been attested and validated.

#### Flags used

* `requires-attestation` — set when a Hospital Official declares a death.
* `attested` — set when the Health Administrator attests the record.
* `validated` — set when the Registration Agent validates the record.

#### Resulting workflow

1. **Declare** (Hospital Officer)
   * Status: Declared
   * Flags: add `requires-attestation`
2. **Attest** (Health Administrator)
   * Allowed only when `requires-attestation` is present.
   * Flags: remove `pending-attestation`, add `attested`
3. **Validate** (Registration Agent)
   * Allowed only when `attested` is present.
   * Flags: add `validated`
4. **Register** (Registrar)
   * Allowed only when `attested` and any other required conditions (for example, `validated`) are met.
   * Status: Registered

Workqueues can then be configured, for example:

* **Pending attestation** — Status: Declared, Flags: `requires-attestation`, Declared at: my-administrative-area.
* **Pending validation** — Status: Declared, Flags: `attested` (optional), Declared at: my-administrative-area.

***

### 6. Worked example: late birth registration

Another example is **late birth registration**.

#### Business requirement

1. If a birth is declared when the child is more than 1 year old, a **Senior Registrar** must approve the registration.
2. A Registrar cannot register the birth until that approval has been given.

#### Flags used

* `late-registration-approval-required` — set automatically when the age-at-declaration > configured threshold (for example, > 1 year).

#### Resulting workflow

1. **Declare** (Registration Agent)
   * Status: Declared
   * Flags: add `late-registration-approval-required`.
2. **Approve late registration** (Senior Registrar)
   * Action visible only to users with the Senior Registrar role and appropriate scopes.
   * Flags: remove `late-registration-approval-required`.
3. **Register** (Registrar)
   * Action only available when the `late-registration-approval-required` flag is no longer present.
   * Status: Registered.

This ensures that late registrations are always reviewed by a senior official before registration.

***

### 7. Summary

To implement flags effectively, you configure:

* **Actions**
  * Which flags they require to be present (or absent) to be available.
  * Which flags they add or remove when completed.
* **Scopes and roles**
  * Which user roles can perform which actions (for example, only Health Administrators can “Attest”).
* **Workqueues**
  * Which combinations of status + flags should be shown to which roles.

This combination allows you to express complex country-specific workflows while keeping the core status model simple and stable. Please review documentation pages for Users, Actions and Workqueues for worked examples on how flags are configured.
