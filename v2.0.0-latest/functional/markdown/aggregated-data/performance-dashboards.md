# Performance dashboards

### 1. Introduction

In OpenCRVS, **performance dashboards** surface near real-time performance and vital statistics data using configurable dashboards powered by **Metabase**.

They are used by operational managers, programme leads, and policy makers to monitor workload, coverage, timeliness, completeness, and data quality across locations and over time. Dashboards draw on aggregated, de-identified data rather than individual records, helping to answer questions such as how many events were registered, how quickly, and where there are gaps in coverage.

***

### 2. Feature overview

Performance dashboards provide a **near real-time view** of how the CRVS system is performing, using aggregated, de-identified data.

#### Core capabilities

With performance dashboards, OpenCRVS supports:

* **Configurable metrics and visualisations** built on analytics-ready datasets from OpenCRVS.
* **Policy and planning insights** based on trends in births, deaths, and other events.
* **Role- aware views** so users see dashboards relevant to their responsibilities and jurisdiction.
* **Operational monitoring** of workload, bottlenecks, and data quality by office, role, and event type.
* **Programme oversight** for coverage, timeliness, and completeness of registration across locations and time periods.

Performance dashboards are:

* **Aggregated and de-identified** — driven by analytics fields only, not raw personal data.
* **Metabase-powered** — implemented as Metabase dashboards connected to OpenCRVS data sources.
* **Extensible** — countries can add new charts, filters, and dashboards as their CRVS monitoring needs evolve.

***

### 3. Data sources and metrics

Performance dashboards rely on structured data from OpenCRVS, including **only fields that have been explicitly marked as suitable for analytics** (that is, form fields with the `analytics = true` property). This ensures that personally identifiable information (PII) is excluded from dashboard datasets.

They draw on:

* **Event registrations** — births, deaths, marriages, and other event types.
* **Key timestamps** — date of event, date of declaration, date of registration.
* **Locations** — where events occurred, where they were declared, where they were registered.
* **Statuses and flags** — Draft, Notified, Declared, Registered, Archived; late registrations; correction requested.
* **User and office information** — which office and which role performed key actions.

From these data, common **metrics** include:

* **Volume** — number of registrations by event type, time period, and location.
* **Timeliness** — time from event to registration (for example, within 30 days, 31–365 days, > 1 year).
* **Completeness / coverage (proxy)** — registrations per 1,000 population or compared against targets (where reference data is available).
* **Data quality** — share of records rejected, corrected, or with missing key fields.
* **Process efficiency** — time spent in each status (Declared, Validated, Registered), number of rejections or escalations.

Countries can decide which metrics to prioritise based on their CRVS strategy and available reference data.

***

### 4. Configuration overview

Performance dashboards in OpenCRVS are delivered using **Metabase**, an open-source business intelligence and analytics platform. Dashboards are created and managed in Metabase and then securely embedded within the OpenCRVS application.

From a user perspective, dashboards appear as part of the OpenCRVS interface. From a configuration perspective, they are defined and maintained separately in Metabase.

#### How dashboards are integrated

Dashboards are:

* **Embedded in the OpenCRVS UI** via links in the side navigation.
* **Access-controlled by scope and role**, ensuring users only see dashboards and data relevant to their jurisdiction (for example national, provincial, or district level).

#### What is configured in Metabase

Configuration primarily happens inside Metabase and includes the following components.

**Dashboards**

Collections of charts that answer specific operational or policy questions (for example registration volumes, timeliness, or completeness).

Each dashboard typically aligns to a use case such as:

* Completness rates
* Registrations
* Operations monitoring
* Data quality

**Datasets / models**

Analytics-ready tables or models that structure OpenCRVS data for reporting.

These commonly include:

* Event “fact” tables (registrations, actions, timestamps)
* Dimensions (event type, date, location hierarchy, office, role, status)
* Pre-calculated indicators (for example timeliness buckets or monthly aggregates)

Using curated models improves consistency, performance, and reuse across multiple dashboards.

**Metrics (data visualisation)**

Charts and tables that present metrics in an interpretable way, such as:

* Time series trends
* Bar or stacked charts by location or event type
* KPIs and summary cards
* Tables for operational detail

Metrics are built on top of datasets and reused across dashboards where needed.

**Filters**

Interactive controls that allow users to narrow the data displayed, for example:

* Date of event
* Event type
* Event location
* Registration location

Filters can apply to individual charts or entire dashboards to support flexible exploration.

**Access control**

Role-based permissions determine:

* Which dashboards a user can open
* What event data they can view based on their jurisidciton ?!?!!?! (think there is a complex solution)

This ensures that sensitive operational insights are visible only to authorised users while supporting decentralised monitoring.

#### Extending and maintaining dashboards

Dashboards are designed to evolve as country needs change. Teams can:

* Add new charts or metrics
* Create additional dashboards for new programmes
* Refine models as data structures mature
* Introduce new analytics fields as forms are updated (with `analytics = true`)

Because dashboards are configuration-driven rather than hard-coded, updates can be made without changes to the core OpenCRVS application.

< Example dashbaords >

***

### 5. Use and interpretation

Performance dashboards should be interpreted in context:

* **\~\~Data lags** — some indicators may be based on partial data if registrations are still being processed.\~\~
* **Population denominators** — coverage estimates depend on the quality of population estimates or target numbers.
* **\~\~Operational factors** — spikes in workload or outages can affect short-term trends.\~\~

Dashboards are most powerful when used as part of a regular **review and action cycle**, for example:

* Monthly or quarterly performance review meetings.
* Joint analysis sessions between CRVS, health, and statistics stakeholders.
* Targeted support or supervision for offices with persistent performance or data quality issues.

OpenCRVS provides the underlying data and integration to support these dashboards; each country decides which indicators to track, how often to review them, and what actions to take based on the insights.
