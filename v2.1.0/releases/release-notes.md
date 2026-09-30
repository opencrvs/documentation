# Release notes

## Introduction

OpenCRVS release notes document changes, improvements, and fixes delivered in each version. These notes help implementation teams understand what has changed, plan migrations, and take advantage of new features.

Each release includes breaking changes, new features, improvements, and bug fixes. Review the notes carefully before upgrading to ensure compatibility with your country configuration.

***

## Config Inputs

{% hint style="warning" %}
TODO: Insert zip of 2.1 Config files
{% endhint %}

***

## Releases

### v2.1

**Core changelog:** [**https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/CHANGELOG.md#210-release-candidate**](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/CHANGELOG.md#210-release-candidate)

**Countryconfig changelog:** [**https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/packages/countryconfig-template/CHANGELOG.md#210-release-candidate**](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0/packages/countryconfig-template/CHANGELOG.md#210-release-candidate)

{% hint style="warning" %}
Read [#version-specific-notes-for-2.1](../technical/guides/version-upgrades.md#version-specific-notes-for-2.1 "mention") before upgrading. Countries on v1.9.x must upgrade to v2.0.0 first.
{% endhint %}

#### **Key highlights**

* **Location and administrative area write API.** Locations and administrative areas can be created, renamed, recoded and inactivated through the API. Every change is kept as an effective-dated version, so records keep showing the names that were valid on the date of the event. Read more: [updates-and-versioning.md](../technical/guides/configuration/administrative-hierarchy/updates-and-versioning.md "mention")
* **Configurable core actions.** Every core action can now be given its own label, icon, conditionals and flags. This includes Delete, Assign, Mark as duplicate and the correction approvals. Notify, Declare, Register, Archive and Reject can show configured form fields on their confirmation dialog, and a new **Unarchive** action restores an archived record. Read more: [core-actions.md](../technical/guides/configuration/events/actions/core-actions.md "mention")
* **Finer-grained scopes.** Record scopes can be restricted by record status (`status`), by record flags (`flags`), and by where and by whom a record was notified (`notifiedIn` / `notifiedBy`). Read more: [how-record-scope-options-map-to-event-declaration.md](../technical/guides/configuration/users/how-record-scope-options-map-to-event-declaration.md "mention")
* **Stronger authentication.** Users get a short-lived access token (10 minutes) with a rotating refresh token, so role changes and deactivations take effect within minutes. Forgotten usernames and passwords are recovered through a single-use link sent to the user.
* **Sealed records.** Registered records can be sealed so that their declaration data is hidden from search and deduplication. Read more: [sealed-records.md](../technical/guides/use-cases/sealed-records.md "mention")
* **MOSIP integration ships with core.** The MOSIP integration is now released with every core release, and MOSIP WebSub callbacks are authenticated with an HMAC signature.
* **Hardened deployments.** Kubernetes network policies are on by default, OpenCRVS and its admin tools can be restricted to allowed IP ranges, and workloads get their own service accounts. Tracing now uses OpenTelemetry.
* **Integration audit log.** The operations performed by a system client can be read through the `integrations.audit` endpoint.
* **Daily usage telemetry (opt-in).** A production instance can share a daily summary of aggregate counts with the OpenCRVS status service. Read more: [telemetry.md](../technical/architecture/telemetry.md "mention")

#### **Breaking changes**

* **MongoDB and InfluxDB removed.** All data lives in PostgreSQL, and the legacy MongoDB migration tooling has been deleted. Countries on v1.9.x must upgrade to v2.0.0 first, because v2.0.0 is the only release that can migrate their data.
* **Confirming an asynchronous action needs its own credentials.** The OAuth token-exchange grant and the `record.confirm-registration` / `record.reject-registration` scopes have been removed. Accepting or rejecting a pending action now requires a system client holding the new `record.action.accept` / `record.action.reject` scopes. A user's token is refused. MOSIP integrations must be given such a client and must send `eventId`. Read more: [action-confirmation.md](../technical/guides/configuration/action-triggers/action-confirmation.md "mention")
* **Country configuration triggers are served under `/trigger`.** User and system notification routes moved from `/triggers/...` to `/trigger/...`. Two new user triggers, `password-reset-link` and `username-reminder-link`, must be implemented for account recovery.
* **Account recovery.** `/auth/verifyUser` no longer reveals whether an account exists, and `/auth/verifyNumber` has been removed. Recovery is by single-use link.
* **Access token lifetime.** `CONFIG_TOKEN_EXPIRY_SECONDS` is now the lifetime of the short-lived access token (default 600). Session length is set by `CONFIG_REFRESH_TOKEN_EXPIRY_SECONDS`.
* **Location APIs.** `validUntil` has been removed from `Location` and `AdministrativeArea` (use `status` and `versions[]`), and `POST /locations` / `POST /administrative-areas` no longer upsert. Change an existing entity with `PUT`.
* **Document access.** The gateway's `/presigned-url` route has been removed. Presigned URLs for record documents require `record.read` on the record, and attachment uploads must name the record they belong to (`eventId`).
* **Configuration changes.** `APPROVE_CORRECTION` and `REJECT_CORRECTION` no longer inherit the configuration of `REQUEST_CORRECTION`, and `ARCHIVE` no longer clears the `incomplete` flag. `npx @opencrvs/toolkit upgrade` adds the explicit correction configuration for you.
* **Sentry removed.** `npx @opencrvs/toolkit upgrade` removes the Sentry wiring from your country configuration. Delete the `SENTRY_DSN` secret.
* **Infrastructure.** Backup and restore server hosts are GitHub variables (`BACKUP_HOST`, `RESTORE_HOST`) instead of being part of the SSH secret. Ansible inventories moved to `environments/<env>/inventory.yml`. The public `events.<domain>` route has been removed; use the gateway.

#### **Deprecations**

* `path` on `POST /attachments`. Send `eventId` instead.
* `POST /auth/token` parameters in the URL query string. Send them in the request body.

#### **Improvements**

* Log retention increased from 2 to 30 days by default. Check the disk headroom of your servers.
* Advanced search keeps records at renamed or inactivated offices, facilities and administrative areas findable.
* Ubuntu 26.04 support and Kubernetes v1.36.
* The data seed job validates all seed data before writing anything.
* ...and many bug fixes, listed in the core changelog.

***

### v2.0

**Release date: 25th of June 2026**

**Core changelog:** [**https://github.com/opencrvs/opencrvs-core/blob/develop/CHANGELOG.md#200-release-candidate**](https://github.com/opencrvs/opencrvs-core/blob/develop/CHANGELOG.md#200-release-candidate)

**Countryconfig changelog:** [**https://github.com/opencrvs/opencrvs-core/blob/v2.1.0-beta/packages/countryconfig-template/CHANGELOG.md#200**](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0-beta/packages/countryconfig-template/CHANGELOG.md#200)

**opencrvs-demoland source:**

{% file src="../.gitbook/assets/opencrvs-demoland-release-v2.0.0.zip" %}

**Test report:** [**https://docs.google.com/spreadsheets/d/1r2CFnnhpKcwO5z-tgcFlPirrmGfH8dZxCTXSSHXBs38/edit?usp=sharing**](https://docs.google.com/spreadsheets/d/1r2CFnnhpKcwO5z-tgcFlPirrmGfH8dZxCTXSSHXBs38/edit?usp=sharing)

#### **Key highlights**

* **Redesigned administrative hierarchy and jurisdiction.** A country is now modelled as a hierarchy of **administrative areas** (e.g. province → district → village) that _contain_ physical **locations** (CRVS offices, health facilities). Read more: [administrative-structure](../functional/markdown/workflows/administrative-structure/ "mention") and [administrative-hierarchy](../technical/guides/configuration/administrative-hierarchy/ "mention")
* **Verifiable credentials for life events.** OpenCRVS can now issue digitally signed credentials through an external issuer. Two forms are available: a digital SD-JWT credential (OpenID4VC) delivered to the citizen's wallet, and a verifiable QR code on printed birth certificates. Signing is handled by an issuer you operate and manage independently. Read more: [verifiable-credentials.md](../functional/markdown/records/verifiable-credentials.md "mention") and [verifiable-credentials.md](../technical/guides/configuration/integrations/verifiable-credentials.md "mention")
* **Biographic updates via MOSIP.** The integration now supports sending birth corrections to MOSIP via a new \`updateBiographics\` endpoint, enabling a child's biographic data to be created or updated in the identity system during amendment flows. Read more: [mosip-registration-integration.md](../technical/guides/configuration/integrations/mosip-registration-integration.md "mention")
* **Custom actions.** Beyond the core actions, each event can now define its own **custom actions**. Read more: [custom-actions.md](../technical/guides/configuration/events/actions/custom-actions.md "mention")
* **Redesigned record editing**. The editing of a previously notified or declared record has been reworked to a completely new "Edit" action flow.
* **Technical architecture rework.** The technical architecture has been simplified, drastically reducing the amount of required services ran on k8s or docker-swarm.

#### Improvements

* **Configurable record flags.** Actions can add or remove flags on a record, so workqueues and status indicators are driven by configuration rather than core code.
* **Kubernetes deployment.** OpenCRVS can now be deployed to any Kubernetes cluster using the Helm charts shipped in `opencrvs-core`. Docker Swarm remains supported until v2.1.
* **Improved offline/online recovery.** The app now recovers automatically if the network changes or drops while it is still initialising.
* **Performance improvements.** Performance improvements to e.g. workqueue load times.

#### **Breaking changes**

* **Webhook integration client removed.** The Webhook integration client and its `webhooks` service have been removed and are not migrated automatically. Country configurations that previously relied on webhook subscriptions must instead react to events via Action triggers in the country configuration code. Any webhook-style fan-out to external systems must be implemented inside those handlers.
* **Event Notification API endpoint renamed.** `POST /api/events/events/notifications` has been renamed to `POST /api/events/events/{eventId}/notify`. Existing integration clients must update their request paths. A new single-request convenience endpoint `POST /api/events/events/notify` is also available for system clients that need to create and notify in one call.
* **Auth service is no longer exposed on its own subdomain.** The public `auth.{hostname}` Traefik route has been removed — the auth service is now reachable only through the gateway proxy at `gateway.{hostname}/auth/*`. Remove the `auth.*` DNS record and TLS certificate from your deployment. The gateway's `/auth/authenticate-super-user` route is now rate limited on a constant key (it previously keyed on a `username` field that super user auth does not send).
* **Configuration model rewritten.** Events, forms, workflows, and actions are now defined in TypeScript with the `@opencrvs/toolkit` package (`defineConfig`).
  * These required changes can be automatically applied to an existing country config using `yarn opencrvs upgrade`, see [#step-2-update-code-and-test-locally](../technical/guides/version-upgrades.md#step-2-update-code-and-test-locally "mention")
* **Other configuration changes.** `InherentFlags.PENDING_CERTIFICATION` has been removed (implement it as a custom flag instead); workqueue configuration uses `action: { … }` rather than `actions: [ … ]` and no longer accepts `'DEFAULT'`; and `FieldType.PARAGRAPH` no longer takes a `fontVariant` — use the new `FieldType.HEADING` where a heading style is needed.
  * These required changes can be automatically applied to an existing country config using `yarn opencrvs upgrade`, see [#step-2-update-code-and-test-locally](../technical/guides/version-upgrades.md#step-2-update-code-and-test-locally "mention")

#### **Bug fixes**

* A broad set of fixes and improvements across the record workflows, record search, notifications, and deployment accompanies.
