# Certificate variables & helpers

Certificate templates are SVG files that use [Handlebars](https://handlebarsjs.com/) syntax. When a certificate is printed or reviewed, OpenCRVS compiles the SVG by injecting runtime data and executing helpers.

***

### Table of Contents

1. How It Works
2. Context Objects
3. $declaration — Form Field Data
4. $metadata — Event Metadata
5. Handlebars Helpers
6. Real Template Patterns
7. Custom Country Helpers

***

### How It Works

When printing a certificate:

1. The form field values (`$declaration`) are run through each field type's `toCertificateVariables()` method — raw IDs and dates become human-readable strings and nested objects.
2. Event metadata (`$metadata`) is resolved similarly — UUID references become names, dates become formatted strings.
3. The resolved data is compiled into a Handlebars template object and rendered into the SVG.

```
SVG Template (Handlebars)
  + $declaration  (stringified form data)
  + $metadata     (resolved event metadata)
  + $review       (boolean)
  + $references   (raw lookup maps)
  ↓
Rendered SVG → PDF
```

***

### Context Objects

These are the top-level variables available in every template.

| Variable       | Type    | Description                                                                           |
| -------------- | ------- | ------------------------------------------------------------------------------------- |
| `$declaration` | object  | All form field values, stringified and ready to display                               |
| `$metadata`    | object  | Event lifecycle data — registrar, dates, location, status                             |
| `$review`      | boolean | `true` during the review/preview step, `false` when actually printing                 |
| `$references`  | object  | Raw data maps: `{ locations: Map, users: Array }` — rarely used directly in templates |

***

### $declaration — Form Field Data

`$declaration` holds the output of all form fields. Each key is a field ID. The shape of the value depends on the field type.

#### Simple Fields (Text, Number, Select, Radio, etc.)

Raw string value. No transformation.

```handlebars
{{$lookup $declaration "child.gender"}}
{{$lookup $declaration "deceased.age"}}
```

#### DateField

Returns a **locale-formatted date string** (e.g. `"15 March 2024"`).

The format comes from the `configuration.dateFormat` i18n message (default: `"d MMMM y"`).

```handlebars
{{$lookup $declaration "child.dob"}}
{{$lookup $declaration "deceased.dob"}}
```

#### Name Field

Returns a **nested object** with four properties:

| Property     | Value                                        |
| ------------ | -------------------------------------------- |
| `fullname`   | All parts joined: `"John Michael Doe"`       |
| `firstname`  | `"John"`                                     |
| `middlename` | `"Michael"` (or undefined if not configured) |
| `surname`    | `"Doe"`                                      |

```handlebars
{{$lookup $declaration "child.name.fullname"}}
{{$lookup $declaration "mother.name.firstname"}}
{{$lookup $declaration "father.name.surname"}}
```

#### Address Field

Returns a **nested object**. The keys vary depending on whether it's a domestic or international address.

| Property                       | Value                                                                                  |
| ------------------------------ | -------------------------------------------------------------------------------------- |
| `country`                      | Country name string (e.g. `"Farajaland"`)                                              |
| `addressType`                  | `"DOMESTIC"` or `"INTERNATIONAL"`                                                      |
| `administrativeHierarchy`      | Pre-joined location string, most-specific first (e.g. `"Ibombo, Central, Farajaland"`) |
| `streetLevelDetails`           | Object with any street-level sub-fields (`{ addressLine1: "42 Main St" }`)             |
| `province` / `district` / etc. | Individual admin level names — keys match your country's `ADMIN_STRUCTURE` config      |

The `administrativeHierarchy` convenience field is the easiest way to render a full address line — it handles missing levels gracefully (no leading commas).

```handlebars
{{$lookup $declaration "child.birthLocation.name"}}
{{$lookup $declaration "child.birthLocation.administrativeHierarchy"}}
{{$lookup $declaration "mother.address.country"}}
{{$lookup $declaration "mother.address.streetLevelDetails.addressLine1"}}
```

#### LocationSearch Field (Health Facility, Office, etc.)

Resolves a stored UUID into a **nested object** of names:

| Property                       | Value                                           |
| ------------------------------ | ----------------------------------------------- |
| `name`                         | Location name (e.g. `"Ibombo Rural Hospital"`)  |
| `country`                      | Country name (e.g. `"Farajaland"`)              |
| `province` / `district` / etc. | Admin level names from the location's hierarchy |

```handlebars
{{$lookup $declaration "child.birthLocation.name"}}
{{$lookup $declaration "child.birthLocation.district"}}
{{$join ", " ($lookup $declaration "child.birthLocation.district") ($lookup $declaration "child.birthLocation.province") ($lookup $declaration "child.birthLocation.country")}}
```

***

### $metadata — Event Metadata

`$metadata` contains all lifecycle information about the event. All values are pre-resolved — dates are formatted strings, user IDs are user objects, location UUIDs are location objects.

#### Top-level Fields

| Path                       | Type   | Description                                   |
| -------------------------- | ------ | --------------------------------------------- |
| `id`                       | string | Event UUID                                    |
| `type`                     | string | Event type (e.g. `"birth"`)                   |
| `trackingId`               | string | Human-readable tracking ID                    |
| `dateOfEvent`              | string | Formatted date of birth/death/marriage        |
| `createdAt`                | string | Formatted date the event was first created    |
| `updatedAt`                | string | Formatted date of the last update             |
| `modifiedAt`               | string | Formatted date of last modification           |
| `copiesPrintedForTemplate` | number | How many times this template has been printed |
| `updatedByUserRole`        | string | Role of the user who last updated             |
| `flags`                    | array  | Currently always empty                        |

```handlebars
{{$lookup $metadata "trackingId"}}
{{$lookup $metadata "dateOfEvent"}}
{{$lookup $metadata "updatedAt"}}
{{$lookup $metadata "copiesPrintedForTemplate"}}
```

#### User Fields

These return an object with two properties: `name` (full name string) and `fullHonorificName` (honorific full name, for humans only).

| Path         | Description                               |
| ------------ | ----------------------------------------- |
| `createdBy`  | User who first created/declared the event |
| `updatedBy`  | User who last modified the event          |
| `assignedTo` | User currently assigned to the event      |

```handlebars
{{$lookup $metadata "updatedBy.name"}}
{{$lookup $metadata "updatedBy.fullHonorificName"}}
{{$lookup $metadata "createdBy.name"}}
```

#### Location Fields

These return a resolved location object (same shape as LocationSearch):

| Path                | Description                                            |
| ------------------- | ------------------------------------------------------ |
| `createdAtLocation` | Office/location where the event was originally created |
| `updatedAtLocation` | Office/location where it was last updated              |

```handlebars
{{$lookup $metadata "updatedAtLocation.name"}}
{{$join ", " ($lookup $metadata "updatedAtLocation.district") ($lookup $metadata "updatedAtLocation.province") ($lookup $metadata "updatedAtLocation.country")}}
```

#### legalStatuses

The `legalStatuses` object tracks each formal step in the event's lifecycle. Currently two statuses are tracked: `DECLARED` and `REGISTERED`. Each is either `null` (if that status hasn't been reached yet) or an object.

**`legalStatuses.DECLARED`**

| Property            | Type   | Description                                      |
| ------------------- | ------ | ------------------------------------------------ |
| `createdAt`         | string | Formatted date the declaration was submitted     |
| `acceptedAt`        | string | Formatted date it was accepted                   |
| `createdBy`         | object | `{ name, fullHonorificName }` — the declarer     |
| `createdAtLocation` | object | Resolved location object — where it was declared |
| `createdByRole`     | string | Role of the declarer                             |

**`legalStatuses.REGISTERED`**

| Property             | Type   | Description                                    |
| -------------------- | ------ | ---------------------------------------------- |
| `createdAt`          | string | Formatted date of registration                 |
| `acceptedAt`         | string | Formatted date it was accepted                 |
| `createdBy`          | object | `{ name, fullHonorificName }` — the registrar  |
| `createdAtLocation`  | object | Resolved location object — registration office |
| `createdByRole`      | string | Role of the registrar                          |
| `registrationNumber` | string | The official registration number               |
| `createdBySignature` | string | File URL of the registrar's signature image    |

```handlebars
No. {{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}

{{$lookup $metadata "legalStatuses.REGISTERED.createdAt"}}

{{$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"}}

{{$lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.name"}}

<image xlink:href="{{$lookup $metadata 'legalStatuses.REGISTERED.createdBySignature'}}" />
```

***

### Handlebars Helpers

#### `$lookup`

**The primary navigation helper.** Resolves a dot-path from `$declaration`, `$metadata`, or an action object. Handles both flat key notation and nested objects.

```
{{$lookup <object> "path.to.value"}}
```

| Argument | Description                                                                   |
| -------- | ----------------------------------------------------------------------------- |
| `object` | `$declaration`, `$metadata`, or the result of `$action` / `$actions`          |
| `"path"` | Dot-separated path. Can traverse nested objects or use flattened key notation |

The path lookup is "mixed" — it tries both flat keys (e.g. `"child.name"` as a single key) and nested traversal (`child` → `name`). This means a field stored as `"child.name": { fullname: "..." }` and a field stored as `"child": { name: { fullname: "..." } }` are both accessible as `"child.name.fullname"`.

```handlebars
{{$lookup $declaration "child.name.fullname"}}
{{$lookup $metadata "updatedAt"}}
{{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}
{{$lookup ($action "PRINT_CERTIFICATE") "createdAt"}}
```

***

#### `$intl`

Translates an i18n key built by joining multiple string parts with `.`.

```
{{$intl "part1" "part2" dynamicValue}}
```

The parts are joined with `.` to form the message ID. If any part is `undefined` or `null`, returns `""`.

```handlebars
{{! Translates key: "constants.male" or "constants.female" based on field value }}
{{$intl "constants" ($lookup $declaration "child.gender")}}

{{! Translates key: "form.section.status.registered" }}
{{$intl "form.section.status" "registered"}}
```

***

#### `$intlWithParams`

Translates an i18n key that takes named parameters (for interpolation like `"Printed {count} times"`).

```
{{$intlWithParams "message.id" "paramName1" value1 "paramName2" value2}}
```

Parameters are passed as alternating name/value pairs. If any value is `undefined`, returns `""`.

```handlebars
{{$intlWithParams 
  "certificates.birth.printedCertificateCount" 
  "copiesPrintedForTemplate" 
  ($lookup $metadata "copiesPrintedForTemplate")
}}
```

***

#### `$join`

Joins values with a separator, **automatically filtering out empty/falsy values**. This is important for address display where some admin levels may be absent.

```
{{$join "separator" value1 value2 value3 ...}}
```

```handlebars
{{! "Ibombo, Central, Farajaland" — omits any empty level }}
{{$join ", " 
  ($lookup $metadata "updatedAtLocation.district") 
  ($lookup $metadata "updatedAtLocation.province") 
  ($lookup $metadata "updatedAtLocation.country")
}}

{{! If district is empty: "Central, Farajaland" — no leading comma }}
{{$join ", " district province country}}
```

***

#### `$or`

Returns the first truthy value between two arguments. Useful for fallback values when a field might be stored under different keys.

```
{{$or value1 value2}}
```

```handlebars
{{! Use district, or fall back to the district2 street-level field }}
{{$or 
  ($lookup $declaration "child.birthLocation.district") 
  ($lookup $declaration "child.birthLocation.other.streetLevelDetails.district2")
}}
```

***

#### `ifCond`

Block helper for conditional rendering. Supports standard comparison and logical operators.

```
{{#ifCond value1 "operator" value2}}
  ... rendered when condition is true ...
{{else}}
  ... rendered when false ...
{{/ifCond}}
```

| Operator | Meaning               |
| -------- | --------------------- |
| `===`    | Strict equality       |
| `!==`    | Strict inequality     |
| `<`      | Less than             |
| `<=`     | Less than or equal    |
| `>`      | Greater than          |
| `>=`     | Greater than or equal |
| `&&`     | Both truthy           |
| `\|\|`   | Either truthy         |

```handlebars
{{! Only show if DOB is known }}
{{#ifCond ($lookup $declaration "deceased.dobUnknown") '!==' "true"}}
  <tspan>{{$lookup $declaration "deceased.dob"}}</tspan>
{{else}}
  <tspan>{{$lookup $declaration "deceased.age"}}</tspan>
{{/ifCond}}

{{! Show different content on review vs print }}
{{#if $review}}
  <text>DRAFT - REVIEW ONLY</text>
{{/if}}

{{! Show a location block only when a location was selected }}
{{#ifCond ($lookup $declaration "child.birthLocation") '!==' undefined}}
  <tspan>{{$lookup $declaration "child.birthLocation.name"}}</tspan>
{{/ifCond}}
```

***

#### `$actions`

Returns all actions of a specific type as an array. Useful when you need to iterate over multiple actions of the same type (e.g. multiple print events).

```
{{$actions "ACTION_TYPE"}}
```

Available action types: `DECLARE`, `REGISTER`, `VALIDATE`, `PRINT_CERTIFICATE`, `REQUEST_CORRECTION`, `APPROVE_CORRECTION`, `REJECT_CORRECTION`.

```handlebars
{{! Rarely used directly — see $action for single-action access }}
{{$actions "PRINT_CERTIFICATE"}}
```

***

#### `$action`

Returns the **most recent** action of a specific type. Combine with `$lookup` to access fields on that action.

```
{{$lookup ($action "ACTION_TYPE") "fieldPath"}}
```

The resolved action object has these fields:

| Property             | Type   | Description                                               |
| -------------------- | ------ | --------------------------------------------------------- |
| `id`                 | string | Action UUID                                               |
| `type`               | string | Action type string                                        |
| `createdAt`          | string | Formatted date                                            |
| `createdBy`          | object | Raw user object from `$references.users`                  |
| `createdByUserType`  | string | `"user"` or `"system"`                                    |
| `createdBySignature` | string | File URL to signature image (if captured)                 |
| `createdAtLocation`  | object | Resolved location object                                  |
| `createdByRole`      | string | Role string                                               |
| `annotation`         | object | Stringified form fields from the action's annotation form |

```handlebars
{{$lookup ($action "PRINT_CERTIFICATE") "createdAt"}}
{{$lookup ($action "PRINT_CERTIFICATE") "createdAtLocation.name"}}
{{$lookup ($action "REGISTER") "annotation.someAnnotationField"}}
```

***

#### `$json`

Converts any value to its JSON string representation. Primarily useful for debugging.

```
{{$json someValue}}
```

```handlebars
{{! Dump the full declaration for debugging }}
{{$json $declaration}}
```

***

### Real Template Patterns

#### Registration number

```handlebars
No. {{$lookup $metadata 'legalStatuses.REGISTERED.registrationNumber'}}
```

#### Child's full name

```handlebars
{{$lookup $declaration 'child.name.fullname'}}
```

#### Date of birth

```handlebars
{{$lookup $declaration "child.dob"}}
```

#### Place of birth (facility)

```handlebars
{{$lookup $declaration 'child.birthLocation.name'}}
{{$join ", " 
  ($lookup $declaration 'child.birthLocation.district') 
  ($lookup $declaration 'child.birthLocation.province') 
  ($lookup $declaration 'child.birthLocation.country')
}}
```

#### Registration office

```handlebars
{{$lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.name"}}
{{$join ", " 
  ($lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.district") 
  ($lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.province") 
  ($lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.country")
}}
```

#### Date of registration

```handlebars
{{$lookup $metadata "createdAt"}}
```

#### Registrar name

```handlebars
{{$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"}}
```

#### Registrar signature

```handlebars
<image 
  xlink:href="{{$lookup $metadata 'legalStatuses.REGISTERED.createdBySignature'}}" 
  x="347" y="605" width="140" height="70" 
/>
```

#### Date of certification (print date)

```handlebars
{{$lookup $metadata "updatedAt"}}
```

#### Place of certification

```handlebars
{{$lookup $metadata 'updatedAtLocation.name'}}
{{$join ", " 
  ($lookup $metadata 'updatedAtLocation.district') 
  ($lookup $metadata 'updatedAtLocation.province') 
  ($lookup $metadata 'updatedAtLocation.country')
}}
```

#### How many times printed

```handlebars
{{$intlWithParams 
  'certificates.birth.printedCertificateCount' 
  'copiesPrintedForTemplate' 
  ($lookup $metadata "copiesPrintedForTemplate")
}}
```

#### DOB with unknown fallback (death certificate)

```handlebars
<tspan>
  {{#ifCond ($lookup $declaration "deceased.dobUnknown") '!==' "true"}}
    {{$lookup $declaration "deceased.dob"}}
  {{else}}
    {{$lookup $declaration "deceased.age"}}
  {{/ifCond}}
</tspan>
```

#### Show block only during review

```handlebars
{{#if $review}}
  <g>
    <!-- watermark or draft notice only visible in review mode -->
  </g>
{{/if}}
```

#### Gender with translation

```handlebars
{{$intl "constants" ($lookup $declaration "child.gender")}}
```

***

### Custom Country Helpers

Country configs can define custom Handlebars helpers in:

```
src/certificate/handlebars/helpers.ts
```

This file is compiled to JavaScript and served at `/handlebars.js`. The client fetches and registers these helpers before compiling any certificate.

Add helpers as named exports:

```ts
// src/certificate/handlebars/helpers.ts

export function formatNationalId(id: string) {
  // format: XXX-XXXX-XXX
  return id.replace(/(\d{3})(\d{4})(\d{3})/, '$1-$2-$3')
}
```

Then use in templates:

```handlebars
{{formatNationalId ($lookup $declaration "applicant.nationalId")}}
```

> **Note:** Each helper receives a `{ intl }` context when called from the built-in registration loop. Helpers exported from `helpers.ts` are registered directly — they do not receive `intl` automatically unless you build that into the helper signature yourself.

***

### Quick Reference

#### What path do I use for...

| I want                         | Path                                                                                                                                                                          |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Child's full name              | `$lookup $declaration "child.name.fullname"`                                                                                                                                  |
| Mother's surname               | `$lookup $declaration "mother.name.surname"`                                                                                                                                  |
| Date of birth                  | `$lookup $declaration "child.dob"`                                                                                                                                            |
| Place of birth (hospital name) | `$lookup $declaration "child.birthLocation.name"`                                                                                                                             |
| Place of birth (address line)  | `$join ", " ($lookup $declaration "child.birthLocation.district") ($lookup $declaration "child.birthLocation.province") ($lookup $declaration "child.birthLocation.country")` |
| Registration number            | `$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"`                                                                                                             |
| Registrar name                 | `$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"`                                                                                                                 |
| Registrar signature            | `$lookup $metadata "legalStatuses.REGISTERED.createdBySignature"`                                                                                                             |
| Date of registration           | `$lookup $metadata "createdAt"`                                                                                                                                               |
| Date certificate was printed   | `$lookup $metadata "updatedAt"`                                                                                                                                               |
| Place certificate was printed  | `$lookup $metadata "updatedAtLocation.name"`                                                                                                                                  |
| Tracking ID                    | `$lookup $metadata "trackingId"`                                                                                                                                              |
| Event UUID                     | `$lookup $metadata "id"`                                                                                                                                                      |
| Print count                    | `$lookup $metadata "copiesPrintedForTemplate"`                                                                                                                                |
