# Summary

The `summary` config defines the **event overview page** — the record summary a user sees when they open a record. It has two parts:

* `fields` — the rows of the summary.
* `banners` — optional info boxes shown above the fields.

```typescript
// src/events/birth/index.ts
export const birthEvent = defineConfig({
  // id, label, declaration, actions, flags, ...
  summary: {
    banners: [ /* info boxes — see Banners */ ],
    fields: [ /* rows — see Summary fields */ ]
  }
})
```

## Summary fields

Each entry in `fields` is a row. There are two kinds.

### Reference an existing declaration field

Point at a declaration field by `fieldId` to show its value. Optionally override its `label`, provide an `emptyValueMessage` for when it has no value, and gate it with `conditionals`.

```typescript
{
  fieldId: 'child.dob',
  emptyValueMessage: {
    id: 'event.birth.summary.child.dob.empty',
    defaultMessage: 'No date of birth',
    description: 'Shown when the child has no recorded date of birth'
  }
}
```

### Define a custom field

A custom row has its own `id`, `label` and a templated `value`. The `value` template can reference:

* **declaration data** by field id — e.g. `{informant.phoneNo} {informant.email}`;
* **event metadata** via the `event.` prefix — e.g. `{event.legalStatuses.REGISTERED.acceptedAt, date, ::dd MMMM yyyy}`.

Metadata date fields are timestamps, so format them with the ICU `date` syntax as shown, rather than printing them raw.

```typescript
{
  id: 'event.registeredAt',
  label: {
    id: 'event.adoption.summary.event.registeredAt.label',
    defaultMessage: 'Registration date',
    description: 'Label for the registration date row'
  },
  value: {
    id: 'event.adoption.summary.event.registeredAt.value',
    defaultMessage:
      '{event.legalStatuses.REGISTERED.acceptedAt, date, ::dd MMMM yyyy}',
    description: 'The date the record was registered'
  },
  emptyValueMessage: {
    id: 'event.adoption.summary.event.registeredAt.empty',
    defaultMessage: 'No registration date',
    description: 'Shown before the record is registered'
  }
}
```

### Show or hide a row

Both kinds accept an array of [conditionals.md](conditionals.md "mention"). When omitted, the row is always shown. This is how, for example, [sealed-records.md](../../use-cases/sealed-records.md "mention") hides sensitive rows with `not(flag('sealed'))`:

```typescript
{
  fieldId: 'child.nid',
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: and(not(field('child.nid').isFalsy()), not(flag('sealed')))
    }
  ]
}
```

## Banners

`banners` is an array of **info boxes** displayed above the summary fields. Use one to surface a state or a suggested next step — for example a "Record is protected" notice on a sealed record.

Each banner is an `InfoBox`:

| Property       | Required | Description                                                                             |
| -------------- | -------- | --------------------------------------------------------------------------------------- |
| `type`         | yes      | Semantic tint: `info` (blue), `positive` (green), `warning` (orange), `negative` (red). |
| `heading`      | yes      | Primary message. Short, sentence-case.                                                  |
| `description`  | no       | Secondary copy below the heading, typically a suggested next step.                      |
| `icon`         | no       | Icon shown in the block. Defaults to `FileSearch`.                                      |
| `background`   | no       | `tinted` (default) reads as a recessed empty state; `white` reads as a standalone card. |
| `conditionals` | no       | `SHOW` conditions. When omitted, the banner is always shown.                            |

**Example — a banner shown only while the record carries the `sealed` flag:**

```typescript
summary: {
  banners: [
    {
      type: 'negative',
      icon: 'FileLock',
      heading: {
        id: 'event.birth.summary.banner.sealed.title',
        defaultMessage: 'Record is protected',
        description: 'Heading of the banner shown when a record is sealed'
      },
      description: {
        id: 'event.birth.summary.banner.sealed.description',
        defaultMessage: 'Request to unseal to view this record',
        description: 'Description of the banner shown when a record is sealed'
      },
      conditionals: [
        { type: ConditionalType.SHOW, conditional: flag('sealed') }
      ]
    }
  ],
  fields: [ /* ... */ ]
}
```

## SummaryConfig schema

{% openapi-schemas spec="events-develop" schemas="SummaryConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
