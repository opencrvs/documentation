---
description: How to configure life events
---

# Events

{% hint style="info" %}
This is technical documentation. For the functional overview of events, see [events](../../../../functional/markdown/events/ "mention")
{% endhint %}

An **event** is a life event your country registers in OpenCRVS (for example birth or death). You configure each event in your country config repository under `src/events/`, then expose all event configs to the core via a single API handler.

The core fetches the event configurations from the country config server via a predefined HTTP endpoint. This means you can, for example, implement custom logic for defining your configs — as long as the endpoint exists and returns a valid array of event configurations.

### File layout

In a typical country config (see [packages/countryconfig-template](https://github.com/opencrvs/opencrvs-core/tree/v2.1.0/packages/countryconfig-template)):

| Path                          | Purpose                                          |
| ----------------------------- | ------------------------------------------------ |
| `src/events/<event>/index.ts` | Event definition (`defineConfig`)                |
| `src/events/<event>/forms/`   | Declaration, review, print, and correction forms |
| `src/events/index.ts`         | Aggregates all events into `eventConfigs`        |
| `src/api/events/handler.ts`   | Returns `eventConfigs` to the OpenCRVS client    |

### Define an event

Wrap each event in the `defineConfig()` helper.

**Example**:

```typescript
// src/events/birth/index.ts
import { ActionType, defineConfig, field } from '@opencrvs/toolkit/events'
import { birthDeclarationForm } from './forms/declaration'

export const birthEvent = defineConfig({
  id: 'birth',
  label: {
    defaultMessage: 'Birth',
    description: 'This is what this event is referred as in the system',
    id: 'event.birth.label'
  },
  dateOfEvent: field('child.dob'),
  actions: [
    {
      type: ActionType.DECLARE,
      declaration: birthDeclarationForm
      // label, review, ...
    }
    // other actions
  ]
  // title, summary, flags, ...
})
```

### Event versions

An event can have several versions, each effective from a date. Pass them to `defineConfig` under `versions`. Fields shared by every version (`id`, `label`, `advancedSearch`) stay at the top level. All other fields (`actions`, `title`, `summary`, `flags`, ...) are defined on each version.

```typescript
export const birthEvent = defineConfig({
  id: 'birth',
  label: { ... },
  versions: [
    { id: 'initial', actions: [ ... ] },
    { id: 'v2', effectiveFrom: '2027-01-01', actions: [ ... ] }
  ]
})
```

* `effectiveFrom` has the format `YYYY-MM-DD`. A version without it is effective from the beginning of time (`0001-01-01`).
* Version ids and `effectiveFrom` dates must be unique within an event.
* `defineConfig` still accepts a flat configuration, as in the example above. It wraps it in a single version with the id `initial`.

#### Which version a record uses

A version takes effect at midnight in the country's time zone (`SYSTEM_IANA_TIMEZONE`). A record is created under the version in effect that day and keeps it for its whole life. Every action on the record, its validation, its workqueue row and the duplicate comparison use that version, even after a newer one takes effect. A record created offline keeps the version in effect when the user created it.

The record stores the version's id as `configVersionId`. Event documents and search results include it. To show it on the record overview, add a custom field to `summary.fields` with the value `{event.configVersionId}`.

When a new version takes effect, the client uses it for new records without a reload. A form that is already open does not change.

#### Rules for versions

* An event must have a version in effect today, or `defineConfig` rejects it. It checks today in UTC−12, the last time zone to begin the day. Schedule an event's only version a day ahead.
* Records created before 2.2 have the version `initial`. When you add `versions` to an existing event, give the version that holds your current configuration the id `initial`.
* Never remove or rename a version that records use. A record whose version is not configured cannot be opened, and the search reindex fails, naming the missing version.

#### Reading a version in code

`defineConfig` returns a `VersionedEventConfig`. To read the fields of a version in code, use `resolveEventConfig`, for example `resolveEventConfig(birthEvent).actions`. The `opencrvs upgrade` command runs the `resolve-versioned-event-config` codemod. It rewrites such reads under `src/` and lists the ones that it could not rewrite.

#### API

* Each event in the `GET /api/events/config` response is `{ id, label, advancedSearch, versions }`. Each version has its `id` and `effectiveFrom`.
* `event.create` takes an optional `configVersionId`. Without it, the record is created under the version in effect. A given `configVersionId` must be a configured version that is already in effect, or the call fails with HTTP 400.

Core 2.2 reads only the versioned shape, so upgrade core and the country config together.

### Register events with the API

First, export every event from `src/events/index.ts`, then return that array from your events handler:

```typescript
// src/events/index.ts
import { birthEvent } from './birth'
import { deathEvent } from './death'

export const eventConfigs = [birthEvent, deathEvent]
```

Then, import and use them in the `getEventsHandler()`:

```typescript
// src/api/events/handler.ts
import * as Hapi from '@hapi/hapi'
import { eventConfigs } from '@countryconfig/events'

export function getEventsHandler(_: Hapi.Request, h: Hapi.ResponseToolkit) {
  return h.response(eventConfigs).code(200)
}
```

### Advanced search

The `advancedSearch` property defines the tabs and searchable fields shown on the advanced search page for an event. See [advanced-search.md](../../../apis/toolkit/configuration/advanced-search.md "mention") for the helper reference.

### Deduplication

The `deduplication` property on the declare and register actions defines a query used to flag potential duplicate records on submission. See [deduplication.md](../../../apis/toolkit/deduplication.md "mention") for the helper reference.

### EventConfig schema

{% openapi-schemas spec="events-v20" schemas="EventConfig" grouped="true" %}
[OpenAPI events-v20](https://api.opencrvs.org/release-v2.0.0/events/openapi.yml)
{% endopenapi-schemas %}
