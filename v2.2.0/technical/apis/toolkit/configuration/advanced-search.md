# Advanced search

Advanced search fields are built with `field` and `event` from `@opencrvs/toolkit/events`. Each call returns a builder with `.exact()`, `.range()`, `.fuzzy()`, or `.within()`.

***

#### `field` (advanced search)

Configures a declaration form field for advanced search.

**Signature**

```ts
function field(
  fieldId: string,
  options?: {
    options?: SelectOption[]
    conditionals?: FieldConditional[]
    validations?: ValidationConfig[]
    searchCriteriaLabelPrefix?: TranslationConfig
    defaultValue?: boolean | string | number
  }
): AdvancedSearchFieldBuilder
```

**Parameters**

| Parameter                           | Type                  | Description                                                                        |
| ----------------------------------- | --------------------- | ---------------------------------------------------------------------------------- |
| `fieldId`                           | `string`              | ID of the declaration form field to expose in search.                              |
| `options.options`                   | `SelectOption[]?`     | Override dropdown options for the search input.                                    |
| `options.conditionals`              | `FieldConditional[]?` | Override visibility conditionals; pass `[]` to always show the field.              |
| `options.validations`               | `ValidationConfig[]?` | Override validations for the search input.                                         |
| `options.searchCriteriaLabelPrefix` | `TranslationConfig?`  | Prefix shown before the field label in search result summaries (e.g. `"Child's"`). |
| `options.defaultValue`              | `boolean \| string \| number?` | Value the field opens with in advanced search. Omitted or `true` keeps the declaration form's `defaultValue`; `false` opens the field empty; a text, number or date value opens it with that value. |

Only TEXT, TEXTAREA, EMAIL, PHONE, ID, SELECT, RADIO_GROUP, COUNTRY, LOCATION, ADMINISTRATIVE_AREA, NUMBER and DATE fields take a value. Other field types (such as NAME and ADDRESS) and dates searched as a range accept only `true` or `false`. Fields using `config.searchFields` don't support `defaultValue`. An event configuration that breaks these rules fails validation.

The returned builder exposes four terminal methods:

| Method      | Match type         | Use for                             |
| ----------- | ------------------ | ----------------------------------- |
| `.exact()`  | Exact              | IDs, select fields, gender          |
| `.range()`  | Date range         | Dates of birth, registration dates  |
| `.fuzzy()`  | Fuzzy text         | Names                               |
| `.within()` | Location hierarchy | Administrative area location fields |

**Example 1 — name field with prefix and no validations**

```ts
import { field } from '@opencrvs/toolkit/events'

field('child.name', {
  searchCriteriaLabelPrefix: { id: 'prefix.child', defaultMessage: "Child's", description: '' },
  validations: [],
  conditionals: []
}).fuzzy()
```

**Example 2 — select field with custom options**

```ts
field('child.placeOfBirth', {
  options: [
    { value: 'HEALTH_FACILITY', label: { id: 'place.facility', defaultMessage: 'Health facility', description: '' } },
    { value: 'PRIVATE_HOME', label: { id: 'place.home', defaultMessage: 'Private home', description: '' } }
  ]
}).exact()
```

**Example 3 — open a name field empty instead of using the form default**

```ts
field('applicant.name', { defaultValue: false }).fuzzy()
```

***

#### `event` (advanced search)

Configures an event metadata field (tracking ID, status, registration date, location) for advanced search.

**Signature**

```ts
function event(fieldId: EventFieldIdInput): AdvancedSearchFieldBuilder
```

**Parameters**

| `fieldId` value                                 | Description                             |
| ----------------------------------------------- | --------------------------------------- |
| `'trackingId'`                                  | The tracking ID assigned at creation.   |
| `'status'`                                      | Current registration status.            |
| `'legalStatuses.REGISTERED.acceptedAt'`         | Date of registration.                   |
| `'legalStatuses.REGISTERED.createdAtLocation'`  | Office where the record was registered. |
| `'legalStatuses.REGISTERED.registrationNumber'` | The official registration number.       |
| `'updatedAt'`                                   | Last modification date.                 |

**Example 1 — search by registration date range**

```ts
import { event } from '@opencrvs/toolkit/events'

event('legalStatuses.REGISTERED.acceptedAt').range()
```

**Example 2 — search by registering office (within the location hierarchy)**

```ts
event('legalStatuses.REGISTERED.createdAtLocation').within()
```
