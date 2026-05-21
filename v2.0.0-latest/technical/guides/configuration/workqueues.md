---
description: Configuring workqueues
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

# Workqueues

{% hint style="info" %}
This is technical documentation. For the functional overview of workqueues, see [Workqueues](../../../functional/markdown/workflows/workqueues.md)
{% endhint %}

A **workqueue** is a filtered list of records shown in the OpenCRVS UI. Each workqueue applies a query against the event index and presents the matching records in a table.

<div align="center"><figure><img src="../../../.gitbook/assets/Screenshot 2026-05-20 at 14.38.43.png" alt="" width="563"><figcaption><p>A list of configured workqueues</p></figcaption></figure></div>

### Default workqueues

OpenCRVS core provides two workqueues that you do not need to configure. They are not affected by the `workqueue` scope's `ids` list — their visibility is determined by the role's record scopes instead.

| Workqueue  | Shown when                             | Contents                                                                                                                                                    |
| ---------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Drafts** | The role has the `record.create` scope | Records the user has started filling in but not yet submitted. Stored locally on the client until declared.                                                 |
| **Outbox** | The role has any `record.*` scope      | Records the user has triggered actions on that are queued for synchronization with the server. Useful for offline work — the queue drains once back online. |

### Configuring workqueues

Workqueues are configured to the countryconfig under `src/api/workqueue/workqueueConfig.ts`.

Wrap your workqueue array in `defineWorkqueues()` from `@opencrvs/toolkit/events`. The helper parses each entry against `WorkqueueConfig` and warns about common misconfigurations.

{% hint style="info" %}
**Note:** Access to any workqueues requires the **`record.search`** scope. The scope's options further narrow which records the user actually sees inside the workqueue, so a user might only be able to access a subset of the workqueue's matching records.
{% endhint %}

**Example:**

```typescript
// src/api/workqueue/workqueueConfig.ts
import {
  ActionType,
  EventStatus,
  InherentFlags,
  defineWorkqueues,
  user
} from '@opencrvs/toolkit/events'

export const Workqueues = defineWorkqueues([
  {
    slug: 'assigned-to-you',
    icon: 'PushPin',
    name: {
      id: 'workqueues.assignedToYou.title',
      defaultMessage: 'Assigned to you',
      description: 'Title of assigned to you workqueue'
    },
    query: { assignedTo: { type: 'exact', term: user('id') } },
    action: { type: ActionType.READ }
  },
  {
    slug: 'pending-registration',
    icon: 'PenNib',
    name: {
      id: 'workqueues.pendingRegistration.title',
      defaultMessage: 'Pending registration',
      description: 'Title of pending registration workqueue'
    },
    query: {
      status: { type: 'exact', term: EventStatus.enum.DECLARED },
      flags: {
        anyOf: ['validated'],
        noneOf: [InherentFlags.POTENTIAL_DUPLICATE]
      },
      'legalStatuses.DECLARED.createdAtLocation': {
        type: 'within',
        location: user('primaryOfficeId')
      }
    },
    action: { type: ActionType.READ }
  }
])
```

### Controlling visibility of workqueues

A configured workqueue is only visible to users whose role grants the **`workqueue` scope** for its `slug`. The scope carries an `ids` option listing the slugs the role may see.

```typescript
// src/data-seeding/roles/roles.ts
{
  id: 'REGISTRATION_AGENT',
  // ...
  scopes: defineScopes([
    // ... other scopes
    {
      type: 'workqueue',
      options: {
        ids: [
          'assigned-to-you',
          'recent',
          'requires-completion',
          'in-external-validation',
          'pending-validation',
          'pending-updates',
          'pending-approval',
          'pending-certification',
          'pending-issuance',
          'correction-requested'
        ]
      }
    }
  ])
}
```

Notes:

* A workqueue defined in `workqueueConfig.ts` but not listed in any role's `workqueue` scope is never shown.
* Two roles may share the same workqueue by listing the same slug in both — there is no per-role override of the underlying query. To give different roles a different view, define separate workqueues with different slugs.
* The Outbox and Drafts workqueues are not affected by `ids` — they appear automatically.

For the full scope configuration, see [users](users/ "mention").

### WorkqueueConfig schema

{% openapi-schemas spec="events-develop" schemas="WorkqueueConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

