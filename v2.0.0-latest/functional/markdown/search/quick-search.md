# Quick search

### 1. Introduction

In OpenCRVS, **quick search** is the global search field in the application header. It is used when the user has one or more **strong identifiers** and needs to locate a record quickly.

Quick search focuses on a small set of configurable identifier fields and only returns records that the user is authorised to see, based on scopes and jurisdiction. It complements **advanced search**, which is used when identifiers are not known and multiple data points are needed to find a record.

Typical use cases include entering a **Tracking ID**, **Registration number**, or **national ID** to locate a specific record.

***

### 2. Feature overview

Quick search provides a **fast, identifier-based entry point** to find records from anywhere in the application.

#### Core capabilities

With quick search, OpenCRVS supports:

* **Instant lookup** of records using strong identifiers (for example, Tracking ID, Registration number, national ID).
* **Scope-aware results** that only return records the user is authorised to see.
* **Per-event configuration** of which identifier fields can be searched.
* A consistent search experience from the **global header**, without navigating to a dedicated search page.
* Complementary behaviour with **advanced search** for cases where identifiers are not known.

Quick search is:

* **Identifier-first** — optimised for exact or normalised matches on a small number of fields.
* **Predictable** — the same input returns the same results for a given user and configuration.
* **Secure** — always filtered by scopes and jurisdiction.

***

### 3. Configuration overview

Quick search is **configured per event type** (for example, birth, death, marriage) and per identifier field.

Configuration defines:

* Which **fields** are queried by quick search.
* Which **events** quick search is allowed to return for a given user.

Key principles:

* Focus on fields that are likely to be unique or highly discriminating.
* Avoid including free‑text name fields, which are better handled by advanced search.
* Keep behaviour predictable: the same input should consistently return the same record set for a given user.

#### Search fields

For each event type, you can configure which data points quick search should use. Recommended fields are identifiers that are either unique or nearly unique, such as:

* **Registration number**
* **Tracking ID**
* **National ID** (where captured)
* **Phone number**
* **Email address**

Configuration should specify, per event type:

* Which fields are enabled for quick search.
* Whether the search is **exact match** only, or allows normalised matching (for example, phone numbers without country code).

#### Access control and scopes

Quick search & advanced search is always subject to the standard access control model:

* Users only see records that their **scopes and jurisdictions** allow.
* Search results never include records outside the user’s permitted scope, even if the identifier matches

Access to search (quick search and advanced search) is controlled by **search scopes** on the user’s role.

* `search[event=<event> event_location=my-administrative-area]` where `<event>` is the relevant event type (for example, `birth`, `death`, `marriage`).

To learn more about users scopes please refer to Users, Jurisdictions

***

### 5. Worked example configuration

Below is an example configuration for quick search for birth records.

#### Business requirement

Users can quickly search for birth records based on names of individuals in the birth record and available unique identifies.

#### Configuration Input

| Data                    | Event | Type                                      |
| ----------------------- | ----- | ----------------------------------------- |
| **Names**               | Birth | Fuzzy on Informant, Child, Mother, Father |
| **Tracking ID**         | Birth | Exact match                               |
| **Registration number** | Birth | Exact match                               |
| **National ID**         | Birth | Exact match                               |
| **Phone number**        | Birth | Exact match                               |

***

### 6. Relationship to advanced search

Quick search and advanced search are complementary:

* **Quick search** is for users who have a strong identifier and need fast access via the application header.
* **Advanced search** is for users who do not have identifiers and need to combine multiple data points (names, dates, locations) to find records.

Both features use the same underlying access control model and scope patterns; configuration should be kept consistent so that a user’s experience of which records they can find is predictable across both search methods.
