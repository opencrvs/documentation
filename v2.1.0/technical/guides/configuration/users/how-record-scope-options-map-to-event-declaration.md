# How "record scope" options map to event declaration?

\
Record scopes manage access to event-related actions. A persisted event is called record.\
\
You can find [available scopes and their definitions here](https://github.com/opencrvs/opencrvs-core/blob/v2.0.0-beta/packages/commons/src/scopes.ts)

For a scope to grant access, every option must match. Scope options are specific to each scope type. Most options control access based on the user or their jurisdiction. [See administrative hierarchy to understand how jurisdictions work](../administrative-hierarchy/).\
\
**Example 1: Searching for records**

`record.search` accepts up to six options. When searching for records, scopes act as an additional filter — results are returned based on your search query, excluding any records you do not have access to. Undefined options are ignored.

```typescript
export const JurisdictionFilter = z
  .enum(['administrativeArea', 'location', 'all'])
  .describe(
    'Filters based on user jurisdiction relative to their office location in hierarchy.'
  )
export type JurisdictionFilter = z.infer<typeof JurisdictionFilter>

export const UserFilter = z
  .enum(['user'])
  .describe('Filters based on the user. Limits to self.')
export type UserFilter = z.infer<typeof UserFilter>

const scopeByEvent = z
  // Ensure input is always an array for consistent parsing, even if a single string is provided by qs.
  .preprocess(
    (val) => (val === undefined ? undefined : [val].flat()),
    z.array(z.string()).optional()
  )
  .describe('Event type, e.g. birth, death')

```

Scope options with truncated record metadata — ([Find the full type here](https://github.com/opencrvs/opencrvs-core/blob/v2.0.0-beta/packages/commons/src/events/EventMetadata.ts))

Scope options now also support **`notifiedIn`** and **`notifiedBy`**, following the same pattern as `declaredIn`/`declaredBy` and `registeredIn`/`registeredBy`.

```ts
// Simplified type for readability.
type RecordSearchScope = {
 type: 'record.search',
 options: {
    event: scopeByEvent,
    placeOfEvent: JurisdictionFilter.optional(),
    notifiedIn: JurisdictionFilter.optional(),
    notifiedBy: UserFilter.optional(),
    declaredIn: JurisdictionFilter.optional(),
    declaredBy: UserFilter.optional()
    registeredIn: JurisdictionFilter.optional(),
    registeredBy: UserFilter.optional()
 }
}
```

The corresponding `legalStatuses.NOTIFIED` entry is populated whenever a Notify action is dispatched — before the event has been declared or registered:

```ts
"legalStatuses": {
  "NOTIFIED": {
    /**
     options.notifiedBy = 'user' ensures user's id matches the one who sent the notification.
    */
    "createdBy": "c05e1c4f-20fa-4e69-af72-819b535d6242",
    "createdAtLocation": [
      /**
       options.notifiedIn = 'all' means the same as undefined.
       options.notifiedIn = 'administrativeArea' ensures user's administrativeAreaId is in the array.
       options.notifiedIn = 'location' ensures user's primaryOfficeId is in the array.

       Notified location is defined by the location of the user performing the action.
      */
      "9e93fbbb-a904-4d5e-ac0b-f77b969b964f",
      "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
      "f7461bf7-b6d9-436a-a66d-5191e6ef6586",
      "ab1f6257-6d3f-492c-8442-21b761b0036d"
    ],
  },
  "DECLARED": { ... },
  "REGISTERED": { ... }
}
```

{% hint style="info" %}
As with `declaredBy`/`registeredIn`, using `notifiedBy` on a scope for an action that occurs before notification is possible (e.g. `record.create`) will always resolve to `forbidden`.
{% endhint %}

**Example 2: Declaring records — why options are limited**\
\
As shown in the previous example, using properties like `declared*` or `registered*` implies the event has already reached that state. For an event to be declared, it must be in a `NOTIFIED` or `CREATED` state. Including `declaredBy` or `registeredIn` in a declare scope would cause it to fail the necessary access checks, so the system limits these options accordingly.

```
// Simplified type for readability.
type RecordDeclareScope = {
 type: 'record.declare',
 options: {
    event: scopeByEvent,
    placeOfEvent: JurisdictionFilter.optional(),
 }
}
```



\
<br>
