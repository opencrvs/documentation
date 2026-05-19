# Certificates

### 1. Introduction

In OpenCRVS, **certificates and certified copies** are printable documents generated from registered event records. They are produced from configured templates and populated automatically with data from the record.

OpenCRVS can generate pdf:

* **Certificates / full copies** — documents containing all key registration data for an event.
* **Certified copies** — copies of a certificate or registration entry that carry the same legal value.
* **Extracts** — shorter summaries containing only a subset of data (for example, name, date of birth, place of birth).

Certificates and certified copies:

* Are always generated **from registered records** (status: Registered).
* Can include any record data (eg. childs name) and record metadata (eg. date of registration)
* Can include the record’s **registration number** and other UINs as key identifiers.
* Can be controlled by **business rules** (for example, only certain roles can print, or only within certain timeframes).

By configuring certificate templates, print actions, and related business rules, countries can issue legally compliant certificates, certified copies, and extracts directly from OpenCRVS.

***

### 2. Feature overview

Certificates and certified copies provide a **standard, printable representation** of a registered record that can be issued, reissued, and verified consistently.

#### Core capabilities

With certificates and certified copies, OpenCRVS supports:

* Generation of **legally compliant documents** directly from registered records.
* Multiple **template types** per event (for example, full certificate, certified copy, extract).
* **Automated population** of templates from record data and metadata (including UINs and registration details).
* Configurable **business rules** that govern when, how often, and by whom documents can be issued.
* Support for **multi-page layouts**, security features, and digital signatures.
* Full **auditability** of print events via the Print action and journaled data model.

Certificates and certified copies are:

* **Data-driven** — they always reflect the underlying registered record.
* **Template-based** — layout and content are defined via configurable SVG templates.
* **Workflow-aware** — issuing is an action that can be controlled by scopes, flags, and status.

***

### 3. Certificate templates

A **certificate template** defines the design and content of a printable document.

#### 3.1 Types of templates

Examples include:

* **Full certificate** — full set of registration data, typically used for first issuance.
* **Certified copy** — copy of the registration entry, used for reissuance.
* **Extract** — simplified version containing a subset of fields.

Countries can configure multiple templates per event type (for example, separate birth, death, and marriage certificates).

#### 3.2 Template properties

Each template typically includes:

* **Design**
  * Page size and orientation (for example, A4, A5).
  * Layout, fonts, colours, and images.
  * Placement of data fields (for example, name, date of event, registration number).
* **Business rules**
  * When the template can be issued (for example, only after registration).
  * Whether it can be issued once or multiple times.
  * Whether it must be issued before other template types (for example, first issuance before extracts).
* **Fees (optional)**
  * Fee schedules based on timing or type (for example, within legal time, delayed, late).

Templates are implemented as SVG designs populated with record data and exported as PDFs.

\<aside> 📌

See certificate design guidelines

\</aside>

***

### 4. Printing and issuing certificates

Certificates and certified copies are generated via the **Print** action.

#### 4.1 Print action

The Print action typically includes a form that allows the user to:

* Select which **template** to use (for example, full certificate, extract, certified copy).
* Capture **requester details** and verify their identity.
* Record **fees** collected and generate a receipt if required.

#### 4.2 Preview and export

Before finalising, OpenCRVS can:

* Display a **preview** of the generated certificate or extract.
* Allow the user to confirm that all details are correct.
* Export the final document as a **PDF** ready for printing.

This ensures that printed documents match the registered data and adhere to the configured template design.

***

### 5. Worked example

Example certificate (business view)

\
<br>

***
