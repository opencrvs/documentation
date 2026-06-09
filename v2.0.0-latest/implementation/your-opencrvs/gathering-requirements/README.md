---
description: Collect and prepare all the inputs required for optimal product configuration.
---

# Gathering requirements

### 1. Introduction

Before you configure OpenCRVS for your country, you need to understand your civil registration reality — the law, the day-to-day processes, the people who run them, and the citizens they serve. This stage is where you gather that understanding and turn it into the concrete inputs an OpenCRVS configuration is built from.

Investing properly here pays off later. A configuration grounded in how registration actually works means less friction, less rework, and fewer surprises once you reach build, testing and roll-out.

{% hint style="info" %}
**What this stage produces:** a validated set of requirements and design artefacts — process maps, business rules, a prioritised feature scope, user roles and office hierarchy, integration use-cases, and configuration templates — ready to hand to the [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration) stage.
{% endhint %}

***

### 2. The four stages

Requirements gathering runs in four stages. Each one consumes the output of the stage before it, and the final stage hands its output to Configuration.

| Stage                                                                                                                                                             | What you do                                                                         | Key output                                                                   | Indicative duration\* |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | --------------------- |
| **1.** [**Desk research & planning**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/preparation-and-foundation)     | Collect and analyse the law, forms, certificates and procedures; plan the fieldwork | A fieldwork plan and a baseline understanding of the country's CRVS context  | 2–4 weeks             |
| **2.** [**Field Research & Discovery**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/field-research-and-discovery) | Interview, observe and shadow; map how registration really works                    | Validated "as-is" process maps and a business-rules register                 | 1–3 weeks in country  |
| **3.** [**Co-Design & Validation**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/co-design-and-validation)         | Run workshops to validate findings, agree scope and shape the future service model  | Prioritised features, user roles and office hierarchy, integration use-cases | 1–2 weeks             |
| **4.** [**Design & Specification**](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/gathering-requirements/design-and-specification)         | Turn the agreed scope into mock-ups, prototypes and configuration templates         | Approved configuration templates ready for build                             | 2–4 weeks             |

\*Indicative only. Effort scales with the number of events in scope, the geographic spread, and whether you are running a proof of concept or a national programme.

The handoff chain, end to end:

> **Desk research & planning** → fieldwork plan → **Field Research** → validated as-is maps + business rules → **Co-Design** → prioritised scope, roles, integrations → **Design & Specification** → configuration templates → **Configuration**

***

### 3. Where this sits in the implementation

Gathering requirements comes after you have done your [project planning](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/project-planning) and [established a core team](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/establish-project-and-team), and before [Solution architecture](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/solution-architecture) and [Configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/configuration).

**You are ready to start when:**

* a project sponsor is identified and the core team is in place — at minimum a Business Analyst and a Technical System Administrator (see [Establish project & team](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/establish-project-and-team))
* you have government agreement to engage registry, health and statistics stakeholders.

**You are ready to move on when:** you hold validated process maps, a business-rules register, a prioritised feature scope, finalised user roles and office hierarchy, integration use-cases, and approved configuration templates.

***

### 4. Who you need and how long it takes

Requirements gathering is led by a small, multidisciplinary team. The disciplines most specific to this stage are:

* **Business / process analysts** — to map processes and capture business rules
* **Qualitative researchers / designers** — to run interviews, observation and workshops
* **Discovery or product managers** — to drive prioritisation and scope
* **Local legal and civil-registration experts** — to interpret the legal framework and validate findings
* **Technical / systems analysts** — to assess existing systems and integration needs

For the full set of roles across the whole implementation — including the change management, training, deployment and monitoring roles you will need later — see [Establish project & team](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs/establish-project-and-team).

{% hint style="info" %}
**Sizing guidance:** A focused discovery for a proof of concept or single-province pilot — one or two vital events, a handful of sites — typically takes **6–12 weeks** end to end. A national programme covering all vital events, multiple administrative tiers and several integrations takes considerably longer and usually runs some activities (for example, desk research and fieldwork logistics) in parallel. Plan the stages to overlap where it is safe to do so, but do not start Co-Design before your field findings are validated.&#x20;
{% endhint %}

{% hint style="info" %}
**Embed your own people.** Wherever an implementing partner leads this work, include government staff (registrars, statisticians, IT) in the team throughout. They hold the contextual knowledge that makes findings accurate, and their involvement is what makes the resulting system sustainable after handover.
{% endhint %}

***

### 5. Principles to carry through every stage

* **Evidence-based.** Decisions are grounded in what you observe and validate in the field, not in assumptions or policy documents alone.
* **Inclusive.** Universal registration is the goal, so actively investigate barriers for under-served groups — rural and hard-to-reach populations, women, persons with disabilities, and displaced, stateless or undocumented people — and design for them, not around them.
* **Privacy by design.** OpenCRVS will hold sensitive personal data on the whole population. Capture data-protection, retention and access requirements from the outset; they shape user roles, access control and integrations.
* **Co-designed with government.** The future service model has to be one the government will commit to and run, so validate every major finding and decision with the people who own and operate the system.

***

### 6. Resources and support

For broader guidance on CRVS digitisation, including requirements and process mapping, see the [CRVS Digitisation Guidebook](http://www.crvs-dgb.org/).

For any questions about gathering requirements or configuring OpenCRVS, contact [**team@opencrvs.org**](mailto:team@opencrvs.org).

