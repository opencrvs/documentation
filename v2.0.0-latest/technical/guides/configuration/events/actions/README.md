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

[core-actions.md](core-actions.md "mention") are actions defined by the OpenCRVS core and all event types implement these actions. In addition to core actions, an event may implement any number of [custom-actions.md](custom-actions.md "mention"). These actions may be freely defined by each country to reflect its unique requirements.

The order of actions in the action menu on the UI is defined in `actionOrder` .

### Action triggers

For configuring action triggers, see [action-triggers](../../action-triggers/ "mention")

### Scopes

For configuring user scopes for actions, see [users](../../users/ "mention")
