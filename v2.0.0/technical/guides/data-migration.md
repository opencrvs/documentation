# Legacy data migration

{% hint style="info" %}
This guide is about importing historical records from legacy sources into OpenCRVS. It is not the same as OpenCRVS version-upgrade database migrations. For version upgrades, see [Version upgrades](https://documentation.opencrvs.org/v2.0/technical/guides/version-upgrades).
{% endhint %}

### 1. Introduction

Legacy data migration is the technical process of transforming records from an approved legacy source and loading them into OpenCRVS through the Core APIs.

This guide assumes the country has already completed the project decisions described in [Migrate legacy data](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/migrate-legacy-data), including source scope, target status, identifier policy, location mapping, exception handling and reconciliation requirements.

***

### 2. Before you begin

You should have:

* an approved migration scope and source assessment
* signed field, identifier, status, attachment and location mapping
* a non-production OpenCRVS environment with the same event configuration as production
* a migration system client with the required permissions
* access to the source data and any supporting files
* agreed validation, exception and reconciliation outputs

***

### 3. Required migration inputs

| Input                    | Purpose                                                                                   |
| ------------------------ | ----------------------------------------------------------------------------------------- |
| Source extract           | The legacy records to be migrated.                                                        |
| Field mapping            | Maps each source field to the configured OpenCRVS event model.                            |
| Identifier mapping       | Defines how legacy registration numbers, source IDs and other identifiers are stored.     |
| Location mapping         | Resolves source places, offices and facilities to configured OpenCRVS locations.          |
| Status mapping           | Defines whether records are loaded as `Registered`, `Declared` or `Notified`.             |
| Attachment mapping       | Links scanned documents or source images to the correct record.                           |
| Exception rules          | Defines which records are loaded, quarantined or excluded.                                |
| Reconciliation plan      | Defines the reports used to confirm the load.                                             |
| Approved business rules  | Defines approved rules for target status, corrections, exclusions and exception handling. |



***

### 4. Migration sequence

A direct API migration usually follows this sequence:

1. Extract source records and supporting files.
2. Profile the extract for completeness, duplicates, formats, identifiers, locations and attachments.
3. Transform records into the configured OpenCRVS event model.
4. Resolve identifiers, locations and attachment references.
5. Validate each transformed record before loading.
6. Authenticate the migration client.
7. Load records through the Core APIs in controlled batches.
8. Store the result for each source record.
9. Reconcile OpenCRVS records against the source.
10. Produce exception and reconciliation reports.

***

### 5. Authentication

Migration clients should authenticate as a system client. See Authenticate a client for the client credentials flow.

The migration client should use only the permissions required for the migration route, such as creating records, submitting the required action and uploading attachments.

***

### 6. Mapping records

Each source record should be transformed into the configured OpenCRVS event model for the relevant event type.

The migration mapping should cover:

* event type
* target status and action route
* required and optional form fields
* legacy registration number and source record ID
* national ID, UIN or other person identifiers
* place of event, place of registration and source office
* original registration date, registrar and source register details
* attachments or source images
* unmapped fields and exclusion decisions
* canonical registration number policy
* original registration date, registrar, office, source register/system, book/page/folio and amendment notes

Do not create new OpenCRVS fields only to store unmapped legacy data unless that field has been approved as part of configuration.

***

### 7. Validation before load

Pre-load validation should check:

* required fields
* date formats and date plausibility
* valid event type and target status
* identifier uniqueness
* duplicate risk
* location and facility references
* attachment availability
* source record ID uniqueness
* values required for certificates, search, reports and integrations
* approved transformation rule for any systematic correction

Records that fail validation should be written to an exception file with a reason code. They should not be silently dropped.

***

### 8. Batching and idempotency

Run migration in controlled batches. Each source record should have a stable migration transaction ID or idempotency key so that interrupted or repeated runs do not create duplicate records.

For each batch, store:

* batch ID
* source record ID
* migration transaction ID
* OpenCRVS record ID or tracking ID
* load result
* error message, where applicable
* timestamp

***

### 9. Attachments and source images

Where legacy records include scanned documents or paper source images, upload them through the Attachments API and link them to the migrated record.

Before loading attachments, confirm file availability, format, size, storage impact and access control. Sensitive historical documents should not be attached unless the country has approved who may view them.

***

### 10. Reconciliation outputs

After loading, produce reconciliation reports that compare the source extract with records created in OpenCRVS.

Reports should include:

* counts by event type, year, location and source
* successful loads
* failed records
* quarantined records
* duplicate warnings
* identifier mismatches
* missing attachments
* sample searches by legacy registration number
* sample certificate rendering checks

***

### 11. Production run

Run a full test migration in a non-production environment before production. Production loading should only proceed after the test load, reconciliation report and exception handling approach have been signed off.

For low-connectivity settings, plan batch size, upload windows, support coverage and recovery steps in case a batch is interrupted.

***

### Related pages

* [Data migration](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data/data-migration) — functional capability and architecture principles.
* [Digitise paper records](https://documentation.opencrvs.org/v2.0/functional/markdown/legacy-data/digitise-paper-records) — functional capability for paper-derived sources.
* [Migrate legacy data](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/migrate-legacy-data) — project planning, ownership, readiness and sign-off.
* [APIs](https://documentation.opencrvs.org/v2.0/functional/markdown/interoperability/apis) — overview of Core APIs.
* [Authenticate a client](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/integrations/authenticate-a-client) — system client authentication.
* [Events](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/events) — event configuration.
* [Locations](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/administrative-hierarchy/locations) — configured locations and facilities.

