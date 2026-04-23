---
layout:
  width: default
  title:
    visible: true
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
---

# Users

### 1. Introduction

**Users** represent individual system accounts in OpenCRVS. Each user is assigned a **role**, a set of **scopes** with **jurisdiction**, and access to specific **workqueues**. Together, these define what the user can see, which actions they can perform, and which records they are responsible for.

Countries can create unlimited custom user role types aligned with their organisational structure. This makes it possible to:

* Restrict sensitive operations to authorised staff.
* Align responsibilities with real-world job roles.
* Enforce geographic and workflow-based access control.

***

### 2. Feature overview

User roles in OpenCRVS are the primary way to configure **who can do what, where, and how they see their work**.

#### Core capabilities

With Users and Roles, OpenCRVS supports:

* Unlimited custom roles (e.g. Registrar, Field Agent, Data Clerk, Health Assistant, System Administrator).
* Fine-grained permissions using **scopes**.
* Jurisdiction-aware access control to records based event location, declared in or registered in, etc.).
* Role-based assignment of workqueues for task-focused navigation.
* System-level actions for creating, editing, deactivating, and reactivating user accounts.

Users are:

* **Role-based** — capabilities are defined by the role configuration.
* **Scope-driven** — every operation is controlled by one or more scopes.
* **Jurisdiction-aware** — access to records is constrained by geography and organisational structure.

***

### 3. User role configuration overview

A **role** is a reusable configuration that defines “what a type of user can do and see” in the system.

Common examples include:

* Registrar
* Registration Agent
* Data Clerk
* Health Assistant
* System Administrator

Each role configuration includes:

<table><thead><tr><th valign="top">Parameter</th><th>Description</th></tr></thead><tbody><tr><td valign="top">Role name</td><td>The label shown on the user profile, in audit history, and in admin tools.</td></tr><tr><td valign="top">Scopes</td><td>A list of permissions that define which actions the user can perform, for which events (for example, <code>record.register[event=birth declared_in=my-administrative-area]</code>).</td></tr><tr><td valign="top">Workqueues</td><td>The set of queues that appear in the left-hand navigation (for example, Assigned to you, Pending registration, Pending corrections). These do not grant extra permissions by themselves, but shape how work is surfaced to the user.</td></tr></tbody></table>

When designing roles, countries should:

* Start from real job functions (for example, Health Assistant, Registration Agent, Registrar, Supervisor, National Admin).
* Define which **actions** each role needs, then translate them into scopes with appropriate event and jurisdiction qualifiers.
* Attach only the **minimum necessary** workqueues to keep navigation focused and simple.

***

### 4. User role scopes

A **scope** is a short text expression that gives a role permission to perform a specific action, for specific events, in specific jurisdictions.

At a high level, a scope answers three questions:

* **What** action is allowed? (for example, search, read, declare, register)
* **For which events?** (for example, birth, death)
* **On records from where?** (for example, declared\_in=my-administrative-area, declared\_in=any)

#### 4.1 Scope format

Record-related scopes follow this pattern:

* `action[event=event {jurisdiction}]`

Where:

* `action` is the permission (for example `search`, `record.read`, `record.register`).
* `event=` lists one or more event types (for example `birth`, `death`, or `birth|death`).
*   Jurisdiction (to learn more see Jurisdiction) is expressed via qualifiers such as:

    * `placeOfEvent` = based on where the event occurred
    * `declared_in` = based on the declaring users assigned location
    * `declared_by` = based on the user who declared the event
    * `registered_in` = based on the registering users assigned location
    * `registered_by` = based on the user who registered the event

    combined with values like `my-administrative-area`, `location`, `any`. `user` for `declared_by` and `registered_by`

**Example scopes:**

* `record.search[event=birth declared_in=my-administrative-area]`
  * Allows quick/advanced search for birth records declared in the user’s administrative area.
* `record.create[event=birth|death event_location=my-administrative-area]`
  * Allows the user to create birth and death declarations for events that occurred in their administrative area. The declaration form will only offer places of event within that area.
* `record.register[event=birth|death]`
  * Allows the user to register birth and death records for which they are assigned. In practice, these records will already be constrained to their jurisdiction by the create and assignment rules.

#### 4.2 Core scopes and core record actions

Each core scope in this table maps **directly to a core record action**. If a role does not have the scope, the corresponding action is not available in the UI, regardless of status, flags, or workqueues. The table shows the default intent; implementers still control where each scope applies via `event=`.&#x20;

| Scope (action)            | Enables                                                                               |
| ------------------------- | ------------------------------------------------------------------------------------- |
| `record.search`           | Use quick search / advanced search to find records.                                   |
| `record.read`             | Open and view record details (non‑mutating).                                          |
| `record.create`           | Start a new declaration from the event form                                           |
| `record.notify`           | Notify (submit an incomplete declaration).                                            |
| `record.declare`          | Declare (submit a complete declaration)                                               |
| `record.reject`           | Reject a declared record                                                              |
| `record.archive`          | Archive a declared record                                                             |
| `record.review-duplicate` | Review and decide on potential duplicates (Mark as duplicate / Mark not a duplicate). |
| `record.register`         | Register a record                                                                     |
| `record.print`            | Print certified copies of a registered record                                         |
| `record.correct`          | Correct a registered record                                                           |

#### 4.3 Custom scopes

Custom scopes are used for **country‑specific custom actions**. They follow the same pattern but use the `record.custom-action`verb, and each custom scope enabled the configured custom action via its `actionType` value.

**Format**

* `record.custom-action[event=<event> actionType={my-custom-action}]`

**Examples**

* `record.custom-action[event=birth actionType=attest]`
  * Enables a custom **Attest** action for birth records, where `attest` matches the configured custom action type.
* `record.custom-action[event=birth|death actionType=approve-late-registration]`
  * Enables an **Approve late registration** custom action for birth and death records.

Custom scopes are paired with:

* **Custom actions** (see the _Actions_ page).
* **Flags** that indicate special states such as `late-registration-approval-required`.
* **Workqueues** that surface records needing those custom actions.

Together, built‑in and custom scopes form the complete permission model for what roles can do with records in OpenCRVS.

#### 4.4 Workqueue assignment

Workqueues are attached to roles using a scope that references workqueue IDs. This scope controls **which queues appear in the user’s navigation**, not the underlying record permissions. Access to the records in those queues is still governed by record-related scopes and jurisdictions.

**Example workqueue scope**

```
workqueue[id=assigned-to-you|recent|notification|in-external-validation|escalated|potential-duplicate|pending-updates|pending-registration|pending-approval|pending-certification|pending-issuance|correction-requested]
```

The user will have following queues in their side navigation:

* Assigned to you
* Recent
* Notification
* Pending updates
* Potential duplicate
* Pending registration
* Pending approval
* In external validation
* Pending certification
* Pending issuance

For a full description of queue behaviour and configuration, see the **Workqueues** page.

***

### 6. Worked example

From a business perspective, configuring a user role means describing **what this role is responsible for** and ensuring scopes, jurisdictions, and workqueues support that responsibility.

#### Business requirement: District Registrar

* The **District Registrar** is responsible for registering, correcting, and issuing certificates for birth and death records registered in their district.
* They can search and read records for their district, but not for other districts.
* They can review potential duplicates for declarations in their district.
* Their work should be focused on queues that surface declared and registered records in their district that need action.

#### Configuration Inputs

| Requirement                                                                                                                                                                                                                                                                 | Input                                                                                                                                                                                                                                    |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Role name                                                                                                                                                                                                                                                                   | District Registrar                                                                                                                                                                                                                       |
| Can search for birth and death records declared and registered in their district.                                                                                                                                                                                           | `search[event=birth]`                                                                                                                                                                                                                    |
| Can open and read birth and death records registered in their district.                                                                                                                                                                                                     | `record.read[event=birth`                                                                                                                                                                                                                |
| Can create birth and death declarations for events that occurred in their district (the form will only allow places of event in their area).                                                                                                                                | `record.create[event=birth]`                                                                                                                                                                                                             |
| Can declare birth and death events (once assigned to the record).                                                                                                                                                                                                           | `record.declare[event=birth]`                                                                                                                                                                                                            |
| Can reject birth and death declarations (once assigned to the record).                                                                                                                                                                                                      | `record.declared.reject[event=birth]`                                                                                                                                                                                                    |
| Can archive birth and death declarations (once assigned to the record).                                                                                                                                                                                                     | `record.declared.archive[event=birth]`                                                                                                                                                                                                   |
| Can register birth and death records (once assigned to the record).                                                                                                                                                                                                         | `record.register[event=birth]`                                                                                                                                                                                                           |
| Can correct birth and death records (once assigned to the record).                                                                                                                                                                                                          | `record.registered.correct[event=birth]`                                                                                                                                                                                                 |
| **Workqueues:**                                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                          |
| <p>• Records assigned directly to this Registrar.</p><p></p><ul><li>Show declared records which have been validated in the district that are ready to be registered.</li></ul><p>• Recently registered records by their office that are ready for certificate printing.</p> | `workqueue[id=assigned-to-you\|recent\|notification\|in-external-validation\|escalated\|potential-duplicate\|pending-updates\|pending-registration\|pending-approval\|pending-certification\|pending-issuance\|correction-requested]` \| |

***

### 7. Core user management actions

OpenCRVS also provides system-level actions for managing user accounts themselves (not records). These actions are restricted to administrators with the appropriate user scopes.

#### User management actions (overview)

<table><thead><tr><th valign="top">Scope</th><th>Action</th><th>Description</th></tr></thead><tbody><tr><td valign="top"><code>user.create</code></td><td>Create new user</td><td>Create a new user account, assign a role, and set initial credentials.</td></tr><tr><td valign="top"><code>user.read.audit</code></td><td>Read</td><td>View a user profile page</td></tr><tr><td valign="top"><code>user.update</code></td><td>Edit user</td><td>Update user details such as role, location, status, or contact details.</td></tr><tr><td valign="top"><code>user.update</code></td><td>Deactivate user</td><td>Disable a user account so the user can no longer log in.</td></tr><tr><td valign="top"><code>user.update</code></td><td>Reactivate user</td><td>Restore access for a previously deactivated user.</td></tr><tr><td valign="top"><code>user.update</code></td><td>Reset user password</td><td>Initiate password recovery for a user who cannot log in.</td></tr><tr><td valign="top"><code>user.update</code></td><td>Send username reminder</td><td>Send the username to the user via configured communication channels.</td></tr></tbody></table>

***

### 8. Summary

* Users gain capabilities through **roles**, which group together scopes, jurisdictions, and workqueues.
* **Scopes** are the only mechanism by which a user is allowed to perform actions on records.
* **Jurisdiction** constraints ensure that access is organisationally limited.
* **Workqueues** control visibility of record lists but do not bypass scope or jurisdiction rules.
* All mutating actions taken by users are journaled, providing a complete audit trail.
