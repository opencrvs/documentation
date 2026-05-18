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

## Action forms

In addition to the primary form, certain actions have separate forms which are filled as part of executing the action. These include:

<table><thead><tr><th width="273.4765625">Configured action type</th><th>Config property</th><th>Description</th></tr></thead><tbody><tr><td><code>ActionType.DECLARE</code></td><td><code>review</code></td><td>Fields to be filled on the review page when declaring a record.</td></tr><tr><td><code>ActionType.READ</code></td><td><code>review</code></td><td><p>Fields to be shown on the review page of a record.</p><p></p><p>This is usually the same as the <code>review</code> config on <code>ActionType.DECLARE</code>.</p></td></tr><tr><td><code>ActionType.PRINT_CERTIFICATE</code></td><td><code>printForm</code></td><td>Form pages to be filled When printing a certificate of a registered record.</td></tr><tr><td><code>ActionType.REQUEST_CORRECTION</code></td><td><code>correctionForm</code></td><td>Form pages to be filled when requesting a correction on a registered record.</td></tr><tr><td><code>ActionType.CUSTOM</code></td><td><code>form</code></td><td>Fields to be filled on the confirmation dialog of the custom action.</td></tr></tbody></table>

For additional action configuration, see [actions](../actions/ "mention").

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
