# Data

### 1. Introduction

In OpenCRVS, **record data** is the structured information captured for a civil registration event (for example, a birth, death, or marriage). This data is:

* First captured when a user **notifies** or **declares** an event.
* Updated or completed (for notifications) using the **Edit** action while the record is still in progress.
* Corrected later using the **Correct** action after the record has been **Registered**.

The same underlying data structure is used throughout the lifecycle. Actions (Notify/Declare, Edit, Correct) determine **when** and **how** users are allowed to change the data, but they all work with the same event record.

It is useful to distinguish between:

* **Form data** — information entered in the event form itself (for example, child’s details, parents’ details, event dates and places).
* **Action metadata** — additional data captured when an action is completed (for example, date and place of registration captured on the **Register** action, or data captured as part of a custom action).

Form data describes the event itself. Action metadata describes **what happened to the record, when, where, and by whom** as it moves through the workflow.

***

### 2. Feature overview

Record data provides a **single, consistent view** of the information about an event across its entire lifecycle, from first notification through to registration and any later corrections.

#### Core capabilities

With record data, OpenCRVS supports:

* A **single event record** that is reused across Notify/Declare, Edit, and Correct actions.
* Clear separation between **form data** (the facts of the event) and **action metadata** (what happened to the record, when, where, and by whom).
* Safe **in-progress editing** before registration using the Edit action, with full audit history.
* Controlled **post-registration corrections** using the Correct action, preserving original values for legal and audit purposes.
* Consistent data for **certificates, verifiable credentials, search, reporting, and interoperability**.

***

### 3. Capturing data with a single form (Notify or Declare)

The first time data is entered for an event is through a **single event form**. At the end of this form, the user chooses whether to **Notify** or **Declare**, depending on whether all mandatory fields have been completed.

* **Single event form**
  * Configured per event type (for example, birth, death, marriage).
  * Contains all fields that may be required for registration.
  * Enforces mandatory fields for registration according to national law and policy.

At the end of the form:

* If **not all mandatory fields** for declaration are completed, the user can save the record as a **Notification (Notify)**. This creates a record in a **Draft** or **Notified** status that can later be completed using **Edit**.
* If **all mandatory fields** for declaration are completed, the user can proceed to **Declare** the event. This creates a declared record that can move through subsequent steps (for example, review, approval, registration) using other actions.

This approach ensures that data is captured once, while still supporting both partial notifications and full declarations, depending on how complete the information is at the time of capture.

Both Notify and Declare use the **same form** configured per event type. The form definition specifies:

* Which fields are displayed.
* Which fields are mandatory or optional.
* Validation rules and allowed values.

***

### 4. Editing record data with the Edit action

After a record has been created (via Notify or Declare) and before it is fully **Registered**, authorised users can change the data using the **Edit** action.

Typical use cases for **Edit** include:

* Completing missing fields that were not captured at notification.
* Correcting obvious data entry mistakes identified during review.
* Updating information following additional verification (for example, clarifying spellings of names or updating contact details).

When a user selects **Edit**:

1. The system opens the event form with the current record data pre-filled.
2. The user can adjust any fields.
3. On ‘Declare with edits’, the record is updated and the change is logged.

All edits are stored in the system’s journaled data model, and appear in audit views showing **who** changed **what** and **when**.

***

### 5. Correcting data after registration with the Correct action

Once a record has reached the **Registered** status, the original data becomes the official record for that event. Further changes must follow a **correction** process rather than ordinary editing.

The **Correct** action is used for post-registration changes, for example:

* Fixing a spelling error in a name on a registered record.
* Updating a date or place when an error is discovered after registration.
* Correcting mis-recorded relationships or other key details, following an approved correction procedure.

When a user selects **Correct** on a registered record:

1. OpenCRVS presents the **same event form** that is used for Notify/Declare, pre-filled with the current registered data.
2. The user completes an upfront from about the corrections. (eg. reason for correction, requester)
3. The user proposes changes to specific fields, according to configured rules and any required supporting documentation.
4. Depending on configuration, the correction may require review or approval before it is applied.
5. Once approved, the system updates the record, maintaining a clear history of the old and new values.

The journaled data model ensures that:

* The original registered values remain visible for audit purposes.
* The corrected values are applied for future outputs (for example, certificates, search results, and statistics)

***

### 6. Form data vs action metadata

In configuration, it is important to decide whether a piece of information should be treated as **form data** or **action metadata**.

* **Form data**
  * Captured in the single event form used for Notify/Declare (and re-used for Edit and Correct).
  * Represents the content of the civil event record itself (for example, date of birth, place of birth, parents’ identities, cause of death).
  * Can be viewed and, when allowed, edited or corrected through the relevant actions.
* **Action metadata**
  * Captured at the moment an action is completed, not as part of the main event form.
  * Includes a standard, non-configurable set of fields for **action timestamp**, **user**, and **assigned user location**. These are always recorded for every action.
  * Additional metadata can be captured as part of specific actions. Examples include:
    * Details captured as part of a custom action (for example, supervisor approval details, reason for cancellation, or notes recorded when marking a record as protected).
  * Describes the **workflow history** of the record (what actions were taken, when, where, and by whom), rather than the underlying event facts.
  * For offline working, the **action timestamp** records the date and time when the user triggered the action on their device, not when it later reaches the backend server. This ensures that the timeline reflects when actions actually occurred, even if the user was offline for an extended period.

Configuration guidelines:

* Use **form data** for information that legally forms part of the civil event record and may need to be corrected via the **Correct** action.
* Use **action metadata** for operational or procedural details that are tied to specific actions (such as Register, Approve, Mark protected, Issue certificate) and should be stored alongside the record’s action history.

By separating form data from action metadata in this way, OpenCRVS keeps the core event record clear, while still providing a rich, auditable history of how and when the record was processed.

***

### 7. Relationship between Notify/Declare, Edit, and Correct

The three actions work together over the life of a record:

* **Notify / Declare** — create the event record and capture the initial data.
* **Edit** — update or complete data **before** registration, while the record is still in progress.
* **Correct** — change data **after** registration, following the configured correction workflow.

By using these actions consistently, OpenCRVS ensures that event data is captured once, updated responsibly, and corrected transparently, with a full history of changes maintained for legal, operational, and statistical purposes.
