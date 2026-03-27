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

# Offline working

### 1. Introduction

OpenCRVS enables civil registration staff to work reliably in **low-connectivity** or **offline** environments. The Offline Working feature ensures that key registration activities can continue even when there is no internet connection, and that all actions are synchronised safely once connectivity is available.

Offline working is built on three core ideas:

* Users can **create and update records** while offline.
* Actions are queued in an **Outbox** on the device.
* When connectivity returns, queued actions are **synchronised** to the backend and written to the audit log with accurate timestamps based on when the user confirmed the action

For details on how action timestamps and audit entries are recorded, see **Record data** and **Audit**.

{% hint style="danger" %}
While you can complete all assigned record actions (such as Register, Edit, or Approve) while offline, the action should not be considered "legally final" until the users device has synchronised with the backend central e-registry
{% endhint %}

***

### 2. Feature overview

Offline working allows users to continue **end-to-end workflows** even when connectivity is unreliable, while keeping the data model and audit history consistent.

#### Core capabilities

With offline working, OpenCRVS supports:

* **Creating and submitting declarations offline**, including Notify and Declare actions.
* **Working on assigned and downloaded records offline**, including review, approval, and corrections where permitted.
* A local **Outbox** that queues actions safely on the device until connectivity returns.
* **Accurate audit timelines** based on the time actions were taken on the device, not when they synced.
* **Conflict prevention** through record assignment and unassignment rules.
* Reliable workflows in **low-connectivity or intermittently connected environments**.

Offline working is:

* **Assignment-driven** — only assigned records are available for offline mutation, reducing conflicts.
* **Action-based** — all offline changes are still captured as actions in the journal.
* **Transparent** — users can see which records are assigned and which actions are pending in the Outbox.

***

### 3. Core offline use cases

#### 2.1 Creating a new declaration

Users can create and submit declarations while offline:

* The user completes the **event form** for Notify/Declare on their device.
* When they choose to **Notify** or **Declare**, the action is stored locally if there is no connectivity.
* The declaration is added to the device’s **Outbox** and will be synchronised automatically when a connection is available.

{% hint style="warning" %}
If a form includes fields that require **online validation** (for example, national ID verification):

* An internet connection is required to complete that validation step.
* Countries are encouraged to configure a **fallback option** so that a declaration can still be completed and submitted offline when online validation is not possible, with follow-up checks performed later.
{% endhint %}

#### 2.2. Registration and certification offline

..

#### 2.3 Working on assigned records

Users can also work offline on records that have been assigned to them:

* When a record is **assigned** to a user, it is downloaded to their device for offline access.
* Depending on the user’s role and permissions, they can **update, review, or approve** the record while offline (for example, using Edit, Correct, or other configured actions).
* All offline actions are added to the **Outbox** and synchronised when connectivity is restored.

{% hint style="danger" %}
While you can complete all assigned record actions (such as Register, Edit, or Approve) while offline, the action should not be considered "legally final" until the users device has synchronised with the backend central e-registry
{% endhint %}

#### 2.4 Search results

User will only be able to search for records they have already assigned whilst offline

***

### 4. Assignment and conflict prevention

Assignment is used to control who can work on a record offline and to reduce the risk of conflicting edits.

When a user assigns a record to themselves, it is downloaded to their device for offline access. The assignment mechanism includes safeguards:

* **Assignment visibility** — the record’s assigned status is visible to other users in the workqueue, indicated by the profile icon of the assigned user.
* **Conflict prevention** — only one user can edit a record at a time, which helps avoid concurrent offline edits on the same record.
* **Unassignment** — users with the appropriate unassign scope can unassign another user from a record. This action discards any unsynchronised changes made by the previously assigned user on their device.

This assignment behaviour, combined with the Outbox, supports robust offline working while minimising data conflicts.

***

### 5. Outbox

The **Outbox** acts as a queue for offline actions, similar to the Outbox in an email client. It temporarily stores updates made while offline and ensures they are securely processed once connectivity is restored.

Key behaviours:

* **Workflow continuity** — Field Agents can create declarations offline, and Registration Agents can review or approve records assigned to them without needing continuous internet access.
* **Automatic synchronisation** — when connectivity is reestablished, the Outbox automatically synchronises all stored actions with the backend. Records are forwarded to the appropriate Registration Office or the next workflow stage.
* **Data security and reliability** — the Outbox reduces the risk of data loss caused by intermittent connectivity. Users can be confident that their offline actions are stored safely on the device until they are successfully synchronised.

The Outbox and assignment model together ensure that OpenCRVS supports consistent, secure workflows even in challenging connectivity conditions.

***

### 6. Offline actions and audit

Every action taken while offline is written to the audit log once synchronised.

Important characteristics:

* Each action includes standard, non-configurable metadata (for example, **action timestamp**, **user**, and **assigned user location**).
* The **action timestamp** records the date and time when the user triggered the action on their device, **not** when it later reaches the backend server.
* This ensures that the audit timeline accurately reflects **when actions actually occurred**, even if a user was offline for one or more days.

For further detail on how this is represented in the data model and audit trails, see the **Record data** and **Audit** documentation pages.



### 6. User management actions

...
