# Digitise paper records

### PENDING REVIEW!



### 1. Introduction

**Data migration** is the process of bringing civil registration event records that already exist in a **legacy system** — a previous registration database, a spreadsheet-based register, or another CRVS application — into OpenCRVS, so that they become first-class records in the new eRegistry.

A migrated record is not a static archive. Once it is in OpenCRVS it behaves like any other record of the same status: it can be **searched**, used to **print a certified copy**, **corrected**, shared with integrated systems, and counted in reporting. Migration is therefore a prerequisite for OpenCRVS to act as the single source of truth from the day a country goes live, rather than leaving staff to consult two systems.

This page covers the **migration of existing digital records** from a legacy system. The related task of capturing historical **paper** registers is covered separately under [Legacy paper import](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data); the two share the same data model and many of the same considerations, but differ in how records are captured.

\{% hint style="info" %\} Migration is a milestone in the [Go-live](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/go-live) readiness checklist: legacy digital data migrated, migrated data validated and cleaned, and migration tested and verified **before** go-live. \{% endhint %\}

***

### 2. Feature overview

Data migration lets a country load existing event records into OpenCRVS through its APIs, mapping each legacy record onto the OpenCRVS event data model and giving it the correct status, identifiers and provenance.

**Core capabilities**

* **Map legacy records to the OpenCRVS event model** — each legacy record is transformed into an OpenCRVS event (birth, death, marriage, and so on) with its fields mapped to the configured form fields for that event.
* **Land records at the correct status** — depending on the agreed business rules, records are imported either as **declarations** for staff to validate, or as **directly registered** events when the legacy record is already a complete legal registration.
* **Preserve legacy identifiers** — the legacy registration number is carried onto the OpenCRVS record so historical references remain valid.
* **Maintain a complete audit trail** — every migrated record records that it was created by a migration/system client and when, so provenance is never lost.
* **Make records immediately usable** — once imported, records are indexed for search and, if registered, available for certified copies, corrections and onward sharing.
* **Support batch processing** — records are loaded in bulk, in controlled batches, with validation and reconciliation.

Migration is:

* **API-driven** — records enter through the same Core APIs that the OpenCRVS applications use, so migrated records are indistinguishable in behaviour from records created in-product.
* **Configuration-aligned** — the mapping targets the country's own configured events, forms and locations.
* **Auditable** — the source and timing of every migrated record is journaled.

***

### 3. What migration produces

The goal of migration is that a legacy record becomes a **native OpenCRVS record**, subject to the same status model, actions and access control as any other.

In practice this means deciding, per record, where it should sit in the OpenCRVS [record lifecycle](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows). OpenCRVS uses a fixed set of statuses, and a migrated record must arrive at one of them:

* A legacy record that represents a **completed legal registration** should arrive as **Registered** — it can then be searched, certified and corrected like any registered record.
* A legacy record that is **incomplete** or that the country wants staff to review before it becomes legal should arrive as a **Declaration** (or a notification), so it flows through the normal validation and registration workflow.

This decision is a business-rule choice, not a technical one, and it is usually made per legacy data source rather than per record (see Section 5).

***

### 4. How migration works

Records are migrated through the OpenCRVS **Core APIs** — principally the Events API, which is the authoritative source of truth for every record. A migration is, in essence, an automated client that authenticates, then creates and submits records on behalf of the registration authority. There are two common delivery patterns:

**4.1 Direct API migration (system client)**

A migration script or middleware authenticates as a trusted **system client** and submits records directly to the Events API in batches. This is the typical approach for a one-off migration of a structured legacy database: the legacy data is extracted, transformed to match the OpenCRVS model, and loaded through the API. Each event is first initialised and then submitted with its full data and the appropriate action.

**4.2 Migration via a custom application**

Where records need human capture or review — most often for paper registers, but sometimes for messy legacy data — a **custom side application** can be built against the same APIs. It provides high-throughput data-entry forms that map to the OpenCRVS event model, validates locally, captures supporting images, and submits records into the eRegistry as declarations or as directly registered events. It records who captured each record and when. This complements the core OpenCRVS interface rather than replacing it.

{% hint style="info" %}
Both patterns write through the same Core APIs, so the resulting records are ordinary OpenCRVS records. The choice between them is about **how records are sourced and reviewed**, not about what they become. \{% endhint %\}
{% endhint %}

***

***

### 5. Mapping legacy data to the OpenCRVS model

Every legacy field must be mapped to a field in the configured OpenCRVS form for that event, or deliberately dropped. Plan for:

* **Field-by-field mapping** — build a mapping from each legacy column to its OpenCRVS form field, per event type.
* **Mandatory fields** — OpenCRVS forms have required fields. Legacy data frequently lacks some of them. Decide in advance how to handle gaps: source the value elsewhere, apply an agreed default, hold the record back, or import at a status that allows later completion. Importing incomplete records directly as Registered is rarely appropriate.
* **Reference data** — values such as place of event must resolve to **configured locations and facilities**, not free text (see Section 8).
* **Supporting documents** — scanned images from the legacy system can be attached where the migration captures them.
* **Unmappable data** — decide what happens to legacy fields that have no home in the OpenCRVS model; do not invent fields to hold them without a configuration decision.

***

### 6. Identifiers

Migrated records must remain traceable to their legacy origins.

* **Legacy registration number** — preserve the existing registration number on the migrated record so that historical certificates, citizen references and downstream systems continue to resolve. OpenCRVS holds the registration number on the registered record.
* **Tracking IDs and internal references** — OpenCRVS assigns its own internal identifiers. Plan how legacy internal references are retained (for example, as a stored legacy reference) for reconciliation.
* **National ID and other person identifiers** — where the legacy record carries a national ID or similar, map it onto the corresponding person field so future search and linkage work correctly.

{% hint style="info" %}
Decide your registration-number policy explicitly: keep the legacy number as the canonical number, or store it alongside a newly issued OpenCRVS number. This affects certificates, search and every integrated system that references the record. \{% endhint %\}
{% endhint %}

***

### 7. Administrative structure and historical locations

Migrated records reference places — place of event, place of registration — and these must resolve to entries in the OpenCRVS [administrative hierarchy](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure), not to free text.

* **Map legacy place names to configured locations.** Build a lookup from legacy place names to OpenCRVS administrative areas and facilities. Spelling variants, renamed areas and merged districts all need resolving during transformation.
* **Locations are archived, never deleted.** A location that is no longer in use can be archived but is retained, precisely so that the historical name on an older record is preserved. This protects the integrity of migrated records that reference places no longer used for new events.

{% hint style="danger" %}
**Roadmap limitation — historical administrative structures.** Full versioning of the administrative structure over time (so that a record can reference an area exactly as it existed at the historical event date) is a planned capability and is **not yet available**. Until it lands, legacy records that reference abolished or restructured areas must be mapped to the nearest appropriate current or archived location, and that mapping decision should be documented. \{% endhint %\}
{% endhint %}

***

### 8. Data quality, validation and reconciliation

Migration is as much a data-cleaning exercise as a technical one. The go-live checklist requires migrated data to be validated and cleaned, and the migration itself to be tested and verified.

* **Validate before load.** Check completeness, formats, date plausibility and referential integrity (every place resolves, every event type is valid) before submitting.
* **Clean at source where possible.** Correct systematic legacy errors in transformation rather than carrying them into OpenCRVS.
* **Handle errors explicitly.** Records that fail validation should be quarantined and reported, not silently dropped.
* **Make loads idempotent.** Use stable transaction identifiers so a re-run does not create duplicates if a batch is interrupted.
* **Reconcile after load.** Compare counts and key fields between the legacy source and OpenCRVS, by batch and in total, and confirm a sample of records render and certify correctly.

***

### 9. Deduplication

OpenCRVS detects potential duplicate records. Migration interacts with this in two ways:

* **Within the migration** — the same person may appear more than once in legacy data; de-duplicate during transformation.
* **Between migrated and live records** — once migrated records are in the system, new declarations can be checked against them, and vice versa. Consider the order and timing of migration relative to go-live so that duplicate detection behaves as intended rather than flagging large volumes of expected matches.

***

### 10. Audit and provenance

Every record created through the APIs is journaled. For migration this means each record carries evidence that it was created by a **migration/system client** and when. Preserving this provenance is essential: it distinguishes a migrated historical record from one registered live in OpenCRVS, and it supports later questions about where a record came from and how much its legacy data can be trusted.

***

### 11. Planning and phasing

Treat migration as a controlled, repeatable process, not a single bulk dump.

* **Pilot first.** Migrate a small, representative subset, validate and reconcile it, and confirm records render, search and certify correctly before scaling.
* **Batch the full load.** Run the migration in controlled batches with validation and reconciliation at each step.
* **Test against a non-production environment.** Verify the full pipeline — extract, transform, load, reconcile — before touching production.
* **Sequence around go-live.** Decide whether migration completes before go-live, runs alongside an initial small launch, or continues in phases, and how that interacts with deduplication and live registration.
* **Account for volume.** Countries often hold very large historical volumes; performance, scheduling and infrastructure load are part of the plan.

***

### 12. What's supported today, and what's on the roadmap

* **Supported today.** Migrating existing digital records — and capturing paper records — by loading them through the Core APIs (directly via a system client, or via a custom capture application), as declarations or as directly registered events, with audit and search applying as normal.
* **On the roadmap (not yet available).** A **native in-product legacy-digitisation workflow** — configurable roles to digitise, approve and reject digitised legacy records as a distinct in-app capability — is a planned feature and is not yet built. Likewise, **versioning of the administrative structure over time** (Section 8) and additional record states such as a dedicated inactive/void status (today expressed using flags) are planned. Design your migration around what exists today, and treat these as future enhancements rather than assumptions.

***

### 13. Summary

* Data migration brings existing legacy event records into OpenCRVS through its Core APIs, where they become native records subject to the same statuses, actions and access control.
* The key business decision is the **import status** — directly **Registered** for complete legal registrations, or **Declaration/Notification** for records that should pass through the normal workflow.
* Legacy data must be **mapped** to the configured event model and to configured **locations**, with **identifiers** (especially the legacy registration number) preserved.
* Migration is an exercise in **data quality**: validate, clean, reconcile, and keep loads idempotent.
* **Audit** preserves the provenance of every migrated record.
* A native in-product legacy-digitisation workflow and historical administrative-structure versioning are **planned** capabilities; today, migration is delivered through the APIs.

***

#### Related pages

* [Legacy data](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data) — the legacy-data module, covering digital import and paper digitisation.
* [Record lifecycle and workflows](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows) — the statuses and actions a migrated record is subject to.
* [Administrative structure](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure) — the hierarchy and locations migrated records must reference.
* [APIs](https://documentation.opencrvs.org/v2.0/functional/markdown/interoperability/apis) — the Core APIs (Events, Search, Locations, Integrations, Attachments) used to load records.
* [Go-live](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/go-live) — where migration sits in the readiness checklist.
