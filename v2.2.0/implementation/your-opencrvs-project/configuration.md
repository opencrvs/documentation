# Configuration

### 1. Introduction

Configuration is where your **to-be design becomes a working system**. You take the configuration inputs that were defined and signed off in [Design & Specification](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification) and implement them, so that OpenCRVS reflects your country's events, forms, business rules, offices, roles, certificates and dashboards.

This page is a high-level, non-technical overview of how configuration works and what it involves. The step-by-step technical instructions live in the [technical configuration guides](https://documentation.opencrvs.org/v2.0/technical/guides/configuration).

{% hint style="info" %}
**Where this sits:** Configuration follows [Gathering requirements](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements) — specifically [Design & Specification](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification), where the configuration inputs are created — and comes before [Deployment](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/deployment) and go-live.
{% endhint %}

***

### 2. What goes into configuration

Configuration starts from the **signed-off configuration inputs** produced in [Design & Specification](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification):

* Administrative structure and locations
* Event business process flows
* Event business rules and requirements
* User roles and scopes
* Workqueues
* Event form definitions (declaration, action forms)
* Event record actions (actions and flag config)
* Certified-copy templates
* Analytics and vital statistics dashboards

{% hint style="info" %}
**Don't start before sign-off.** Configuration implements decisions that have already been agreed. If the requirements are not yet signed off, you risk building — and then rebuilding — against a moving target. Confirm sign-off first.
{% endhint %}

***

### 3. How configuration works

OpenCRVS separates the **core product** from a **country configuration**. The core software is the same for every country; everything specific to your country — its events, forms, rules, offices, roles, certificates and dashboards — lives in the country configuration, which your technical team sets up and maintains. This is what lets you tailor OpenCRVS without changing the core software.

At a high level, completing the configuration means:

1. **Set up the country configuration** — establish the configuration and the environments (for example development, staging and production) it will be applied to.
2. **Implement each configuration input** — translate each signed-off input into the country configuration: the administrative structure and locations, the events and their process flows, business rules, form definitions, record actions and workqueues, user roles and scopes, certified-copy templates, and dashboards.
3. **Load the reference data** — import the supporting data the system needs, such as administrative locations, health facilities and initial users.
4. **Review against the signed-off requirements** — confirm the configured system matches what was agreed.

Each of these steps has detailed instructions in the [technical configuration guides](https://documentation.opencrvs.org/v2.0/technical/guides/configuration). This work is led jointly by your Technical System Administrator and Business Analyst (see [Establish project & team](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/establish-project-and-team)): the analyst confirms the configuration matches the requirements, and the administrator implements and deploys it.

***

### 4. Validate and iterate

Configuration is not finished when the inputs are loaded — it is finished when the system **behaves as the signed-off requirements describe**. Test the configured system against those requirements, fix any gaps, and validate with stakeholders. See [Quality assurance](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/quality-assurance) for how to test the configuration before go-live.

***

### 5. When configuration is complete

Configuration is done when:

* \[ ] every configuration input has been implemented in the country configuration
* \[ ] the configured system matches the signed-off requirements
* \[ ] the configuration has been tested and validated (see [Quality assurance](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/quality-assurance))
* \[ ] the configuration is ready to deploy (see [Deployment](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/deployment)).

***

### 6. Resources and support

* [Technical configuration guides](https://documentation.opencrvs.org/v2.0/technical/guides/configuration) — step-by-step instructions for implementing each configuration input.
* [Design & Specification](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification) — where the configuration inputs are defined and signed off.
* [Quality assurance](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/quality-assurance) and [Deployment](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/deployment) — the stages that follow configuration.
