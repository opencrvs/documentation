---
description: Configuring form field validations
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
  actions:
    visible: true
---

# Form validations

All form fields support custom validations, which are configured with the `validation` property. **If a validation does not pass, it means the form is filled incorrectly and a validation error is displayed.**

The `validation` property takes an array of validations, and all of them must pass for the validation of that field to succeed.

{% hint style="info" %}
Validators are conditionals. Each `validator` has the similar expressions you would write for a `SHOW` / `ENABLE` conditional — most commonly built from the `field(...)` chain, optionally combined with `and` / `or` / `not`. See [conditionals.md](../conditionals.md "mention") for the full list of helpers.
{% endhint %}

The `validation` property is only used for content checks on a filled-in value. To mark a field as mandatory, use the separate `required` property on the field configuration.

**Example:**

In this example, we have a father's date-of-birth field with two custom validations:

1. The inputted date must be before today.
2. The inputted date must be before the inputted child's date of birth, `child.dob`.
   1. For the validation to work correctly, we expect that the `child.dob` field is configured on the form (but it may be on a different page).

```typescript
import { field, defineFormPage, FieldType } from '@opencrvs/toolkit/events'

export const father = defineFormPage({
  id: 'father',
  title: {
    defaultMessage: "Father's details",
    description: 'Form section title for fathers details',
    id: 'form.section.father.title'
  },
  fields: [
    // ... other fields
    {
      id: 'father.dob',
      type: FieldType.DATE,
      validation: [
        {
          message: {
            defaultMessage: 'Must be a valid Birthdate',
            description: 'This is the error message for invalid date',
            id: 'event.birth.action.declare.form.section.person.field.dob.error'
          },
          validator: field('father.dob').isBefore().now()
        },
        {
          message: {
            defaultMessage: "Birth date must be before child's birth date",
            description:
              "This is the error message for a birth date after child's birth date",
            id: 'event.birth.action.declare.form.section.person.dob.afterChild'
          },
          validator: field('father.dob').isBefore().date(field('child.dob'))
        }
      ]
    }
  ]
})
```

Now both validations must succeed for the validation to pass, otherwise we will display a validation error on the UI and consider the declaration as incomplete.

Validation errors on the declaration form are shown both on the form page, and the review page:

{% columns %}
{% column %}
<figure><img src="../../../../../.gitbook/assets/Screenshot 2026-05-20 at 9.48.30.png" alt=""><figcaption><p>Form page</p></figcaption></figure>
{% endcolumn %}

{% column %}
<figure><img src="../../../../../.gitbook/assets/Screenshot 2026-05-20 at 9.49.05.png" alt=""><figcaption><p>Review page</p></figcaption></figure>
{% endcolumn %}
{% endcolumns %}

### ValidationConfig schema

{% openapi-schemas spec="events-develop" schemas="ValidationConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
