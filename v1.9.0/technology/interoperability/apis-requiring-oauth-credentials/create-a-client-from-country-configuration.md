---
description: >-
  Declaring integration clients in your country configuration so that an
  integrating system authenticates with its own credentials
---

# Create a client from the country configuration

{% hint style="info" %}
Available from OpenCRVS **1.9.16**.
{% endhint %}

## Why create a client this way

Clients created in the Integrations UI are limited to the permissions that come with their type. A Record Search client cannot register a record, and there is no client type that can.

Until now, an integration that needed to perform a registration had to reuse the access token of whichever user triggered the call. That works, but the record's history then shows the registrar rather than the integrating system, and there is no way to tell the two apart afterwards.

From 1.9.16 you can declare integrations in your country configuration. OpenCRVS registers each one when the stack starts, issues it its own credentials, and the integration authenticates as itself. Its actions are attributed to it in the audit trail, and a National System Administrator can reveal its keys, deactivate it or delete it from the Integrations page like any other client.

The list ships empty, so an unmodified country configuration registers nothing and behaves exactly as it did before.

## 1. Add `USER_MANAGEMENT_URL`

The `countryconfig` service now talks to the user management service directly. Add the variable to the `countryconfig` service in `infrastructure/docker-compose.deploy.yml`:

```yaml
countryconfig:
  environment:
    - USER_MANAGEMENT_URL=http://user-mgnt:3030
```

{% hint style="warning" %}
There is no production default for this variable. The `countryconfig` service will not start without it.
{% endhint %}

## 2. Declare your integrations

Edit `src/api/integration/handler.ts` in your country configuration and add an entry to `INTEGRATIONS` for each integrating system:

```typescript
const INTEGRATIONS: IntegrationConfig[] = [
  {
    name: 'MOSIP',
    scopes: [
      { type: 'record.register', options: { event: ['birth', 'death'] } }
    ]
  }
]
```

**`name`** must be unique. OpenCRVS identifies an integration by its name every time it starts, so renaming an entry registers a second client rather than renaming the first one.

**`scopes`** is the list of record permissions the integration is granted. Each entry has a `type` and an `options.event` array naming the events it applies to. The event identifiers are the ones declared in your event configuration — `birth`, `death`, `tennis-club-membership` and so on.

`type` must be one of:

| Scope type                            | Grants the integration the ability to             |
| ------------------------------------- | ------------------------------------------------- |
| `record.create`                       | Create a new record                                |
| `record.read`                         | Read a record                                      |
| `record.declare`                      | Submit a complete declaration                      |
| `record.notify`                       | Submit an incomplete notification                  |
| `record.declared.validate`            | Validate a declared record                         |
| `record.declared.reject`              | Send a declared record back for updates            |
| `record.declared.archive`             | Archive a declared record                          |
| `record.declared.review-duplicates`   | Review records flagged as potential duplicates     |
| `record.register`                     | Register a record                                  |
| `record.registered.request-correction`| Request a correction to a registered record        |
| `record.registered.correct`           | Apply a correction to a registered record          |
| `record.unassign-others`              | Unassign a record assigned to another user         |

An unrecognised scope type is rejected and the integration is not registered, so check the `countryconfig` logs after a deploy.

{% hint style="danger" %}
Grant only the scopes the integration genuinely needs. A client that can register records is as powerful as a registrar, and its behaviour remains the responsibility of the National System Administrator of the OpenCRVS installation.
{% endhint %}

## 3. Deploy and collect the credentials

Registration happens automatically on startup. When the events service comes up it requests a short-lived bootstrap token from the auth service and calls `GET /triggers/system/ready` on your country configuration, which forwards each declared integration to the user management service. Credentials are generated there.

The client secret is generated inside OpenCRVS and is never sent back to your country configuration, so there is nothing to store in your repository. To hand it to the integrating system, a National System Administrator opens **Configuration → Integrations**, finds the client — it is listed with the type **API integration** — and uses **Reveal keys**, then **Refresh secret**.

{% hint style="warning" %}
As with a client created in the UI, the Client Secret is shown once and cannot be retrieved afterwards. Copy it when it is displayed.
{% endhint %}

Registration is idempotent. On every subsequent restart the scopes are reconciled with what your country configuration declares, and the stored secret is left untouched — a secret refreshed by an NSA survives redeployment.

If the country configuration is not yet reachable when the events service starts, the failure is logged as a warning and registration is retried the next time the events service restarts.

## Optional: seed pre-shared credentials

When the integrating system already carries a client id and secret in its own environment — `OPENCRVS_CLIENT_ID` and `OPENCRVS_CLIENT_SECRET` in `mosip-api`, for example — you can seed OpenCRVS with the same pair so that nobody has to copy a secret between two systems by hand:

```typescript
const INTEGRATIONS: IntegrationConfig[] = [
  {
    name: 'MOSIP',
    scopes: [
      { type: 'record.register', options: { event: ['birth', 'death'] } }
    ],
    clientId: MOSIP_INTEGRATION_CLIENT_ID,
    clientSecret: MOSIP_INTEGRATION_CLIENT_SECRET
  }
]
```

`clientId` must be a UUID. Read both values from environment variables backed by your deployment secrets; never commit them to your country configuration repository.

Seeded credentials are applied only when the client is first created. If an integration of that name already exists with a different client id, the seeded values are ignored and a warning is written to the logs — delete the client from the Integrations page first if you need to re-seed it.

## Authenticating as the integration

Nothing special: the integration exchanges its client id and secret for an access token exactly like a client created in the UI. See [Authenticate a client](authenticate-a-client.md).

## What this changes in the audit trail

An action performed by an integration is recorded against the system client rather than against a user. Because a system client has no role, the role of an action can now be empty. This is visible in a record's history and in the `analytics.event_actions.created_by_role` column, which became nullable in 1.9.16 — the `NOT NULL` constraint is dropped on existing databases during deploy.

## Note for implementers hardening a deployment

The bootstrap token used for registration is issued by an internal auth endpoint, `POST /auth/internal/integration-creator-token`. It is valid for 60 seconds, carries only the `integration.create` scope, and the API gateway answers `404` for anything under `/auth/internal/`, so it is not reachable from outside your network. Keep it that way: any caller that can reach this endpoint can register an integration with any scope.
