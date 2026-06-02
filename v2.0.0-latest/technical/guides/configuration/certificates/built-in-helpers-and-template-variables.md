# Built-in helpers and template variables

Reference for everything available in a certificate SVG template — the four context objects and all built-in Handlebars helpers.

***

## Template Variables

These four objects are available at the top level of every certificate template.

### `$declaration`

Stringified form field values for the event. Each key is a field ID from the form configuration. Values are pre-resolved into human-readable output — dates are formatted strings, UUIDs are resolved to names, name fields are expanded into sub-properties.

The exact shape depends on the field types in your form. See below for the most common ones.

**Simple fields** (text, select, radio, number) — raw string value:

```handlebars
{{$lookup $declaration "child.gender"}}
{{$lookup $declaration "informant.nationalId"}}
```

**Date fields** — formatted locale string (e.g. `"15 March 2024"`):

```handlebars
{{$lookup $declaration "child.dob"}}
```

**Name fields** — nested object with four properties:

| Property     | Value                                      |
| ------------ | ------------------------------------------ |
| `fullname`   | All parts joined (`"John Michael Doe"`)    |
| `firstname`  | First name only                            |
| `middlename` | Middle name (empty string if not provided) |
| `surname`    | Last name only                             |

```handlebars
{{$lookup $declaration "child.name.fullname"}}
{{$lookup $declaration "mother.name.firstname"}}
{{$lookup $declaration "father.name.surname"}}
```

**Address fields** — nested object:

| Property                       | Value                                                                    |
| ------------------------------ | ------------------------------------------------------------------------ |
| `country`                      | Country name string                                                      |
| `addressType`                  | `"DOMESTIC"` or `"INTERNATIONAL"`                                        |
| `administrativeHierarchy`      | Most-specific-first joined string (e.g. `"Ibombo, Central, Farajaland"`) |
| `streetLevelDetails`           | Object of any street-level sub-fields                                    |
| `province` / `district` / etc. | Individual admin level names — keys match your country's admin structure |

```handlebars
{{$lookup $declaration "mother.address.country"}}
{{$lookup $declaration "mother.address.administrativeHierarchy"}}
{{$lookup $declaration "mother.address.streetLevelDetails.addressLine1"}}
```

**LocationSearch fields** (health facility, registration office, etc.) — nested object:

| Property                       | Value                                           |
| ------------------------------ | ----------------------------------------------- |
| `name`                         | Location name (e.g. `"Ibombo Rural Hospital"`)  |
| `country`                      | Country name                                    |
| `province` / `district` / etc. | Admin level names from the location's hierarchy |

```handlebars
{{$lookup $declaration "child.birthLocation.name"}}
{{$lookup $declaration "child.birthLocation.district"}}
```

***

### `$metadata`

Event lifecycle data — lifecycle dates, status, users, and locations. All values are pre-resolved: date strings are formatted, UUID references are expanded to objects.

**Top-level scalar fields**

| Path                       | Type   | Description                                            |
| -------------------------- | ------ | ------------------------------------------------------ |
| `id`                       | string | Event UUID                                             |
| `type`                     | string | Event type (e.g. `"birth"`, `"death"`)                 |
| `trackingId`               | string | Human-readable tracking ID                             |
| `dateOfEvent`              | string | Formatted date of birth / death / marriage             |
| `createdAt`                | string | Formatted date the event record was first created      |
| `updatedAt`                | string | Formatted date of the last update                      |
| `modifiedAt`               | string | Formatted date of last modification                    |
| `copiesPrintedForTemplate` | number | How many times this specific template has been printed |
| `updatedByUserRole`        | string | Role string of the user who last updated               |
| `status`                   | string | Always `"REGISTERED"` at time of printing              |
| `flags`                    | array  | Currently always `[]`                                  |

```handlebars
{{$lookup $metadata "trackingId"}}
{{$lookup $metadata "dateOfEvent"}}
{{$lookup $metadata "copiesPrintedForTemplate"}}
```

**User fields**

Each resolves to an object with two properties:

| Property            | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| `name`              | Full name string                                             |
| `fullHonorificName` | Honorific full name (only for human users, not system users) |

| Path         | Description                                             |
| ------------ | ------------------------------------------------------- |
| `createdBy`  | User who first created or declared the event            |
| `updatedBy`  | User who last modified the event (empty string if none) |
| `assignedTo` | User currently assigned to the event                    |

```handlebars
{{$lookup $metadata "updatedBy.name"}}
{{$lookup $metadata "updatedBy.fullHonorificName"}}
{{$lookup $metadata "createdBy.name"}}
```

**Location fields**

Each resolves to the same shape as a LocationSearch field:

| Path                | Description                                                                          |
| ------------------- | ------------------------------------------------------------------------------------ |
| `createdAtLocation` | Office / location where the event was originally created                             |
| `updatedAtLocation` | Office / location where it was last updated (where the certificate is being printed) |

```handlebars
{{$lookup $metadata "updatedAtLocation.name"}}
{{$join ", " 
  ($lookup $metadata "updatedAtLocation.district") 
  ($lookup $metadata "updatedAtLocation.province") 
  ($lookup $metadata "updatedAtLocation.country")
}}
```

**`legalStatuses`**

Tracks formal lifecycle milestones. Two statuses are supported: `DECLARED` and `REGISTERED`. Each is `null` if that milestone hasn't been reached yet.

**`legalStatuses.DECLARED`**

| Property            | Type   | Description                                             |
| ------------------- | ------ | ------------------------------------------------------- |
| `createdAt`         | string | Formatted date the declaration was submitted            |
| `acceptedAt`        | string | Formatted date it was accepted                          |
| `createdBy`         | object | `{ name, fullHonorificName }` — the person who declared |
| `createdAtLocation` | object | Resolved location where it was declared                 |
| `createdByRole`     | string | Role of the declarer                                    |

**`legalStatuses.REGISTERED`**

| Property             | Type   | Description                                   |
| -------------------- | ------ | --------------------------------------------- |
| `createdAt`          | string | Formatted date of registration                |
| `acceptedAt`         | string | Formatted date it was accepted                |
| `createdBy`          | object | `{ name, fullHonorificName }` — the registrar |
| `createdAtLocation`  | object | Resolved location of the registration office  |
| `createdByRole`      | string | Role of the registrar                         |
| `registrationNumber` | string | Official registration number                  |

> **Note:** `createdBySignature` is **not** available on `$metadata.legalStatuses.REGISTERED`. Signature is available on actions — use `$lookup ($action "REGISTER") "createdBySignature"` instead.

```handlebars
{{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}

{{$lookup $metadata "legalStatuses.REGISTERED.createdAt"}}

{{$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"}}

{{$lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.name"}}
```

***

### `$review`

Boolean. `true` when the user is reviewing/previewing the certificate before printing. `false` when the certificate is actually being printed or downloaded.

Use this to show watermarks, draft notices, or hide elements that should only appear on the printed version.

```handlebars
{{#if $review}}
  <g><!-- draft watermark --></g>
{{/if}}

{{#ifCond $review '===' false}}
  <g><!-- only visible when printing --></g>
{{/ifCond}}
```

***

### `$references`

Raw reference data used internally. Rarely accessed directly in templates.

| Property    | Type                                                |
| ----------- | --------------------------------------------------- |
| `locations` | `Map<UUID, Location>` — all loaded location objects |
| `users`     | `UserOrSystemSummary[]` — all loaded user objects   |

`$lookup` and `$metadata` already resolve all UUIDs using this data, so you generally don't need to use `$references` yourself.

***

## Built-in Helpers

***

### `$lookup`

The primary navigation helper. Resolves a dot-separated path from `$declaration`, `$metadata`, or an action object returned by `$action`/`$actions`.

```
{{$lookup <object> "path.to.value"}}
```

| Argument | Type   | Description                                      |
| -------- | ------ | ------------------------------------------------ |
| `object` | object | `$declaration`, `$metadata`, or an action object |
| `"path"` | string | Dot-separated path to the value                  |

The path lookup is "mixed" — it tries both:

* Flat key lookup: `"child.name"` as a single key on the object
* Nested traversal: `obj.child.name`

This means a field stored as `"child.name": { fullname: "..." }` and one stored as `"child": { name: { fullname: "..." } }` are both accessible via `"child.name.fullname"`.

**When given `$metadata`:** resolves lazily via `stringifyEventMetadata` — all UUIDs, dates, and user references are resolved at lookup time.

**When given `$declaration`:** uses the pre-resolved stringified declaration built at compile time.

**When given an action object** (from `$action` or `$actions`): resolves the action's fields including `createdAt`, `createdAtLocation`, `annotation`, and `createdBySignature`.

```handlebars
{{$lookup $declaration "child.name.fullname"}}
{{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}
{{$lookup $metadata "updatedAt"}}
{{$lookup ($action "REGISTER") "createdBySignature"}}
{{$lookup ($action "PRINT_CERTIFICATE") "createdAt"}}
```

***

### `$intl`

Translates an i18n message key built by joining multiple parts with `.`.

```
{{$intl "part1" "part2" ... dynamicValue}}
```

All arguments (except the trailing `options` that Handlebars adds automatically) are joined with `.` to form the message ID. If any part is `undefined` or `null`, the helper returns `""` — it will not render a partial or broken key.

```handlebars
{{! Translates key: "constants.male" or "constants.female" }}
{{$intl "constants" ($lookup $declaration "child.gender")}}

{{! Translates key: "form.section.status.registered" }}
{{$intl "form.section.status" "registered"}}

{{! Three-part key }}
{{$intl "certificate" "birth" "title"}}
```

If the translation is missing, it renders: `Missing translation for <id>`.

***

### `$intlWithParams`

Translates an i18n key that includes interpolated values (e.g. `"Printed {count} times"`).

```
{{$intlWithParams "message.id" "paramName1" value1 "paramName2" value2 ...}}
```

Arguments after the message ID are **alternating name/value pairs**. If any name or value is `undefined`, returns `""`.

```handlebars
{{! Message: "Printed {copiesPrintedForTemplate} times" }}
{{$intlWithParams 
  "certificates.birth.printedCertificateCount" 
  "copiesPrintedForTemplate" 
  ($lookup $metadata "copiesPrintedForTemplate")
}}

{{! Two interpolated values }}
{{$intlWithParams 
  "some.message.with.two.params"
  "firstName" ($lookup $declaration "child.name.firstname")
  "district"  ($lookup $metadata "updatedAtLocation.district")
}}
```

***

### `$join`

Joins values with a separator, **automatically filtering out empty and falsy values**. Critical for rendering location hierarchies where some admin levels may be absent.

```
{{$join "separator" value1 value2 value3 ...}}
```

| Argument       | Description                    |
| -------------- | ------------------------------ |
| First arg      | Separator string (e.g. `", "`) |
| Remaining args | Values to filter and join      |

Any value that is falsy (`""`, `null`, `undefined`, `0`, `false`) is excluded. The result has no leading or trailing separators.

```handlebars
{{! "Ibombo, Central, Farajaland" — any absent level is silently omitted }}
{{$join ", " 
  ($lookup $declaration "child.birthLocation.district") 
  ($lookup $declaration "child.birthLocation.province") 
  ($lookup $declaration "child.birthLocation.country")
}}

{{! If district is empty: "Central, Farajaland" (no leading comma) }}
{{$join ", " district province country}}

{{! Works with any separator }}
{{$join " | " name role location}}
```

***

### `$or`

Returns the first truthy value between two arguments.

```
{{$or value1 value2}}
```

Takes exactly two arguments. If `value1` is truthy, returns it. Otherwise returns `value2`.

```handlebars
{{! Use facility name, fall back to address field }}
{{$or 
  ($lookup $declaration "child.birthLocation.name") 
  ($lookup $declaration "child.birthLocation.streetLevelDetails.addressLine1")
}}

{{! Fall back to a static string }}
{{$or ($lookup $declaration "informant.email") "Not provided"}}
```

***

### `ifCond`

Block helper for conditional rendering with comparison operators.

```
{{#ifCond value1 "operator" value2}}
  ... rendered when true ...
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

The `{{else}}` block is optional. If the condition is false and there is no `{{else}}`, nothing is rendered.

```handlebars
{{! Show age only when DOB is unknown }}
{{#ifCond ($lookup $declaration "deceased.dobUnknown") "===" "true"}}
  <tspan>Age: {{$lookup $declaration "deceased.age"}}</tspan>
{{else}}
  <tspan>DOB: {{$lookup $declaration "deceased.dob"}}</tspan>
{{/ifCond}}

{{! Show a section only for one gender }}
{{#ifCond ($lookup $declaration "child.gender") "===" "female"}}
  <g><!-- female-specific content --></g>
{{/ifCond}}

{{! Numeric comparison }}
{{#ifCond ($lookup $metadata "copiesPrintedForTemplate") ">" "0"}}
  <tspan>DUPLICATE CERTIFICATE</tspan>
{{/ifCond}}
```

> For simple truthy checks (no comparison), use Handlebars' built-in `{{#if}}` and `{{#unless}}`:
>
> ```handlebars
> {{#if $review}}<tspan>PREVIEW</tspan>{{/if}}
> {{#unless ($lookup $declaration "child.middlename")}}<!-- no middle name -->{{/unless}}
> ```

***

### `$action`

Returns the **most recent** action of a specific type. Combine with `$lookup` to read fields from that action.

```
{{$lookup ($action "ACTION_TYPE") "fieldPath"}}
```

Available action types: `DECLARE`, `REGISTER`, `VALIDATE`, `PRINT_CERTIFICATE`, `REQUEST_CORRECTION`, `APPROVE_CORRECTION`, `REJECT_CORRECTION`.

The resolved action object has these properties:

| Property             | Type   | Description                                          |
| -------------------- | ------ | ---------------------------------------------------- |
| `id`                 | string | Action UUID                                          |
| `type`               | string | Action type string                                   |
| `createdAt`          | string | Formatted date of the action                         |
| `createdBy`          | object | Raw user object from `$references.users`             |
| `createdByUserType`  | string | `"user"` or `"system"`                               |
| `createdBySignature` | string | File URL to the registrar's signature image          |
| `createdAtLocation`  | object | Resolved location object                             |
| `createdByRole`      | string | Role string                                          |
| `annotation`         | object | Stringified fields from the action's annotation form |

```handlebars
{{! Date of printing }}
{{$lookup ($action "PRINT_CERTIFICATE") "createdAt"}}

{{! Office where certificate was printed }}
{{$lookup ($action "PRINT_CERTIFICATE") "createdAtLocation.name"}}

{{! Registrar's signature image }}
<image 
  xlink:href="{{$lookup ($action "REGISTER") 'createdBySignature'}}" 
  x="347" y="605" width="140" height="70"
/>

{{! Registrar's name }}
{{$lookup ($action "REGISTER") "createdBy.name"}}

{{! A field from the registration annotation form }}
{{$lookup ($action "REGISTER") "annotation.certificateCollector"}}
```

***

### `$actions`

Returns **all** actions of a specific type as an array. Useful for iterating over multiple occurrences of the same action type.

```
{{$actions "ACTION_TYPE"}}
```

Most of the time you want `$action` (singular) for the most recent one. Use `$actions` only when you need to iterate.

```handlebars
{{! Iterate over all print actions }}
{{#each ($actions "PRINT_CERTIFICATE")}}
  <tspan>Printed on: {{$lookup this "createdAt"}}</tspan>
{{/each}}
```

***

### `$json`

Converts any value to its JSON string representation. Use this for debugging.

```
{{$json someValue}}
```

```handlebars
{{! Dump the entire declaration to inspect its structure }}
{{$json $declaration}}

{{! Inspect a specific nested value }}
{{$json ($lookup $declaration "child.birthLocation")}}

{{! Inspect metadata }}
{{$json $metadata}}
```

> Remove `$json` calls before deploying — they render raw JSON into the SVG output.

***

## Quick Reference Table

#### Common template paths

| What you need                 | Template expression                                                                                                                                                           |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Child's full name             | `$lookup $declaration "child.name.fullname"`                                                                                                                                  |
| Child's first name            | `$lookup $declaration "child.name.firstname"`                                                                                                                                 |
| Mother's surname              | `$lookup $declaration "mother.name.surname"`                                                                                                                                  |
| Date of birth                 | `$lookup $declaration "child.dob"`                                                                                                                                            |
| Child's gender (translated)   | `$intl "constants" ($lookup $declaration "child.gender")`                                                                                                                     |
| Birth facility name           | `$lookup $declaration "child.birthLocation.name"`                                                                                                                             |
| Birth location address        | `$join ", " ($lookup $declaration "child.birthLocation.district") ($lookup $declaration "child.birthLocation.province") ($lookup $declaration "child.birthLocation.country")` |
| Tracking ID                   | `$lookup $metadata "trackingId"`                                                                                                                                              |
| Event UUID                    | `$lookup $metadata "id"`                                                                                                                                                      |
| Date of event                 | `$lookup $metadata "dateOfEvent"`                                                                                                                                             |
| Date of registration          | `$lookup $metadata "legalStatuses.REGISTERED.createdAt"`                                                                                                                      |
| Registration number           | `$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"`                                                                                                             |
| Registrar name                | `$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"`                                                                                                                 |
| Registration office name      | `$lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.name"`                                                                                                         |
| Registrar's signature         | `$lookup ($action "REGISTER") "createdBySignature"`                                                                                                                           |
| Date certificate printed      | `$lookup ($action "PRINT_CERTIFICATE") "createdAt"`                                                                                                                           |
| Office certificate printed at | `$lookup $metadata "updatedAtLocation.name"`                                                                                                                                  |
| Certifier name (who printed)  | `$lookup ($action "PRINT_CERTIFICATE") "createdBy.name"`                                                                                                                      |
| Print count                   | `$lookup $metadata "copiesPrintedForTemplate"`                                                                                                                                |
| Is preview/review mode        | `$review`                                                                                                                                                                     |

#### Helper signatures at a glance

| Helper            | Signature                              | Returns                              |
| ----------------- | -------------------------------------- | ------------------------------------ |
| `$lookup`         | `$lookup obj "path"`                   | Value at path, or `""`               |
| `$intl`           | `$intl "part1" "part2" ...`            | Translated string                    |
| `$intlWithParams` | `$intlWithParams "id" "key1" val1 ...` | Translated string with interpolation |
| `$join`           | `$join "sep" val1 val2 ...`            | Filtered and joined string           |
| `$or`             | `$or val1 val2`                        | First truthy value                   |
| `ifCond`          | `{{#ifCond v1 "op" v2}}...{{/ifCond}}` | Block helper                         |
| `$action`         | `$action "TYPE"`                       | Most recent action object            |
| `$actions`        | `$actions "TYPE"`                      | Array of action objects              |
| `$json`           | `$json value`                          | JSON string (debug only)             |
