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

The goal of migration is that a legacy record becomes a **native OpenCRVS record**, subject to the same status model, actions, access control, audit and search behaviour as any other record.

A migrated record must arrive at a valid OpenCRVS status. A legacy record that represents a completed legal registration may be imported as `Registered`. A record that is incomplete, uncertain, or requires staff review may be imported as `Declared` or `Notified`, depending on the configured workflow and approved business rules.

A digital legacy record is not automatically a completed legal registration. The target status is a registration-authority decision and may vary by source, event type, date range, location or data-quality band.

For target-status assessment and sign-off, see [Migrate legacy data](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/migrate-legacy-data).

***

### 4. How migration works

Records are migrated through the OpenCRVS **Core APIs** — principally the Events API, which is the authoritative source of truth for every record. Migration uses the same record model, actions and audit principles as records created through the OpenCRVS applications.

There are two common delivery patterns:

#### **4.1 Direct API migration (system client)**

A migration script or middleware authenticates as a trusted system client and submits records directly to the Events API. This is the usual approach where the source is already structured, such as a legacy database, spreadsheet, or export from another CRVS system.

#### **4.2 Migration via a custom application**

Where records need human capture or review, a custom side application can be built against the same APIs. This may be useful for messy legacy data or paper-derived capture where operators need a dedicated high-throughput workflow.

{% hint style="info" %}
Both patterns write through the same Core APIs, so the resulting records are ordinary OpenCRVS records. The choice between them is about how records are sourced and reviewed, not about what they become.
{% endhint %}

For technical extraction, transformation, validation, loading, idempotency and reconciliation steps, see [Legacy data migration](https://documentation.opencrvs.org/v2.0/technical/guides/data-migration).

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

Migrated records should only become usable in OpenCRVS when they meet the country’s approved quality, legal and business rules for the target status.

OpenCRVS supports importing records through its APIs, but the migration programme is responsible for deciding what level of completeness, consistency, identifier matching and exception handling is acceptable. Records that do not meet approved rules should be reviewed, quarantined, excluded, or retained in controlled legacy access rather than silently loaded.

Migration should not rewrite legally meaningful historical facts unless an approved correction policy exists.

For migration governance, exception ownership and sign-off, see [Migrate legacy data](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/migrate-legacy-data).

For technical validation, batching, idempotency and reconciliation outputs, see [Legacy data migration](https://documentation.opencrvs.org/v2.0/technical/guides/data-migration).

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

### 11. Planning and implementation boundaries

Data migration should be treated as a controlled capability, not as a one-off database dump. OpenCRVS supports migration through its Core APIs, so migration can be delivered in controlled batches or phases according to the country’s approved migration approach.

This Functional Architecture page describes what OpenCRVS supports and the principles that apply to migrated records. The migration plan, readiness gates, cutover approach, exception handling and reconciliation sign-off are project activities.

For project planning and readiness activities, see [Migrate legacy data](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/migrate-legacy-data).

For technical batching, validation, loading and reconciliation guidance, see [Legacy data migration](https://documentation.opencrvs.org/v2.0/technical/guides/data-migration).

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
