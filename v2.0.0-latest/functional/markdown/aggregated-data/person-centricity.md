# Person centricity

### 1. Introduction

In OpenCRVS, **person‑centric views** are a planned feature in the backlog. They are not yet built, but this page describes the current understanding of the concept and requirements.

Today, OpenCRVS functions as a **standard civil registration system** that records the specifics of each civil event (for example, a birth or death) in an electronic registry. Person‑centric views extend this by linking event records at the **person level**, providing a unified view of life events linked to an individual where this is legally permitted and technically possible.

***

### 2. Feature overview (proposed)

Person‑centric views aim to provide a **single, supervised view** of all relevant life events for a person, while respecting existing access control, privacy, and legal constraints.

**Core capabilities (proposed)**

With person‑centric views, OpenCRVS could support:

* **Linking vital event records** (birth, death, marriage, and others) to an individual using available identifiers and safe matching rules.
* **Consolidated person overviews** that show a person’s registration history to authorised staff.
* **Suggested links** based on probabilistic matching, which users can confirm or reject.
* **Safer data reuse** in forms and workflows by reusing verified person‑level information across events.
* **Improved data quality checks** by highlighting gaps and inconsistencies across a person’s events.

These capabilities are subject to further design and country‑level governance decisions. The rest of this page outlines the current, high‑level model and requirements for such a feature.

The goal of person‑centric views is to:

* Link **vital event records** (birth, death, marriage, etc.) to an **individual person** using available identifiers (for example, National ID, Registration number, or another UIN).
* Present a **single, consolidated view** of that person’s life events to authorised civil registration staff.
* Support **safe, supervised linkage** by showing probable matches that a user can **confirm or reject**.

This will help civil registration authorities:

* Understand a person’s **full registration history** (for example, birth → marriage → death).
* Detect potential **gaps or inconsistencies** (for example, death registered without a corresponding birth registration).
* Improve the quality and usefulness of data for planning and interoperability with other systems.

***

### 3. Linking model

Person‑centric views rely on a combination of:

* **Deterministic links via UINs**
  * When a record contains a stable identifier (for example, National ID from MOSIP, or a person‑level UIN), OpenCRVS can link records that share that identifier.
* **Probabilistic matching for suggestions**
  * Where no shared UIN exists, OpenCRVS can propose **probable matches** based on attributes such as name, date of birth, sex, and location.
  * These suggestions are **not applied automatically**; they require human review.

Each person‑centric view will therefore be based on:

* A **person anchor** (for example, a National ID or a synthetic person ID).
* A set of **linked event records** (confirmed links).
* A set of **suggested event records** (pending review by a user).

***

### 4. User experience

#### 3.1 Person overview

From a person‑centric view, an authorised user can see:

* **Person header**
  * Core identifiers (for example, National ID, Registration number, synthetic person ID).
  * Basic attributes (for example, name, date of birth, sex), where permitted.
* **Timeline or list of events**
  * Birth registration.
  * Marriage(s).
  * Death registration.
  * Other configured event types (for example, adoptions, name changes), when available.

This gives civil registration staff a **“life course”** view for that individual.

#### 3.2 Probable matches and confirmation

When OpenCRVS identifies potential links (for example, a death record that might correspond to an existing birth registration), the UI will:

* Show a **“Suggested links”** section listing **probable matches**, with a similarity score or short explanation (for example, same name, same date of birth, same National ID).
* Allow the user to **review each suggestion** side‑by‑side:
  * Suggested event record details.
  * Current set of linked events.
* Provide explicit actions:
  * **Confirm link** — permanently link the event record to this person.
  * **Reject link** — mark that this record should _not_ be linked, so the same suggestion is not shown again.

All confirm / reject decisions will be:

* Controlled by **scopes** and **roles** (for example, only certain roles can confirm cross‑event links).
* Written to the **audit log** so that future reviews can see who linked which records, and when.
*

***

### 5. Configuration and controls

To support person‑centric views safely and flexibly, configuration will cover:

* **Identifiers used for linking**
  * Which UINs and external IDs can be used as person anchors (for example, National ID, synthetic person ID).
* **Matching rules for suggestions**
  * Which fields to compare (for example, full name, date of birth, sex, location).
  * Thresholds for suggesting vs ignoring a potential match.
* **Permissions and scopes**
  * Scopes such as `person.view` and [`](<http://person.link/>)[person.link](<http://person.link>)[`](http://person.link/) to control who can see person‑centric views and who can confirm/reject linkage.
* **Privacy and data protection**
  * Ensuring that visibility of person‑level aggregates and event history follows existing jurisdiction and role rules.
  * Avoiding person‑centric views in contexts where person‑level aggregation is not legally permitted.

***

### 6. Benefits

Once implemented, person‑centric views will:

* Help civil registration staff **see the whole picture** for an individual, not just separate event records.
* Enable **smarter forms and business rules**, for example:
  * Pre‑populating event forms with known information about a person (for example, name, date of birth, sex, previous events) once they are linked.
  * Conditionally enforcing what events can and cannot be declared based on existing life events (for example, preventing a second marriage declaration when an active marriage already exists, or flagging unusual sequences).
* Support **better governance and error detection**, such as:
  * Identifying unlinked deaths for people with known birth registrations.
  * Spotting inconsistent information across events.
* Lay groundwork for **stronger interoperability** with identity, social protection, and health systems by making it easier to align person‑level data while keeping CRVS records authoritative.

This feature is currently in the **backlog** and will require further design of the matching logic, UI patterns for suggested links, and the security model for person‑level views.
