# 4.2.6 Configure events

#### ⚠️ Important: Changes to Event Configuration in OpenCRVS 1.9

OpenCRVS **v1.9** introduces a **completely new event configuration framework**.\
This allows you to define **any event type** you need, with full flexibility across:

* Event forms
* Certificate templates
* Correction flows
* Print collection workflows
* De-duplication algorithms
* Workqueues
* Notifications
* Analytics
* API behaviour (From GraphQL > tRPC)
* Database technology (From MongoDB > PostgreSQL)

This new system is fundamentally different from the approach used in **OpenCRVS v1.8**.

***

#### 🔄 How 1.9 Differs from 1.8

**OpenCRVS 1.8**

* Events are stored in **MongoDB**
* The storage model uses **FHIR** objects
* Event configuration is limited and tightly coupled to the FHIR structure

**OpenCRVS 1.9**

* Events are stored in **PostgreSQL**
* Uses a **custom event model**, designed for flexibility and performance
* FHIR is pushed into the **interoperability layer**, instead of being the primary storage model
* Event configuration is modular and highly customisable

This new architecture provides much more freedom in defining workflows and event types.

####

#### 🚫 For New Users: Do NOT Use the Old 1.8 Method

OpenCRVS 1.9 is a transitional release designed to allow safe migration while enabling all new deployments to start cleanly on the modern architecture.

> ❗ **New implementers must not configure events using the old (1.8 and earlier) approach.**

Only the **new 1.9 event configuration framework** should be adopted.

Using the old method will leave you with obsolete configurations that will be **completely deprecated in OpenCRVS 2.0**, scheduled for release in **2026**.

🚀 For **all new deployments**, you should configure events only using the **v2** approach in `src/form/v2/`.

***

#### 🧭 Transitional Release: Both Systems Exist Side-by-Side

The **countryconfig** service still contains:

* The **old 1.8-style event configuration code**, AND
* The **new 1.9 event configuration system**

This is intentional. It allows countries already running OpenCRVS 1.8 to **migrate their events** to the new 1.9 model during the 1.9 lifecycle.

> ℹ️ **If you are currently running OpenCRVS 1.8**, [this](https://github.com/opencrvs/notebooks) repository includes everything needed to support your transition to 1.9.\
> **Please contact us for guidance on the migration process.**

***

In OpenCRVS **v1.9**, the legacy event configuration remains available alongside the new system:

* The **old (v1.8-style) event configuration** still lives under the main countryconfig entry point in\
  `src/index.ts` (see the legacy configuration exports around the event-related sections).
* The **new event configuration framework** for OpenCRVS 1.9 and later is implemented in the\
  `src/form/v2/` directory, which contains the v2 form and event configuration code.

> 🧭 For **existing 1.8 deployments**, you may still see and use the old configuration code in `src/index.ts` while you migrate.\
> 🚀 For **all new deployments**, you should configure events only using the **v2** approach in `src/form/v2/`.

An environment variable `V2_EVENTS` can be used to toggle between versions. See: [https://github.com/opencrvs/opencrvs-core/pull/10763](https://github.com/opencrvs/opencrvs-core/pull/10763)



***

#### 📘 About This Documentation

The guidance in this section refers **exclusively** to:

* The **new 1.9 event configuration code** in this directory
* The **API endpoints** associated with the new configuration model

