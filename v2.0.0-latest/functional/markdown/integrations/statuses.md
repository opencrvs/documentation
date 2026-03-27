# Statuses

### 1. Introduction

In OpenCRVS, **record status** describes the current legal state of an event record (for example, Draft, Notified, Declared, Registered).

Statuses are used to:

* Express the **legal state** of a record (for example, not yet registered vs registered).
* Control which **actions** are available at each stage (for example, Notify, Declare, Register, Correct).
* Drive **workqueues**, approvals, and reporting.

***

### 2. Feature overview

Record status provides a simple, shared language for understanding **where a record is in its lifecycle** and what can or cannot happen next.

#### Core capabilities

With record status, OpenCRVS supports:

* A **standard lifecycle** for event records (Draft → Notified → Declared → Registered).
* Clear separation between the **legal state** of a record and finer workflow details (handled by **flags**).
* **Deterministic availability** of actions based on status, so users always know what they can do next.
* Consistent inputs for **workqueues, reporting, and analytics** across all event types.
* Integration with **deduplication, corrections, and approvals** while keeping the core status model stable.

Statuses are:

* **Simple** — only a small number of core statuses are used.
* **Reusable** — the same set of statuses can be applied across event types and countries.
* **Configurable at the edges** — flags, scopes, and actions provide the flexibility for country-specific rules.

***

### 3. Core statuses

The following core statuses are used by OpenCRVS to support standard registration workflows.

* **Draft**
  * A saved declaration that has not yet been submitted.
  * Data can still be edited freely by the user who is preparing the declaration.
* **Notified**
  * A declaration submitted with **incomplete** information.
  * Often used when a notifier (for example, health facility) captures partial data for follow-up by a Registration Agent.
* **Declared**
  * A declaration submitted with all **required** information.
  * Ready for validation, duplicate review, and potential registration.
* **Archived**
  * A notified or declared declaration that is no longer being processed.
  * Typical reasons include: identified as a duplicate, informant did not complete missing information within a defined timeframe, or the declaration was withdrawn.
* **Registered**
  * The event has been formally registered according to law.
  * A registration number is assigned and certificates can be issued.

\<aside> 📌

Record statuses **“Registered (inactive)”** or **“Revoked”** are not currently supported. They can ben configured as a record **flag**, so the core status remains Registered while flags express that the registration is inactive or revoked.

\</aside>

***

### 4. Status flow

Records move through statuses in a predictable order:

1. **Draft** — user is preparing a declaration.
2. **Notified** — partial information submitted.
3. **Declared** — complete information submitted.
   1. **Archived** — declaration is no longer in process (for example, duplicate, abandoned).
4. **Registered** — declaration has been validated and registered.

This flow can vary by event type and country policy (for example, some countries may not allow incomplete declarations to be submit therefore the Notified status is not required).

_(Insert status flow diagram or screenshot here)_

#### Core actions change a record status

Core record actions (see the **Actions** page) are responsible for moving a record between statuses.

* **Notify** ⇒ sets status to **Notified**.
* **Declare** ⇒ sets status to **Declared**.
* **Archive** ⇒ sets status to **Archived**.
* **Register** ⇒ sets status to **Registered**.

Custom actions **do not** change status directly. Instead, they can add or remove **flags** and capture additional metadata while the record remains in the same status.

#### Available actions at each status

Other core actions and custom actions can be mapped to and controlled be the record status. As an example:

| **Status** | **Birth record actions**                                                                        |
| ---------- | ----------------------------------------------------------------------------------------------- |
| Draft      | Update, Notify, Declare, Delete                                                                 |
| Notified   | Edit, Declare, Reject, Archive                                                                  |
| Declared   | Edit, Validate, Reject, Archive, Approve, Escalate, Register, Mark as duplicate / not duplicate |
| Archived   | Reinstate                                                                                       |
| Registered | Correct, Print, Issue Verifiable Credential, Revoke                                             |

The exact set of actions will vary by country and event type, but the **status model remains the same**, providing a stable backbone for workflows.

***

### 7. Relationship between status and flags

More detailed workflow nuances can be represented using **flags**.

Example:

* A birth declaration is submitted **late** (for example, the child is more than 1 year old at the time of declaration).
* Country policy requires **senior approval** before such a declaration can be registered.

This can be modelled as:

* Status: **Declared** (the declaration is complete but not yet registered)
* Flags: `late-registration-approval-required`

Configuration can then ensure that:

* Only users with the appropriate **Senior Registrar** role and scopes see a custom action **Approve** for records with `late-registration-approval-required` flags.
* The **Register** action is only available once this flag has been cleared by the **Approve** action.

This approach keeps the status model **simple and consistent** (Draft → Notified → Declared → Registered), while flags and actions handle country-specific business rules and sub-states such as late registrations, special approvals, or escalation reviews. Please see the documentation of Flags for more details documentation and examples.

### Summary
