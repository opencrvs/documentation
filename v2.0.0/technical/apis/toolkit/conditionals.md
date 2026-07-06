---
description: >-
  All conditional builders return a JSONSchema object. Combine them with and,
  or, and not. Use them in field or action conditionals arrays.
---

# Conditionals

#### `field` (conditionals)

Entry point for building conditions on a form field's value.

**Signature**

```ts
function field(fieldId: string): FieldConditionalBuilder
```

The returned builder exposes these methods:

| Method                               | Description                                                                   |
| ------------------------------------ | ----------------------------------------------------------------------------- |
| `.isEqualTo(value)`                  | Field equals a literal value or another field reference.                      |
| `.isFalsy()`                         | Field is `undefined`, `false`, `null`, or `''`.                               |
| `.isUndefined()`                     | Field has never been set.                                                     |
| `.inArray(values)`                   | Field value is one of the given strings.                                      |
| `.matches(pattern)`                  | Field value matches a regex pattern string.                                   |
| `.isBetween(min, max)`               | Numeric field falls within an inclusive range.                                |
| `.isGreaterThan(value)`              | Numeric field is strictly greater than a number or another field.             |
| `.isLessThan(value)`                 | Numeric field is strictly less than a number or another field.                |
| `.isValidEnglishName()`              | Value contains only Latin letters, digits, hyphens, apostrophes, and dots.    |
| `.isValidAdministrativeLeafLevel()`  | Address field points to the lowest administrative level.                      |
| `.get(path)`                         | Navigate into a nested property before applying a check (e.g. `.get('dob')`). |
| `.getByPath(parts)`                  | Same as `.get` but accepts a string array.                                    |
| `.asDob()`                           | Shorthand for `.get('dob')`.                                                  |
| `.asAge()`                           | Shorthand for `.get('age')`.                                                  |
| `.isAfter().days(n).inPast()`        | Date is more than `n` days ago.                                               |
| `.isAfter().days(n).inFuture()`      | Date is more than `n` days in the future.                                     |
| `.isAfter().days(n).fromDate(date)`  | Date is at least `n` days after a fixed date or field reference.              |
| `.isAfter().date(date)`              | Date is after a fixed ISO date or another field reference (no day tolerance). |
| `.isAfter().now()`                   | Date is in the future.                                                        |
| `.isBefore().days(n).inPast()`       | Date is fewer than `n` days ago.                                              |
| `.isBefore().days(n).fromDate(date)` | Date is fewer than `n` days before a fixed date or field reference.           |
| `.isBefore().now()`                  | Date is in the past.                                                          |

**Example 1 — show a field only when another field has a specific value**

```ts
import { field, ConditionalType } from '@opencrvs/toolkit/events'

// Show the birth-facility field only when the place of birth is a health facility
{
  fieldId: 'child.birthLocation',
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: field('child.placeOfBirth').isEqualTo('HEALTH_FACILITY')
    }
  ]
}
```

**Example 2 — hide a field when it has no value**

```ts
// Show the NID field in the summary only when it has been filled in
{
  fieldId: 'child.nid',
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: not(field('child.nid').isFalsy())
    }
  ]
}
```

***

#### `field.get` — nested field access

Navigates into an object-typed field before applying a check.

**Signature**

```ts
field(fieldId: string).get(path: string): FieldConditionalBuilder
```

**Parameters**

| Parameter | Type     | Description                              |
| --------- | -------- | ---------------------------------------- |
| `fieldId` | `string` | Top-level field ID.                      |
| `path`    | `string` | Dot-separated path to a nested property. |

**Example 1 — validate each part of a name field**

```ts
import { and, field } from '@opencrvs/toolkit/events'

const validName = and(
  field('child.name').get('firstname').isValidEnglishName(),
  field('child.name').get('surname').isValidEnglishName()
)
```

**Example 2 — check the address type**

```ts
// Show domestic address fields when the country is the local country
const isDomesticAddress = field('applicant.address').get('country').isEqualTo('FAR')
```

***

#### `and`

All supplied conditions must be true.

**Signature**

```ts
function and(...conditions: JSONSchema[]): JSONSchema
```

**Parameters**

| Parameter       | Type           | Description                                 |
| --------------- | -------------- | ------------------------------------------- |
| `...conditions` | `JSONSchema[]` | Two or more conditional schemas to combine. |

**Example 1 — require both a valid name and a valid date**

```ts
import { and, field } from '@opencrvs/toolkit/events'

const validChild = and(
  field('child.name').get('firstname').isValidEnglishName(),
  field('child.dob').isBefore().now()
)
```

**Example 2 — name validator used in a field's `validations` array**

```ts
// From Farajaland validators.ts
export const invalidNameValidator = (fieldName: string) => ({
  message: { id: 'error.invalidName', defaultMessage: "Invalid characters", description: '' },
  validator: and(
    field(fieldName).get('firstname').isValidEnglishName(),
    field(fieldName).get('middlename').isValidEnglishName(),
    field(fieldName).get('surname').isValidEnglishName()
  )
})
```

***

#### `or`

At least one of the supplied conditions must be true.

**Signature**

```ts
function or(...conditions: JSONSchema[]): JSONSchema
```

**Parameters**

| Parameter       | Type           | Description                                 |
| --------------- | -------------- | ------------------------------------------- |
| `...conditions` | `JSONSchema[]` | Two or more conditional schemas to combine. |

**Example 1 — accept multiple place-of-birth values**

```ts
import { or, field } from '@opencrvs/toolkit/events'

const isKnownPlaceOfBirth = or(
  field('child.placeOfBirth').isEqualTo('HEALTH_FACILITY'),
  field('child.placeOfBirth').isEqualTo('PRIVATE_HOME'),
  field('child.placeOfBirth').isEqualTo('OTHER')
)
```

**Example 2 — show address block when country is unset or local**

```ts
const showDomesticAddress = or(
  field('applicant.address').get('country').isFalsy(),
  field('applicant.address').get('country').isEqualTo('FAR')
)
```

***

#### `not`

Inverts a condition.

**Signature**

```ts
function not(condition: JSONSchema): JSONSchema
```

**Parameters**

| Parameter   | Type         | Description              |
| ----------- | ------------ | ------------------------ |
| `condition` | `JSONSchema` | The condition to negate. |

**Example 1 — show a field when it has a value**

```ts
import { not, field, ConditionalType } from '@opencrvs/toolkit/events'

{
  fieldId: 'child.nid',
  conditionals: [{ type: ConditionalType.SHOW, conditional: not(field('child.nid').isFalsy()) }]
}
```

**Example 2 — display international address fields**

```ts
const isInternationalAddress = not(
  or(
    field('applicant.address').get('country').isEqualTo('FAR'),
    field('applicant.address').get('country').isFalsy()
  )
)
```

***

#### `alwaysTrue`

Returns a condition that is always satisfied. Useful as a no-op placeholder.

**Signature**

```ts
function alwaysTrue(): AjvJSONSchema
```

**Example 1 — unconditionally show a field**

```ts
import { alwaysTrue, ConditionalType } from '@opencrvs/toolkit/events'

{ type: ConditionalType.SHOW, conditional: alwaysTrue() }
```

**Example 2 — use as a default branch in a conditional expression**

```ts
const showWhenOnlineOrAlways = user.isOnline()
  ? user.isOnline()
  : alwaysTrue()
```

***

#### `never`

Returns a condition that is never satisfied. Use it to hide a field or action completely.

**Signature**

```ts
function never(): JSONSchema
```

**Example 1 — hide a field from end users entirely**

```ts
import { never, ConditionalType } from '@opencrvs/toolkit/events'

{ type: ConditionalType.SHOW, conditional: never() }
```

**Example 2 — disable an action for all users**

```ts
import { never, ConditionalType } from '@opencrvs/toolkit/events'

{
  type: ActionType.DELETE,
  conditionals: [{ type: ConditionalType.ENABLE, conditional: never() }]
}
```

***

#### `flag`

Checks whether a named flag is currently set on the event.

**Signature**

```ts
function flag(flagValue: string): JSONSchema
```

**Parameters**

| Parameter   | Type     | Description                                                           |
| ----------- | -------- | --------------------------------------------------------------------- |
| `flagValue` | `string` | The flag ID to check for. Must match an entry in `EventConfig.flags`. |

**Example 1 — show an action only when a flag is set**

```ts
import { flag, ConditionalType } from '@opencrvs/toolkit/events'

{
  type: ConditionalType.SHOW,
  conditional: flag('pending-first-certificate-issuance')
}
```

**Example 2 — require approval step for late registrations**

```ts
{
  type: ConditionalType.ENABLE,
  conditional: not(flag('approval-required-for-late-registration'))
}
```

***

#### `status`

Checks the current registration status of an event.

**Signature**

```ts
function status(statusValue: EventStatus): JSONSchema
```

**Parameters**

| Parameter     | Type          | Description                                                                                                                          |
| ------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `statusValue` | `EventStatus` | One of `'CREATED'`, `'NOTIFIED'`, `'DECLARED'`, `'VALIDATED'`, `'REGISTERED'`, `'REJECTED'`, `'ARCHIVED'`, `'CORRECTION_REQUESTED'`. |

**Example 1 — show register action only after declaration**

```ts
import { status, ConditionalType } from '@opencrvs/toolkit/events'

{ type: ConditionalType.SHOW, conditional: status('DECLARED') }
```

**Example 2 — enable correction only after registration**

```ts
{ type: ConditionalType.ENABLE, conditional: status('REGISTERED') }
```

***

#### `user.hasScope`

Checks whether the current user has a particular scope string in their token.

**Signature**

```ts
user.hasScope(scope: string): JSONSchema
```

**Parameters**

| Parameter | Type     | Description                                                       |
| --------- | -------- | ----------------------------------------------------------------- |
| `scope`   | `string` | A scope string such as `'record.register'` or `'record.declare'`. |

**Example 1 — show register action only for registrars**

```ts
import { user, ConditionalType } from '@opencrvs/toolkit/events'

{ type: ConditionalType.SHOW, conditional: user.hasScope('record.register') }
```

**Example 2 — allow printing only for users with the print scope**

```ts
{ type: ConditionalType.ENABLE, conditional: user.hasScope('record.print-certified-copies') }
```

***

#### `user.hasRole`

Checks whether the current user has a specific role.

**Signature**

```ts
user.hasRole(role: string): JSONSchema
```

**Parameters**

| Parameter | Type     | Description                                                                   |
| --------- | -------- | ----------------------------------------------------------------------------- |
| `role`    | `string` | Role identifier as defined in the country configuration (e.g. `'REGISTRAR'`). |

**Example 1 — show a review action only for local registrars**

```ts
{ type: ConditionalType.SHOW, conditional: user.hasRole('LOCAL_REGISTRAR') }
```

**Example 2 — disable national-level actions for field agents**

```ts
{ type: ConditionalType.ENABLE, conditional: not(user.hasRole('FIELD_AGENT')) }
```

***

#### `user.isOnline`

Returns true when the user has an active internet connection.

**Signature**

```ts
user.isOnline(): JSONSchema
```

**Example 1 — require online for biometric verification**

```ts
{ type: ConditionalType.ENABLE, conditional: user.isOnline() }
```

**Example 2 — show an offline banner field when disconnected**

```ts
{ type: ConditionalType.SHOW, conditional: not(user.isOnline()) }
```

***

#### `event.hasAction`

Checks whether the event's action history contains a specific action type.

**Signature**

```ts
event.hasAction(action: ActionType): JSONSchema & {
  withFields(fields: Record<string, unknown>): { minCount(n: number): JSONSchema; maxCount(n: number): JSONSchema }
  withTemplate(id: string): { minCount(n: number): JSONSchema; maxCount(n: number): JSONSchema }
  minCount(n: number): JSONSchema
  maxCount(n: number): JSONSchema
}
```

**Parameters**

| Parameter             | Type         | Description                                             |
| --------------------- | ------------ | ------------------------------------------------------- |
| `action`              | `ActionType` | The action type to look for in the event's action list. |
| `.minCount(n)`        | —            | Require at least `n` occurrences of the action.         |
| `.maxCount(n)`        | —            | Require at most `n` occurrences.                        |
| `.withTemplate(id)`   | —            | Further filter by certificate template ID.              |
| `.withFields(fields)` | —            | Further filter by arbitrary action fields.              |

**Example 1 — show issue-certified-copy only after first certificate was printed**

```ts
import { event, ConditionalType, ActionType } from '@opencrvs/toolkit/events'

{ type: ConditionalType.SHOW, conditional: event.hasAction(ActionType.PRINT_CERTIFICATE) }
```

**Example 2 — limit re-printing to at most one time**

```ts
{
  type: ConditionalType.ENABLE,
  conditional: event.hasAction(ActionType.PRINT_CERTIFICATE).maxCount(1)
}
```

#### `defineFormConditional`

Low-level escape hatch for writing a raw JSON Schema conditional against form data. The schema is automatically wrapped so it validates against `$form`.

**Signature**

```ts
function defineFormConditional(schema: Record<string, unknown>): JSONSchema
```

**Parameters**

| Parameter | Type                      | Description                                                         |
| --------- | ------------------------- | ------------------------------------------------------------------- |
| `schema`  | `Record<string, unknown>` | A JSON Schema object that will be evaluated against the form state. |

**Example 1 — validate a national ID with a regex**

```ts
import { defineFormConditional } from '@opencrvs/toolkit/conditionals'

export const nationalIdValidator = (fieldId: string) => ({
  message: {
    id: 'error.invalidNationalId',
    defaultMessage: 'The national ID must be 10 digits',
    description: ''
  },
  validator: defineFormConditional({
    type: 'object',
    properties: {
      [fieldId]: { type: 'string', pattern: '^[0-9]{10}$' }
    }
  })
})
```

**Example 2 — require a field to be a positive integer**

```ts
const mustBePositive = defineFormConditional({
  type: 'object',
  properties: {
    'child.birthOrder': { type: 'number', minimum: 1 }
  },
  required: ['child.birthOrder']
})
```
