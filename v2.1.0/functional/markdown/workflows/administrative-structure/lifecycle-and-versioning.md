# Lifecycle & Versioning

### 1. Overview

OpenCRVS tracks changes to locations and administrative areas over time. Every location — an office or a health institution — and every administrative area keeps one permanent identity for life, alongside a running history of every name, status, and reference code it has ever had, each tagged with the date it took effect.

This means a record never has to choose between being accurate today and being accurate to history. A birth registered in Alaminos in 1995 — before the town was renamed Alaminos City in 2001 — still shows Alaminos on its record and on any certificate printed today. A birth registered after 2001 correctly shows Alaminos City. Nothing about the underlying place record needs to change for either case to be true.

A location or administrative area can be created, renamed, given a new reference code, or marked inactive (closed) — and any of these changes can be scheduled ahead of time for a future date. None of this is destructive: nothing is ever overwritten or deleted, so a closed or renamed place stays permanently on record and continues to resolve correctly wherever it's referenced.

### 2. Effective Dates & Historical Resolution

One idea underlies everything in this guide: a location's identity is permanent, but its name is a matter of record for a particular date.

Every location and administrative area has one permanent identity that never changes — think of it as the place's file number. Attached to that identity is an ordered history of **versions**: each version records the name, status (active or inactive), and reference code that were correct starting from a particular date. Nothing in that history is ever edited or removed once its date has passed — a further change is always recorded as a new version, never as a correction to an old one.

Whenever the system needs to show a location's name, it doesn't default to "whatever it's called today." It looks up the one date that's actually relevant to what's being shown — called the **anchor date** — and finds the version that was in effect on that date.

> **Resolution rule:** The name shown for a given date is the most recent version that had already taken effect by that date. If the date comes before any recorded version, the earliest available version is used instead.

This same rule applies independently to every level of a location's hierarchy — the province, district, and municipality above it — so a full historical address resolves correctly as a whole, not just its lowest level.

**Worked example — Alaminos → Alaminos City**

| Anchor date        | Version in effect                | Name shown      |
| ------------------ | -------------------------------- | --------------- |
| 1995 (birth event) | Version 1 — effective 0001-01-01 | "Alaminos"      |
| Today              | Version 2 — effective 2001-03-05 | "Alaminos City" |

Same identity, two versions — the anchor date decides which name is shown.

Inactivation (closing a place) is handled the same way: it is simply a new version with status set to inactive, not a deletion. An inactive place is never removed from the system — it remains permanently available to anything that needs to resolve it at a past date.

**Terms used in this guide**

* **Identity** — The permanent, unchanging record for a place — same identity for its entire life, however many times it's renamed.
* **Version** — One dated entry in a place's history: a name, status, and code, effective from a given date.
* **Anchor date** — The specific date used to decide which version applies — varies by context (event date, record date, today).

### 3. Types of Changes

OpenCRVS can keep track of different types of changes to locations and administrative areas. These changes are recorded as part of the place's history, so users can understand what information was valid at different points in time.

When a location or administrative area is created, it is assigned a **parent** — the administrative area it belongs to. This parent remains fixed throughout the lifetime of that place. If a place needs to move to a different parent, it is handled by closing the existing place and creating a new one under the new parent.

| Change                  | What happens                                                                                                                                                                     | Example                                                               |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Create**              | A new location or administrative area is created with a name, type, and parent.                                                                                                  | A new health post is added to a district.                             |
| **Rename**              | The new name is recorded with an effective date. Previous names remain available in the place's history.                                                                         | **Alaminos** is renamed to **Alaminos City**, effective 5 March 2001. |
| **Change code**         | An official code can be changed while keeping the same place. The previous code remains in its history.                                                                          | A district receives a new government code.                            |
| **Inactivate**          | A location or administrative area can be made inactive from a specified date. It is no longer available for new selections, but its history and existing records are retained.   | A registration office closes permanently.                             |
| **Future-dated change** | A create, rename, code change, or inactivation can be scheduled to take effect on a future date. The change is stored in advance but does not affect the system until that date. | An office is scheduled to close three months from now.                |
| **Transfer**            | A place cannot be moved directly to a different parent. Instead, the existing place is inactivated and a new place is created under the new parent.                              | A barangay moves from one municipality to another.                    |

### 4. Effect on Records & Certificates

Changes to a location or administrative area do **not change existing records**. A record remains associated with the same place where it was originally created.

However, when a record or certificate is viewed, OpenCRVS displays the **name and administrative information that was valid at the relevant time**.

For example, if a child was born in **Alaminos** in 1995 and the location was renamed **Alaminos City** in 2001:

* A record for a birth in **1995** continues to show **Alaminos**.
* A certificate printed in **1995** shows **Alaminos**.
* If the same certificate is reprinted today, it still shows **Alaminos**.
* A birth registered after the rename shows **Alaminos City**.

The date used to determine the correct information depends on what the location information represents:

* **Event locations** — such as place of birth or place of death — use the **event date**. This ensures that the location reflects how it was known when the event occurred.
* **Action-related locations** — such as the office where a registration was processed — use the **date of that action**. This means different locations shown on the same record may display different names if they changed at different times.

The same principle applies to the **full administrative hierarchy**. When a location is displayed together with its district, region, or other parent areas, OpenCRVS shows the hierarchy that was valid at the relevant time.

If a location is later **inactivated or closed**, existing records that use that location are not affected. The location remains available for those historical records, and its historical information can still be displayed correctly.

### 5. Locations in Forms and Selectors

When a user selects a location from a dropdown in a form, OpenCRVS shows the locations that are **valid for the date relevant to that field**. This ensures that users select locations based on the appropriate point in time.

The locations available in a new registration depend on what the field represents:

| Field                                                         | Locations are based on             |
| ------------------------------------------------------------- | ---------------------------------- |
| **Place of event / place of delivery**                        | The event date entered on the form |
|  **Residential address**                                      | The event date entered on the form |
| **Other addresses** (such as the informant's current address) | The current date                   |

For example, if an event occurred in 1995, the **Place of Event** dropdown will show the locations that were active in 1995, rather than only showing locations that are active today.

A location that is scheduled to become active or inactive in the future is stored in OpenCRVS but is **not available for selection until its effective date**.

**Correcting an Existing Record**

When correcting an existing record, location dropdowns are expected to show the locations that were **valid on the original date of the record**, rather than the locations that are active today.

For example, when correcting a record for an event that occurred on **1 January 2020**, the location options would be based on the administrative structure that was valid on that date.

### 6. Searching Historical Locations

A closed office doesn't take its records into hiding — Advanced Search is designed to keep them findable.

Whether a search filter includes inactive places depends on what kind of location the filter represents:

| Search filter                          | Includes inactive locations? |
| -------------------------------------- | ---------------------------- |
| Place of registration (office)         | ✅ Yes                        |
| Place of delivery (health institution) | ✅ Yes                        |
| Residential address                    | ❌ No — active only           |
| Other address filters                  | ❌ No — active only           |

Selecting a closed office or health institution in a search filter returns every record ever created there — inactivation never removes records from being found. Address-type filters, by contrast, only ever list currently active administrative areas, since they describe present-day jurisdictions rather than a historical event location.

### 7. Workqueues & User Access

* **Renaming or inactivating a place does not move a record.** A record's visibility in workqueues (Notified, Declared, Pending Registration, and so on) depends on comparing its location against the current administrative structure — unaffected by a name change or closure.
* **Records at a closed office stay visible to nearby offices.** If an office is inactivated, records already created there remain visible and workable to any other office within the same administrative area — nothing is hidden or deleted.
* **Users are never auto-reassigned.** Closing or restructuring an office does not move its staff to a different office. Where continued access is needed, an administrator manages that manually through existing user-management functions.

**Lockout for users at an inactivated office**

If a user's assigned office is made inactive, they are blocked from using the application until an administrator resolves the situation. They see a full-screen message: _"Your assigned office has been made inactive, please contact admin…"_ — this overlay blocks all further use of the application.

### 8. Offline Behaviour

OpenCRVS keeps location information accurate even when staff are working offline.

* **Location history is synced to the device**, including past, current, and scheduled changes.
* **Scheduled changes take effect automatically** on the device when their effective date arrives, even without a new sync.
* **If a device has not synced recently**, it may show older location information until it connects and syncs again.

### 9. Implementation Guidance & Limitations

**Guidance for country implementation teams**

* **Plan how changes will be requested and applied.** Since locations cannot currently be created, renamed, or inactivated through the OpenCRVS user interface, country teams should establish an internal process for managing these changes, such as a support or configuration request.
* **Plan for office closures.** Before closing an office, clear or redirect any pending work in its queue, as pending work is not automatically moved to another office.
* **Validate location codes.** If your country requires location codes to be unique among active locations, include this validation in your import or configuration process.
* **Test offline synchronisation.** Before a large-scale rollout, test offline synchronisation using the size and structure of your country's actual administrative hierarchy.

#### Current Functional Limitations

* **Moving a place to a different parent:** A place cannot be moved directly to a new parent. The existing place must be inactivated and a new place created under the new parent.
* **Splitting or merging places:** A place cannot be split into multiple places or multiple places merged into one as tracked operations.
* **Linking replaced places:** OpenCRVS does not currently link an inactivated place to the new place that replaces it. They remain separate locations in the system.
* **Statistics and reporting:** Changes to locations do not affect how statistics or reporting figures are calculated.
* **Managing locations through the user interface:** Locations cannot currently be created, renamed, or inactivated through an on-screen administrative tool. These changes are managed through platform configuration.
* **Historical information before versioning:** OpenCRVS does not reconstruct the history of existing locations. Existing locations start with their current name and status as their initial version.
* **Viewing location change history:** The system records changes to locations, but there is currently no user interface for viewing who made a change and when.

