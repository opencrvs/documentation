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

# Administrative structure

### 1. Introduction

The **administrative structure** in OpenCRVS models how a country organises its geography and registration offices. It defines the hierarchy of locations (for example, country → province → district) and the registration offices that operate within those locations.

This structure underpins:

* How addresses are captured in forms
* Locations where users can be assigned
* Which users can **see and act on** which records (via assigned location, scopes and jurisdictions).
* Where events are **declared**, **registered**, and **certified**.
* How data is **aggregated** for reporting and vital statistics.

OpenCRVS does not impose a fixed hierarchy. Instead, each country defines a structure that mirrors its own administrative model and civil registration responsibilities.

***

### 2. Feature overview

The administrative structure provides a configurable foundation for modelling the administrative areas and the locations where civil registration activities occur.

#### Core capabilities

With the administrative structure, OpenCRVS supports:

* **Custom administrative hierarchies** (for example, Country → State → District).
* **Multiple location types** (for example, “Registration Office”, “Health Facility”, “Community Point”).
* **Offices at any administrative level** (for example State A Office, in State A)
* **Jurisdiction-aware access control** through integration with scopes (for example, `placeOfEvent`, `declared_in`, `registered_in`).
* **Routing of records** based on event location, declared-in location, registered-in location.
* **Location-based reporting and analytics** (for example, births registered per district).

The administrative structure is:

* **Shared** across features such as Users, Workqueues, Actions, and Reports.
* **Configurable** per deployment to reflect country specific adminstrative structures.
* **\~\~Stable** over time, but able to support **historical changes** (for example, boundary changes) via configuration and data migration.\~\~

***

### 3. Location hierarchy

The location hierarchy represents the **geographic and administrative units** of a country.

#### Location properties

Each location typically includes:

* **Name** — Human-readable name displayed in the UI.
* **Code** — Unique code for …
* **Type** — Administrative type (for example, District, CRVS Office, HealthFacility).
* **Parent** — The location one level above in the hierarchy.
* **Status** — Whether the location is active (usable) or retired.

This hierarchy is used by:

* Forms (for selecting event location and rendering address fields)
* Users (for assigning office locations).
* Scopes and workqueues (for filtering by “within my administrative area”).

***

### 4. Registration offices and service points

Within the administrative hierarchy, different location types can be distinguished such as **registration offices** and health facilities.

#### Registration offices

A **registration office** is represented as a location in the hierarchy and can appear at **any level** (for example, a province-level office or district-level office). Being an “office” does **not** in itself define what can be done there.

What happens at an office is determined by the **users based at that office** and their **configured roles and scopes**:

* If users at an office have scopes that allow them to register events, that office effectively functions as a registration point.
* If users only have scopes for notifying or declaring, the office functions as an or declaration point.

In other words, **responsibilities are not configured on the office itself**. They are derived from:

* The **roles** assigned to users located there, and
* The **scopes and jurisdictions** attached to those roles.

#### Other service points

Other service points may include:

* **Health facilities** (for facility notifications and declarations).
* **Community points** (for outreach or mobile registration).

These locations are treated like any other location type; what they can do depends on the users and scopes assigned to them.

***

### 5. Jurisdiction and access control

The administrative hierarchy is tightly integrated with **Users roles and scopes** to control who can act on which records.

Scopes can refer to a user’s **administrative area,** which is defined using the administrative hierarchy and the user assigned location. For example:

> record.register\[event=birth|death, placeOfEvent=my-administrative-area]

Interpretation:

* The user may register births and deaths that **occurred anywhere within their assigned area**, where “my administrative area” includes the user’s primary office location and all child locations beneath it (for example, district + all health facilities and community points in that district).

This ensures that:

* Local staff cannot action records outside their authorised area.
* Senior and national staff sitting in offices are higher admin levels can be given broader access where needed

To learn more about jurisdictions please see Users and Jurisdictions

***

### 6. Routing records between offices & users

Routing in OpenCRVS is ultimately driven by how Users, Actions and Workqueues have been configured.

When a record changes **status** or gets a **flag**, it appears in the relevant workqueues for users who are allowed to act on it. Think of routing as:

**Status/flag changes → record state matches a workqueue filter → eligible users can see and act on it.**

#### Typical routing patterns

Below are common routing scenarios with step-by-step examples.

**Facility → District office**

**Scenario:** A birth or death is declared at a health facility and must be validated by the district registration office.

**Flow:**

1. A **Health Facility user** creates and submits a declaration for District A Health Facility
2. The record status becomes **Declared**.
3. Record appears in the Pending validation workqueue filtered by:
   1. Status = Declared
   2. User search scope eg. `search[event=birth|death declared_in=my-administrative-area`
4. **Registration Officer** at the **District A Registration Office** sees the record and can validate it.

**Result:**

* District A Registration Officer automatically receives the declaration for review.
* District B Registration Officer will **not** see the record in their Pending validation workqueue

***

#### **Community point → District office**

**Scenario:** A community worker reports an event that must be formally registered at the district level.

**Flow:**

1. A **Community worker** submits a notification from a **Sub-district Community Point**.
2. The record status becomes **Notified**.
3. Record appears in the Notifications workqueue filtered by:
   * Status = Notified
   * User search scope eg. `search[event=birth|death placeOfEvent=my-administrative-area)`
4. **District A Registration Agents** see it and can help to progress the notification to a validated declaration

**Result:**

* District A Registration Officer automatically receives the notification
* District B Registration Officer will **not** see the record in their Notification workqueue

***

#### **Escalation → Higher-level office**

**Scenario:** A case needs senior approval (for example, a late registration).

**Flow:**

1. A district user flags the record as **Late registration**.
2. The system adds a **flag** to the record.
3. Record appears in the Escalated workqueue filtered by:
   * Flag = Late registration
   * `search[event=birth|death declared_in=my-administrative-area)`
4. **State A Provincial Officer** sees it and can approve or reject the late registration

**Result:**

* Only State A Provincial Officer can see the escalated record
* Provincial Officers in other States can not see the escalated record.

Routing in practice is the combination of:

* **Actions** (what action changed that record status or added/removed a flag)
* **Workqueues** (which filter for specific record state) and filtered further based on a users
* **Search scope and assigned location** (which specifies their jurisdiction)

Together, these determine **who sees a record next and who can act on it**.

***

### 7. Worked example

#### Business requirement: Super Simple Administrative Structure

Farajaland has only 1 Province and 1 District with the following offices where civil registration activities occur:

* Farajaland HQ office
  * Review escalations
  * Audit
  * Review performance
* Langa Province Registration Office (Office)
  * Review escalations
  * Audit
  * Review performance
* Ibombo District Registration Office (Office)
  * Registers births and deaths that occurred within Ibombo District.
  * Issues certificates and manages corrections.
* Ibombo Health Facility (Health Facility)

***

#### Configuration input

| **Location** | **Type** | Location             | Type     | Location              | Type     | Location                            | Type            |
| ------------ | -------- | -------------------- | -------- | --------------------- | -------- | ----------------------------------- | --------------- |
| Farajaland   | Country  |                      |          |                       |          |                                     |                 |
| Farajaland   | Country  | Farajaland HQ Office | Office   |                       |          |                                     |                 |
| Farajaland   | Country  | Langa Province       | Province | Langa Province Office | Office   |                                     |                 |
| Farajaland   | Country  | Langa Province       | Province | Ibombo District       | District | Ibombo District Registration Office | Office          |
| Farajaland   | Country  | Langa Province       | Province | Ibombo District       | District | Ibombo District Health Facility     | Health Facility |
|              |          |                      |          |                       |          |                                     |                 |

***

### 8. Summary

A clear administrative structure is a prerequisite for configuring **Users, Scopes, Workqueues and Actions** in a way that accurately reflects how civil registration is organised in the country.
