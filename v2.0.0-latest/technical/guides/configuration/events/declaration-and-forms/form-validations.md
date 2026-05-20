---
description: Configuring form field value validations
---

# Form validations

All form fields support custom validations, which are configured with the `validation` property. **If a validation does not pass, it means the form is filled incorrectly and a validation error is displayed.**

The `validation` property takes an array of validations, and all of them must pass for the validation to succeed.

**Example:**

In this example, we have a father's date-of-birth field with two custom validations:

1. The inputted date must be before today
2. The inputted datemust be before the inputted child's date-of-birth `child.dob`
   1. For the validation to work correctly, we expect that the `child.dob` field has is configured on the form (but it may be on a different page).

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

| Form page                                                                                                                     | Review page                                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| <p></p><p><img src="../../../../../.gitbook/assets/Screenshot 2026-05-20 at 9.48.30 (1).png" alt="" data-size="original"></p> | <p><img src="../../../../../.gitbook/assets/Screenshot 2026-05-20 at 9.49.05 (2).png" alt="" data-size="original"></p><p></p> |
