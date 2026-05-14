# Data architecture

OpenCRVS treats every civil registry record as an **append-only sequence of actions** rather than a row you UPDATE. The current state of a record — what gets shown in search, on a certificate, in an analytics dashboard — is always _derived_ by folding those actions in order. This shapes nearly every other decision in the platform, so it's worth understanding before evaluating the rest.

### Life events are sequences of actions

A birth registration is not a single database write. It is a sequence such as:

```
CREATE → DECLARE → REGISTER → PRINT_CERTIFICATE → REQUEST_CORRECTION → APPROVE_CORRECTION
```

The record's current state at any point in time is the reduction of all actions from the first one onwards. All actions are immutable once written.

#### Why this shape?

* **Full audit trail by construction.** There is no separate audit log to maintain in lockstep with the data — the data _is_ the log. For a civil registry, where every change carries legal weight, this matters.
* **Reproducible state.** All consumers of OpenCRVS data can fold the same actions and arrive at the same state without coordination.

### PostgreSQL is the source of truth; Elasticsearch is a derived view

Action records are stored in PostgreSQL with a strict schema. Action payloads are JSON (jsonb) but validated against a Zod discriminated union before being accepted, so every row in `event_actions` is one of the known action shapes.

Elasticsearch holds the **current state** of every record — i.e. the reduced view — for search and listing screens. It is fully derivable from PostgreSQL:

* The ES index is rebuilt on every deploy.
* It can also be rebuilt manually at any time.
* The reduction is a plain fold over an array of objects; there is no snapshotting, no checkpointing — it is always a full replay from action #1.

Records are expected to accumulate well under 100 actions over their lifetime (typically around 20), which keeps the fold trivially fast both on the server and in the browser. The same reducer code runs in both places.

PostgreSQL is backed up nightly to a separate server.



### Concurrency: record assignment, not merge

OpenCRVS avoids the offline-first conflict-resolution problem by **assigning** a record to one user at a time. Assignment is itself an action (`ASSIGN` / `UNASSIGN`), and only the currently assigned user can write further actions. Two system users cannot race; a second system user must wait for the first to release the record.

This is intentional. Civil registry actions are deliberative — declaring a birth or approving a correction is not a write you want to silently merge with a competing write — and the assignment model keeps the data model simple while reflecting how registry offices actually work.

### Offline-first clients hold actions until acknowledged

The web client is designed for field work in low-connectivity environments. When a user submits an action, the client does not consider the action "delivered" until the backend has confirmed it was processed correctly:

* The action sits in an **outbox** persisted to IndexedDB on the device.
* It is retried until the backend acknowledges it.
* Only then is it removed from the outbox.

Because state is derived from actions, the same reducer used on the server can be run locally over the outbox to show the user what their record _will_ look like once their pending actions sync.

### Files are uploaded ahead of the action

Attachments — supporting documents, photos, signatures — are not sent inside the action payload. Instead:

1. As soon as the user adds a file in the form, the client uploads it directly to S3-compatible static storage.
2. The storage layer returns a unique file path.
3. That path is embedded into the eventual action payload.

This means uploads happen _while the user is still filling out the form_, not at submit time. By the time the form is submitted, the heavy work is already done and the action itself is small and fast.

When an action is processed, the backend verifies that every referenced file path actually exists before accepting the action. It also **cleans up unreferenced files for the event in the same step**: any file uploaded under the event's prefix that is not referenced by the freshly-computed state is deleted. There is no scheduled GC job — orphan cleanup is reactive, on every action.

### Country configuration receives every action

OpenCRVS Core is event-agnostic. The concepts of "birth", "death", "marriage" do not exist inside core — they are defined entirely by a **country configuration server** that each implementing country runs and owns. The configuration defines event types, form fields, validation rules, certificate templates, business rules, and notification logic.

On every action the core sends the **full event document** (the event metadata plus the complete raw action history) to the country configuration server. Country config can:

* Handle the action **synchronously** — respond with 200 to confirm, or an error to reject and have it retried.
* Handle it **asynchronously** — respond with 204 and call back later via APIs to confirm completion.

If the country configuration server is unreachable or returns an error, the user-facing action **fails** and is retried until country config is back up. This is deliberate: country config often holds business rules that the core cannot validate on its own (e.g. legal eligibility), so accepting an action that country config would have rejected is worse than asking the user to wait.

Delivery is **at-least-once**: a retried action after a country config 5xx may be delivered more than once, so country config integrations should be idempotent.

This integration point is where countries typically wire in their analytics warehouses, downstream identity systems, statistical bureaus, and so on — by subscribing to the action stream rather than reaching into core's database.

### What this means for adopters

* **Configurability is per-country, not per-deploy.** Event types and payload schemas are owned by your country configuration server. Birth/death/marriage are not hardcoded in the core.
* **The full history is non-negotiable.** Actions are immutable; corrections happen by appending new actions, not by editing past ones. Errors stay visible in the log but no longer affect the derived state.
* **You can rebuild from Postgres alone.** Losing Elasticsearch is recoverable; losing Postgres is not. Backup strategy should focus there.

