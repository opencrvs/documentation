# Guide: Mapping offices and users

#### 1. Introduction

This guide helps you turn the validated office hierarchy and user roles from **Co-Design & Validation** into the configuration inputs that the build team needs. Working through it produces two of the inputs listed in [Design & specification](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/gathering-requirements/design-and-specification):

* **Administrative structure and locations** — the jurisdictional hierarchy, registration offices and health facilities.
* **User roles and scopes** — the roles your staff perform, and the scope-based permissions and jurisdictions that govern them.

Use this page when you are deciding how your country's administrative geography, offices and user roles should be modelled in OpenCRVS. It explains _what to decide and why_; the full reference for how the concepts behave lives in the functional docs, linked throughout.

{% hint style="info" %}
**Start from the defaults.** OpenCRVS ships with the Farajaland reference configuration. Configure against it and adapt, rather than starting from a blank page — it shows you the shape of each artefact you need to produce.
{% endhint %}

***

#### 2. What's different in 2.0

If you are coming from earlier versions, three shifts change how you do this mapping:

* **Custom roles replace fixed system roles.** You are no longer mapping staff onto a fixed set of standard roles with fixed privileges. You define as many custom roles as you need and compose each one from **scopes**.
* **Offices can sit at any level of the hierarchy.** They are no longer always pinned to the lowest administrative level. A user's reach is _computed_ from where their office sits in the hierarchy.
* **Jurisdiction lives on the scope.** Each scope carries its own qualifier deciding _where_ the user can act, so one role can reach differently for different actions, and two users with the same role get different reach from their office location.

For the full model — the scope catalogue, jurisdiction qualifiers and values, and how routing works — see [Users](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/users) and [Administrative structure](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure).

***

#### 3. The key principle: offices carry no behaviour, users do

This is the idea country teams most often need to unlearn:

> **Being called an "office" gives a location no registration capability of its own. What happens at a location is determined entirely by the roles, scopes and jurisdictions of the users assigned to it.**

A "Registration Office" staffed only by users with notify scopes is a notification point. A "Health Facility" staffed by users with register scopes can register. The location type is descriptive — it labels the place for people and for reporting; it does not grant permissions.

So when stakeholders draw "this office sends records to that office", that flow is the _result_ of how the users at each office are scoped and where their jurisdictions overlap — not something configured on the offices. Your task is to capture the offices and the scoped roles that, together, produce the flow they describe.

***

#### 4. Do's and don'ts

**4.1 Do**

1. **Model the administrative hierarchy on the country's real geography.** It drives address capture and the aggregation of vital statistics, not just registration — so it must match the official structure and the levels at which you need to report.
2. **Place offices at the level they genuinely operate.** National, provincial, district or sub-district — or directly under the country (for an HQ or embassy). Let jurisdiction follow from the hierarchy.
3. **Start roles from real job functions.** Field Agent, Registration Agent, Registrar, Provincial Officer, National Administrator, and any country-specific role — then translate what each needs to do into scopes.
4. **Choose the narrowest jurisdiction each scope needs.** Tune jurisdiction per scope: a Registrar might search across a province but register only in their own district.
5. **Assign every participating user to one location and one role.** Anyone who performs an OpenCRVS action — including a health administrator or court clerk acting as a field agent — is a user assigned to a location.

**4.2 Don't**

1. **Don't try to give an office permissions.** Capability comes from users' roles and scopes, never from the office itself.
2. **Don't force staff into generic roles.** With unlimited custom roles, model the role that matches the real job rather than approximating it.
3. **Don't default every scope to the same jurisdiction.** Decide deliberately, per scope, between the user's exact office, their whole area and its children, only records they personally touched, or unrestricted.
4. **Don't leave routing gaps.** Every record state that needs human attention must surface in a queue for the right role; check there are none that a role can create but not progress.
5. **Don't assume 1.x terms still exist.** `record.reinstate` and `record.assign` are not 2.0 scopes, and there is no `notified_in` jurisdiction qualifier yet — design around these.

***

#### 5. How to approach the mapping

Work through these in order with your stakeholders. Each step produces part of the input set.

1. **Model the administrative hierarchy** — every administrative tier and area, with each area's parent. Branches can be uneven; not every level need appear everywhere.
2. **Place the locations** — every office, health facility, community point, court or embassy that takes part in registration, its type, and the administrative area it sits in.
3. **List the roles** — the real job functions in your to-be Service Delivery Model.
4. **Translate each role into scopes** — list the actions each role performs, for which events, and set the jurisdiction qualifier on each scope. Keep the create / notify / declare scopes aligned for jurisdiction-limited roles.
5. **Attach workqueues** — only the queues each role needs, named from the user's perspective.
6. **Assign users** — one location and one role each; reach follows automatically from the office location.
7. **Trace the routing end to end** — for each event, confirm every state needing attention surfaces in exactly one queue for exactly the right role.

***

#### 6. Questions to guide your mapping

* **Hierarchy** — Does the structure match the country's real geography _and_ the levels at which vital statistics must aggregate?
* **Offices** — At which level does each office genuinely operate? Are any best placed directly under the country?
* **Roles** — Are you starting from real job functions rather than forcing staff into generic roles?
* **Scopes and jurisdiction** — For each scope, is the jurisdiction the narrowest that still lets the role do its job? Are create, notify and declare aligned for jurisdiction-limited roles?
* **Workqueues** — Does every role see only the queues it needs, named from its own perspective?
* **Routing** — Trace each event end to end: exactly one queue for every state needing attention, behind exactly the right role, with no record a role can create but not progress?

***

#### Related pages

* [Administrative structure](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/administrative-structure) — functional reference for the hierarchy, offices and routing.
* [Users](https://documentation.opencrvs.org/v2.0/functional/markdown/workflows/users) — functional reference for roles, scopes, jurisdiction and workqueues.
* [Administrative hierarchy](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/administrative-hierarchy) and [Roles and scopes](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/users/roles-and-scopes) — technical configuration.
* [Guide: Event configuration](https://documentation.opencrvs.org/v2.0/implementation/your-opencrvs-project/gathering-requirements/design-and-specification/guides/guide-event-configuration) — the sibling design guide for workflows and workqueues.
