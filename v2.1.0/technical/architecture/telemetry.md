# Telemetry

OpenCRVS can share a small **daily usage summary** with the OpenCRVS status service. It is **anonymous and aggregate** — plain counts such as "how many records are registered" and "how many users are active". **No personal data, no health data, and no record-level data ever leaves your instance.**

Telemetry is **opt-in**. A freshly scaffolded country config ships with it disabled, and it is only ever sent from **production** instances.

***

### Why we collect it

OpenCRVS is a global public good deployed by governments and organisations around the world. We usually have no visibility into where it runs or how much it is used, which makes it hard to:

* **Understand adoption** — how many instances are live, and roughly how much civil registration work they carry.
* **Prioritise the roadmap** — invest in the events, workflows, and scale points that are actually in use.
* **Spot problems early** — e.g. an instance whose reporting stops, or numbers that suggest a scaling issue.
* **Tell the story of impact** — aggregate, anonymised figures help demonstrate to funders and partners that the software is delivering real value.

The goal is a lightweight signal of usage and health — never surveillance of individuals or records.

***

### Privacy principles

* **Aggregate only.** Every metric is a total or a count. There are no per-person or per-record rows.
* **No personal or protected data.** No names, dates of birth, identifiers, addresses, health information, or any field from any registration record is collected or transmitted.
* **Opt-in.** Nothing is sent unless an operator sets `TELEMETRY_ENABLED=true`.
* **Transparent.** The instance logs its telemetry configuration at startup, and everything documented here is exactly what the code collects.

***

### What exactly is collected

#### Usage metrics

Collected by the events service directly from the events database. Every value is a single number.

| Metric key                            | Meaning                                                                                                                                                     |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `events.total`                        | Total number of events (records) in the system.                                                                                                             |
| `declarations.registered`             | Total registered declarations (an event with an accepted `REGISTER` action).                                                                                |
| `declarations.registered.<eventType>` | The above, broken down per event type, e.g. `declarations.registered.birth`.                                                                                |
| `declarations.pending`                | Events that have been declared but not yet registered.                                                                                                      |
| `certificates.printed`                | Total certificates printed (each accepted `PRINT_CERTIFICATE` action; a record printed twice counts twice, so this can exceed the number of registrations). |
| `certificates.printed.<eventType>`    | The above, broken down per event type, e.g. `certificates.printed.death`.                                                                                   |
| `users.total`                         | Total number of user accounts.                                                                                                                              |
| `users.active`                        | Number of user accounts with `active` status.                                                                                                               |
| `system.uptime_seconds`               | Process uptime of the events service, in seconds.                                                                                                           |

#### Instance identity

Stamped onto the report by **country config** (not by core) from the country config's environment, so you control exactly what identifies your instance.

| Field                       | Source                                | Meaning                                                                         |
| --------------------------- | ------------------------------------- | ------------------------------------------------------------------------------- |
| `country_code`              | `env.COUNTRY_CODE`                    | ISO-style country code of the instance.                                         |
| `organisation`              | `env.ORGANISATION`                    | Organisation running the instance (empty string when unset).                    |
| `domain`                    | `env.DOMAIN`                          | Public domain of the instance. A wildcard/empty `DOMAIN` is reported as `null`. |
| `instance.environment`      | `env.ENVIRONMENT_NAME`                | Reported environment name, e.g. `production`.                                   |
| `instance.application_name` | `config.APPLICATION_NAME`             | The instance's configured application name.                                     |
| `instance.app_version`      | events service `package.json` version | Running OpenCRVS version.                                                       |
| `reported_at`               | UTC midnight of the reporting day     | Stable timestamp used for idempotency (see below).                              |
| `schema_version`            | fixed by `@opencrvs/toolkit`          | Payload contract version (currently `1.0`).                                     |

That is the **entire** payload. There are no free-text fields carrying record data, and no identifiers of individuals.

***

### How it works

Responsibilities are split so the events service never knows the telemetry policy or the instance identity, and countryconfig owns both.

```
events service                countryconfig                 OpenCRVS telemetry service
──────────────                ─────────────                 ───────────────────────
collect metrics from
the events DB (at most
once per UTC day)
        │
        │  POST /trigger/telemetry
        │  { reported_at, app_version, metrics }
        │  (anonymous system bearer token)
        ▼
                        verify token is a *system* token
                        if !TELEMETRY_ENABLED  → skip (200)
                        if development         → skip (200)
                        else stamp identity and forward
                                │
                                │  sendTelemetry(report)
                                ▼
                                                      store report,
                                                      deduplicated by
                                                      (reported_at, schema_version)
```

1. **Events service** — a background worker wakes hourly and, at most once per UTC day, collects the metrics above and POSTs `{ reported_at, app_version, metrics }` to countryconfig's `POST /trigger/telemetry`. The request carries an OpenCRVS **system** token (the service's anonymous token). `reported_at` is midnight UTC of the day, so a retry or a mid-day restart reuses the same timestamp.
2. **countryconfig** — verifies the token is a system token (a logged-in user's token is rejected, and the endpoint is not reachable through the public gateway). It then decides whether to send: it skips silently when `TELEMETRY_ENABLED` is false, and skips when the instance is not running in production. Otherwise it stamps the instance identity and forwards the report.
3. **Toolkit** — `@opencrvs/toolkit`'s `sendTelemetry(report)` owns the status service URL (`https://status.opencrvs.dev/v1/telemetry`) and the `schema_version`. Keeping these in the toolkit means a core release can change the endpoint or payload shape, and a country config picks the change up on upgrade — an incompatible payload surfaces as a TypeScript error rather than a silent runtime mismatch.
4. **Status service** — deduplicates on `(reported_at, schema_version)`, so at-most-once-per-day reporting never double-counts even if a report is retried.

***

### Enabling or disabling telemetry

Telemetry is configured with environment variables on the **countryconfig** service. To enable it:

```bash
TELEMETRY_ENABLED=true
COUNTRY_CODE=FAR            # ISO alpha-3 code of your instance
ORGANISATION="..."         # organisation running the instance
ENVIRONMENT_NAME=production # reported environment name
```

To disable it, set `TELEMETRY_ENABLED=false` (or leave it unset — it defaults to disabled in the country config template). Nothing is sent while it is disabled.

Because sends are gated on production, telemetry from staging/QA/local instances is never transmitted regardless of these settings.

#### Scaffolding and upgrades

* **New country configs** — `create-countryconfig` asks for your organisation, ISO alpha-3 country code, and whether to enable telemetry, then writes them as the environment defaults.
* **Existing country configs** — `opencrvs upgrade` wires telemetry into a v2.0 config (the `/trigger/telemetry` handler, its route, and the new environment variables). It asks whether to enable it and, if so, requires your country code and organisation.

***

### Visibility

Each countryconfig instance logs its telemetry configuration once at startup:

* **Enabled** — logs that telemetry is on and prints the exact identity it will report with (`COUNTRY_CODE`, `ORGANISATION`, `ENVIRONMENT_NAME`, `DOMAIN`, application name), plus a reminder that reports are only sent from production.
* **Disabled** — logs a notice explaining what would be shared and how to opt in.

This makes it easy to confirm, from the logs alone, whether an instance is reporting and exactly what it would report.

###
