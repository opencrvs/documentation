---
description: Configuring actions for your event
layout:
  width: wide
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
---

# Actions

Actions are the workflow steps users can take on a record (declare, validate, register, reject, print a certificate, and so on). You configure them on each event inside `defineConfig()` under the `actions` array. This means that the action configuration is event-specific.

[core-actions.md](core-actions.md "mention") are actions defined by the OpenCRVS core and which all events must implement. In addition to core actions, an event may implement any number of [custom-actions.md](custom-actions.md "mention"). These actions may be freely defined by each country to meet its unique requirements.

The order of actions in the action menu on the UI is defined on the [EventConfig schema](../#eventconfig-schema) with the `actionOrder` property. Each entry is either an `ActionType` (for core actions) or a `customActionType` string (for custom actions).

**Example:**

```typescript
export const birthEvent = defineConfig({
  id: 'birth',
  actionOrder: [
    ActionType.ASSIGN,
    ActionType.REGISTER,
    ActionType.DECLARE,
    ActionType.EDIT,
    ActionType.MARK_AS_DUPLICATE,
    'MY_CUSTOM_ACTION_TYPE',
    ActionType.REJECT,
    ActionType.ARCHIVE,
    ActionType.DELETE,
    ActionType.PRINT_CERTIFICATE,
    ActionType.REQUEST_CORRECTION,
    ActionType.UNASSIGN
  ],
  actions: [
    // 'actions' must contain all core action configurations,
    // and additionally it may contain any number of custom action configurations
  ],
  // label, declaration, title, summary, flags, ...
})
```

## Action conditionals

Every action config accepts an optional `conditionals` array which gates whether the action is shown or enabled for the current user and record. Each entry is an `ActionConditional` wrapping a conditional expression:

* `ConditionalType.SHOW` — Action is shown only when the conditional holds.
* `ConditionalType.ENABLE` — Action is shown but disabled unless the conditional holds.

When `conditionals` is omitted, the action is shown and enabled for everyone.

For available conditional helper functions, see [conditionals.md](../conditionals.md "mention")

**Example:**

```typescript
import {
  ActionType,
  ConditionalType,
  and,
  flag,
  InherentFlags,
  not,
  status
} from '@opencrvs/toolkit/events'

{
  type: ActionType.CUSTOM,
  customActionType: 'VALIDATE_DECLARATION',
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: and(status('DECLARED'), not(flag('validated')))
    },
    {
      type: ConditionalType.ENABLE,
      conditional: not(flag(InherentFlags.POTENTIAL_DUPLICATE))
    }
  ]
}
```

### ActionConditional schema

{% openapi-schemas spec="events-develop" schemas="ActionConditional" grouped="false" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

## Action triggers

For configuring action triggers, see [action-triggers](../../action-triggers/ "mention")

## Scopes

For configuring user scopes for actions, see [users](../../users/ "mention")
