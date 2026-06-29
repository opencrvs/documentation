# Data migration



### 1. Introduction

**Data migration** is the process of bringing civil registration event records that already exist in a **legacy system** — a previous registration database, a spreadsheet-based register, or another CRVS application — into OpenCRVS, so that they become first-class records in the new eRegistry.

A migrated record is not a static archive. Once it is in OpenCRVS it behaves like any other record of the same status: it can be **searched**, used to **print a certified copy**, **corrected**, shared with integrated systems, and counted in reporting. Migration is therefore a prerequisite for OpenCRVS to act as the approved single source of truth from the day a country goes live, rather than leaving staff to consult two systems.

This page covers the **migration of existing digital records** from a legacy system. The related task of capturing historical **paper** registers is covered separately under [Legacy paper import](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data); the two share the same data model and many of the same considerations, but differ in how records are captured.

{% hint style="info" %}
Migration is a milestone in the [Go-live](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/go-live) readiness checklist: legacy digital data migrated, migrated data validated and cleaned, and migration tested and verified **before** go-live.
{% endhint %}

***

### 2. Feature overview

Data migration lets a country load existing event records into OpenCRVS through its APIs, mapping each legacy record onto the OpenCRVS event data model and giving it the correct status, identifiers and provenance.

Migration starts with assessment, not loading. Before using the APIs, the country team should decide which sources are in scope, what legal status each source has, what data quality threshold applies, and what should happen to records that cannot be safely migrated.

**Core capabilities**

* **Map legacy records to the OpenCRVS event model** — each legacy record is transformed into an OpenCRVS event (birth, death, marriage, and so on) with its fields mapped to the configured form fields for that event.
* **Land records at the correct status** — records are imported as `Registered`, `Declared`, or `Notified` according to business rules approved by the registration authority. A technical team should not infer legal registration status from the existence of a digital record alone.
* **Preserve legacy identifiers** — legacy registration numbers, book/page/folio references, legacy system IDs, certificate numbers, PIN/UIN/National ID values, and amendment references should be preserved where available and relevant.
* **Maintain a complete audit trail** — every migrated record records that it was created by a migration/system client, while also preserving original registration provenance where available, such as original registration date, office, registrar, source register, and book/page reference.
* **Make records immediately usable** — once imported, records are indexed for search and, if registered, available for certified copies, corrections and onward sharing.
* **Support batch processing** — records are loaded in bulk, in controlled batches, with validation and reconciliation.

Migration is:

* **API-driven** — records enter through the same Core APIs that the OpenCRVS applications use, so migrated records are indistinguishable in behaviour from records created in-product.
* **Configuration-aligned** — the mapping targets the country's own configured events, forms and locations.
* **Auditable** — the source and timing of every migrated record is journaled.

Migration is NOT:

* a substitute for legal approval of the legacy records and their status on the register.
* a bulk cleansing exercise for all historical data.
* an obligation to migrate every historical source if controlled legacy access is safer.

***

### 3. What migration produces

The goal of migration is that a legacy record becomes a **native OpenCRVS record**, subject to the same status model, actions and access control as any other.

In practice this means deciding, per record, where it should sit in the OpenCRVS [record lifecycle](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows). OpenCRVS uses a fixed set of statuses, and a migrated record must arrive at one of them:

* A legacy record that represents a **completed legal registration** should arrive as **Registered** — it can then be searched, certified and corrected like any registered record.
* A legacy record that is **incomplete** or that the country wants staff to review before it becomes legal should arrive as a **Declaration** (or a notification), so it flows through the normal validation and registration workflow.

A useful target-status decision matrix is:

| Legacy source / record type                                           | Usual migration treatment                                                                                                                                                                                               |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Legally completed civil registration record                           | Import as `Registered`, if the registration authority confirms the source is legally authoritative.                                                                                                                     |
| Incomplete record requiring staff review                              | Import as `Declared` or `Notified`, depending on completeness and workflow design.                                                                                                                                      |
| Health notification, hospital spreadsheet, or local notification list | Use for reconciliation, duplicate checking, or import as `Notified` only if the country confirms it should enter the workflow. Do not import as `Registered` unless it is legally accepted as a completed registration. |
| Uncertain, conflicting, or low-quality record                         | Quarantine, report as an exception, or retain in controlled legacy access until resolved.                                                                                                                               |
| Source outside migration scope                                        | Do not migrate; document the reason and how staff can access it if needed.                                                                                                                                              |

This decision may vary by source, event type, date range, location, or data-quality band. For example, recent records in a structured database may be migrated as `Registered`, while older partial records from local books may require review.

This decision is a business-rule choice, not a technical one, and it is usually made per legacy data source rather than per record (see Section 5).

***

### 4. How migration works

Records are migrated through the OpenCRVS **Core APIs** — principally the Events API, which is the authoritative source of truth for every record. A migration is, in essence, an automated client that authenticates, then creates and submits records on behalf of the registration authority. There are two common delivery patterns:

**4.1 Direct API migration (system client)**

A migration script or middleware authenticates as a trusted **system client** and submits records directly to the Events API in batches. This is the typical approach for a one-off migration of a structured legacy database: the legacy data is extracted, transformed to match the OpenCRVS model, and loaded through the API. Each event is first initialised and then submitted with its full data and the appropriate action.

A direct API migration usually follows an extract-transform-load pattern:

1. Extract source data.
2. Profile the data for completeness, duplicates, formats, identifiers, locations, and attachments.
3. Clean systematic issues where there is an approved rule.
4. Map source fields, identifiers, statuses, and locations to the configured OpenCRVS event model.
5. Validate records before load.
6. Load records in controlled batches.
7. Reconcile loaded records against the source.
8. Produce exception reports.
9. Re-run safely using stable transaction identifiers where needed.

**4.2 Migration via a custom application**

Where records need human capture or review — most often for paper registers, but sometimes for messy legacy data — a **custom side application** can be built against the same APIs. It provides high-throughput data-entry forms that map to the OpenCRVS event model, validates locally, captures supporting images, and submits records into the eRegistry as declarations or as directly registered events. It records who captured each record and when. This complements the core OpenCRVS interface rather than replacing it.

{% hint style="info" %}
Both patterns write through the same Core APIs, so the resulting records are ordinary OpenCRVS records. The choice between them is about **how records are sourced and reviewed**, not about what they become.
{% endhint %}

***

### 5. Mapping legacy data to the OpenCRVS model

Migrated records must map to the configured OpenCRVS event model. This means the migration must use the country’s configured event types, form fields, identifiers, locations, statuses and attachment rules.

OpenCRVS does not provide a generic legacy-data store for unmapped historical data. Data that cannot be mapped to the configured model should either be excluded, retained in the legacy source, or handled through an approved configuration decision.

Detailed source assessment, mapping sign-off and exception handling are project activities. See [Migrate legacy data](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/migrate-legacy-data).

Technical mapping, validation and loading steps are covered in [Legacy data migration](https://documentation.opencrvs.org/v2.0/technical/guides/data-migration).

***

### 6. Identifiers

Migrated records must remain traceable to their legacy origins. Identifier policy affects certificates, search, corrections, reporting, and downstream systems. Decide whether the legacy registration number remains the canonical registration number in OpenCRVS, or whether it is stored alongside a new OpenCRVS number.

* **Legacy registration number** — preserve the existing registration number on the migrated record so that historical certificates, citizen references and downstream systems continue to resolve. OpenCRVS holds the registration number on the registered record.
* **Tracking IDs and internal references** — OpenCRVS assigns its own internal identifiers. Plan how legacy internal references are retained (for example, as a stored legacy reference) for reconciliation.
* **National ID and other person identifiers** — where the legacy record carries a national ID or similar, map it onto the corresponding person field so future search and linkage work correctly. Where a national ID or UIN depends on civil registration numbers, reconcile those identifiers before go-live and confirm how they will appear on migrated records, certificates, and integrations.

{% hint style="info" %}
Decide your registration-number policy explicitly: keep the legacy number as the canonical number, or store it alongside a newly issued OpenCRVS number. This affects certificates, search and every integrated system that references the record.
{% endhint %}

***

### 7. Administrative structure and historical locations

Migrated records may reference several different location concepts: place of event, place of registration, current office, historical office, and source office. These may not be the same, especially where administrative boundaries, facility names, or office responsibilities have changed. Each location used by a migrated record must resolve to an entry in the OpenCRVS [administrative hierarchy](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure), not remain as free text.

* **Map legacy place names to configured locations.** Build a lookup from legacy place names to OpenCRVS administrative areas and facilities. Historical-to-current location mapping decisions should be documented for traceability. Spelling variants, renamed areas and merged districts all need resolving during transformation.&#x20;
* **Locations are archived, never deleted.** A location that is no longer in use can be archived but is retained, precisely so that the historical name on an older record is preserved. This protects the integrity of migrated records that reference places no longer used for new events.

{% hint style="danger" %}
**Roadmap limitation — historical administrative structures.** Full versioning of the administrative structure over time (so that a record can reference an area exactly as it existed at the historical event date) is a planned capability and is **not yet available**. Until it lands, legacy records that reference abolished or restructured areas must be mapped to the nearest appropriate current or archived location, and that mapping decision should be documented.
{% endhint %}

***

### 8. Data quality, validation and reconciliation

Migration is as much a data-cleaning exercise as a technical one. The go-live checklist requires migrated data to be validated and cleaned, and the migration itself to be tested and verified.

* **Validate before load.** Pre-load validation should check completeness, formats, date plausibility, duplicate risk, identifier uniqueness, valid target status, required legal fields, attachment availability, and referential integrity for event types and locations before submitting.
* **Clean at source where possible.** Correct systematic legacy errors in transformation rather than carrying them into OpenCRVS. Note: Migration should not rewrite legally meaningful historical facts without an approved correction policy.
* **Handle errors explicitly.** Records that fail validation should be quarantined and reported with an appropriate reason code, not silently dropped.
* **Make loads idempotent.** Use stable transaction identifiers so interrupted or repeated migration runs do not create duplicates.
* **Reconcile after load.** Reconciliation should include counts by event type, year, location, and source; key field comparison between the legacy source and OpenCRVS; search by legacy registration number; sample certificate rendering; duplicate-detection checks; reporting/statistics checks; and sign-off of accepted exceptions.

***

### 9. Deduplication

OpenCRVS detects potential duplicate records. Migration interacts with this in two ways:

* **Within the migration** — the same person may appear more than once in legacy data; de-duplicate during transformation.
* **Between migrated and live records** — once migrated records are in the system, new declarations can be checked against them, and vice versa. Consider the order and timing of migration relative to go-live so that duplicate detection behaves as intended rather than flagging large volumes of expected matches.

In phased or low-connectivity rollouts, late paper returns, or continued spreadsheet use can create duplicates after go-live. The cutover plan should explain how these cases are detected and resolved.

***

### 10. Audit and provenance

Every record created through the APIs is journaled. For migration this means each record carries evidence that it was created by a **migration/system client** and when. This distinguishes a migrated historical record from one registered live in OpenCRVS.

Migration audit should be separate from original civil registration source history. OpenCRVS should record that the record was migrated, but the migrated data should also preserve original source details where available: original registration date, registrar or office, source register/system, book/page/folio, amendment notes, and source record ID.

Migrated historical records must follow the same configured access, search, correction, certificate, and privacy rules as other records, unless the country defines stricter controls for sensitive historical data.

***

### 11. Planning and phasing

Treat migration as a controlled, repeatable process, not a single bulk dump.&#x20;

A migration plan should normally include these gates:

1. Source assessment approved.
2. Migration scope approved.
3. Field, identifier, and location mapping signed off.
4. Test migration completed in a non-production environment.
5. Reconciliation and exception report signed off.
6. Cutover rehearsal completed.
7. Final load or delta load completed.
8. Post-load verification completed.
9. Controlled legacy access plan confirmed.



* **Pilot first.** Migrate a small, representative subset, validate and reconcile it, and confirm records render, search and certify correctly before scaling.
* **Batch the full load.** Run the migration in controlled batches with validation and reconciliation at each step.
* **Test against a non-production environment.** Verify the full pipeline — extract, transform, load, reconcile — before touching production.
* **Sequence around go-live.** Decide whether migration completes before go-live, runs alongside an initial small launch, or continues in phases, and how that interacts with deduplication and live registration. The cutover plan should define data freeze timing, final delta migration, rollback or contingency arrangements, staff instructions for using legacy systems, and how late-arriving records are handled after go-live.
* **Account for volume.** Countries often hold very large historical volumes; performance, scheduling and infrastructure load are part of the plan.

***

### 12. What's supported today, and what's on the roadmap

* **Supported today.** Migrating existing digital records and capturing paper-derived records through the Core APIs, either directly via a system client or via a custom capture application. Countries still need project-specific extraction, transformation, validation and reconciliation tools, and signed business rules for mapping and target status.
* **On the roadmap (not yet available).** A **native in-product legacy-digitisation workflow** — configurable roles to digitise, approve and reject digitised legacy records as a distinct in-app capability — is a planned feature and is not yet built. Likewise, **versioning of the administrative structure over time** (see Section 7) and additional record states such as a dedicated inactive/void status (today expressed using flags) are planned. Design your migration around what exists today, and treat these as future enhancements rather than assumptions.

***

### 13. Summary

* Data migration brings existing legacy event records into OpenCRVS through its Core APIs, where they become native records subject to the same statuses, actions and access control.
* Migration begins with source assessment and legal/business decisions, not API loading.
* The most important business decision is the target status: `Registered`, `Declared`, `Notified`, quarantine, or controlled legacy access.
* A digital source is not automatically a legal registration source.
* Legacy identifiers, original registration source history, and historical location mapping should be preserved where available.
* Migration readiness requires validation, reconciliation, exception reporting, test migration, and cutover planning.
* A native in-product legacy-digitisation workflow and historical administrative-structure versioning are **planned** capabilities; today, migration is delivered through the APIs.

***

#### Related pages

* [Legacy data](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data) — the legacy-data module, covering digital import and paper digitisation.
* [Record lifecycle and workflows](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows) — the statuses and actions a migrated record is subject to.
* [Administrative structure](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure) — the hierarchy and locations migrated records must reference.
* [APIs](https://documentation.opencrvs.org/v2.0/functional/markdown/interoperability/apis) — the Core APIs (Events, Search, Locations, Integrations, Attachments) used to load records.
* [Go-live](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/go-live) — where migration sits in the readiness checklist.
