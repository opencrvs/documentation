---
description: Configuring actions for your event
---

# Actions

Actions are the workflow steps users can take on a record (declare, validate, register, reject, print a certificate, and so on). You configure them on each event inside `defineConfig()` under the `actions` array. This means that the action configuration is event-specific.

The order of actions in the action menu on the UI is defined in `actionOrder` .

### Configurable action types

Only the following types can be defined in country config. Other action types (for example `ASSIGN`, `CREATE`, `NOTIFY`) are strictly defined by the system and are not configured.

| Type                            | Typical use                                                                                               |
| ------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `ActionType.READ`               | Record-tab content                                                                                        |
| `ActionType.DECLARE`            | Submit a new declaration (includes `review` fields). This config is also shared with `ActionType.NOTIFY`. |
| `ActionType.EDIT`               | Edit record before registration                                                                           |
| `ActionType.REGISTER`           | Register the record                                                                                       |
| `ActionType.REJECT`             | Reject a record before registration                                                                       |
| `ActionType.ARCHIVE`            | Archive a record                                                                                          |
| `ActionType.PRINT_CERTIFICATE`  | Print a certificate                                                                                       |
| `ActionType.REQUEST_CORRECTION` | Request a correction on a registered record                                                               |
| `ActionType.CUSTOM`             | Any kind of custom country-specific step (validate, approve, escalate, …)                                 |

### Action confirmation

Several actions call your country config server before they complete. \<TODO which ones?>

When a user triggers such an action, OpenCRVS core POSTs the current `EventDocument` to the route&#x20;

```typescript
'/trigger/events/{event}/actions/{action}'
```

on your country config server. Your handler returns:

| HTTP status | Meaning                                                                            |
| ----------- | ---------------------------------------------------------------------------------- |
| **200**     | Accept immediately (for `REGISTER`, include `{ registrationNumber }` in the body)  |
| **400**     | Reject immediately                                                                 |
| **202**     | Defer — action stays in `Requested` until you call accept/reject on the events API |

### Scopes

For configuring user scopes for actions, see [users](../../users/ "mention")
