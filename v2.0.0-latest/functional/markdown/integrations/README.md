# Records

### Overview

The **Records** section focuses on the lifecycle and structure of individual event records in OpenCRVS.

It is organised into the following pages:

* **Record data** — describes the underlying data model for a record, including form data vs action metadata, and how Notify/Declare, Edit, and Correct all operate on the same event form.
* **Statuses** — explains the record status model (for example, Draft, Notified, Declared, Registered, Corrected), including which actions move a record between statuses and how status is used in workqueues and search.
* **Flags** — covers flags as additional workflow markers (for example, pending-attestation, correction-requested, protected) that complement status when a new status is not needed.
* **Certificates** — describes how registered records produce certificates and certified copies from configured templates, and how those outputs relate to the underlying record data and status.
* **Verifiable Credential** — explains how a registered record can produce a verifiable credential (VC), how it links back to the source record, and how it can be verified.
* **Protected data** — explains how some records or fields can be marked as protected, how this hides them from general search, and how access is controlled via protected search scopes.
* **Audit** — describes how every action on a record is written to the audit log, including who did what, where, and when, and how this supports accountability, investigations, and quality improvement.

These pages together show how OpenCRVS treats each event record as a journaled, auditable history from first notification through registration, correction, and output.
