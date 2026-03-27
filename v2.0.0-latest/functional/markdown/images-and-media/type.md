# Type

### 1. Introduction

In OpenCRVS, an **event type** represents a kind of civil event that can be declared, registered, and certified. Each event type:

* Relates to one or more specific people (for example, child, mother, spouse, deceased).
* Occurs on a specific date (and optionally at a specific time and place).
* Has a set of data fields that describe what happened (for example, cause of death, place of birth).

OpenCRVS is not limited to births and deaths. Any civil event that can be clearly defined in terms of **who** it affects and **when** it occurred can be modelled as an event type.

***

### 2. Examples of civil event types

Common examples of civil events that can be configured in OpenCRVS include:

* Birth
* Death
* Stillbirth
* Foundling
* Marriage
* Divorce
* Adoption
* Legitimation
* Recognition
* Name change
* Address change

Countries can choose which event types to enable and how to name them, based on their legal framework and CRVS policy.

***

### 3. Configuring event types in OpenCRVS

Each event type can be configured to match country requirements. At a high level, configuration covers:

* **Forms and data**
  * Which fields are captured (for example, parents’ details, cause of death, place of marriage).
  * Which fields are mandatory vs optional.
* **Workflows and approvals**
  * Which record actions are available (for example, Notify, Declare, Validate, Register, Correct).
  * What deduplication checks should run.
  * Which workqueues surface records for review.
* **Roles, scopes, and jurisdiction**
  * Which user roles can create, review, approve, or correct records for that event type.
  * Jurisdiction rules based on event location, declared-in, or registered-in.
* **Outputs and post-registration steps**
  * Certificate templates for each event type.
  * Optional integrations such as verifiable credentials.

This configuration model allows a country to support **all relevant civil events** in a consistent way, while tailoring details to national law and practice.
