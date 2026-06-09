# MOSIP Registration Integration

{% hint style="info" %}
This section assumes that you are already familiar with the [general registration integration concepts](../../../functional/markdown/interoperability/mosip-id-integration.md). If you have not read that page, read it first for a high-level introduction to the concepts, and then return here.
{% endhint %}

#### Architecture

In OpenCRVS v2.0.0, MOSIP registration integration is implemented through **action confirmation handlers** registered in the country configuration server. When a registrar performs a `REGISTER` action, OpenCRVS core calls the country configuration's registered action trigger. [Learn more about action triggers](../configuration/action-triggers/). The trigger can respond synchronously (HTTP 200) or defer the response for asynchronous external validation (HTTP 202).

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
**ID Auth verification is not enabled in the reference implementation.** The `verifyNid()` calls are **commented out** in the opencrvs-integrationland example because MOSIP does not recommend offline ID Auth verification as a substitute for real-time biometric or eSignet authentication. Verifying identity by matching biographic data (name, DOB, NID) against MOSIP records provides weak assurance — it confirms the data exists in the ID system but does not authenticate the person presenting it. eSignet authentication ([§4.1 of the functional guide](../../../functional/markdown/interoperability/mosip-id-integration.md#id-4.1-e-signet-authentication-flow)) is the preferred approach.

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

To read more about configuring workqueues, see [the technical guide on workqueues](../configuration/workqueues.md).
