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
| `client.locations.list.query({ locationIds })`                | Fetch one or more location objects by UUID.           |
| `client.locations.getLocationHierarchy.query({ locationId })` | Get the full administrative hierarchy for a location. |
| `client.user.get.query(userId)`                               | Fetch a user's profile by ID.                         |

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
