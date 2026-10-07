---
description: Desktop research and planning before any fieldwork
---

# Desk research & planning

### 1. Introduction

Before you can configure OpenCRVS for your country, you need a working knowledge of how civil registration and vital statistics (CRVS) are supposed to work — in law and in procedure. This page covers the first stage of [Gathering requirements](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements): the **desk research** that builds that knowledge, and the **planning** that turns it into a fieldwork plan.

Doing this well means your time with registrars, health workers and citizens is spent validating and probing the things documents cannot tell you — not on basic discovery. The result is targeted, efficient fieldwork and far better use of your stakeholders' time.

{% hint style="info" %}
**What this stage produces:** a baseline understanding of the country's CRVS context, and a ready-to-execute fieldwork plan. Both feed directly into [Field Research & Discovery](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/field-research-and-discovery).
{% endhint %}

**When:** This is the first stage of requirements gathering and is mostly desk-based. It can begin as soon as your core team is in place. Indicative duration: **2–4 weeks**, depending on the number of vital events in scope and how readily the source documents can be obtained.

**Before you start, you should have:**

* a project sponsor and the core team in place — at minimum a Business Analyst and a Technical System Administrator (see [Establish project & team](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/establish-project-and-team))
* the list of vital events the implementation will cover (for example: birth, death, marriage — and possibly divorce, adoption or stillbirth)
* government agreement to request documents from, and later engage, registry, health and statistics bodies.



<figure><img src="../../../.gitbook/assets/image (26).png" alt=""><figcaption><p>Registration Agent sharing examples of vital event records, declaration forms and certificate templates.</p></figcaption></figure>

***

### 2. Desk research

Build your understanding from the documents that define how registration works today, then read them with configuration in mind.

#### 2.1 Collect the existing materials

Gather the official documents listed below. Log anything you cannot obtain so the gap can be filled during fieldwork.

| Document                                         | What to extract from it                                                       | Likely source                          | Collected? |
| ------------------------------------------------ | ----------------------------------------------------------------------------- | -------------------------------------- | ---------- |
| Civil Code / Vital Statistics Act                | Legal mandate, event definitions, registration time limits, who must register | Ministry of Justice / Attorney General | ☐          |
| Subsidiary regulations, decrees, circulars       | Detailed procedures, fees, late-registration rules                            | Registrar General's office             | ☐          |
| Blank declaration/registration forms (per event) | Data fields collected, ordering, complexity                                   | Registry / health facilities           | ☐          |
| Sample certificates (per event)                  | Legal content, security features, languages                                   | Registry                               | ☐          |
| Standard Operating Procedures (SOPs) / manuals   | The intended workflow, actors and handoffs                                    | Registry                               | ☐          |
| Data-protection law and regulations              | Lawful basis, data residency, retention, access rules                         | Data Protection Authority / Justice    | ☐          |
| Existing data-sharing agreements                 | Current or planned integrations (National ID, health, statistics)             | Relevant ministries                    | ☐          |
| Fee schedule                                     | Registration, certification and late-registration fees, and any waivers       | Registrar General's office             | ☐          |
| Administrative-boundary and office list          | Jurisdictions and office hierarchy                                            | Statistics office / interior ministry  | ☐          |

#### 2.2 Analyse the legal and procedural framework

Collecting the law is not the same as knowing what it requires. Read the documents with one question in mind: **which legal parameters will shape the OpenCRVS configuration?** Capture each one, and where the answer is unclear or contested, mark it as something to confirm in the field.

The table below maps the parameters that most often drive configuration decisions to the configuration work they feed. Use it as your extraction checklist.

| Legal / policy parameter              | Question to answer                                                                      | Feeds (downstream configuration)                                                                                                                            |
| ------------------------------------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Registrable events in scope           | Which events are legally registered?                                                    | [Event configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-event-configuration)                  |
| Registration time limit               | What is the on-time window per event (for example, 30 days for a birth)?                | Workflow branches; late/delayed logic                                                                                                                       |
| Late & delayed registration           | What evidence, approval or fees apply after the window? When is a court order required? | Conditional fields, scopes, fees                                                                                                                            |
| Eligible informants                   | Who may declare each event?                                                             | [Form configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-form-configuration); declaration roles |
| Required vs optional data             | What is the legal minimum data set per event?                                           | Form configuration / validation                                                                                                                             |
| Supporting documents                  | What evidence must accompany a declaration?                                             | Form (document upload) requirements                                                                                                                         |
| Who may register, approve and certify | Which roles validate, register and sign records?                                        | User roles & scopes; certificate signing                                                                                                                    |
| Correction & amendment                | Administrative vs court-ordered correction; who approves?                               | Correction flows; scopes                                                                                                                                    |
| Certified-copy content & security     | What must a certificate show? What security features and languages are required?        | [Certificate configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-certificate-configuration)      |
| Fees & waivers                        | What is charged, to whom, and who is exempt?                                            | Business rules / configuration                                                                                                                              |
| Jurisdiction & hierarchy              | Which office serves which area, and what are the reporting lines?                       | [Mapping offices and users](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-mapping-offices-and-users)      |
| Identifiers                           | Is a national ID issued at birth? What is the registration-number format?               | Integrations; number generation                                                                                                                             |
| Languages & scripts                   | What are the official languages? Are any right-to-left?                                 | Localisation                                                                                                                                                |
| Notification obligations              | Who must be notified of an event (National ID, health, statistics, electoral)?          | Integration use-cases                                                                                                                                       |
| Data protection & retention           | What is the lawful basis, residency, retention period, access and audit expectation?    | Roles/scopes; non-functional requirements; audit                                                                                                            |

#### 2.3 Draft a preliminary "as-is" picture

From the SOPs and process documents, sketch a first draft of how each in-scope event is registered today — the main steps, the actors, and the forms used. This is a starting hypothesis, not the truth: you will test and correct it in the field. Capturing it now means you arrive with specific things to verify rather than a blank page.

***

### 3. Fieldwork planning

Turn your understanding and your open questions into a concrete plan: who to see, when, and what to ask.

#### 3.1 Map your stakeholders

You cannot plan fieldwork without knowing who to see and why. Build a stakeholder map covering everyone from national policymakers to facility staff and citizens.

For each stakeholder, record: **name / role**, **organisation**, **level** (national, sub-national, facility, citizen), **their interest**, **their influence**, **what you need from them**, **engagement priority** (high / medium / low), and **contact details**. Plotting interest against influence helps you decide who to engage, and how deeply.

#### 3.2 Plan the schedule and logistics

Turn the stakeholder map into a concrete itinerary:

* **Itinerary** — specific dates, sites (central registry, regional offices, health facilities) and people to meet.
* **Site selection** — deliberately include contrasting contexts: urban and rural, high- and low-volume offices, well-connected and offline locations. Note your reasoning so the research is defensible.
* **Objectives per visit** — what each meeting or site visit needs to confirm or uncover, based on the gaps from section 2.
* **Logistics** — travel, permissions, equipment, and (for workshops) venues, invitations and materials.

#### 3.3 Prepare the discussion guides

Write a short, tailored guide for each audience rather than one generic list. Suggested starting points:

* **Policymakers / CRVS officials** — mandate, priorities, known pain points, and what success looks like.
* **Registrars** — the real day-to-day steps, exceptions, workarounds, volumes, and what slows them down.
* **Health-facility staff** — how births and deaths are notified, and what data they hold.
* **IT / systems staff** — current systems, connectivity, integration appetite, and security.
* **Citizens** — how they register an event, what it costs them in time, money and travel, and what gets in the way.

{% hint style="info" %}
**Build in the inclusion lens.** In every guide, include prompts about under-served groups: how do rural or hard-to-reach families register? Are there gender-related barriers? How are persons with disabilities, or displaced, stateless or undocumented people served? Are there customary or religious practices the formal system does not capture? These questions are easy to omit and hard to retrofit.
{% endhint %}

***

### 4. Outputs and definition of done

**Key outputs:** by the end of this stage you should have:

* a collection of source materials (laws, forms, certificates, SOPs, fee schedules, boundary lists), with gaps explicitly logged
* a legal-parameter register — the completed analysis from section 2.2, flagging what still needs field validation
* a preliminary as-is sketch for each in-scope event
* a stakeholder map with engagement priorities
* a fieldwork plan and schedule with site-selection rationale
* a set of tailored discussion guides, one per audience.

**Definition of done:** you are ready to move to [Field Research & Discovery](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/field-research-and-discovery) when:

* \[ ] all priority documents are collected, or their absence is logged as a field question
* \[ ] the legal-parameter register is drafted, with open questions flagged
* \[ ] the stakeholder map is agreed
* \[ ] the fieldwork schedule is confirmed with named contacts
* \[ ] a discussion guide exists for each audience you plan to meet.

***

### 5. Resources and support

For broader guidance on requirements gathering and process mapping for CRVS, see the [CRVS Digitisation Guidebook](http://www.crvs-dgb.org/).

For any questions about gathering requirements or configuring OpenCRVS, contact [**team@opencrvs.org**](mailto:team@opencrvs.org).

{% hint style="info" %}
**Next:** the fieldwork plan and baseline understanding produced here are the inputs to [Field Research & Discovery](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/field-research-and-discovery), where you validate and correct them on the ground.
{% endhint %}
