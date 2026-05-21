---
description: Configuring custom actions
---

# Custom actions

In addition to [core-actions.md](core-actions.md "mention"), an event may implement **any number of custom actions**. These actions may be freely defined by each country to reflect its unique requirements.

Custom actions are also defined in the `actions` array using `ActionType.CUSTOM`.

**Example:**

```typescript
export const birthEvent = defineConfig({
  // ... other event configuration ...
  actions: [
    // ... other action configurations ...
    {
      type: ActionType.CUSTOM,
      customActionType: 'ESCALATE',
      icon: 'FileArrowUp',
      label: {
        defaultMessage: 'Escalate',
        description: 'The label shown on the action menu for Escalate-action',
        id: 'event.birth.action.escalate.label'
      },
      supportingCopy: {
        defaultMessage: 'Escalating this declaration will forward it to the chosen authority for further review and decision.',
        description: 'This is the confirmation text for the escalate action',
        id: 'event.birth.action.escalate.supportingCopy'
      },
      form: [ /* The custom action may contain form fields which are filled in the dialog modal when executing the action */  ],
      flags: [ /* Like other actions, custom actions may add or remove flags */ ],
      auditHistoryLabel: {
        defaultMessage: 'Escalated',
        description: 'The label to show in audit history for the escalate action',
        id: 'event.birth.action.escalate.audit-history-label'
      }
    },
  ],
})
```

## CustomActionConfig schema

{% openapi-schemas spec="events-develop" schemas="CustomActionConfig" grouped="false" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

