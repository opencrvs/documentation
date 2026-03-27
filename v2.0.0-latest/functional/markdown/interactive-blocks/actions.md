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

# Actions

### 1. Introduction

In OpenCRVS, **Actions** are system operations that can be performed on a record. Actions may change a record’s status, add or remove flags, modify record data, or use record data to generate outputs such as certificates or verifiable credentials.

OpenCRVS uses a **journaled database** to record every action performed on a record. Each action is written as an immutable entry in a sequential audit log (the “journal”), ensuring full traceability and auditability of all changes over time.

OpenCRVS supports:

* **Core actions**, which implement standard civil registration workflows
* **Custom actions**, which allow countries to model additional, country-specific business processes

***

### 2. Feature Overview

Actions provide a controlled and auditable way to progress records through their lifecycle.

#### Core capabilities

With Actions, OpenCRVS supports:

* Strict control over which actions are available at each record status
* Permission-based access using user scopes (including jurisdiction constraints)
* Conditional availability based on record flags
* Optional user input captured at action time (forms)
* Fully auditable state transitions
* Conditionally add or remove flags
* Configure custom actions to support custom workflows

Actions are:

* **Contextual** — only visible when applicable
* **Deterministic** — availability depends on record state, flags, and user permissions
* **Journaled** — every action is recorded immutably

***

### 3. Record Action Menu (User Experience)

Actions are presented to users through the **Record Action Menu**.

An action appears in the menu when **all** of the following conditions are met:

1. The user has the required scope
2. The record is in a compatible status
3. Any required flags are present
4. The record is assigned to the user (where assignment is required)

If an action is visible but currently unavailable, it will appear disabled until the required conditions are met.

#### Example action menu state

For a record with status **Registered**, and a logged-in user assigned to the record with the scopes:

* `record.assign[event=birth]`
* `record.print[event=birth]`
* `record.correct[event=birth]`
* `record.customAction[event=birth actionType=Issue-Verifiable-Crendential]`

The action menu would display:

* Print
* Correct
* Issue verifiable credential
* Unassign

_(Insert example screenshot or diagram here)_

Actions remain disabled until the user assigns the record to themselves. This supports safe offline working and prevents conflicting updates.

***

### 4. Core Record Actions

Core record actions are maintained by OpenCRVS to support standard civil registration workflows. These actions cover declaration, review, registration, correction, and issuance processes.

#### Core record actions

| Action                    | Description                                         | Required status     | Required flag        |
| ------------------------- | --------------------------------------------------- | ------------------- | -------------------- |
| Create                    | Create an event record                              | -                   |                      |
| Update                    | Update a draft declaration                          | Draft               |                      |
| Notify                    | Submit an incomplete declaration for follow-up      | Draft               | —                    |
| Declare                   | Submit a completed declaration                      | Draft, Notified     | —                    |
| Mark as duplicate         | Mark a declaration as a duplicate during review     | Declared            | Potential duplicate  |
| Mark not a duplicate      | Confirm a declaration is not a duplicate            | Declared            | Potential duplicate  |
| Archive                   | Archive a declaration                               | Declared            | —                    |
| Reject                    | Reject a declared or validated record               | Declared, Validated | —                    |
| Edit                      | Edit notification or declaration data during review | Declared, Validated | —                    |
| Register                  | Finalise and register a declaration                 | Declared            | —                    |
| Request correction        | Flag a registered record for correction             | Registered          | —                    |
| Review correction request | Review a submitted correction request               | Registered          | Correction requested |
| → Reject correction       | Reject a correction request                         | Registered          | Correction requested |
| → Approve correction      | Approve a correction request                        | Registered          | Correction requested |
| Print                     | Generate and issue a certified copy                 | Registered          | —                    |
| Assign                    | Assign the record to yourself                       | Any                 | —                    |
| Unassign                  | Release or change record assignment                 | Any                 | —                    |

#### Configurable flags on core actions

Core actions can be configured to conditionally add or remove flags based on the context in which they are performed. This allows for flexible workflow customization while maintaining standard action behaviour.

**Examples:**

* When a registration agent **Creates** and performs the **Declare** action, it can append the `validated` record flag to indicate the declaration has been reviewed by an authorised agent
* If a declaration is late (based on configured time limits), the **Declare** action can add the `late-registration` flag

This configuration allows countries to adapt core workflows to their specific requirements without modifying the core action definitions.

#### Core actions by status

The table below summarises which actions are available at each stage of the record lifecycle.

| Record status | Available actions                                                                  |
| ------------- | ---------------------------------------------------------------------------------- |
| Draft         | Update, Notify, Declare                                                            |
| Notified      | Assign, Unassign, Declare, Edit                                                    |
| Declared      | Assign, Unassign, Archive, Reject, Edit, Mark duplicate, Mark not a duplicate      |
| Archived      | Assign, Unassign                                                                   |
| Registered    | Assign, Unassign, Request correction, Approve correction, Reject correction, Print |

***

### 6. Custom Actions (Overview)

Custom Actions allow implementers to extend the system beyond core workflows to support **country-specific or programme-specific business processes**.

Custom actions are similar to core actions in that:

* They are permission-controlled
* They are deterministic based on the record status and flags
* They are journaled
* They can add and/or remove record flags
* They can capture additional metadata viewable in record audit
* They appear in the same action menu

They differ by:

* They can not change the status of a record
* They can not edit/correct data in the record
* Support only a one page form within a dialog

#### Custom action parameters

Each custom action is defined using a configuration that controls its visibility, behaviour, and side effects.

| Property                     | Description                                    | Example                                              |
| ---------------------------- | ---------------------------------------------- | ---------------------------------------------------- |
| **Icon**                     | Icon displayed in the action menu and dialog   | warning                                              |
| **Name**                     | Display text shown in the action menu          | Attest                                               |
| **Audit copy**               | Text written to the audit log                  | Attested                                             |
| **Required scope**           | User permission required to perform the action | `custom.attest[event=birth, jurisdiction=my-office]` |
| **Required status(es)**      | Record status(es) required                     | Declared                                             |
| **Required flag(s)**         | Flag(s) required for availability              | senior-approval-required                             |
| **Disable if**               | Conditions that disable the action             | Disable if record has `rejected` flag                |
| **Dialog supporting copy**   | Explanatory text in the confirmation dialog    | —                                                    |
| **Dialog confirmation form** | Optional form to capture metadata              | Comments, reason dropdown                            |
| **Output flags added**       | Flags added when action completes              | attested                                             |
| **Output flags removed**     | Flags removed when action completes            | pending-certificate-issuanc                          |

#### Example custom actions

The following examples illustrate possible custom actions you could configure:

| Action                | Description                            |
| --------------------- | -------------------------------------- |
| Attest                | Attest a declaration before submission |
| Grant senior approval | Approve late registrations             |
| Escalate              | Request senior-level review            |
| Give feedback         | Add guidance or notes to a record      |
| Collect search fees   | Record fee collection for access       |

***

### 7. Worked example

This section illustrates how a real-world business rule is translated into a custom action configuration.

#### Business requirement - Attest

* All death declarations declared by a Health Official must be Attested by the Hospital Administrator
* Registration is not allowed until the event has be attested

#### Configuration input - Action: Attest

| Property                     | Value                                                                                |
| ---------------------------- | ------------------------------------------------------------------------------------ |
| **Icon**                     | Check                                                                                |
| **Name**                     | Attest                                                                               |
| **Audit copy**               | Attested                                                                             |
| **Required scope**           | `record.custom.action[event=death, actionType=Attest]`                               |
| **Required status(es)**      | Declared                                                                             |
| **Required flag(s)**         | Pending attestation                                                                  |
| **Disable if**               | -                                                                                    |
| **Dialog supporting copy**   | By attesting this record you confirm that the event occurred in your health facility |
| **Dialog confirmation form** | Comments - Text Area Field - (optional)                                              |
| **Output flags added**       | -                                                                                    |
| **Output flags removed**     | Pending attestation                                                                  |

#### Configuration input - Action: Register

The Register action must be disabled when the record has the `pending-attestation` flag

| Property   | Value                     |
| ---------- | ------------------------- |
| Disable if | flag: pending attestation |

#### Configuration input - Workqueue: Pending attestation

A **Pending attestation** workqueue that displays all records with the `pending-attestation` flag

| Workqueue           | Query                       |
| ------------------- | --------------------------- |
| Pending attestation | flag: `pending-attestation` |

#### Configuration input - User Role: Hospital Administrator

The **Hospital Administrator** need to be given the scope to perform the custom action Attest and the Pending Attestation workqueue

| Role                   | Scope                                                                                      |
| ---------------------- | ------------------------------------------------------------------------------------------ |
| Hospital Administrator | `record.custom.action[event=death, actionType=Attest]` `workqueue[id:pending-attestation]` |

See: Workqueues, User Roles and Flags to learn more.

***

***

### 8. Core User Management Actions

In addition to record-based actions, OpenCRVS includes system-level actions for managing users. These actions are available only to administrators with appropriate user scopes.

#### User management actions

| Action                 | Description                                  |
| ---------------------- | -------------------------------------------- |
| Create                 | Create a new user account                    |
| Edit                   | Update user details (role, location, status) |
| Deactivate             | Disable user access                          |
| Reactivate             | Restore user access                          |
| Reset password         | Initiate password recovery                   |
| Send username reminder | Send username via email or SMS               |

***
