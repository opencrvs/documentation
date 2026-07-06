---
description: Creating implementation-ready deliverables
---

# Design & specification

### 1. Introduction

This is the final stage of [Gathering requirements](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements). It turns the validated scope, roles and workflows from [Co-Design & Validation](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/co-design-and-validation) into your **to-be design** — tangible artefacts and configuration inputs that a team can build from with minimal ambiguity.

The **configuration guides** that sit under this stage are your main reference. Each one documents what OpenCRVS supports and includes recommendations, so you use them to shape the to-be requirements rather than designing in the abstract. Working through design before build also lets you validate the solution with stakeholders before any intensive coding.

{% hint style="info" %}
**What this stage produces:** approved mock-ups and prototypes, and a complete set of **configuration inputs** that capture the to-be (the full list is in section 3). These are then applied in the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage.
{% endhint %}

**When:** This stage follows Co-Design & Validation and closes out requirements gathering. Indicative duration: **2–4 weeks**, depending on the number of events in scope and how much is configured with defaults versus designed afresh.

**Before you start, you should have** the outputs of Co-Design & Validation — a prioritised feature list and service-concept epics, a future Service Delivery Model (SDM) per event, a validated office hierarchy and user roles, and agreed integration use-cases — plus the business-rules register and non-functional requirements from earlier stages to design against.

You will also draw on the **configuration guides below**, which tell you what OpenCRVS supports and recommend good-practice defaults.

***

### 2. Design the experience

Produce visual mock-ups and interactive prototypes so stakeholders can see and validate the to-be solution before it is built. Trace every screen back to the business rules and legal parameters captured earlier, and check what is configurable against the relevant guide, so design decisions are grounded rather than invented.

#### 2.1 Registration form mock-ups

For each in-scope event, mock up the registration form: the fields, their order, conditional logic, and validation. Each field and rule should trace to a business rule or legal parameter. Use the [Form configuration guide](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-form-configuration) to see what is supported and recommended.

#### 2.2 Correction and print/record flow mock-ups

Mock up how corrections and record printing behave — including the difference between administrative and court-ordered corrections, and how a certified copy is printed and reissued — so the workflow rules are concrete before configuration.

#### 2.3 Vital-event certificate mock-ups

Design the certified copy for each event: layout, the legally required content, security features, and any languages or scripts. Use the [Certificate configuration guide](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-certificate-configuration).

#### 2.4 Integration UI component mock-ups

Where an integration surfaces in the interface — for example a National ID lookup or a health-facility notification intake — mock up the components so the interaction and the data shown are agreed before build.

#### 2.5 Prototypes of new features

For anything beyond OpenCRVS default behaviour, build an interactive prototype. Prototypes are the cheapest way to test a new idea with stakeholders and surface problems while they are still easy to change.

***

### 3. Configuration guides and inputs

The guides below sit under this stage as your inputs. Each documents what OpenCRVS supports and includes recommendations, so you use them to shape the to-be design. Work through them to produce the **configuration inputs** — the artefacts that define your OpenCRVS configuration and are handed to the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage to build.

**The guides:**

* [**Event configuration**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-event-configuration) — designing the end-to-end business process for each event: steps, statuses, actions and workqueues (includes a worked [Name change](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-event-configuration/name-change) example).
* [**Form configuration**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-form-configuration) — defining the declaration and action form fields, validation and conditional logic.
* [**Certificate configuration**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-certificate-configuration) — defining certified-copy content, layout and security.
* [**Mapping offices and users**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-mapping-offices-and-users) — defining the administrative structure, offices, user roles and scopes.
* [**Dashboard**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-dashboard) — defining the analytics and vital-statistics dashboards.



**The configuration inputs** you produce, and the guide that supports each:

| Configuration input                                    | What it defines                                                          | Guide                     |
| ------------------------------------------------------ | ------------------------------------------------------------------------ | ------------------------- |
| **Administrative structure and locations**             | The jurisdictional hierarchy, registration offices and health facilities | Mapping offices and users |
| **Event business process flows**                       | The workflow and statuses each event moves through                       | Event configuration       |
| **Event business rules and requirements**              | The rules governing each event — time limits, eligibility, validation    | Event configuration       |
| **User roles and scopes**                              | Roles, permissions and scope-based access                                | Mapping offices and users |
| **Workqueues**                                         | The queues of records users work from, by status and role                | Event configuration       |
| **Event record actions** (actions and flag config)     | The actions available on a record, and flag configuration                | Event configuration       |
| **Event form definitions** (declaration, action forms) | Fields, ordering, validation and conditional logic                       | Form configuration        |
| **Certified-copy templates**                           | Certificate layout, legal content, security features and languages       | Certificate configuration |
| **Analytics and vital statistics dashboards**          | The dashboards and reporting outputs                                     | Dashboard                 |

{% hint style="info" %}
**Start from the defaults.** OpenCRVS ships with the Farajaland reference configuration. Use it as your worked example: configure against it and adapt, rather than starting from a blank set of inputs. It shows you the shape of the target artefact for each input above.
{% endhint %}

***

### 4. Outputs and definition of done

**Key outputs:** by the end of this stage you should have:

* approved mock-ups for registration forms, correction and print/record flows, vital-event certificates, and integration UI components
* interactive prototypes for any new features
* the completed configuration inputs listed in section 3.

**Definition of done:** you are ready to move to the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage when:

* \[ ] mock-ups and prototypes are signed off by stakeholders
* \[ ] each form field and rule traces back to a business rule or legal parameter
* \[ ] configuration inputs are complete and checked against the legal-parameter register, using the guides above
* \[ ] the completed configuration inputs are ready to apply in the Configuration stage.

***

### 5. Resources and support

The guides under this stage — [Event configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-event-configuration), [Form configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-form-configuration), [Certificate configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-certificate-configuration), [Mapping offices and users](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-mapping-offices-and-users) and [Dashboard](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification/guides/guide-dashboard) — are the working references for this stage.

For broader guidance on CRVS digitisation, see the [CRVS Digitisation Guidebook](http://www.crvs-dgb.org/). For any questions, contact [**team@opencrvs.org**](mailto:team@opencrvs.org).

{% hint style="info" %}
**Next:** this is the last stage of requirements gathering. With approved designs and completed configuration inputs in hand, you move on to [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) to build the system.
{% endhint %}
