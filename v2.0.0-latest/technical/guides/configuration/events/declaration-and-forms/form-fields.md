---
description: Configuring form fields
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

# Form fields

OpenCRVS provides a selection of different kinds of form fields, which can be used on the declaration or action forms.

Note that some of the form fields are read-only fields intended to provide additional information on the form.

## Field conditionals

Every form field accepts an optional `conditionals` array which gates whether the field is shown, enabled, or displayed on the review page. Each entry is a [`FieldConditional`](form-fields.md#fieldconditional-schema) wrapping a conditional expression:

* `ConditionalType.SHOW` — Field is shown only when the conditional holds.
* `ConditionalType.ENABLE` — Field is editable only when the conditional holds.
* `ConditionalType.DISPLAY_ON_REVIEW` — Field appears on the review page only when both this conditional and the `SHOW` conditional hold.

When `conditionals` is omitted, the field is shown and enabled for everyone, and is displayed on review whenever it has a value.

For available conditional helper functions, see [conditionals.md](../conditionals.md "mention")

**Example — hide a field on the review page using `never()`:**

```typescript
import { ConditionalType, FieldType, never } from '@opencrvs/toolkit/events'

{
  id: 'recommender.none',
  type: FieldType.CHECKBOX,
  // ...
  conditionals: [
    {
      type: ConditionalType.DISPLAY_ON_REVIEW,
      conditional: never()
    }
  ]
}
```

### FieldConditional schema

{% openapi-schemas spec="events-develop" schemas="FieldConditional" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

## Available field types

\<TODO>
