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

### TextField

A single-line text input.

{% openapi-schemas spec="events-develop" schemas="TextField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### TextAreaField

A multi-line text input.

{% openapi-schemas spec="events-develop" schemas="TextAreaField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### EmailField

An email input.

{% openapi-schemas spec="events-develop" schemas="EmailField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### PhoneField

A phone number input.

{% openapi-schemas spec="events-develop" schemas="PhoneField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### IdField

An input for identification numbers (e.g. national ID, passport).

{% openapi-schemas spec="events-develop" schemas="IdField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### NumberField

A numeric input.

{% openapi-schemas spec="events-develop" schemas="NumberField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### NumberWithUnitField

A numeric input paired with a unit selector (the unit options come from the field config).

{% openapi-schemas spec="events-develop" schemas="NumberWithUnitField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### AgeField

An age input. Resolves to a date using today as the reference.

{% openapi-schemas spec="events-develop" schemas="AgeField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### DateField

A date input in `yyyy-MM-dd` format.

{% openapi-schemas spec="events-develop" schemas="DateField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### TimeField

A time input in `HH-mm` format.

{% openapi-schemas spec="events-develop" schemas="TimeField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### DateRangeField

A date range input (`{ start: yyyy-MM-dd, end: yyyy-MM-dd }`). Intended for search forms.

{% openapi-schemas spec="events-develop" schemas="DateRangeField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### SelectDateRangeField

A select dropdown of predefined date ranges (e.g. "last 7 days"). Intended for search forms.

{% openapi-schemas spec="events-develop" schemas="SelectDateRangeField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Checkbox

A boolean checkbox.

{% openapi-schemas spec="events-develop" schemas="Checkbox" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### RadioGroup

A grouped set of radio buttons. The user picks one option.

{% openapi-schemas spec="events-develop" schemas="RadioGroup" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Select

A dropdown select.

{% openapi-schemas spec="events-develop" schemas="Select" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Country

A select dropdown of countries.

{% openapi-schemas spec="events-develop" schemas="Country" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### NameField

A composite input for capturing a person's name (firstname / middlename / surname).

{% openapi-schemas spec="events-develop" schemas="NameField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### AdministrativeAreaField

A field for selecting an administrative area from the country's location hierarchy.

{% openapi-schemas spec="events-develop" schemas="AdministrativeAreaField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### LocationInput

A field for selecting a specific location (e.g. health facility, CRVS office). Filterable by location type.

{% openapi-schemas spec="events-develop" schemas="LocationInput" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Address

A composite address input combining country, administrative-area selectors, and free-text address lines.

{% openapi-schemas spec="events-develop" schemas="Address" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### File

A single-file upload field.

{% openapi-schemas spec="events-develop" schemas="File" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### FileUploadWithOptions

A file upload field that lets the user attach files under a set of named document categories (e.g. "Proof of birth", "Photo ID").

{% openapi-schemas spec="events-develop" schemas="FileUploadWithOptions" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### SignatureField

Captures a handwritten signature.

{% openapi-schemas spec="events-develop" schemas="SignatureField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### PageHeader

A read-only page-header block.

{% openapi-schemas spec="events-develop" schemas="PageHeader" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Heading

A read-only heading. Supports a configurable HTML heading variant (h3, h4, ...).

{% openapi-schemas spec="events-develop" schemas="Heading" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Paragraph

A read-only HTML paragraph.

{% openapi-schemas spec="events-develop" schemas="Paragraph" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### BulletList

A read-only bullet list.

{% openapi-schemas spec="events-develop" schemas="BulletList" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### Divider

A horizontal divider line.

{% openapi-schemas spec="events-develop" schemas="Divider" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### ImageViewField

A read-only image block.

{% openapi-schemas spec="events-develop" schemas="ImageViewField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### DataField

A read-only table that renders structured data from earlier in the form.

{% openapi-schemas spec="events-develop" schemas="DataField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### LoaderField

A non-interactive loading indicator. Typically paired with `HttpField` to surface request status.

{% openapi-schemas spec="events-develop" schemas="LoaderField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### ButtonField

A generic button that triggers an action.

{% openapi-schemas spec="events-develop" schemas="ButtonField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### LinkButtonField

A button styled as a hyperlink that opens a URL.

{% openapi-schemas spec="events-develop" schemas="LinkButtonField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### AlphaPrintButton

(Experimental.) A button for printing certificates during the declaration process.

{% openapi-schemas spec="events-develop" schemas="AlphaPrintButton" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### HttpField

Issues a background HTTP request to an external service and stores the response so other fields can reference it. No visible UI — pair with `LoaderField` to surface request status.

{% openapi-schemas spec="events-develop" schemas="HttpField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### AutocompleteField

An autocomplete input designed for large dictionary-style datasets (tens or hundreds of thousands of records). Options are fetched dynamically from a configured source.

{% openapi-schemas spec="events-develop" schemas="AutocompleteField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### SearchField

A search input. Extends `HttpField` to query an external service and surface the matches.

{% openapi-schemas spec="events-develop" schemas="SearchField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### QrReaderField

A QR code reader, with optional JSON-Schema validation on the scanned value.

{% openapi-schemas spec="events-develop" schemas="QrReaderField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### IdReaderField

A wrapper around nested `QrReaderField` and `LinkButtonField` sub-fields. Holds the value scanned by the inner reader.

{% openapi-schemas spec="events-develop" schemas="IdReaderField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### QueryParamReaderField

Reads values from URL query parameters into form values, then clears them.

{% openapi-schemas spec="events-develop" schemas="QueryParamReaderField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### VerificationStatus

Displays a verification state (e.g. ID verified / pending). Often paired with `IdReaderField` — it can read its value off the reader rather than holding its own.

{% openapi-schemas spec="events-develop" schemas="VerificationStatus" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### UserRoleField

A select dropdown automatically populated with the user roles configured in the country config.

{% openapi-schemas spec="events-develop" schemas="UserRoleField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### FieldGroup

A wrapper that groups several fields together, supporting nested `FieldConfig` entries.

{% openapi-schemas spec="events-develop" schemas="FieldGroup" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### HiddenField

A non-interactive, hidden field that holds a value but is not rendered in the form.

{% openapi-schemas spec="events-develop" schemas="HiddenField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

### CustomField

(Experimental.) A custom field implemented by a module path defined in the country config.

{% openapi-schemas spec="events-develop" schemas="CustomField" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
