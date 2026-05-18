---
description: How to configure life events
---

# Events

{% hint style="info" %}
This is technical documentation. To see functional definition of events, navigate to [images-and-media](../../../../functional/markdown/images-and-media/ "mention")
{% endhint %}

When configuring your event, make sure to wrap it in the `defineConfig()` helper; this ensures type safety and provides warnings for misconfigurations to the country config server log.

**Example:**

```typescript
// src/events/birth/index.ts
import { defineConfig } from '@opencrvs/toolkit/events'

export const birthEvent = defineConfig({
  id: 'birth',
  // ... further configuration
})

// src/api/events/handler.ts
import { birthEvent } from '../marriage'
import { otherEvent } from '../other'

export function getEventsHandler(_: Hapi.Request, h: Hapi.ResponseToolkit) {
  return h
    .response([birthEvent, otherEvent])
    .code(200)
}
```

## EventConfig schema

{% openapi-schemas spec="events-develop" schemas="EventConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

