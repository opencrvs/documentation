# Project planning

### 1. Introduction

“Failing to prepare is preparing to fail.” Before configuring OpenCRVS for a country, it is important to plan the overall digital transformation journey. Pre‑configuration activities help to:

* Build shared understanding of goals and constraints.
* Align stakeholders around a realistic implementation roadmap.
* Reduce rework during configuration by clarifying priorities early.
* Identify risks, dependencies, and data considerations in advance.

These activities sit **before** full configuration and pilot work, and make later phases faster and more effective.

***

### 2. Implementation phases

A typical OpenCRVS programme is organised into three main implementation phases, plus a pre‑transformation phase that can secure buy‑in and super‑charge business analysis.

1. **Proof of Concept (PoC)** – configure the core product with basic country inputs to prove OpenCRVS’ applicability and identify additional requirements.
2. **Pilot** – test OpenCRVS in a range of real‑world settings to prove that it works, improve the configuration, and refine a scalable, integrated rollout plan.
3. **Scale‑up** – expand digital services across the country using the integrated components tested in the pilot.
4. **Operational support** – manage and maintain the solution for the long term, including regular product upgrades and hot fixes.

Pre‑configuration activities prepare the country to move through these phases efficiently.

***

### 3. Roles and responsibilities

A successful OpenCRVS project needs clear ownership. The country owns the legal, operational and policy decisions that shape the system. The OpenCRVS team, an implementation partner, or another delivery team may provide product expertise, implementation guidance, configuration support, technical delivery and project coordination, depending on the agreed project approach.

The exact split between the OpenCRVS team, implementation partners, suppliers and local technical teams should be confirmed in the project scope, workplan or terms of reference.

| Activity                       | Country / government team                                                                                             | OpenCRVS team, implementation partner or delivery team                                                                                                                                               |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Project governance             | Appoint sponsor, decision-makers and working groups; approve scope, risks and milestones.                             | Advise on recommended governance and implementation approach; coordinate governance meetings, action logs and delivery reporting where agreed.                                                       |
| Vision, scope and roadmap      | Define country objectives, event types, locations, service channels and rollout priorities.                           | Explain OpenCRVS capabilities, constraints and typical implementation pathways; help translate objectives into a practical roadmap and workplan.                                                     |
| Stakeholder engagement         | Convene civil registration, health, statistics, identity, legal, ICT and local service stakeholders.                  | Advise on which stakeholder groups are usually needed; facilitate workshops, document decisions and follow up actions where agreed.                                                                  |
| Business analysis              | Confirm current processes, pain points, legal rules, future workflows and user needs.                                 | Lead or support analysis, process mapping and requirements documentation; provide product and CRVS domain guidance; challenge requirements that may add unnecessary complexity.                      |
| Legal and policy decisions     | Decide registration authority, legal source of truth, fees, certificate rules, privacy, data sharing and delegations. | Identify where legal or policy decisions affect configuration; provide examples from other implementations where appropriate; track unresolved decisions and dependencies.                           |
| Configuration decisions        | Approve forms, workflows, roles, scopes, workqueues, certificates, notifications and reporting requirements.          | Advise how requirements map to OpenCRVS configuration; prepare configuration specifications; configure the country instance where agreed; identify where custom development should be avoided.       |
| Technical environments         | Provide or approve hosting, domains, VPN/access, security requirements, backup expectations and production ownership. | Provide deployment guidance, reference architecture and product release information; install, configure or operate environments where agreed.                                                        |
| Data migration / digitisation  | Own source data; approve migration scope, mapping rules, legal status of records and exception handling.              | Advise on OpenCRVS data model, API approach, migration constraints and readiness criteria; build or run migration/digitisation tools, test loads, reconciliation and exception reports where agreed. |
| Integrations                   | Approve integration scope, data-sharing agreements, security model and operational ownership.                         | Explain available APIs, action triggers and product integration patterns; design, build, test and document integrations where agreed.                                                                |
| Testing and UAT                | Provide users, test scenarios, acceptance criteria and sign-off decisions.                                            | Prepare test plans, run QA, support UAT, advise on expected product behaviour, support issue triage and manage defect tracking where agreed.                                                         |
| Training and change management | Own user readiness, communication, policy updates and adoption across offices.                                        | Provide product knowledge and examples of role-based training needs; develop training materials, train users and support change activities where agreed.                                             |
| Deployment and rollout         | Approve rollout sequence, site readiness, go-live decision and local support arrangements.                            | Advise on readiness gates, product release considerations and support escalation routes; coordinate deployment logistics, site activation and go-live support where agreed.                          |
| Operational support            | Own day-to-day service operation, user administration, incident management and long-term sustainability.              | Provide product-level support routes, upgrades and fixes according to agreed support arrangements; provide L1-L3 support or managed service responsibilities where agreed.                           |

{% hint style="info" %}
The OpenCRVS team, implementation partners and suppliers should not be treated as the owners of country policy, legal interpretation, data ownership or operational sign-off. Those decisions must be made by the country registration authority and relevant government stakeholders. Delivery teams support those decisions by explaining product capabilities, risks, dependencies and good-practice implementation patterns.
{% endhint %}

***

### 4. Proof of Concept (PoC)

OpenCRVS can be quickly configured to meet the basic civil registration needs of a country. A **Proof of Concept** uses this capability to test the product and learn more about specific business needs and system requirements before committing to full implementation.

#### 4.1 What a PoC is

* A quick way to see how OpenCRVS can enable digital CRVS in your country.
* Use of existing functionality in the core product, applied to country‑specific data and workflows.
* An opportunity to learn what works and what does not, and to identify additional system requirements.
* Small‑scale field‑testing to gather user feedback and better understand requirements.
* A way to inform the development of a long‑term digitisation and investment strategy.

#### 4.2 What a PoC is not

* Not a full requirements‑gathering process (that happens once the country confirms it wants to use OpenCRVS).
* Not customisation of OpenCRVS with new features; no new functionality is built during the PoC.
* Not live registration of vital events; only mock data is used, so data sovereignty questions (such as in‑country hosting) do not affect the exercise.

#### 4.3 Outputs of a PoC

A typical PoC produces:

1. **Configured OpenCRVS instance** – a basic configuration for the country, hosted in the cloud.
2. **Analysis document** – including “as‑is” and “to‑be” process maps for key workflows.
3. **Requirements backlog** – a structured list of requirements identified during analysis that can be used for subsequent work (this is the start of a backlog, not a complete one).
4. **Pilot plan** – a high‑level plan for piloting the solution to inform a national‑scale CRVS digitisation effort.

These outputs feed directly into more detailed configuration and pilot planning. During a PoC, the OpenCRVS team may support rapid product configuration, product demonstrations, technical guidance and analysis of product fit. The country team should provide the business context, confirm whether the PoC reflects real operational needs, and decide whether to proceed to a pilot. A PoC should not transfer ownership of future legal, policy or operational decisions to the OpenCRVS team.

***

### 5. Pilot

A **pilot** is a small‑scale, real‑world implementation used to test feasibility, viability, and effectiveness before full‑scale roll‑out.

The purpose of a pilot is to **learn and inform scale‑up plans**, not to deliver a final, nationwide solution.

#### 5.1 Why pilot

* Validate that OpenCRVS works in different environments (urban, rural, health facilities, stand‑alone offices).
* Refine configuration (forms, workflows, roles, workqueues, communications) based on real usage.
* Test integrations with other systems (for example, health or ID systems) in a controlled way.
* Identify training, change‑management, and support needs for national roll‑out.

#### 5.2 Integrated pilot workstreams

A successful pilot is an **integrated programme**, not just a technology exercise. Each workstream should have a named country owner and, where relevant, an implementation partner or OpenCRVS team support role. Typical workstreams include:

* **Business analysis** – refine business and system requirements to help the country achieve its CRVS objectives.
* **Product configuration & testing** – design, configure, and test the country instance of OpenCRVS against agreed requirements.
* **Change management** – design and deliver activities that secure buy‑in from leadership and staff, and support behavioural change.
* **Training** – develop and implement scalable training that equips users to work effectively with OpenCRVS.
* **Monitoring & evaluation** – define key performance indicators (KPIs) and a continuous improvement approach that uses data from the pilot to adjust product, service design, and deployment.
* **Operational support** – establish tier 0–4 support (self‑help, helpdesk, technical support, vendor support) so services remain operational during the pilot.

Before the pilot starts, agree who leads each workstream, who provides input, who signs off outputs, and how issues are escalated. The OpenCRVS team should normally support product and technical questions, while the country team owns operational decisions and acceptance of the pilot model. Findings from these workstreams directly shape the design of the national scale‑up.

***

### 6. Establish project and team

OpenCRVS is designed to minimise technical effort for setup and configuration, but a small, well‑structured team is still essential for a successful implementation.

At a minimum, countries should identify **two core roles**:

* **Technical System Administrator** – responsible for installing, running, and maintaining the OpenCRVS infrastructure
* **Business Analyst / National System Administrator** – responsible for configuring application details, forms, workflows, and vital event certificates

For a full digitisation programme, additional skills are usually required, including designers, developers, QA engineers, and programme management roles. These roles may sit within government, an implementation partner, or another delivery organisation, but ownership must be explicit. The OpenCRVS team can advise and support, but the project should not assume that the OpenCRVS team will perform all business analysis, configuration, migration, training, deployment or operational support activities unless this is agreed in the project scope.

For detailed guidance on roles, skills, and team composition, see [establish-project-and-team.md](establish-project-and-team.md "mention")

***

### 7. Pre‑configuration checklist

Before starting detailed OpenCRVS configuration, countries should consider:

* **Vision and scope** – which event types, geographies, and service channels will be included in the PoC or pilot.
* **Governance, ownership and responsibilities** – who is responsible for decision‑making, sign‑off, day‑to‑day coordination, and each major activity across business analysis, configuration, infrastructure, migration, integrations, testing, training, deployment and support.
* **Data and integration landscape** – existing systems (for example, health, ID), data standards, and integration priorities.
* **Change readiness** – current processes, capacity, and any legal or policy changes required to support digital CRVS.
* **Resource planning** – availability of business analysts, implementers, trainers, and support staff to run the programme.
* **OpenCRVS team involvement** – what support is expected from the OpenCRVS team, what is expected from the country team, and what will be delivered by any implementation partner or supplier.

Clarifying these elements early helps ensure that subsequent configuration work across Events, Records, Workflows, Access, and Aggregate Data modules is grounded in a realistic, well‑understood plan.
