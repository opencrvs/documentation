# MOSIP Registration Integration

{% hint style="info" %}
This section assumes that you are already familiar with the [general registration integration concepts](../../../../functional/markdown/interoperability/mosip-id-integration.md). If you have not read that page, read it first for a high-level introduction to the concepts, and then return here.
{% endhint %}

#### Architecture

From OpenCRVS v2.0.0, MOSIP registration integration is implemented through **action confirmation handlers** registered in the country configuration server. When a registrar performs a `REGISTER` action, OpenCRVS core calls the country configuration's registered action trigger. [Learn more about action triggers](../action-triggers/). The trigger can respond synchronously (HTTP 200) or defer the response for asynchronous external validation (HTTP 202).

The reference implementation is in [opencrvs-integrationland](https://github.com/opencrvs/opencrvs-integrationland).

#### Route registration

Routes for MOSIP integration are registered in [`src/index.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/index.ts):

```typescript
server.route({
  method: 'POST',
  path: `/trigger/events/${Event.Birth}/actions/${ActionType.REGISTER}`,
  handler: onMosipBirthRegisterHandler
})

server.route({
  method: 'POST',
  path: `/trigger/events/${Event.Death}/actions/${ActionType.REGISTER}`,
  handler: onMosipDeathRegisterHandler
})
```

#### Birth registration handler

The `onMosipBirthRegisterHandler` is defined in [`src/api/registration/index.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/registration/index.ts).

The handler:

1. Extracts the declaration data from the event.
2. Generates a registration number.
3. Evaluates eligibility via `shouldForwardBirthRegistrationToMosip`.
4. If eligible, creates a `createMosipInteropClient` and calls `mosipInteropClient.register(...)` with the child's biographic data.
5. Returns HTTP 202 (deferred) to place the record in the "Awaiting external validation" work queue while MOSIP processes the packet.
6. If not eligible, returns HTTP 200 with the registration number for immediate acceptance.

```typescript
export async function onMosipBirthRegisterHandler(
  request: ActionConfirmationRequest,
  h: Hapi.ResponseToolkit
) {
  const token = request.auth.artifacts.token as string
  const event = request.payload
  const declaration = aggregateActionDeclarations(event)
  const registrationNumber = generateRegistrationNumber()

  if (!shouldForwardBirthRegistrationToMosip(declaration)) {
    // Register immediately, no MOSIP interaction
    return h.response({ registrationNumber }).code(200)
  }

  const mosipInteropClient = createMosipInteropClient(
    MOSIP_INTEROP_URL,
    `Bearer ${token}`
  )

  await mosipInteropClient.register({
    trackingId: event.trackingId,
    requestFields: { /* child's biographic data */ },
    notification: { /* informant contact */ },
    metaInfo: { /* registration metadata */ },
    audit: { /* audit trail */ },
    schemaJson: '/* MOSIP identity schema */'
  })

  return h.response().code(202)
}
```

#### Birth correction handler

The `onBirthCorrectionActionHandler` in [`src/api/events/handler.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/events/handler.ts) handles two scenarios:

* **UIN creation on correction**: If the child has no existing NID and eligibility rules pass, a new packet is sent to MOSIP via `mosipInteropClient.register(...)`.
* **Biographic update**: If the child already has a NID, `mosipInteropClient.updateBiographics(...)` is called instead.

```typescript
if (!childHasNid) {
  await mosipInteropClient.register({ /* new packet */ })
} else {
  await mosipInteropClient.updateBiographics({
    VID: childIdentifier,
    requestFields: { /* updated fields */ },
    introducerInfoToken: informantPsut
  })
}
```

#### Death registration handler

The `onMosipDeathRegisterHandler` in [`src/api/registration/index.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/registration/index.ts) follows the same pattern:

1. Evaluates eligibility via `shouldForwardDeathRegistrationToMosip`.
2. If eligible, sends the deceased's information to MOSIP via `mosipInteropClient.register(...)` with UIN and death details.
3. Returns HTTP 200 for immediate acceptance (death registration does not require the external validation work queue).

#### Eligibility rules

Eligibility rules are defined in [`src/events/mosip.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/mosip.ts).

**`shouldForwardBirthRegistrationToMosip`**

```typescript
export function shouldForwardBirthRegistrationToMosip(
  declaration: Record<string, any>
): boolean {
  if (declaration['child.dob'] === undefined) return false
  if (
    declaration['mother.verified'] !== 'verified' &&
    declaration['mother.verified'] !== 'authenticated' &&
    declaration['father.verified'] !== 'verified' &&
    declaration['father.verified'] !== 'authenticated'
  ) return false

  const mosipEligibilityExpiryDate = addYears(
    new Date(declaration['child.dob']),
    CHILD_MAX_AGE_YEARS_FOR_MOSIP // 10
  )
  return !isAfter(Date.now(), mosipEligibilityExpiryDate)
}
```

The birth registration is forwarded to MOSIP when:

* The child has a date of birth.
* At least one parent (mother or father) has been identity-verified or authenticated.
* The child is under 10 years old (configurable via `CHILD_MAX_AGE_YEARS_FOR_MOSIP`).

**`shouldForwardDeathRegistrationToMosip`**

```typescript
export function shouldForwardDeathRegistrationToMosip(
  declaration: Record<string, any>
): boolean {
  const informantRelation = declaration['informant.relation']
  if (informantRelation === 'SPOUSE')
    return (
      declaration['spouse.verified'] === 'verified' ||
      declaration['spouse.verified'] === 'authenticated'
    )
  return (
    declaration['informant.verified'] === 'verified' ||
    declaration['informant.verified'] === 'authenticated'
  )
}
```

The death registration is forwarded to MOSIP when the informant or spouse (if the informant is the spouse) has been identity-verified or authenticated.

#### Identity verification on action (ID Auth)

Beyond the dedicated MOSIP register handlers, the general `onBirthActionHandler` and `onDeathActionHandler` in [`src/api/events/handler.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/events/handler.ts) fire on every event action (DECLARE, VALIDATE, REGISTER, etc.). They can be used to verify identity data submitted offline against the MOSIP ID Auth SDK when the system comes online.

In a production implementation, the handler would call `mosipInteropClient.verifyNid()` for each available individual:

```typescript
const mosipInteropClient = createMosipInteropClient(
  MOSIP_INTEROP_URL,
  `Bearer ${token}`
)

const updatedFields: Record<string, 'verified' | 'failed'> = {}

if (isMotherAvailable && declaration['mother.verified'] !== 'authenticated') {
  updatedFields['mother.verified'] = await mosipInteropClient.verifyNid({
    dob: declaration['mother.dob'],
    nid: declaration['mother.nid'],
    name: declaration['mother.name'],
    gender: 'female',
    transactionId: `mother-${event.id}`
  })
}
```

{% hint style="warning" %}
**ID Auth verification is not enabled in the reference implementation.** The `verifyNid()` calls are **commented out** in the opencrvs-integrationland example because MOSIP does not recommend offline ID Auth verification as a substitute for real-time biometric or eSignet authentication. Verifying identity by matching biographic data (name, DOB, NID) against MOSIP records provides weak assurance — it confirms the data exists in the ID system but does not authenticate the person presenting it. eSignet authentication ([§4.1 of the functional guide](../../../../functional/markdown/interoperability/mosip-id-integration.md#id-4.1-e-signet-authentication-flow)) is the preferred approach.

The commented-out blocks in [`src/api/events/handler.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/events/handler.ts) serve as a reference showing how `verifyNid()` would integrate in a production context that has chosen to accept this trade-off. They are retained as documentation of the integration surface rather than as a recommended pattern.
{% endhint %}

#### The `createMosipInteropClient`

The MOSIP interoperability client is created using:

```typescript
import { createMosipInteropClient } from '@opencrvs/mosip/api'
import { MOSIP_INTEROP_URL } from '@countryconfig/constants'

const mosipInteropClient = createMosipInteropClient(
  MOSIP_INTEROP_URL,   // e.g. http://mosip-api:2024
  `Bearer ${token}`     // OpenCRVS JWT for callback authentication
)
```

The client provides:

* `register(...)` — Send a new packet for UIN creation
* `updateBiographics(...)` — Send biographic updates for an existing VID

#### Asynchronous flow and the "Awaiting external validation" workqueue

When the handler returns HTTP 202, the record enters a `Requested` state and appears in the **"Pending external validation"** workqueue. This workqueue is configured in [`src/api/workqueue/workqueueConfig.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/workqueue/workqueueConfig.ts):

```typescript
{
  slug: 'in-external-validation',
  icon: 'FileText',
  name: {
    id: 'workqueues.inExternalValidation.title',
    defaultMessage: 'Pending external validation'
  },
  query: {
    flags: {
      anyOf: [
        `${ActionType.REGISTER}:${ActionStatus.Requested}`.toLowerCase()
      ]
    },
    updatedAtLocation: {
      type: 'within',
      location: user('primaryOfficeId')
    }
  },
  action: { type: ActionType.READ }
}
```

{% hint style="warning" %}
MOSIP does not return failure responses. Records that stall in "Pending external validation" must be investigated directly with MOSIP and may need to be manually resolved by the system implementer.
{% endhint %}

To read more about configuring workqueues, see [the technical guide on workqueues](../workqueues.md).

#### **Debugging a record stuck in "Pending external validation"**

A record stays in this workqueue when MOSIP never sends the credential back. MOSIP does not report failures, so first check with the MOSIP team whether the packet failed. When it did, an implementer has to close the record by hand:

1. Find the pending transaction in `mosip-api`.
2. Reject the registration in OpenCRVS.
3. Remove the transaction from `mosip-api`.

{% hint style="info" %}
The examples below use localhost. In a deployed environment, use `https://gateway.<your-domain>` instead of `http://localhost:7070` and `https://mosip-api.<your-domain>` instead of `http://localhost:2024`. Auth and events are reached through the gateway, not directly.

Every command runs on your own machine, against the deployed APIs. Only the `kubectl exec` in step 1 runs inside the cluster.
{% endhint %}

**1. Find the pending transaction**

`mosip-api` keeps one row per record it is waiting for. The row holds the MOSIP transaction `id`, the OpenCRVS `event_id` and the registration number.

If you have a token with the `record.search` scope (a registrar has one), list the rows over HTTP. The integration's own token does not work here — it has no search scope, and the route answers `403`:

```sh
curl http://localhost:2024/debug/transactions \
  -H "Authorization: Bearer <TOKEN>"
```

```json
[
  {
    "eventId": "1c4c2208-79ff-47c7-ae4d-e55cfcf4e6e4",
    "id": "100013380723500",
    "registration_number": "EE008OLG4317",
    "created_at": "2025-09-10 13:15:13"
  }
]
```

Otherwise, read the SQLite database directly. It lives at `SQLITE_DATABASE_PATH`, which is `/data/sqlite/mosip-api.db` in the Helm chart and `data/sqlite/mosip-api.db` under the repository root in local development. The image has no `sqlite3` command, so query it with Node:

```sh
kubectl exec -n <namespace> deploy/mosip-api -- node -e "
  const db = require('better-sqlite3')('/data/sqlite/mosip-api.db')
  console.log(db.prepare('SELECT id, event_id, registration_number, created_at FROM transactions ORDER BY created_at').all())
"
```

Rows much older than a normal MOSIP round trip are the stuck ones. Take the `id` and the `event_id` of the row you want to close.

**2. Get a token for the integration**

Use the integration's own credentials, `OPENCRVS_CLIENT_ID` and `OPENCRVS_CLIENT_SECRET`. These are the values `mosip-api` is configured with, and a National System Admin can read them from the OpenCRVS **Integrations** page. The client already has the `record.read`, `record.register` and `record.correct` scopes, which is everything the next steps need.

```sh
curl -X POST http://localhost:7070/auth/token \
  -d grant_type=client_credentials \
  -d client_id=<OPENCRVS_CLIENT_ID> \
  -d client_secret=<OPENCRVS_CLIENT_SECRET>
```

The response contains the token in `access_token`. It is used as `<SYSTEM_TOKEN>` below.

Rejecting as the integration also keeps the audit trail honest: no registrar rejected the record, it was closed because MOSIP never answered.

**3. Find the action to reject**

Read the event and take the `id` of the `REGISTER` action that is still `Requested`:

```sh
curl -G http://localhost:7070/events/event.get \
  --data-urlencode 'input={"json":{"eventId":"<EVENT_ID>"}}' \
  -H "Authorization: Bearer <SYSTEM_TOKEN>"
```

The event document comes back under `result.data.json`. If you have `jq`, pipe the response through it to print the id directly:

```sh
jq -r '.result.data.json.actions[]
       | select(.type == "REGISTER" and .status == "Requested")
       | .id'
```

Without `jq`, read the `actions` array yourself and take the `id` of the entry whose `type` is `REGISTER` and whose `status` is `Requested`.

If there is more than one such action, the record has been through registration before. Pick the one that no other action refers to in its `originalActionId` — that is the pending one.

**4. Reject the registration**

```sh
curl -X POST http://localhost:7070/events/event.actions.register.reject \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer <SYSTEM_TOKEN>" \
  -d '{"json":{"eventId":"<EVENT_ID>","actionId":"<ACTION_ID>","transactionId":"<ANY_UNIQUE_STRING>"}}'
```

The record leaves the workqueue and is unassigned. Calling this again for the same action is safe: the second call returns the event unchanged.

**5. Remove the transaction**

Finally, drop the row so `mosip-api` stops waiting for it:

```sh
curl -X DELETE http://localhost:2024/debug/transactions/<ID> \
  -H "Authorization: Bearer <SYSTEM_TOKEN>"
```

This route needs the `record.register` scope, which the integration's token has. If MOSIP does answer later, the callback no longer finds the transaction and is logged as an error instead of confirming the record.

{% hint style="warning" %}
Both `/debug` routes exist for this support workflow only. They require an OpenCRVS token and expose event ids and registration numbers, so treat their output as record data.
{% endhint %}
