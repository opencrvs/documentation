# API Client

#### `createClient`

Creates a typed tRPC client for communicating with the OpenCRVS events service. Used in country-config server-side code to fetch event and location data, e.g. inside certificate handlebar helpers or custom action handlers.

**Signature**

```ts
import { createClient } from '@opencrvs/toolkit/api'

function createClient(
  baseUrl: string,
  token: `Bearer ${string}`
): TRPCClient
```

**Parameters**

| Parameter | Type                     | Description                                                                   |
| --------- | ------------------------ | ----------------------------------------------------------------------------- |
| `baseUrl` | `string`                 | URL of the tRPC events endpoint, e.g. `process.env.GATEWAY_HOST + '/events'`. |
| `token`   | `` `Bearer ${string}` `` | Authorization header value. Must include the `Bearer` prefix.                 |

The returned client exposes:

| Method                                                        | Description                                           |
| ------------------------------------------------------------- | ----------------------------------------------------- |
| `client.event.get.query({ eventId })`                         | Fetch a single event document by ID.                  |
| `client.locations.list.query({ locationIds })`                | Fetch locations. Also filterable by `isActive`, `locationType` and `externalId`. |
| `client.locations.getLocationHierarchy.query({ locationId })` | Get the full administrative hierarchy for a location. |
| `client.locations.create.mutate(payload)`                     | Create a location with its initial version. Requires the `location.edit` scope. |
| `client.locations.update.mutate(payload)`                     | Append a new version (rename, recode or deactivate). Requires the `location.edit` scope. |
| `client.locations.withdrawVersion.mutate({ id, versionId })`  | Withdraw a version that has not taken effect yet. Requires the `location.edit` scope. |
| `client.administrativeAreas.list.query({ isActive })`         | Fetch administrative areas. `create`, `update` and `withdrawVersion` work the same way as for locations. |
| `client.user.get.query(userId)`                               | Fetch a user's profile by ID.                         |

For the payloads of the location write methods, see [How to add new locations & administrative areas](../../guides/configuration/administrative-hierarchy/how-to-add-locations-and-administrative-areas.md) and [How to update & deactivate locations & administrative areas](../../guides/configuration/administrative-hierarchy/how-to-update-and-deactivate-locations-and-administrative-areas.md).

**Example 1 — fetch an event and read its current state**

```ts
import { createClient } from '@opencrvs/toolkit/api'
import { aggregateActionDeclarations } from '@opencrvs/toolkit/events'

const client = createClient(`${process.env.GATEWAY_HOST}/events`, `Bearer ${token}`)
const event = await client.event.get.query({ eventId })
const state = aggregateActionDeclarations(event)
const childNid = state['child.nid'] as string
```

**Example 2 — resolve a location name from its UUID**

```ts
const client = createClient(`${process.env.GATEWAY_HOST}/events`, `Bearer ${token}`)

const [location] = await client.locations.list.query({ locationIds: [locationId] })
return location.name
```

`location.name` is the name in effect **today**. Locations are versioned, so when the name should match a record — for example on a certificate — resolve the version in effect at the record's date instead:

```ts
import { resolveVersion } from '@opencrvs/toolkit/events'

const [location] = await client.locations.list.query({ locationIds: [locationId] })
// anchorDate is a 'YYYY-MM-DD' string, e.g. the record's date of event
return resolveVersion(location.versions, anchorDate).name
```

See [Updates & versioning](../../guides/configuration/administrative-hierarchy/updates-and-versioning.md) for how versions are resolved.
