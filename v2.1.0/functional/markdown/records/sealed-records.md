# Sealed Records

### 1. Introduction

Some records in OpenCRVS may contain especially sensitive information, or be subject to special safeguarding rules (for example, adoption, witness protection, gender recognition, or court-ordered restrictions). To support stronger privacy controls in these situations, OpenCRVS allows certain records to be marked as **sealed**.

Sealing is independent of the record's status. A sealed record can remain **Registered**, or a country can configure sealing to trigger a separate status transition where required by law.

This helps countries meet legal, privacy, and safeguarding requirements by ensuring that sensitive records remain within the registry while their visibility and use are restricted to appropriately authorised users.

***

### 2. What it means for a record to be Sealed?

A **sealed record** remains part of the legal registry, but access to it is restricted to authorised users.

A sealed record:

1. **Has restricted visibility**
   * It is not visible in normal search results, workqueues, listings, or counts to users who are not authorised to access sealed records.
   * Authorised users can still locate the record when required.
2. **Has restricted access**
   * Being able to find a sealed record does not necessarily mean the user can view its contents.
   * Users without permission to view the record see a **masked version** instead.
3. **Is clearly identified as sealed**
   * Authorised users who can find a sealed record can distinguish it from an ordinary record through a clear sealed indicator.
4. **Is subject to audit**
   * Sealing, unsealing, and access to sealed records are recorded for traceability.

Sealing does not change the underlying record data. It controls **who can find, view, and perform** certain actions on the record.

***

### 3. Controlling access to sealed records

Access to sealed records is controlled through separate **search and read permissions**.

For each event type that may contain sealed records (for example, birth, death, or marriage), countries can grant users permission to search for and/or view sealed records.

**Search access**

Users who are authorised to search for sealed records can locate them in search results, workqueues, listings, and counts.

For example:

* `record.search[event=birth incl=sealed]`
* `record.search[event=death incl=sealed]`

Users without the appropriate permission will not see sealed records in these areas.

**Read access**

Being able to find a sealed record does **not** automatically give a user permission to view its contents.

Users who are authorised to view sealed records can see the **full record**, with a clear **Sealed** indicator to show that they are viewing restricted information.

Users who can search for a sealed record but do not have permission to view it see a **fully masked version**, showing only the minimum information needed to identify the record.

For example:

* A specialist role that needs to locate sealed birth records may have:
  * `record.search[event=birth incl=sealed]`
* A role that also needs to view those records may additionally have:
  * `record.read[event=birth incl=sealed]`

All views of sealed records by authorised users are **audited** for traceability.

**Key principle:** Search and read access to sealed records are separate permissions. Being able to locate a sealed record does not necessarily mean the user can view its contents.

***

### 4. Interaction with other search scopes and jurisdiction

Access to sealed records follows the user's existing **event and jurisdiction permissions**. The `incl=sealed` qualifier determines whether sealed records are included in the search.

For example, a user authorised to search birth records within their administrative area may have:

* `record.search[event=birth declared_in=my-administrative-area registered_in=my-administrative-area]`

To also include sealed birth records within the same scope, the user must have permission to search sealed records:

* `record.search[event=birth declared_in=my-administrative-area registered_in=my-administrative-area incl=sealed]`

This means a user cannot gain access to sealed records outside the **event types or jurisdictions** they are otherwise authorised to access.

Countries can therefore control sealed-record search access based on both **role** and **jurisdiction**, for example limiting it to national-level users, supervisory roles, or specialised units

***

### 5. Reasons for sealing records

Countries may choose to seal records, in situations such as:

* **Adoption** — the original birth record is hidden once a child is legally adopted. Only the new birth record (showing adoptive parents) and the associated adoption record can be found in search. Access to the original record is restricted to authorised roles.
* **Domestic or gender-based violence cases** — records where disclosure of a parent's or informant's identity or address could put someone at risk.
* **High-profile or sensitive persons** — records relating to specific individuals (for example, public figures or protected witnesses) where additional privacy is required.
* **Court-ordered restrictions** — records that must be hidden or limited following a court decision (for example, sealed records).
* **Special safeguarding policies** — any other category defined in national policy (for example, children in alternative care, humanitarian protection cases).

These examples are illustrative. Each country should define its own criteria for when records or specific fields should be sealed, and how long sealing should apply.

***

### 6. Sealing and unsealing a record

A record can be sealed or unsealed through dedicated custom actions on the record, such as `Seal` and `Unseal`.

#### 6.1 Marking a record as sealed

A user with the appropriate permissions can mark a record as sealed from the record overview:

1. Open the event record (for example, a birth record).
2. Select the **Seal** custom action.
3. If a country-configured form is available, provide the required information, such as the reason for sealing, legal basis, or court order reference.
4. Confirm the action

When **Seal** is applied:

* The system automatically adds a **Sealed** flag to the record.
* The record immediately behaves as a sealed record:
  * It is excluded from search results for users who are not authorised to search for sealed records.
  * It remains visible only to users who have the relevant `search[event=<event> incl=sealed]` scope and the necessary jurisdiction.
* If configured by the country, sealing can also trigger a status transition, such as **Registered → Revoked**
* The action, including who performed it and when, is recorded in **Audit**.

#### 6.2 Unsealing a record

When a record should no longer be treated as sealed(for example, after a policy-defined period or following a supervisory decision), authorised users can unseal the record:

1. Open the sealed event record.
2. Select a the unseal custom action.
3. Complete any required country-configured form and confirm the action.

When a record is unsealed:

* The **Sealed** flag is removed from the record.
* The record returns to the normal access and search rules based on the user's scopes and jurisdiction.
* Any actions that were disabled while the record was sealed become available again.
* The unsealing action is recorded in **Audit**, alongside the original sealing action.

These actions ensure that protection of records is explicit, auditable, and reversible only by appropriately authorised users.

***

### 7. Configuration considerations

When introducing Sealed records, countries should decide:

* **Which event types** can have selaled records.
* **Which roles** should be allowed to search sealed records (and in which jurisdictions).
* How to align protected access with broader **privacy and safeguarding policies** (for example, adoption law, child protection guidelines, or data protection legislation).

By carefully configuring sealed records and the associated `search[event=<event> incl=sealed]` scopes, OpenCRVS helps ensure that only appropriately authorised users can retrieve and view the most sensitive records, while keeping them hidden from general search.
