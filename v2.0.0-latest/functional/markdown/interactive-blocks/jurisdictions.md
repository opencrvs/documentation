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

# Jurisdictions

### 1. Introduction

Jurisdictions define the **scope within which a user is permitted to view, create, assign, and action records**. They are primarily an **access-control and workflow boundary**, not just a representation of administrative geography.

While jurisdictions reference the country’s administrative structure (for example country → province → district), their purpose is to **control which events and records a user can act on**, based on where those events occurred or the location for where a past action was performed by a user.

Jurisdiction rules are evaluated at the **user scope level** and applied consistently across recored creation, search and assignment. This ensures that civil registration work happens only within the location(s) a user is authorised to operate in, supporting legal compliance, data protection, and operational separation of responsibilities.

In short, jurisdictions determine **what a user can do and which records they can access**, rather than simply describing where data belongs.

***

### 2. Feature overview

Jurisdictions provide a **policy layer** that connects administrative locations to permissions and system behaviour. They enable OpenCRVS to enforce location-aware access and workflows across the platform.

#### Core capabilities include:

With jurisdictions, OpenCRVS supports:

* **Location-scoped permissions** so users can only see and act on records relevant to their authorised area.
* **Controlled creation of records**, restricting where events can be notified, declared, or registered.
* **Scoped search results and workqueues**, ensuring users only work on records within their permitted locations.
* **Consistent enforcement across actions**, including create, assign, update, and register operations.

Jurisdictions in OpenCRVS are:

* **Type-based** — permissions use predefined jurisdiction types (for example, “my administrative area”, “my office”, or “any”)
* **Applied per scope** — each permission (such as create, search, or assign) can specify its own jurisdiction rule.
* **User-specific** — different users in the same office may have different jurisdiction boundaries.

This design allows fine-grained control over who can act on which records, while remaining flexible enough to match diverse civil registration operating models.

***

### 3. Jurisdiction configuration overview

#### 3.1 Jurisdictions types

The system currently supports four boundary types:

| Type                   | Functional meaning                                                             |
| ---------------------- | ------------------------------------------------------------------------------ |
| my administrative area | My location and all child locations (for example, my district + all districts) |
| my office              | Only my exact office or facility                                               |
| me                     | Only records personally declared/registered by me                              |
| any                    | No location restriction                                                        |

{% hint style="warning" %}
More complex custom jurisdiction types eg. A Senior Registrar in a district office but has jurisdiction over all District offices in the State; are planned to be supported in future releases.
{% endhint %}



Jurisdictions can be applied to different **location characteristics** of a record.

| Characteristic | What it represents                |
| -------------- | --------------------------------- |
| Event location | Where the event actually occurred |
| Notified in    | Where it was first reported       |
| Declared in    | Where it was formally declared    |
| Registered in  | Where final registration happened |

#### 3.2 Jurisdictions and users

Jurisdiction is enforced at a user scope level. From a user’s perspective therefore, jurisdictions determine:

* What records they can see (search results only include records inside their jurisdiction)
* What event declarations they can create (for example, only events that occurred in their jurisdiction)
* What records they can work on (they can only validate, edit, register or print records that fall inside their jurisdiction

If a record is outside their jurisdiction:

* it will not appear in search, or
* actions will be blocked

Example user scopes:

* `record.create[event=birth event_location=my-administrative-area]`
  * user can only create declarations for events that occurred in their administrative area
  * place of birth locations are automatically filtered
* `search[event=birth notified_in=my-administrative-area declared_in=my-administrative-area registered_in=my-administrative-area]`
  * user can only see records in search results for records either notified, declared or registered in their administrative area

\<aside> 🚨

As jurisdiction are enforced at the individual scope level (rather than being determined solely by the user's assigned office location). As a result:

* Different users in the same office can be assigned different jurisdictions.
* A single user role can have different jurisdictions for different scopes \</aside>

#### 3.3 “Declared in” & “Registered In” >> better title?

Sometimes a single location rule is not enough.

For example:

* “In search results show only records declared in my district” (single location rule)
* or “Show records either declared OR registered in my district”
* or “Only records both declared AND registered in my district”

To support real operational needs, jurisdictions support **AND** and **OR** logic.

~~Add example… declared in one jurisdiction but registered in another. can no longer view the record even tho it was originally registered in their jurisdiction~~

**AND logic (stricter filtering)**

When multiple conditions are applied together in the same rule, **all must be true**.

This narrows access.

Example:

A district registrar is only allowed to see records that were:

* declared in their district **AND**
* registered in their district

Result:

* records handled entirely inside the district only
* excludes records declared in their district but registered elsewhere

```
{
  type: 'search',
  options: {
    event: ['birth'],
    declaredIn: 'administrativeArea',
    registeredIn: 'administrativeArea'
  }
}
```

By definition, these filter out events that have not been registered. Out of the registered events, only the ones that were both declared and registered within user's administrative area are returned.

**OR logic (broader filtering)**

When separate rules are defined for the same action, **any rule may match**.

This broadens access.

Example:

A supervisor wants to see records:

* declared in their district **OR**
* registered in their district

Result:

* includes locally declared records
* includes records registered locally but declared elsewhere

```
[
  {
  type: 'search',
  options: {
    event: ['birth'],
    declaredIn: 'administrativeArea',
    }
  },
  {
  type: 'search',
  options: {
    event: ['birth'],
    declaredIn: 'administrativeArea',
    }
  }
]
```

Out of all birth events, the ones that are declared within the administrative area, or registered within the administrative area are returned.

### 4. Worked example

#### **Business requirement: Health Official**

* A health official working at a specific health facility can only work on records for events that occurred in **their own facility**.
* They must not see or modify records from other facilities or districts.

#### Configuration input

| Permission | Event        | Jurisdiction                | Meaning                                                                                              |
| ---------- | ------------ | --------------------------- | ---------------------------------------------------------------------------------------------------- |
| Create     | Birth, Death | event\_location = my-office | Can only create records of events that occurred in their facility (filters place of event locations) |
| Search     | Birth, Death | event\_location = my-office | Can only see records for events that occurred in their facility                                      |
| Declare    | Birth, Death | event\_location = my-office | Can only declare events that occurred in their facility                                              |
| Edit       | Birth, Death | declared\_in = my-office    | Can only edit declarations declared be someone in their health facility                              |

### 5. Summary

\<aside> 📌

~~In practice, **jurisdiction for mutating actions** (declare, reject, archive, register, correct, custom actions) is enforced by a combination of:~~

* ~~Where records can be created (`record.create` with jurisdiction), and~~
* ~~Which records a user is allowed to assign to themselves (`record.assign` with jurisdiction).~~

~~If a user cannot assign a record because it is outside their `record.assign` jurisdiction, they cannot perform follow‑up actions on that record.~~

\</aside>
