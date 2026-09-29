---
description: Accepting or rejecting an action from the country configuration
---

# Action confirmation

When a user performs an action on a record, OpenCRVS Core first records it as **requested** and calls the event action trigger `POST /trigger/events/{eventType}/actions/{actionType}` on your country configuration server. The country configuration decides whether the action goes ahead. This is known as **action confirmation**.

The following actions support action confirmation:

* `NOTIFY`, `DECLARE`, `EDIT`, `REGISTER`, `REJECT`, `ARCHIVE`, `UNARCHIVE`
* `PRINT_CERTIFICATE`, `CUSTOM`
* `REQUEST_CORRECTION`, `APPROVE_CORRECTION`, `REJECT_CORRECTION`

The reference country configuration registers a catch-all route that answers `200` for every event action. Add a more specific route to intercept one:

```typescript
server.route({
  method: 'POST',
  path: `/trigger/events/birth/actions/${ActionType.REGISTER}`,
  handler: onBirthRegisterHandler,
  options: {
    tags: ['api', 'events'],
    description: 'Confirms birth registrations'
  }
})
```

***

#### 1. Synchronous confirmation

Answer the trigger request directly:

| Response   | Result                                   |
| ---------- | ---------------------------------------- |
| `HTTP 200` | The action is accepted immediately.      |
| `HTTP 400` | The action is rejected immediately.      |
| `HTTP 202` | The action stays pending (see below).    |

A registration must return the registration number when it is accepted:

```typescript
return h.response({ registrationNumber: generateRegistrationNumber() }).code(200)
```

When several actions are submitted together — for example declare and register in one go — the intermediate actions must be answered synchronously.

***

#### 2. Asynchronous confirmation

Return `HTTP 202` when the decision is not available yet, for example while waiting for a national ID system. The action stays in the **Requested** state, and the user who started it is unassigned from the record. Accept or reject it later by calling Core's `accept` or `reject` endpoint for that action type.

**Credentials**

{% hint style="danger" %}
Do not call `accept` or `reject` with the token Core sent to your trigger. That token only proves the request came from Core — it carries no scopes.
{% endhint %}

Call Core with **your country configuration's own system client**. The client needs:

| Scope                  | Needed to                  |
| ---------------------- | -------------------------- |
| `record.action.accept` | Accept a pending action    |
| `record.action.reject` | Reject a pending action    |

For example, `{ type: 'record.action.accept', options: { event: ['birth', 'death'] } }`, encoded as `type=record.action.accept&event=birth,death`.

The scope of the action itself (for example `record.register`) does not allow anyone to confirm it, and a user's token is refused whatever scopes it carries. A client with these scopes cannot be created from the Integrations page — register it from your country configuration. See [Create a client](../integrations/create-a-client.md#process-of-creation-via-the-country-configuration).

{% hint style="danger" %}
Never grant `record.action.accept` or `record.action.reject` to a user role. Anyone who can both request an action and confirm it can, for example, register a record without your country configuration being involved. Core does not stop you from doing this — grant these scopes only to integrations.
{% endhint %}

**Rules Core applies**

* A confirmation is refused with `CONFLICT: User is assigned to this event` while any user is assigned to the record. The requesting user is unassigned as soon as you return `202`, so this only happens if someone assigns themselves while your confirmation is pending. Wait until nobody is assigned, then retry.
* The `actionId` must be a pending action of the matching type. Any other action id is refused.

**Accepting**

```typescript
import { createClient } from '@opencrvs/toolkit/api'

// systemToken: obtained with your own client_id and client_secret,
// see Authenticate a client
const client = createClient(`${GATEWAY_URL}/events`, `Bearer ${systemToken}`)

await client.event.actions.register.accept.mutate({
  ...action, // action input
  transactionId: uuidv4(),
  eventId,
  actionId,
  registrationNumber: generateRegistrationNumber() // REGISTER only
})
```

**Rejecting**

```typescript
await client.event.actions.register.reject.mutate({
  transactionId: uuidv4(),
  eventId,
  actionId
})
```

Replace `register` with the action type you are confirming, for example `archive` or `printCertificate`. To obtain `systemToken`, see [Authenticate a client](../integrations/authenticate-a-client.md).

{% hint style="info" %}
Before OpenCRVS 2.1, a country configuration could confirm an action with the requesting user's token, or with a token obtained through the OAuth token-exchange grant. Both have been removed, together with the `record.confirm-registration` and `record.reject-registration` scopes and the `CONFIG_ACTION_CONFIRMATION_TOKEN_EXPIRY_SECONDS` auth environment variable.
{% endhint %}
