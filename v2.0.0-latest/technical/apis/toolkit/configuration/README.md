# Configuration

`defineConfig`

Defines and validates a complete event type (birth, death, marriage, or any custom event). Parses and validates the config at startup; throws if the config is invalid.

**Signature**

```ts
function defineConfig(config: EventConfigInput): EventConfig
```

**Parameters**

{% openapi-schemas spec="events-develop" schemas="EventConfig" grouped="false" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

**Example 1 — marriage event**

```ts
import { defineConfig, field, ActionType } from '@opencrvs/toolkit/events'

export const marriageEvent = defineConfig({
  id: 'marriage',
  label: { id: 'event.marriage.label', defaultMessage: 'Marriage', description: '' },
  title: {
    id: 'event.marriage.title',
    defaultMessage: '{bride.name.firstname} & {groom.name.firstname}',
    description: ''
  },
  fallbackTitle: { id: 'event.marriage.fallbackTitle', defaultMessage: 'No names provided', description: '' },
  dateOfEvent: field('marriage.date'),
  summary: { fields: [{ fieldId: 'marriage.date' }, { fieldId: 'marriage.placeOfMarriage' }] },
  declaration: MARRIAGE_DECLARATION_FORM,
  actions: [
    { type: ActionType.DECLARE, label: { id: 'event.marriage.declare', defaultMessage: 'Declare', description: '' }, review: MARRIAGE_REVIEW_FORM, form: MARRIAGE_DECLARATION_FORM },
    { type: ActionType.REGISTER, label: { id: 'event.marriage.register', defaultMessage: 'Register', description: '' }, review: MARRIAGE_REVIEW_FORM, form: MARRIAGE_DECLARATION_FORM }
  ]
})
```

**Example 2 — birth event with date/place references**

```ts
export const birthEvent = defineConfig({
  id: 'birth',
  label: { id: 'event.birth.label', defaultMessage: 'Birth', description: '' },
  title: {
    id: 'event.birth.title',
    defaultMessage: '{child.name.firstname} {child.name.surname}',
    description: ''
  },
  fallbackTitle: { id: 'event.birth.fallbackTitle', defaultMessage: 'No name provided', description: '' },
  dateOfEvent: field('child.dob'),
  placeOfEvent: field('child.birthLocationId'),
  summary: { fields: [{ fieldId: 'child.dob' }] },
  declaration: BIRTH_DECLARATION_FORM,
  actions: [
    { type: ActionType.DECLARE, label: { id: 'event.birth.declare', defaultMessage: 'Declare', description: '' }, review: BIRTH_REVIEW_FORM, form: BIRTH_DECLARATION_FORM }
  ]
})
```
