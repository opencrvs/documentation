---
description: How to configure the declaration and action forms
---

# Declaration & Forms

## Declaration form

The `declaration` property on the [EventConfig schema](../#eventconfig-schema) includes the configuration for the primary record declaration details. For example, for a birth registration event it should contain:

* The child's details, such as the date and place of birth
* The birth informant's details
* Parents' details

When configuring your declaration form, make sure to use the `defineDeclarationForm()` helper.

**Example:**

```typescript
// src/events/birth/forms/declaration.ts
import { defineDeclarationForm, FieldType } from '@opencrvs/toolkit/events'
import { child } from './pages/child'
import { informant } from './pages/informant'
import { mother } from './pages/mother'
import { father } from './pages/father'

export const birthDeclarationForm = defineDeclarationForm({
  label: {
    defaultMessage: 'Birth decalration form',
    id: 'event.birth.action.declare.form.label',
    description: 'This is what this form is referred as in the system'
  },
  pages: [child, informant, mother, father]
})

// src/events/birth/index.ts
import { birthDeclarationForm } from './forms/declaration'

export const birthEvent = defineConfig({
  id: Event.Birth,
  declaration: birthDeclarationForm,
  // ...
```

## Pages

The `declaration`, `printForm` and `correctionForm` configurations use `pages` to split the different form sections in to separate pages. Each page may contain any amount of form fields.

When configuring pages, make sure to use the `defineFormPage()` helper.

**Example:**

```typescript
// src/events/birth/forms/pages/child.ts
import { defineFormPage } from '@opencrvs/toolkit/events'

export const child = defineFormPage({
  id: 'child',
  type: PageTypes.enum.FORM,
  title: {
    defaultMessage: "Child's details",
    description: 'Form section title for Child',
    id: 'form.birth.child.title'
  },
  fields: [
    //...
  ]
})
```



### FieldConfig schema

{% openapi-schemas spec="events-develop" schemas="FieldConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
