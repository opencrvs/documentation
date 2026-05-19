# Workflows

### Overview

As part of the **Functional Architecture**, the **Workflows** section describes the workflow module in OpenCRVS — how records move through the system and how users interact with them at each step.

It is organised into the following modules:

* **Administrative Structure** —
* **Users** — describes how user roles, scopes, and jurisdictions determine who can see which records and perform which actions in a workflow.
* Jurisdictions
* **Actions** — explains the building blocks of workflows: the actions users can take on a record (for example, Notify, Declare, Register, Correct), how actions change status and flags, and how custom actions are configured.
* **Workqueues** — covers how records are surfaced to users as work items, using filters, assignment, and queue configuration to support day-to-day operations (review, validation, approval, certification).
* **Offline working** — describes how users can continue workflow steps when offline, including assignment, Outbox behaviour, and how offline actions are synchronised and audited.
* **Deduplication** — explains how OpenCRVS detects and manages potential duplicate records, and how review actions (Mark as duplicate / Mark not duplicate) fit into the overall record workflow.
* **Comms** — describes how communications (SMS, email) are triggered from actions in the workflow, for example sending notifications to informants when a record is registered, rejected, or requires correction.

These modules together show how to translate country business rules into concrete, action-driven workflows in OpenCRVS.
