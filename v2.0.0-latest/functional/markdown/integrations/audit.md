# Audit

### 1. Introduction

OpenCRVS maintains a detailed **audit log** of all important actions taken on:

* **Records** (for example, declarations, registrations, corrections, certificate issuance).
* **User accounts** (for example, login, password changes, user management).

Every change to a record, and every key event on a user account, is written as a time-stamped audit entry. Taken together, these entries form a **complete, chronological history** of how records are processed and how user accounts are used across the system.

Audit information is used to:

* Provide **accountability** for service providers (who did what, where, and when).
* Support **investigations** of suspected fraud or misuse (for example, unusual corrections or registrations).
* Demonstrate **compliance** with laws and policies during audits or reviews.
* Inform **management and quality improvement**, by highlighting patterns such as high rejection rates or repeated corrections.

~~Audit information is only visible to **authorised users** (for example, supervisors, system administrators), according to their scopes. Countries can define which roles are permitted to view audit details, in line with their own governance and data protection requirements.~~

***

### 2. Feature overview

Audit provides a **complete, time-ordered history** of key actions across records and user accounts, so that countries can see who did what, where, and when.

#### Core capabilities

With audit, OpenCRVS supports:

* **End-to-end traceability** of record workflows, from initial declaration through to registration, correction, and certificate issuance.
* **Standardised metadata** on every action, including timestamp, user, role, and location.
* **Detailed action histories** for individual records and user accounts.
* **Support for investigations, supervision, and external audits**, using a reliable, immutable log of activity.
* **Accurate timelines in offline scenarios**, based on when actions were taken on the device.

Audit is:

* **Journal-based** — ~~built on the same underlying action journal as workflows and record data.~~
* **Non-editable** — audit entries cannot be altered once written.
* **\~\~Configurable at the access layer** — countries can decide which roles and scopes are allowed to view audit details.\~\~

***

### 3. Record audit

The **record audit** shows the full history of actions performed on a specific event record (for example, a birth or death). Each audit entry includes a standard, non-configurable set of fields:

* **Action name** — what was done (for example, Declared, Registered, Corrected).
* **Action timestamp** — the date and time when the user triggered the action on their device.
* **User name** — who performed the action.
* **User role** — which role they held at the time (for example, Registrar, Registration Agent).
* **User location** — the location (office) associated with the user.

Additional audit details based on the action include:

* **Annotations / metadata** — additional data captured in the action form (for example, reason for rejection, correction details).

For offline working, the **action timestamp** reflects the moment the user triggered the action on their device, not the time it eventually reached the backend server. This ensures that the audit timeline accurately records when actions actually occurred, even if a user was offline for one or more days.

#### Core record audit actions:

* **Created** — a declaration was created.
* **Notified** — an incomplete declaration was submitted.
* **Declared** — a complete declaration was submitted.
* **Updated** — a declaration was edited.
* **Rejected** — a declaration was rejected and sent back for updates.
* **Flagged as potential duplicate** — the system flagged a declaration as a potential duplicate.
* **Marked as a duplicate** — a user confirmed the declaration is a duplicate.
* **Marked not a duplicate** — a user confirmed the declaration is not a duplicate.
* **Archived** — a declaration was archived
* **Registered** — an event was registered.
* **Certified** — a certificate or certified copy was issued.
* **Correction requested** — a correction request was submitted.
* **Correction rejected** — a correction request was rejected.
* **Correction approved** — a correction request was approved and the correction finalised.
* **Corrected** — a registered record was corrected.
* **Viewed** — a record was viewed by a user (where tracked).
* **Assigned** — a record was assigned to a user.
* **Unassigned** — a record was unassigned from a user.

Custom action are also recorded in audit and will use the configured copy eg.

* **Validated** — a declaration was validated
* **Attested** — a declaration was attested

These entries provide a chronological view of how a record moved through the workflow and who was involved at each step.

***

### 4. User audit

The **User Audit** provides a **complete, chronological history of activity related to an individual user account**, including both operational record actions listed above in 'Core record audit actions' the following system-level account events are recorded.

#### System-level actions:

* **Logged in** — user successfully logged in.
* **Logged out** — user logged out.
* **Username reminder requested** — a username reminder was triggered.
* ~~**Password reset** — a password reset process was initiated.~~
* **Password changed** — the user changed their password.
* **Profile updated ??!?** — the user’s account details were edited (for example name, phone, email, role, office, or device assignment)

These entries provide a clear audit trail of when the user accessed the system, what administrative changes were made to their account and which event records they worked on. Together, this ensures accountability, supports investigations, and helps maintain secure system operations.

***

### 5. System admin audit

For users with the scope to create and update other users. Their user audit log also records **user management** actions taken on other users.

#### System admin audit actions:

* **Created user** — a new user account was created.
* **Edited user details** — user details (such as role, location, contact information) were updated.
* **Username name reminder sent**  — a username reminder was sent for a user&#x20;
* **Password reset**— a user password was reset
* **Deactivated user** — a user’s access to OpenCRVS was revoked.
* **Reactivated user** — a previously deactivated user’s access was restored.

These entries provide a transparent history of how access to the system is granted, changed, or revoked.

***

### 6. Using audit information

Audit information can be used in several ways:

* **Case investigation** — supervisors can review the full action history on a record when a complaint or anomaly is reported.
* **Performance and quality monitoring** — managers can identify patterns (for example, high rejection rates by a specific office) for follow-up and training.
* **Fraud detection** — auditors can look for unusual activity patterns, such as repeated corrections or registrations by the same user under unusual conditions.

OpenCRVS provides the underlying audit data; how it is reviewed, escalated, and acted on is defined by each country’s governance and oversight processes.
