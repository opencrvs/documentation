# Release notes

## Introduction

OpenCRVS release notes document changes, improvements, and fixes delivered in each version. These notes help implementation teams understand what has changed, plan migrations, and take advantage of new features.

Each release includes breaking changes, new features, improvements, and bug fixes. Review the notes carefully before upgrading to ensure compatibility with your country configuration.

***

## Releases

### v2.1 (Upcoming Q3 2026)

#### **Key highlights**

* Support for custom form fields on action dialogs ([#11951](https://github.com/opencrvs/opencrvs-core/issues/11951))
* Support for `notifiedIn` and `notifiedBy` properties on scopes ([#11875](https://github.com/opencrvs/opencrvs-core/issues/11875))
* Add legal statuses: "Registered (Inactive)" and "Revoked", and related core actions ([#11952](https://github.com/orgs/opencrvs/projects/4/views/88))
* Add audit log retrieval endpoint ([#11909](https://github.com/opencrvs/opencrvs-core/issues/11909))
* ...and miscellaneous bug fixes and improvements

***

### v2.0

**Release date: 25th of June 2026**

#### **Key highlights**

* **Custom actions.** Beyond the core actions (declare, validate, register, reject, print certificate), each event can now define its own **custom actions**. Read more: [custom-actions.md](../technical/guides/configuration/events/actions/custom-actions.md "mention")
* **Redesigned administrative hierarchy and jurisdiction.** A country is now modelled as a hierarchy of **administrative areas** (e.g. province → district → village) that _contain_ physical **locations** (CRVS offices, health facilities). Read more: [administrative-structure.md](../functional/markdown/workflows/administrative-structure.md "mention") and [administrative-hierarchy](../technical/guides/configuration/administrative-hierarchy/ "mention")
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
* **Configuration model rewritten.** Events, forms, workflows, and actions are now defined in TypeScript with the `@opencrvs/toolkit` package (`defineConfig`). v1 country configurations are not compatible with v2.0 and must be migrated to the new model.
  * These required changes can be automatically applied to an existing country config using `yarn opencrvs upgrade`, see [#step-2-update-code-and-test-locally](../technical/guides/version-upgrades.md#step-2-update-code-and-test-locally "mention")
* **Other configuration changes.** `InherentFlags.PENDING_CERTIFICATION` has been removed (implement it as a custom flag instead); workqueue configuration uses `action: { … }` rather than `actions: [ … ]` and no longer accepts `'DEFAULT'`; and `FieldType.PARAGRAPH` no longer takes a `fontVariant` — use the new `FieldType.HEADING` where a heading style is needed.
  * These required changes can be automatically applied to an existing country config using `yarn opencrvs upgrade`, see [#step-2-update-code-and-test-locally](../technical/guides/version-upgrades.md#step-2-update-code-and-test-locally "mention")

#### **Bug fixes**

* A broad set of fixes and improvements across the record workflows, record search, notifications, and deployment accompanies.

