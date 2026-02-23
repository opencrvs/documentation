# Workqueues (test)

### 1. Introduction

In OpenCRVS, **Workqueues** are role-based, pre-filtered lists of vital event records, organised to help registration staff clearly see pending tasks and what needs their attention.

Instead of searching for records, users may open a Workqueue from the left-hand navigation to get a task-focused view of records at a particular status or that require a specific action, such as declaration review, validation, approval, certificate printing, or issuance.

Each Workqueue combines configurable filters with role-based visibility so that:

* Users are able to see records relevant to them at that moment in time
* Users only see queues that are relevant to their responsibilities
* Users can stay in a focused workflow with less searching and context switching

\<image>

***

### 2. Feature overview

Workqueues provide a flexible mechanism for showing records relevant for the user based on workflow state, timing, location, user actions, and record data.

#### Core capabilities

OpenCRVS supports:

* Unlimited custom workqueues
* Role-based access to workqueues
* Filtering by event type and record status
* Date-based filtering using exact dates, ranges, or relative periods
* Location-aware filtering using administrative hierarchies and jurisdictions
* User- and role-based filtering (e.g. “updated by me”, “updated by registrar”)
* Filtering based on record data (e.g. date of event, event location, calculated values such as age)

Filters can be combined to create precise, task-oriented views such as:

> “All birth declarations rejected by a Registrar in the last 7 days within my district.”

***

### 3. Configuration overview

Each Workqueue is defined by a small set of parameters that control how it appears in the user interface and which records it displays.

#### Workqueue parameters

| **ID / Slug**                | Unique identifier for the Workqueue. Used internally and in URLs.  |
| ---------------------------- | ------------------------------------------------------------------ |
| **Icon**                     | Icon displayed in the left-hand navigation.                        |
| **Name**                     | User-facing display name shown in the navigation.                  |
| **Time since table heading** | Label copy for the workqueue table heading                         |
| **Actions**                  | Required quick action from the workqueue table                     |
| **Query (search criteria)**  | A set of filters that determine which records appear in the queue. |

#### Supported query filters

Workqueues are powered by a flexible query system. Multiple filters can be combined to create highly targeted views of records.

THIS NEEDS TO BE REVIEWED BY A CORE DEVELOPER!!

| **Filter**                                | **Type options**                                             | **Description**                                                                          | **Examples**                 |
| ----------------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------------------------------- | ---------------------------- |
| **Event type(s)**                         | Any of                                                       | Filter records by civil event type.                                                      | Any of (Birth, Marriage)     |
| **Record status(es)**                     | Any of                                                       | Filter records by workflow status.                                                       | Any of (Declared, Validated) |
| **Created at**                            | Exact date                                                   |                                                                                          |                              |
| Date range                                |                                                              |                                                                                          |                              |
| Relative                                  | Filters by when the record was first created.                | After 01/01/2024                                                                         |                              |
| Within last 14 days                       |                                                              |                                                                                          |                              |
| **Updated at**                            | Exact date                                                   |                                                                                          |                              |
| Date range                                |                                                              |                                                                                          |                              |
| Relative                                  | Filters by when the last ~~mutating~~ action occurred.       | Before 01/02/2024                                                                        |                              |
| Within last 7 days                        |                                                              |                                                                                          |                              |
| **Created at location**                   | Exact                                                        |                                                                                          |                              |
| Within                                    | Filters by where the initial action was performed.           | Exact: Ibombo                                                                            |                              |
| Within Ibombo District                    |                                                              |                                                                                          |                              |
| **Updated at location**                   | Exact                                                        |                                                                                          |                              |
| Within                                    | Filters by where the last ~~mutating~~ action occurred.      | In user’s primary office                                                                 |                              |
| Within Langa District                     |                                                              |                                                                                          |                              |
| **Created by**                            | Exact                                                        |                                                                                          |                              |
| User                                      | Filters by the user who created the record.                  | User ID: 123-456Me                                                                       |                              |
| **Updated by**                            | Exact                                                        |                                                                                          |                              |
| User                                      | Filters by the user who last updated the record.             | User ID: 123-123Me                                                                       |                              |
| **Updated by role**                       | Exact role                                                   |                                                                                          |                              |
| Any role                                  | Filters by the role of the user who last updated the record. | Registrar                                                                                |                              |
| Any registrar role                        |                                                              |                                                                                          |                              |
| **Record data fields**                    | Field-type dependent                                         | Filters on values within the record data. Available operations depend on the field type. | Child age > 1 year           |
| Event location = Ilanga District Hospital |                                                              |                                                                                          |                              |
| Date of event between 2023–202            |                                                              |                                                                                          |                              |

#### Filter type options

The following matching types are used across filters:

* **Exact** – Matches a single, precise value (e.g. a specific date, user, or location).
* **Within** – Matches a location and all of its child locations in the administrative hierarchy.
* **Any of** – Matches at least one value from a selected set.
* **Range / Relative** – Matches a date range or a period relative to the current date (e.g. “last 14 days”).
* **Me** – A special selector representing the currently logged-in user.

***

### 4. Worked example

This section illustrates how a real-world business rule is translated into a **workqueue configuration** and then into **code in the country configuration package**.

#### Business requirement: Pending validation workqueue

1. Show all birth and death declarations that are ready to be reviewed by the Registration Officer, so that they can quickly identify declarations that are ready for them to validate.
2. Show all birth declarations that:
   * Have been declared in the Registration Officer’s administrative area
   * Have not yet been validated
   * Have the status “declared”
   * Have not been rejected
   * Do not require senior approval

#### Configuration input

| **Property**                            | **Value**          |
| --------------------------------------- | ------------------ |
| Name                                    | Pending validation |
| Icon                                    | Stamp              |
| Event type                              | Birth              |
| Death                                   |                    |
| Record status                           | Declared           |
| No flag                                 | Validated          |
| Rejected                                |                    |
| Approval required for late registration |                    |

#### Configuration code

The configuration below implements the “Pending validation” workqueue as described above.

```tsx
{
  slug: 'pending-validation',
  icon: 'Stamp',
  name: {
    id: 'workqueues.pendingValidation.title',
    defaultMessage: 'Pending validation',
    description: 'Title of pending validation workqueue'
  },
  query: {
    ...declaredInMyAdminArea,
    status: { type: 'exact', term: EventStatus.enum.DECLARED },
    flags: {
      noneOf: [
        InherentFlags.REJECTED,
        'validated',
        'approval-required-for-late-registration'
      ]
    }
  },
  actions: [{ type: 'DEFAULT', conditionals: [] }],
  columns: [
    DATE_OF_EVENT_COLUMN,
    {
      label: {
        defaultMessage: 'Validation requested',
        description: 'This is the label for the validation requested column',
        id: 'workqueue.pending-validation.updatedAtColumn'
      },
      value: event.field('updatedAt')
    }
  ]
},
```

***

### 5. Pre-configured workqueues

OpenCRVS includes several pre-configured workqueues that support common civil registration workflows. These queues can be customised, extended or removed as needed.

| Workqueue             | **Description**                                                   |
| --------------------- | ----------------------------------------------------------------- |
| Assigned to you       | Records currently assigned to the user                            |
| Recent                | Recently created or updated records                               |
| Notifications         | Incomplete declarations missing mandatory information             |
| Pending validation    | Declarations ready to be validated                                |
| Pending updates       | Records flagged for additional data                               |
| Potential duplicate   | Declarations that have been flagged as potential duplicates       |
| Pending registration  | Declarations that have been validated and ready to be registered  |
| Escalated             | Records that have been escalated to senior user roles             |
| Pending approvals     | Records forwarded for higher-level approval                       |
| Pending certification | Registered records ready for certificate printing                 |
| Pending issuance      | Certified copies that have been printed off inadvance of issuance |
| Pending corrections   | Records with pending correction requests                          |

***

### 7. Workqueue assignment and access control

Workqueues are assigned to user roles alongside other scopes. Assigning a workqueue makes the workqueue visible in the navigation pane and allows the user to see the full list of filtered records, however it **does not** grant additional “action” permissions on the records themselves.

Multiple workqueue IDs can be combined using the pipe (`|`) separator to tailor queue visibility by role and responsibility.

#### Example workqueue scope

```
workqueue[id=assigned-to-you|recent|pending-updates|pending-validation|pending-certification]
```

**Meaning:**

Users with this scope can access the listed workqueues, enabling them to view and manage the corresponding filtered record sets.

####
