# Vital statistics export

### 1. Introduction

OpenCRVS supports the export of **vital statistics data** by configuring **tabular dashboards in Metabase**. Each export dashboard is a **table of records** that:

* Is built from OpenCRVS registration data (for example, births, deaths, marriages).
* Includes only **non‑PII analytics fields** (fields with `analytics = true`).
* Can be **filtered** and **exported** (for example, as CSV) by authorised users.

This model is similar to performance dashboards, but focused on **structured tables for export**, rather than charts. It enables National Statistical Offices and other stakeholders to obtain data extracts that are ready for analysis in external tools, while protecting privacy.

***

### 2. Feature overview

Vital statistics export provides **structured, analytics-ready tables** that authorised users can filter and download for further analysis outside OpenCRVS.

#### Core capabilities

With vital statistics export, OpenCRVS supports:

* **Regular provision of vital statistics datasets** to national statistics offices and other stakeholders.
* **Configurable tabular views** per event type, built from non-PII analytics fields only.
* **Flexible filtering** by time period, location, event type, and other dimensions before export.
* **Standards-friendly outputs** (for example, CSV) that can be loaded into statistical tools and data warehouses.
* Consistent alignment with the **analytics flag** so that only approved fields are exposed.

Vital statistics exports are:

* **De-identified by design** — based on analytics-safe fields, not raw personal data.
* **Table-first** — focused on rows and columns rather than charts.
* **Extensible** — countries can add new export tables as indicator needs evolve.

***

### 3. Vital statistics exports confgiuration overview

Vital statistics exports are configured as **tabular dashboards in Metabase** that present rows and columns of data ready for download. They draw on the same underlying OpenCRVS data as performance dashboards.

* Only fields from forms marked with `analytics = true` are included in exportable datasets.
* Personally identifiable information (PII) such as names, exact addresses, and contact details must **not** be marked as analytics and therefore never appear in exports.
* Data is typically **aggregated or de‑identified** at the row level (for example, including age, sex, district, and dates, but not names or IDs).

Each export dashboard typically defines:

* **Rows** — the unit of analysis (for example, one row per registered birth, one row per registered death).
* **Columns** — which analytics fields are included (for example, year of event, district, sex, age group, place of occurrence).
* **Filters** — parameters that users can adjust before export (for example, year, event type, district).

Examples of fields commonly included:

* Event type, date of event, date of registration.
* Sex, age groups, place of occurrence (for example, facility vs home).
* Registration location (district / province).
* Flags such as late registration or correction requested (where appropriate for statistics).

***

### 4. Use cases

Vital statistics export dashboards support common CRVS and statistics use cases, such as:

* Preparing **annual vital statistics reports** (for example, births and deaths by age, sex, and district).
* Supplying data to the **National Statistics Office** or Ministry of Health for integration into broader statistical systems.
* Supporting **research and planning**, such as analysing mortality patterns or fertility trends over time.

By configuring export dashboards carefully—selecting only analytics‑safe fields and appropriate filters—countries can maximise the value of their OpenCRVS data while maintaining strong privacy protections.
