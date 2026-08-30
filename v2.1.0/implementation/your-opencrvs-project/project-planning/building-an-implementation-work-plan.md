# Building an implementation work plan

### 1. Introduction

An OpenCRVS implementation is a multi-workstream programme that touches technical, operational, legal, and organisational change. The **work plan** is the document that turns the implementation intent — captured in the signed programme cost and scope — into a coherent set of phases, deliverables, resources, and checkpoints that the delivery team can execute against.

Every Implementation Partner will bring its own project management style, tooling (Microsoft Project, Excel, Notion, Jira, PowerPoint), and internal governance. This page does not prescribe a template. It describes what the work plan must cover to support an OpenCRVS implementation from mobilisation through go-live and into operational support, and highlights areas that partners commonly underestimate.

### 2. Purpose of the work plan

The work plan translates the agreed cost into a delivery schedule. It should let a country stakeholder, the Project Manager, and the OpenCRVS Support team all see the same picture:

* Which phases the programme moves through, in what order, and over what duration
* Which resources are needed for each phase, from which discipline
* Which deliverables mark the end of each phase and what decisions depend on them
* Which dependencies — between workstreams, between the partner and the country, and between the country and third parties — control the critical path
* Which risks are being tracked and how they are mitigated

A useful work plan is not a static Gantt chart. It is the living record that the programme uses to decide what to do next, what to escalate, and what to move.

### 3. Phases of an OpenCRVS implementation

The 2.0 documentation describes the implementation lifecycle in detail — see [Your OpenCRVS Project](../). The work plan should reflect all of the following phases as distinct blocks of work, with entry criteria, deliverables, and exit criteria for each. The duration of each phase varies significantly by country, but the sequence and shape are stable.

* **Project planning.** Programme scope agreed, funding confirmed, executive sponsor identified. Deliverables: signed programme scope, budget envelope, high-level timeline, governance structure.
* **Establish project and team.** Country and partner team mobilised. Deliverables: staffed team on both sides, ways-of-working agreed, tooling in place, kick-off held.
* **Gathering requirements.** Country context understood, business rules captured. Deliverables: business requirements document, decisions log, stakeholder map. See the requirements-gathering sub-guides for preparation, field research, co-design, and design & specification.
* **Solution architecture.** Technical solution agreed within the country's infrastructure and integration constraints. Deliverables: solution architecture document, integration list, non-functional requirements, security posture.
* **Configuration.** Country configuration package built, tested, and iterated. Deliverables: configured events, forms, roles, workqueues, certificates, dashboards, translations, integrations.
* **Deployment.** Environments provisioned and OpenCRVS deployed. Deliverables: development, staging, and production environments, backup and restore rehearsed, monitoring in place.
* **Legacy data migration.** Historical records brought into OpenCRVS. Deliverables: mapping specification, cleansing pipeline, migrated records, reconciliation report.
* **Quality assurance.** End-to-end verification against country requirements. Deliverables: test plans and evidence, defect log, sign-off for go-live.
* **Go-live.** Live cutover with the country's registration operations. Deliverables: go-live runbook, cutover plan, hyper-care schedule, communications to informants and staff.
* **Operational support.** Post-go-live stabilisation and handover to country support teams. Deliverables: support model, incident response process, training records, knowledge transfer artefacts.
* **Monitoring.** Ongoing observability of the platform against agreed service levels. Deliverables: dashboards, alerts, reporting cadence.
* **Upgrading.** Planned uptake of OpenCRVS releases across the country's environments. Deliverables: upgrade schedule, testing plan, rollback plan.

Some phases overlap; others are strictly sequential. A useful work plan makes the overlaps and the strict handovers explicit.

### 4. Workstreams and roles

Within each phase, work runs in parallel workstreams. A typical OpenCRVS pilot organises around six of these:

* **Business analysis** — refines business and system requirements against country context.
* **Product configuration and testing** — designs, configures, and tests the country instance of OpenCRVS.
* **Change management** — secures buy-in from leadership and staff and supports behavioural change.
* **Training** — develops and delivers scalable training so users can work effectively with OpenCRVS.
* **Monitoring and evaluation** — defines KPIs and a continuous improvement approach that uses pilot data to adjust product, service design, and deployment.
* **Operational support** — establishes tier 0 to tier 4 support (self-help, helpdesk, technical support, vendor support) so services remain operational throughout.

The roles that staff these workstreams scale with the ambition of the implementation. The set below is the same as the one defined in [Establish project & team](../establish-project-and-team.md); it is grouped here through the work-plan lens — from the minimum needed to run a Proof of Concept to the full team for a national rollout. See the linked page for the full responsibilities, skills, and hiring guidance for each role.

**Core roles** (minimum needed to set up OpenCRVS for a Proof of Concept or pilot):

* **Project Manager** — owns the plan, the risk register, and the country relationship.
* **Business Analyst(s)** — lead requirements gathering, the decisions log, and configuration inputs.
* **Technical System Administrator / DevOps Engineer** — provisions environments, manages secrets, backups, monitoring, and deployment.

**Additional technical roles** (when custom development or deeper user research is in scope):

* **Design Researchers / Qualitative Researchers** — conduct user research and service design work that informs requirements.
* **UX/UI Designer** — designs custom interfaces where OpenCRVS is extended beyond the core product.
* **Technical Architect** — owns the technical solution, integration strategy, and non-functional posture.
* **Software Developers** — extend or integrate where configuration is not sufficient.
* **Test Lead / Quality Assurance Engineers** — plan and execute testing across configuration, integration, and non-functional dimensions.

**Programme and change management roles** (essential for adoption, sustainability, and national rollout):

* **Change Management Lead** — designs the change strategy that secures buy-in and supports staff transition.
* **Training Lead / Trainers** — design the training programme and deliver it across user roles.
* **Deployment Team** — plans and coordinates national rollout, site readiness, and go-live logistics.
* **Monitoring & Evaluation Lead** — defines KPIs, monitors performance, and drives continuous improvement.

**Country-side counterparts** — the plan should also account for country-side counterparts, who vary by context. Commonly they include registrars, statisticians, national ID authority engineers, health information system contacts, legal and policy advisers, and IT operations. Their availability is a common critical-path assumption; the plan should treat it as one to be verified, not assumed.

The work plan should show, for each phase, which roles are active, when they are needed to start, when their contribution ends, and where they hand off. Under-planning either the country side or the operations side (procurement, cloud provider, telco for connectivity) is the most common cause of critical-path slippage.

### 5. Technical planning prompts

Technical items are covered in detail across the docs pages under Your OpenCRVS. The prompts below are a project-management lens on those pages — questions a plan should answer before each phase closes, so nothing lands on the critical path by surprise. Use them as a checklist for the plan itself, not as a substitute for the underlying guidance.

* **Environments** — where will development, staging, and production run? Who procures them, and how far in advance?
* **Domain and DNS** — which domains are in scope (gateway, login, additional environments), and who owns their registration and delegation?
* **Certificates and TLS/SSL** — are certificates issued via Let's Encrypt, country-provided PKI, or another route? How is renewal automated? See the [installation guides](../../../technical/guides/installation/).
* **Secrets and credentials** — where are secrets stored, how are they rotated, and who has access?
* **Country configuration package** — how are the configured events, forms, roles, workqueues, certificates, and translations built, reviewed, and versioned? See the [configuration guides](../../../technical/guides/configuration/).
* **Third-party integrations** — for each integration in scope (identity, health, verifiable credentials, communications, others), which third-party team is involved, what resources are needed on each side, and when does the work start? See the [interoperability docs](../../../functional/markdown/interoperability/).
* **Legacy data migration** — what historical records are in scope, who owns transformation and reconciliation, and what is the cutover plan for live registrations mid-migration? See [Migrate legacy data](../migrate-legacy-data.md).
* **Backups and disaster recovery** — are backups automated? Have restores been rehearsed? What are the recovery-time and recovery-point targets? See the [backup and restore guides](../../../technical/guides/installation/opencrvs-maintenance-tasks/backup-and-restore/).
* **Monitoring, alerting, and logging** — what does "healthy" look like, and who is on call? See [Monitoring](../monitoring.md).
* **Upgrade path** — how will the country take future OpenCRVS releases without disrupting service? See [Upgrading](../version-upgrades.md).

### 6. Non-technical planning prompts

Technical delivery is only part of an OpenCRVS implementation. The prompts below are the non-technical axes a work plan should also answer for.

* **Legal and policy alignment** — does the current civil registration law support the intended digital workflows? Are any executive orders, legal sandboxes, or data-protection sign-offs needed, and by when?
* **Stakeholder engagement** — what is the cadence of steering committee meetings, working groups, and ministry updates, and who owns it?
* **Training, change management, and standard operating procedures** — what training materials are needed, how do they cascade to registration officers, and when? How will staff use OpenCRVS day to day, and what are the offline and escalation procedures? See the Change Management Lead and Training Lead responsibilities in [Establish project & team](../establish-project-and-team.md).
* **Go-live communications** — what needs to be communicated to registration staff, informants, and the public, and how does this coordinate with the ID and health authorities?
* **Post-go-live support model** — what does the country-side helpdesk look like, and how do second- and third-line support hand-offs work? See [Operational support](../operational-support.md).

### 7. Tracking, dependencies, and risk&#x20;

The work plan should be a live artefact. To be useful during delivery it needs to expose:

* **Progress** — completion status against each deliverable, with dates, ideally attached to concrete evidence (a merged pull request, a signed-off requirements document, a passed acceptance test).
* **Responsibility** — every line item on the plan should show who owns it: the Implementation Partner (SI), the country, or both. Larger plans may use a full RACI matrix (Responsible / Accountable / Consulted / Informed). Ambiguity about ownership is one of the most common causes of delayed action.
* **Dependencies** — internal (one workstream waiting on another), external to the partner (country decisions, third-party integrations), and external to the country (cloud provider, telco, ID authority release cycles).
* **Decision points** — where the programme needs to choose between options, and by when.
* **Risks** — with likelihood, impact, owner, and mitigation. Risks that materialise become issues; issues that go unresolved become escalations.
* **Change control** — how scope, timeline, or resourcing changes are captured and approved.

The tool used is less important than the discipline of updating it. A plan that is out of date within two weeks of kick-off will not be trusted by anyone on the programme, and the delivery team will fall back to informal communication.

### 8. Common oversights&#x20;

The following items are consistently missed in first-draft work plans and consistently cause delivery pain:

* Not planning the country side. Country counterparts are often part-time on the programme and have day jobs; assumed availability is a common failure mode.
* Treating all third-party integrations as one line item. Each integration (identity, health, verifiable credentials, communications, payments) has its own third-party team, resource footprint, and approval cycle. Lumping them together hides the resource demand and the critical-path risk.
* Skipping backup and restore rehearsal. Rehearsing a restore before go-live is what turns a backup strategy into an actual disaster recovery capability.
* Under-planning training. Training rarely happens once — it happens on rollout, again on refresh, and again on turnover.
* No plan for the day after go-live. Hyper-care, incident response, and second-line support arrangements need to be booked in advance, not improvised in the first week.
* No plan for the next release. OpenCRVS releases regularly; the country's approach to taking upgrades should be part of the initial plan, not deferred.
* Legal and policy alignment left too late. Executive orders, data-sharing agreements, and public communications need long lead times.

### 9. Summary

A good OpenCRVS work plan is:

* Complete across all phases from planning to upgrading
* Explicit about who is doing what and when
* Honest about dependencies inside the partner, in the country, and with third parties
* Actively maintained and referenced during delivery
* Readable by a country stakeholder, the Project Manager, and an OpenCRVS Support engineer

It is not a Gantt chart for its own sake, and it is not a document that lives in a drawer after kick-off. It is the shared source of truth that carries the programme from a signed cost sheet to a healthy live registration service.
