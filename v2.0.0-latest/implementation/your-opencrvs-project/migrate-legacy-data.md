# Migrate legacy data

### 1. Introduction

Migrating legacy data is the project activity of preparing historical civil registration records for use in OpenCRVS. It includes deciding which sources are in scope, what legal status they have, how fields and identifiers will map, how exceptions will be handled, and how the migration will be tested and signed off.

For the functional capability, see [Data migration](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data/data-migration). For technical implementation guidance, see [Legacy data migration](https://documentation.opencrvs.org/v2.0/technical/guides/data-migration).

***

### 2. Source assessment

For each legacy source, document:

| Area                  | Questions to answer                                                                                     |
| --------------------- | ------------------------------------------------------------------------------------------------------- |
| Source owner          | Who owns the data and can approve migration decisions?                                                  |
| Legal status          | Is this a legal civil register, notification source, index, statistics dataset, or supporting evidence? |
| Event coverage        | Which event types are included?                                                                         |
| Date range and volume | What period and how many records are covered?                                                           |
| Field coverage        | Which mandatory OpenCRVS fields are present or missing?                                                 |
| Identifiers           | What registration numbers, book/page references, PINs/UINs, National IDs, or legacy IDs exist?          |
| Locations             | Can places of event and registration be mapped to configured locations?                                 |
| Attachments           | Are scanned documents or evidence files available?                                                      |
| Amendments            | Are corrections, name changes, adoptions, or other amendments represented?                              |
| Data quality          | What duplicate, missing, inconsistent, or implausible data is known?                                    |
| Access constraints    | Are there technical, legal, privacy, or vendor constraints on extraction?                               |
| Migration decision    | Migrate, migrate for review, quarantine, retain legacy access, or exclude?                              |

***

### 3. Target status decision

The registration authority should approve the target status for each source before migration is built or tested.

| Legacy source or record type                                          | Usual treatment                                                                                                                                                          |
| --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Legally completed civil registration record                           | Import as `Registered`, if the source is confirmed as legally authoritative.                                                                                             |
| Incomplete record requiring staff review                              | Import as `Declared` or `Notified`, depending on completeness and workflow design.                                                                                       |
| Health notification, hospital spreadsheet, or local notification list | Use for reconciliation, duplicate checking, or import as `Notified` only if approved. Do not import as `Registered` unless legally accepted as a completed registration. |
| Uncertain, conflicting, or low-quality record                         | Quarantine, report as an exception, or retain in controlled legacy access until resolved.                                                                                |
| Source outside migration scope                                        | Do not migrate; document the reason and how staff can access it if needed.                                                                                               |

Target status may vary by source, event type, date range, location, or data-quality band. This is a business decision, not a technical one.

***

### 4. Mapping sign-off

Before technical migration starts, sign off:

* field-by-field mapping to the configured OpenCRVS event model
* mandatory-field handling
* registration number policy
* legacy ID and source record ID handling
* national ID or UIN handling
* historical-to-current location mapping
* attachment and source image handling
* amendment and correction handling
* unmapped fields and exclusion decisions

***

### 5. Data quality and exceptions

Agree which systematic errors may be corrected during transformation and which records require review. Migration should not rewrite legally meaningful historical facts without an approved correction policy.

Records that fail validation should have an owner, reason code, decision path and exception report. They should not be silently dropped.

***

### 6. Planning gates

A migration plan should normally include:

1. Source assessment approved.
2. Migration scope approved.
3. Field, identifier and location mapping signed off.
4. Test migration completed in a non-production environment.
5. Reconciliation and exception report signed off.
6. Cutover rehearsal completed.
7. Final load or delta load completed.
8. Post-load verification completed.
9. Controlled legacy access plan confirmed.

***

### 7. Pilot and cutover

The pilot sample should include clean records, messy records, duplicates, missing fields, old or renamed locations, records with amendments, records with attachments, and records used to print certificates.

The cutover plan should define data freeze timing, final delta migration, rollback or contingency arrangements, staff instructions for using legacy systems, and how late-arriving records are handled after go-live.

For low-connectivity settings, account for batch size, upload windows, support availability, service continuity, and whether records may be captured offline before synchronisation.
