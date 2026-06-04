# Release notes

## Introduction

OpenCRVS release notes document changes, improvements, and fixes delivered in each version. These notes help implementation teams understand what has changed, plan migrations, and take advantage of new features.

Each release includes breaking changes, new features, improvements, and bug fixes. Review the notes carefully before upgrading to ensure compatibility with your country configuration.

***

## Releases

### v2.1 (Planned Q3 2026)

**Focus:** …

**Key highlights**

* …

**Improvements**

* …

**Breaking changes**

* …

**Bug fixes**

* …

***

### v2.0 (8 May 2026)

**Focus:** …

**Key highlights**

* ….

**Improvements**

* …

**Breaking changes**

* **Webhook integration client removed.** The Webhook integration client and its `webhooks` service have been removed and are not migrated automatically. Country configurations that previously relied on webhook subscriptions must instead react to events via Action triggers in the country configuration code. Any webhook-style fan-out to external systems must be implemented inside those handlers.
* **Event Notification API endpoint renamed.** `POST /api/events/events/notifications` has been renamed to `POST /api/events/events/{eventId}/notify`. Existing integration clients must update their request paths. A new single-request convenience endpoint `POST /api/events/events/notify` is also available for system clients that need to create and notify in one call.
* **Auth service is no longer exposed on its own subdomain.** The public `auth.{hostname}` Traefik route has been removed — the auth service is now reachable only through the gateway proxy at `gateway.{hostname}/auth/*`. Remove the `auth.*` DNS record and TLS certificate from your deployment. The gateway's `/auth/authenticate-super-user` route is now rate limited on a constant key (it previously keyed on a `username` field that super user auth does not send).

**Bug fixes**

* …

\<aside>

**Major version upgrade** — v2.0 includes significant breaking changes that require careful migration planning. All external integrations must be updated to use the new authentication system.

\</aside>
