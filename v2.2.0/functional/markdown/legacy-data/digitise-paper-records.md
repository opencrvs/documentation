# Digitise paper records

### 1. Introduction

**Digitisation of paper records** is the process of capturing historical civil registration events that exist only on **paper** — bound registers, register books, certificate counterfoils or loose register sheets held in district offices and archives — and turning them into structured digital records in OpenCRVS.

Like [Data migration](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data/data-migration), digitisation deals with historical civil registration sources. In many cases these are completed legal registrations, such as entries in official register books. However, the registration authority should confirm the legal status of each paper source before capture. A register book, certificate counterfoil, loose sheet, index, or archive file may have different evidential value and may require different handling.

Where the paper source is confirmed to represent a completed legal registration, the digitised record can arrive in OpenCRVS as a `Registered` record. Where the source is incomplete, uncertain, or not legally authoritative, it should be held back, reviewed, or treated as supporting evidence rather than imported as a registered record.

A digitised record is not a static scan. Once captured it can be **searched**, used to **print a certified copy**, **corrected**, shared with integrated systems, and counted in reporting, exactly like a record created during day-to-day registration.

> **Where this sits.** Digitisation is part of the legacy-data milestone in the [Go-live](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/go-live) readiness checklist: historical paper records digitised and uploaded (if required), the data validated and cleaned, and the process tested and verified before go-live. Digitisation is often a long-running programme that continues in parallel with live registration, rather than something completed in a single window.

***

### 2. Feature overview

Digitisation lets a country convert paper registers into OpenCRVS records by capturing each one through a data-entry tool that maps to the configured event model, attaches the source image, and submits the record through the Core APIs as a registered record.

#### Core capabilities

* **Capture paper records against the OpenCRVS event model** — operators enter each paper record into forms that map to the same configured fields (birth, death, marriage, and so on) used for live registration.
* **Attach the source image** — a scan or photograph of the original register page is captured and stored with the record, preserving the documentary evidence.
* **Land confirmed legal registrations as Registered** — where the paper entry is confirmed to be an existing legal registration, it is captured as a `Registered` record. Revoked or inactive registrations are represented according to the current OpenCRVS status and flag model (see Section 3).
* **Preserve legacy identifiers** — the original registration number and the book/volume/page reference are carried onto the record.
* **Maintain a complete audit trail** — every record captures who digitised it and when, while preserving source details such as register book, volume, page, entry number, and source image.
* **Support high-throughput, batch capture** — many records from a single book or time period can be captured efficiently, in controlled batches with verification.

Digitisation is:

* **Capture-driven** — the bottleneck and the quality risk are in human data entry, not in a database transform.
* **Configuration-aligned** — capture targets the country's own configured events, forms and locations.
* **Auditable** — the operator and timing of every digitised record is journaled.

***

### 3. Record states in scope

Where paper entries are confirmed to be completed legal registrations, digitised records arrive as `Registered`. Three registration states are in scope:

* **Registered** — an active, valid registration. It can be searched, certified and corrected like any registered record.
* **Revoked** — a registration that was subsequently revoked or cancelled (for example, annotated as void in the register).
* **Registered (inactive)** — a registration that has been deactivated or superseded but is retained for the historical record.

> **How the three states are represented today.** OpenCRVS currently has a single **Registered** status; **Revoked** and **Registered (inactive)** are planned future statuses. Until they exist, both can be represented as **flags** on a Registered record.

***

### 4. How digitisation works

Paper records are captured through a data-entry tool and submitted to the OpenCRVS **Core APIs** — principally the Events API, where accepted records become native OpenCRVS records. The common delivery pattern is a purpose-built capture application.

#### 4.1 A dedicated digitisation application

A country contracts a digitisation team and equips them with a **custom side application** built against the OpenCRVS APIs and designed for one task: high-throughput capture of paper records. Such an app typically:

* Lets operators **scan or photograph** pages from old paper registers.
* Provides **data-entry forms that map to the OpenCRVS event model**, including mandatory and optional fields.
* **Validates data locally** and then submits records into the eRegistry as **Registered** records.
* **Records who digitised each record and when**, so audit trails remain complete.
* **Supports batch processing**, so many records from a single book or period can be captured efficiently.

The digitisation app does not replace the core OpenCRVS interface; it complements it, providing a specialised tool that feeds the same eRegistry used for routine registration.

#### 4.2 Capture and review

Some programmes separate capture from approval — an operator captures the record and a supervisor checks it before it is committed. Today that check happens **within the capture application**, before the record is submitted to OpenCRVS as a Registered record. A dedicated in-product workflow to digitise, approve and reject digitised records is on the roadmap (see Section 13).

> **Note.** Whichever tool is used, records are written through the same Core APIs, so the resulting records are ordinary registered OpenCRVS records. The choice of tool is about **how paper is captured and checked**, not about what the records become.

***

### 5. Capturing the record

Every field on the paper record must be captured into a field in the configured OpenCRVS form, or deliberately omitted. Plan for:

#### 5.1 Data entry

Operators key the paper record into forms mapped to the configured event. Field-level mapping from the layout of each register type to the OpenCRVS form should be defined and documented before capture begins, because historical register formats vary across eras.

#### 5.2 Document and image capture

A scan or photograph of the original register page is attached to the record as supporting evidence. This preserves the documentary source behind the digital record and supports later verification and dispute resolution.

#### 5.3 Mandatory fields

OpenCRVS forms have required fields, and old paper records frequently omit some of them or record them illegibly. Where a digitised record will be imported as `Registered`, gaps must be resolved before capture is committed: sourced from another register, cross-checked against a certificate counterfoil, reviewed by a supervisor, or handled under an approved exception rule. A paper entry that cannot be completed to a valid registration should be held back rather than registered with missing mandatory data.

#### 5.4 Reference data

Values such as place of event and place of registration must resolve to **configured locations and facilities**, not free text (see Section 7).

***

### 6. Identifiers

Digitised records must remain traceable to their paper source. Identifier policy affects certificates, search, corrections, reporting, and downstream systems. Decide whether the original paper registration number remains the canonical registration number in OpenCRVS, or whether it is stored alongside a newly issued OpenCRVS number.

* **Original registration number** — preserve the registration number written on the paper record so historical certificates and citizen references continue to resolve. OpenCRVS holds the registration number on the registered record.
* **Book / volume / page references** — capture the physical location of the source entry (register book, volume, page, entry number) so each digital record can be traced back to, and reconciled against, the original.
* **National ID and other person identifiers** — where present on the paper record, map them onto the corresponding person field so future search and linkage work correctly.

> Identifier decisions should be signed off before test digitisation. Changing number policy after records have been captured can affect certificates, search, duplicate detection, integrations, and reconciliation reports.

***

### 7. Administrative structure and historical locations

Digitised records reference places — place of event, place of registration — and these must resolve to entries in the OpenCRVS [administrative hierarchy](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure), not free text. Digitised records may reference several different location concepts: place of event, place of registration, current office, historical office, and source office. These may not be the same, especially where administrative boundaries, facility names, or office responsibilities have changed. Each location used by a digitised record must resolve to an entry in the OpenCRVS administrative hierarchy, not remain as free text.

* **Map paper place names to configured locations.** Build a lookup from the place names written in the registers to OpenCRVS administrative areas and facilities. Historical-to-current location mapping decisions should be documented. Spelling variants, historical names, renamed areas and merged districts all need resolving during capture.
* **Locations are archived, never deleted.** A location no longer in use can be archived but is retained, precisely so the historical name on an older record is preserved. Archived locations should be governed so they remain available for digitised and historical records, but are not accidentally used for new registrations.

> **Roadmap limitation — historical administrative structures.** Full versioning of the administrative structure over time (so a record can reference an area exactly as it existed at the historical event date) is a planned capability and is **not yet available**. Until it lands, paper records that reference abolished or restructured areas must be mapped to the nearest appropriate current or archived location, and that mapping decision should be documented.

***

### 8. Data quality, verification and reconciliation

Digitisation is as much a quality exercise as a capture one — the quality risk sits in human transcription. The go-live checklist requires digitised data to be validated and cleaned, and the process tested and verified.

* **Verify entry.** Use quality-control techniques such as double-entry (two operators independently key the same record) or supervised sampling to catch transcription errors before records are committed as registrations.
* **Sample against the source.** Periodically compare digitised records against the original register pages to measure accuracy and catch systematic errors.
* **Handle illegibility explicitly.** Define a convention for unreadable or ambiguous entries — resolve against another source or hold the record back — rather than letting operators guess.
* **Reconcile by book and batch.** Track which books, volumes and date ranges have been captured, and reconcile counts so no register or page is missed or double-captured.

***

### 9. Deduplication

OpenCRVS detects potential duplicate records. Digitisation interacts with this in the following ways:

* **Within the programme** — the same event may be captured twice, for example from a register and from a certificate counterfoil; guard against double capture through book/page tracking and reconciliation.
* **Across paper and digital sources** — the same event may exist in both a paper register and a legacy digital system. Digitisation and data migration plans should be sequenced so the same historical record is not loaded twice.
* **Between digitised and live records** — once digitised records are in the system, new declarations can be checked against them, and vice versa. Consider the order and timing of digitisation relative to go-live so duplicate detection behaves as intended.

***

### 10. Audit and provenance

Every record created through the APIs is journaled. For digitisation this means each record captures who digitised it and when, alongside the attached source image. This distinguishes a digitised historical record from one registered live in OpenCRVS.

Digitisation audit should be separate from original civil registration source history. OpenCRVS should record that the record was digitised, but the captured data should also preserve original source details where available: original registration date, registrar or office, source register, book/page/folio, amendment notes, source image, and entry number.

Digitised historical records must follow the same configured access, search, correction, certificate, and privacy rules as other records, unless the country defines stricter controls for sensitive historical data.

***

### 11. Planning, throughput and physical handling

Treat digitisation as a controlled, long-running operation rather than a one-off task.

A digitisation plan should normally include these gates:

1. Paper source assessment approved.
2. Digitisation scope approved.
3. Field, identifier, image, and location mapping signed off.
4. Test digitisation completed in a non-production environment.
5. Verification, reconciliation, and exception report signed off.
6. Physical handling and chain-of-custody plan approved.
7. Production capture started in controlled batches.
8. Post-capture verification completed.
9. Controlled legacy archive access plan confirmed.



* **Pilot first.** Digitise a small, representative set of books, verify and reconcile them, and confirm records render, search and certify correctly before scaling.
* **Plan for volume and throughput.** Historical archives can be very large; staffing, operator productivity, equipment (scanners, devices) and infrastructure load all shape the timeline.
* **Manage the physical source.** Plan chain of custody for fragile registers, the handling and storage of originals, and what happens to paper after capture.
* **Run in parallel with live registration.** Digitisation commonly continues after go-live; sequence it so it does not disrupt routine registration and so deduplication behaves predictably. The plan should explain how late-arriving paper records and continued archive access are handled.
* **Test against a non-production environment.** Validate the full pipeline — capture, image attachment, submission, reconciliation — before capturing into production.

***

### 12. What's supported today, and what's on the roadmap

* **Supported today.** Capturing paper records — and migrating existing digital records — by submitting them through the Core APIs from a custom capture application as **Registered** records, with audit, image attachment and search applying as normal.
* **On the roadmap (not yet available).** **Revoked** and **Registered (inactive)** are planned future statuses; until they exist, both are represented as flags on a Registered record (see Sections 3 and 5). A **native in-product digitisation workflow** — configurable roles to **digitise**, **approve** and **reject** digitised legacy records as a distinct in-app capability — and **versioning of the administrative structure over time** (Section 7) are also planned. Design your digitisation programme around what exists today, and treat these as future enhancements rather than assumptions.

***

### 13. Summary

* Digitisation captures paper civil registration sources into OpenCRVS through its Core APIs, where accepted records become native records subject to the same actions and access control as other records.
* Digitisation begins with source assessment and legal/business decisions, not data entry alone.
* Where the source is confirmed to be a completed legal registration, the target status is `Registered`; uncertain or incomplete sources should be held back or reviewed.
* Because the source is paper, the work is human capture: data entry plus source-image attachment. The main operational risk is transcription quality.
* Original registration numbers, book/page references, source images, original registration source history, and historical location mapping should be preserved where available.
* Quality is managed through verification, sampling against the source, reconciliation by book and batch, exception reporting, and sign-off.
* Distinct Revoked and Registered (inactive) statuses, a native in-product digitisation-and-approval workflow, and historical administrative-structure versioning are planned capabilities; today, digitisation is delivered through the APIs and a capture application.

***

### Related pages

* [Legacy data](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data) — the legacy-data module, covering digital migration and paper digitisation.
* [Data migration](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data) — the sibling capability for records that are already digital.
* [Record lifecycle and workflows](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows) — the Registered status and the actions a digitised record is subject to.
* [Administrative structure](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure) — the hierarchy and locations digitised records must reference.
* [APIs](https://documentation.opencrvs.org/v2.0/functional/markdown/interoperability/apis) — the Core APIs (Events, Search, Locations, Integrations, Attachments) used to load records.
* [Go-live](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/go-live) — where digitisation sits in the readiness checklist.
