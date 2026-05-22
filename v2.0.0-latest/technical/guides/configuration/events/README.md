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

In a typical country config (see [opencrvs-countryconfig](https://github.com/opencrvs/opencrvs-countryconfig)):

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
  declaration: birthDeclarationForm,
  dateOfEvent: field('child.dob'),
  // title, summary, actions, flags, ...
})
```

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

{% openapi-schemas spec="events-develop" schemas="EventConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
