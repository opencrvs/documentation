---
description: How to configure life events
---

# Events

Over view of this topic from a dev perspectvie + link to product specifications

TODO: [**Events**](../../../../functional/markdown/images-and-media/) are...



When configuring your event, make sure to wrap it in the `defineConfig()` helper; this ensures type safety and provides warnings for misconfigurations to the country config server console logs.

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



TODO: Add OpenAPI doc for EventConfig here?
