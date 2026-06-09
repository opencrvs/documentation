---
description: Creating implementation-ready deliverables
---

# Design & specification

### 1. Introduction

This is the final stage of [Gathering requirements](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements). It turns the validated scope, roles and workflows from [Co-Design & Validation](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/co-design-and-validation) into tangible design artefacts and configuration inputs that a team can build from with minimal ambiguity.

Working through design before build does two things: it lets you validate the proposed solution with stakeholders before any intensive coding, and it produces the configuration templates that the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage consumes directly.

{% hint style="info" %}
**What this stage produces:** approved mock-ups and prototypes, and a set of configuration templates (event definitions, certified copies, and users/roles/scopes). The templates are the inputs to the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage.
{% endhint %}

**When:** This stage follows Co-Design & Validation and closes out requirements gathering. Indicative duration: **2–4 weeks**, depending on the number of events in scope and how much is configured with defaults versus designed afresh.

**Before you start, you should have** the outputs of Co-Design & Validation:

* a prioritised feature list and service-concept epics
* a future Service Delivery Model (SDM) for each in-scope event
* validated office hierarchy and user roles, and agreed integration use-cases
* the business-rules register and non-functional requirements from earlier stages, to design against.

***

### 2. Design the experience

Produce visual mock-ups and interactive prototypes so stakeholders can see and validate the solution before it is built. Trace every screen back to the business rules and legal parameters captured earlier, so design decisions are grounded rather than invented.

#### 2.1 Registration form mock-ups

For each in-scope event, mock up the registration form: the fields, their order, conditional logic, and validation. Each field and rule should be traceable to a business rule or legal parameter from earlier stages. These feed the [Form configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-form-configuration) guide.

#### 2.2 Correction and print/record flow mock-ups

Mock up how corrections and record printing behave — including the difference between administrative and court-ordered corrections, and how a certified copy is printed and reissued. This makes the workflow rules concrete before configuration.

#### 2.3 Vital-event certificate mock-ups

Design the certified copy for each event: layout, the legally required content, security features, and any languages or scripts. These feed the [Certificate configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-certificate-configuration) guide.

#### 2.4 Integration UI component mock-ups

Where an integration surfaces in the interface — for example a National ID lookup or a health-facility notification intake — mock up the components so the interaction and the data shown are agreed before build.

#### 2.5 Prototypes of new features

For anything beyond OpenCRVS default behaviour, build an interactive prototype. Prototypes are the cheapest way to test a new idea with stakeholders and surface problems while they are still easy to change.

***

### 3. Produce the configuration templates

These are the bridge artefacts that hand requirements gathering over to the build. Each maps to a configuration guide, and together they are the inputs listed on the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage.

| Configuration template           | What it captures                                                | Feeds                                                                                                                                                  |
| -------------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Event definitions**            | The events in scope, their statuses and workflow                | [Event configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-event-configuration)             |
| **Form definitions (per event)** | Fields, validation and conditional logic                        | [Form configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-form-configuration)               |
| **Certified-copy templates**     | Certificate layout, legal content, security features, languages | [Certificate configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-certificate-configuration) |
| **Users, roles and scopes**      | Roles, permissions and office hierarchy                         | [Mapping offices and users](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-mapping-offices-and-users) |

{% hint style="info" %}
**Start from the defaults.** OpenCRVS ships with the Farajaland reference configuration. Use it as your worked example: configure against it and adapt, rather than starting from a blank template. It shows you the shape of the target artefact for each of the templates above.
{% endhint %}

***

### 4. Outputs and definition of done

**Key outputs:** by the end of this stage you should have:

* approved mock-ups for registration forms, correction and print/record flows, vital-event certificates, and integration UI components
* interactive prototypes for any new features
* completed configuration templates: event definitions, form definitions, certified copies, and users/roles/scopes.

**Definition of done:** you are ready to move to the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage when:

* \[ ] mock-ups and prototypes are signed off by stakeholders
* \[ ] each form field and rule traces back to a business rule or legal parameter
* \[ ] configuration templates are complete and checked against the legal-parameter register
* \[ ] the completed templates are handed to the Configuration stage as its inputs.

***

### 5. Resources and support

The configuration templates produced here are used in the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage. See the configuration guides for [events](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-event-configuration), [forms](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-form-configuration), [certificates](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-certificate-configuration), and [mapping offices and users](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration/guides/guide-mapping-offices-and-users).

For broader guidance on CRVS digitisation, see the [CRVS Digitisation Guidebook](http://www.crvs-dgb.org/). For any questions, contact [**team@opencrvs.org**](mailto:team@opencrvs.org).

{% hint style="info" %}
**Next:** this is the last stage of requirements gathering. With approved designs and completed configuration templates in hand, you move on to [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) to build the system.rpose
{% endhint %}
