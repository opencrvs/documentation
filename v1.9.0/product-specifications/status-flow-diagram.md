# Status Flow Diagram

The status flow diagram shows all the vital event record statuses and record flags in OpenCRVS and how it is possible to move from one to the next.\\

**Statuses**:\
A record status describe the primary legal status of a record, control what actions can be performed and can be used to filter custom workqueues:

* Draft
* Notified
* Declared
* Archived
* Validated (Deprecated in 1.10. Will become a record flag)
* Registered

\
**Flags:**\
A record flag can be thought of as a secondary record status. It describes additonal characteristics of a declared or registered record, control what actions can be performed and can be used to filter custom workqueues.

* Rejected
* Potential duplicate
* Pending certification
* Correction requested
* Duplicate\\

<figure><img src="../../v1.6.0/.gitbook/assets/Status WorkFlow (1).png" alt=""><figcaption></figcaption></figure>
