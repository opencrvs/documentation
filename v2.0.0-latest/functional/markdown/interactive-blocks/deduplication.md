---
layout:
  width: default
  title:
    visible: true
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
---

# Deduplication

### 1. Introduction

**Deduplication** is the process by which OpenCRVS detects and manages potential duplicate event records (for example, multiple declarations for the same birth). It is designed to prevent errors and fraud, and to protect the integrity of the civil register.

OpenCRVS uses Elasticsearch-based matching to compare new declarations against existing records. When a potential duplicate is found, a user with the appropriate scope is prompted to review the records side by side and decide whether the new declaration should proceed or be treated as a duplicate.

***

### 2. Feature overview

Deduplication supports a controlled, reviewable process for detecting and resolving potential duplicates.

#### Core capabilities

With Deduplication, OpenCRVS supports:

* Automated matching of new declarations against existing records using configurable rules.
* Per–event-type configuration (for example, separate rules for birth vs death).
* Fuzzy matching on names, dates, and other key fields (for example, using Levenshtein distance for names).
* Business-rule based checks (for example, biological plausibility checks such as two births within 9 months to the same mother).
* Role- and scope-based review of potential duplicates (for example, Registrar review).
* Side by side review experience with matched records
* Clear outcomes for each review: **mark as duplicate** or **mark as not duplicate**.
* Full audit trail of matching results and human decisions.

Deduplication is:

* **Proactive** — aims to catch duplicates before registration.
* **Deterministic** — behaviour is driven by explicit configuration per country and event type.
* **Transparent** — configuration and decisions can be inspected and adjusted over time.
* **Configurable** — matching logic can be tailored per event type (for example birth, death).
* **Early in the workflow** — potential duplicates are flagged at declaration / review, before registration.
* **Auditable** — decisions (duplicate vs not duplicate) are journaled for future review.

***

### 3. Configuring deduplication logic

Deduplication logic is configured **per event type** (for example, birth, death, marriage) using Elasticsearch queries.

#### 3.1 What a deduplication configuration defines

A deduplication configuration typically defines:

* **Fields to match on** — for example:
  * Child’s first name(s)
  * Child’s last name
  * Date of birth
  * Mother’s first name(s)
  * Mother’s last name
  * Mother’s date of birth or age
  * Mother’s national ID
* **Matching rules per field** — for example:
  * **Names (strings):** fuzzy match using edit distance (Levenshtein), with allowed edits depending on name length.
  * **Dates:** exact or within a configured range (for example, ±5 days or ±3 years).
  * **IDs:** exact match.
* **Boosting and weighting** — certain fields can be given higher weight in the overall match score (for example, national ID vs name similarity). IS THIS TRUE?!?
* **Thresholds** — only matches above a certain relevance score are presented for review. IS THIS TRUE?!?

Business owners define **what should be considered “close enough”** for each field and event type, and technical teams implement that as Elasticsearch queries and scoring.

{% hint style="info" %}
You can configure more than one check per event to target different types of potential duplicates or fraudulent activity.
{% endhint %}

#### 3.2 Impact of allowing multiple ID types in declarations

When the declaration form allows multiple ID types (for example, **National ID**, **Passport**, **BRN**) with a type selector, there are some important considerations:

*   **ID matches are strongest when the same ID type is reused.**

    If the same mother is recorded twice with the **same ID type and value** (for example, NID vs NID), ID‑based deduplication is a strong signal.
*   **Different ID types weaken ID‑based matching.**

    If the same mother is recorded once with a Passport and once with a National ID, deduplication cannot treat these as the same identifier. In these cases, matching must rely primarily on **name and date‑of‑birth similarity**.

To mitigate these limitations, countries should:

* Treat a single, stable ID type (for example, **National ID**) as the **primary deduplication identifier** where available.
* Always configure additional checks that **do not depend on IDs at all**, using combinations of names, dates of birth, locations, and other demographics to catch duplicates where ID types differ or are not provided.

***

### 4. Reviewing potential duplicates

When a new declaration is submitted, OpenCRVS automatically runs the configured deduplication checks for that event type.

If one or more potential matches are found:

1. A user with the scope `record.review-duplicate` can perform the action: Review potential duplicates
2. The system displays a **side-by-side view** of the new declaration and matching existing records.
3. The reviewer compares key data fields (for example, child’s name, date of birth, mother’s details) and any additional context.
4. The reviewer chooses one of the following outcomes:
   * **Mark as duplicate** — the new declaration is archived as a duplicate of the existing record.
   * **Mark as not a duplicate** — the declaration proceeds through the normal workflow (for example, validation and registration).

All review outcomes are audited, including:

* Which record was reviewed.
* Which potential matches were presented.
* Who made the decision.
* The decision taken (duplicate / not duplicate).

_(Insert example screenshot or diagram here)_

***

### 5. Worked example

From a business perspective, configuring deduplication logic means describing **what kinds of mistakes or duplicate situations you want the system to catch**, and then defining **what “close enough” means for each field**.

#### **Business requirement:**

Detect cases where the **same birth is accidentally declared more than once** (mistaken redeclaration).

**Why this happens in practice**

Common causes include:

* Parents returning to the office and submitting the same declaration twice
* Staff re-entering an event because the first submission appeared to fail
* Spelling differences between declarations (e.g., _Sara_ vs _Sarah_)
* Small date entry mistakes (e.g., 12 vs 14 May)
* The same mother using the same ID but slightly different name spelling

Because these are not intentional duplicates, we expect:

* Most core details to be very similar
* At least one strong identifier (often the mother’s national ID)

#### Configuration input

<table><thead><tr><th valign="top">Check</th><th valign="top">Reason for check</th><th>Required matching criteria</th></tr></thead><tbody><tr><td valign="top"><p>Standard check</p><p></p></td><td valign="top">Mistaken redeclaration</td><td><ul><li>Similar child's first name(s)</li><li>Similar child's last name</li><li>Date of birth within ±5 days</li><li>Similar mother's first name(s)</li><li>Similar mother's last name</li><li>Similar mother's date of birth or same age</li><li>Exact mother's national ID |</li></ul></td></tr></tbody></table>

#### Name matching configuration

To support fuzzy name matching, OpenCRVS uses the following Levenshtein-based rules:

* **Similar first name**
  * 0–3 characters: 0 edits allowed
  * 4–6 characters: 1 edit allowed
  * 7+ characters: 2 edits allowed
* **Similar last name**
  * Applies the same Levenshtein rules as first names.
  * For compound surnames (for example, "von Thiele Schwarz"), all parts must match in some form.
  * Word-level distance is applied so that small spelling errors or transpositions (for example, "Thoele" vs "Thiele") can still be detected as potential matches.

These rules balance **sensitivity** (catching likely duplicates) with **specificity** (avoiding too many false positives). They can be tuned during implementation based on real-world data.

***

### 8. Summary

At a high level, implementers can think of deduplication as:

* A set of **Elasticsearch queries** defined per event type.
* A **matching pipeline** that runs when declarations are notified, declared or edited.
* A **UI component** that renders the side-by-side comparison and captures the reviewer’s decision.
* A set of **journal entries and actions** (for example, archive as duplicate) triggered by that decision.
