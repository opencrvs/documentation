# Certificates

This document covers printable documents in OpenCRVS — what they are, how they work end-to-end, and how to configure them.

***

### What Are Certificates?

Certificates are printable PDF documents generated from event records. They are produced from SVG templates that are automatically populated with record data at print time.

Core provides the rendering pipeline, the `PRINT_CERTIFICATE` action type, and the data available to templates. Everything else — which templates exist, when they are shown, what form is shown during printing, and what flags are set — is configured in countryconfig.

Certificates are:

* **Data-driven** — content is drawn from the live record, not typed manually.
* **Template-based** — layout and design are controlled by SVG files defined in countryconfig.
* **Auditable** — every print is recorded as a `PRINT_CERTIFICATE` action on the event, with who printed, when, where, and which template was used.
* **Workflow-aware** — when and by whom documents can be printed is controlled via action conditionals and flags, all defined in countryconfig.

***

### Document Types

From core's perspective, there is only one concept: a **template**. Core does not distinguish between a "certificate", "certified copy", or any other document type — those are naming conventions. Any number of templates can be registered per event. Each template is an SVG file with its own label, fee schedule, and display conditions.

The Farajaland countryconfig registers these templates for birth as an example of how templates can be structured:

| Template ID                   | Label                            | When shown                                                                               |
| ----------------------------- | -------------------------------- | ---------------------------------------------------------------------------------------- |
| `birth-certificate`           | Birth Certificate                | Only before any certificate has been printed (`not(event.hasAction(PRINT_CERTIFICATE))`) |
| `birth-certified-certificate` | Birth Certificate certified copy | Only after the original has been printed at least once                                   |

This sequencing — first issuance followed by re-issuance — is a countryconfig convention, not a core rule. You can register as many or as few templates as your country needs, with any conditions.

***

### End-to-End Flow

```
1. User opens a record
      ↓
2. The PRINT_CERTIFICATE action is available (controlled by conditionals in the event config)
      ↓
3. User triggers Print → the print form opens (defined in printForm of the action config)
      ↓
4. User completes the print form (what pages appear is entirely up to the countryconfig)
      ↓
5. Certificate preview is displayed ($review = true during this step)
      ↓
6. User confirms → PDF is generated:
   - SVG template fetched from countryconfig
   - Handlebars expressions compiled with record data ($declaration, $metadata, etc.)
   - SVG converted to PDF via pdfmake
      ↓
7. PDF downloaded or sent to printer
      ↓
8. A PRINT_CERTIFICATE action is written to the event record, capturing:
   - User, role, office
   - Template ID used
   - Timestamp
   - Registrar's signature (if captured during registration)
   - Annotation values from the print form
      ↓
9. Flag side-effects defined in the action config are applied to the record
```

***

### Template Configuration

Templates are defined in countryconfig in the certificate handler:

```
src/api/certificates/handler.ts   (Farajaland path — your countryconfig may vary)
```

The handler exports a `certificateConfigs` array. Core reads this endpoint to know which templates are available for each event. Each entry has this shape (`ICertificateConfigData`):

```ts
{
  id: 'birth-certificate',          // unique template ID
  event: Event.Birth,                   // which event type this belongs to
  label: {
    id: 'certificates.birth.certificate',
    defaultMessage: 'Birth Certificate',
    description: 'Label shown in the template selection UI'
  },
  isDefault: true,                      // pre-selected when the print form opens
  fee: {
    onTime: 7,                          // fee within the legal timeframe
    late: 10.6,                         // fee in the late window
    delayed: 18                         // fee in the delayed window
  },
  svgUrl: '/api/countryconfig/certificates/birth-certificate.svg',
  fonts: { ... },                       // font families for PDF rendering
  conditionals: [                       // when this template appears in the list
    {
      type: 'SHOW',
      conditional: not(event.hasAction(ActionType.PRINT_CERTIFICATE))
    }
  ]
}
```

#### Key fields

**`id`** — The template's unique identifier. Referenced in `withTemplate()` conditionals and in `ALPHA_PRINT_BUTTON` field configs.

**`isDefault`** — If `true`, this template is pre-selected when the print form opens.

**`fee`** — Three-tier fee amounts. What counts as "on time", "late", or "delayed" is determined by the event's registration rules, not by this config.

**`svgUrl`** — URL path to the SVG template file served by countryconfig.

**`fonts`** — Font families to embed in the PDF. Each font family is an object with `normal`, `bold`, `italics`, `bolditalics` keys pointing to font file URLs.

**`conditionals`** — Controls when this template appears in the selection list. Uses the same condition API as the rest of the event config. If omitted, the template always appears.

#### Conditional examples

```ts
// Show only before any certificate has been printed
conditionals: [
  { type: 'SHOW', conditional: not(event.hasAction(ActionType.PRINT_CERTIFICATE)) }
]

// Show only after a specific template has been printed at least once
conditionals: [
  {
    type: 'SHOW',
    conditional: event
      .hasAction(ActionType.PRINT_CERTIFICATE)
      .withTemplate('birth-certificate')
      .minCount(1)
  }
]

// Never show in the print flow (used for templates triggered only by ALPHA_PRINT_BUTTON)
conditionals: [
  { type: 'SHOW', conditional: never() }
]
```

***

### Template Files (SVG)

The SVG template files can live anywhere in countryconfig as long as the `svgUrl` in the config points to the correct URL. In Farajaland, they are placed in:

```
src/api/certificates/source/
```

and the certificate handler serves them at `/api/countryconfig/certificates/<filename>` like this:

```ts
if (request.params.id) {
  const filePath = `${__dirname}/source/${request.params.id}`
  return h.file(filePath)
}
```

Templates are Handlebars SVG files — standard SVG syntax with `{{` expressions `}}` for dynamic content. See Template Design for details.

***

### Configuring the Print Action

`PRINT_CERTIFICATE` is a built-in action type. It is configured in the event's `actions` array:

```ts
{
  type: ActionType.PRINT_CERTIFICATE,
  label: {
    defaultMessage: 'Print',
    id: 'event.birth.action.collect-certificate.label',
    description: '...'
  },
  printForm: BIRTH_CERTIFICATE_COLLECTOR_FORM,  // form shown during printing
  conditionals: [...],                           // when the action is available
  flags: [...]                                   // side-effects after printing
}
```

#### `printForm`

The form shown to the user before the PDF is generated. Defined with `defineActionForm()`. The structure, pages, and fields are entirely up to the countryconfig. Core renders whatever pages are defined there.

#### `conditionals`

Controls when the Print action appears and whether it is enabled. Uses `ConditionalType.SHOW` and `ConditionalType.ENABLE`:

```ts
// Hide the action when a flag is set
{ type: ConditionalType.SHOW, conditional: not(flag('some-flag')) }

// Disable without hiding
{ type: ConditionalType.ENABLE, conditional: status('REGISTERED') }
```

#### `flags`

Side-effects applied to the record when the print action completes. Flags are set or removed conditionally:

```ts
flags: [
  {
    id: 'my-custom-flag',
    operation: 'add',
    conditional: field('collector.requesterId').isEqualTo('SOME_VALUE')
  },
  { id: 'another-flag', operation: 'remove' }
]
```

Flag IDs are defined entirely in countryconfig — core has no built-in certificate-specific flags.

***

### The Print Form

The print form is defined using `defineActionForm()` and can have any number of pages. Core supports these page types that are particularly useful in print flows:

* **`PageTypes.enum.FORM`** — a standard data-entry form page
* **`PageTypes.enum.VERIFICATION`** — a page that shows record data alongside controls for the user to confirm or deny identity

The Farajaland countryconfig implements the print form as three pages as an example of one way to structure this:

**Page 1 — Collector selection:** A `FORM` page with a select field asking who is collecting the certificate. Farajaland uses values like `INFORMANT`, `OTHER`, and `PRINT_IN_ADVANCE`, with additional fields appearing conditionally based on the selection.

**Page 2 — Identity verification:** A `VERIFICATION` page (shown conditionally based on the selection in page 1) that renders key record fields from `$declaration` alongside a confirm/deny action. This lets the registrar cross-reference the collector against the record without leaving the flow.

```ts
{
  id: 'collector.identity.verify',
  type: PageTypes.enum.VERIFICATION,
  conditional: field('collector.requesterId').isEqualTo('INFORMANT'),
  fields: [
    {
      id: 'collector.identity.verify.data',
      type: FieldType.DATA,
      configuration: {
        data: [{ fieldId: 'applicant.name' }, { fieldId: 'applicant.dob' }]
      }
    }
  ],
  actions: {
    verify: { label: 'Verified' },
    cancel: {
      label: 'Identity does not match',
      confirmation: { title: 'Print without proof of ID?', body: '...' }
    }
  }
}
```

**Page 3 — Payment:** A `FORM` page using `FieldType.DATA` to display the fee and service. The values can be hardcoded or derived conditionally.

Your print form does not need to follow this structure. It can have more or fewer pages, different fields, or no collector step at all.

#### Accessing print form values in the template

All annotation fields captured in the print form are accessible in the SVG template:

```handlebars
{{$lookup ($action "PRINT_CERTIFICATE") "annotation.collector.requesterId"}}
{{$lookup ($action "PRINT_CERTIFICATE") "annotation.collector.OTHER.firstName"}}
```

***

### Business Rules and Flags

Flags are boolean markers on a record that any action can set or remove. They are defined entirely in countryconfig — core provides the flag mechanism but has no certificate-specific built-in flags.

#### Controlling access with conditionals

```ts
// Show the Print action only when the record is registered
{
  type: ConditionalType.SHOW,
  conditional: status('REGISTERED')
}

// Disable when a flag is set
{
  type: ConditionalType.ENABLE,
  conditional: not(flag('some-blocking-flag'))
}
```

#### Sequencing templates

To enforce that one template must be printed before another appears, use `withTemplate().minCount()` in the template config:

```ts
conditionals: [
  {
    type: 'SHOW',
    conditional: event
      .hasAction(ActionType.PRINT_CERTIFICATE)
      .withTemplate('birth-certificate')
      .minCount(1)
  }
]
```

This is how the Farajaland countryconfig ensures the certified copy only becomes available after the original certificate has been printed.

#### Tracking print count

Core automatically tracks how many times a given template has been printed in `$metadata.copiesPrintedForTemplate`. Use it in your template to mark re-prints:

```handlebars
{{#ifCond ($lookup $metadata "copiesPrintedForTemplate") ">" "0"}}
  <tspan>DUPLICATE</tspan>
{{/ifCond}}
```

***

### Template Design

Certificate templates are **SVG files with Handlebars expressions**. The SVG defines the visual layout; Handlebars expressions pull in record data at print time. This is implemented in core (`compileSvg` in `pdfUtils.ts`).

#### How rendering works

1. The SVG file is fetched from the `svgUrl` in the template config.
2. Handlebars compiles the SVG string, resolving all `{{...}}` expressions against the record's data.
3. The compiled SVG is converted to a PDF via pdfmake.
4. The PDF is downloaded or sent to the printer.

#### What data is available

Four top-level variables are available in every template — these are provided by core:

| Variable       | Contains                                                                             |
| -------------- | ------------------------------------------------------------------------------------ |
| `$declaration` | All form field values from the declaration, pre-resolved into human-readable strings |
| `$metadata`    | Event lifecycle data — registration number, dates, users, offices, legal statuses    |
| `$review`      | `true` when previewing before print, `false` when actually printing                  |
| `$references`  | Raw location and user maps (rarely used directly)                                    |

#### Reading values

Use `$lookup` to navigate into any variable:

```handlebars
{{$lookup $declaration "child.name.fullname"}}
{{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}
{{$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"}}
{{$lookup ($action "PRINT_CERTIFICATE") "createdAt"}}
```

#### Built-in helpers

These are all registered by core in `pdfUtils.ts`:

| Helper                                    | Purpose                                       |
| ----------------------------------------- | --------------------------------------------- |
| `$lookup obj "path"`                      | Navigate into any data object by dot-path     |
| `$intl "key.part1" dynamicValue`          | Translate an i18n key built from joined parts |
| `$intlWithParams "id" "paramName" value`  | Translate with interpolated values            |
| `$join ", " val1 val2 val3`               | Join values, filtering out empty ones         |
| `$or val1 val2`                           | First truthy value                            |
| `{{#ifCond v1 "===" v2}} ... {{/ifCond}}` | Conditional blocks with comparison operators  |
| `$action "TYPE"`                          | Most recent action of a given type            |
| `$actions "TYPE"`                         | All actions of a given type as an array       |
| `$json value`                             | JSON string representation (debug only)       |

#### Registrar signature

The registrar's signature is stored on the `REGISTER` action and accessible via:

```handlebars
<image
  xlink:href="{{$lookup ($action 'REGISTER') 'createdBySignature'}}"
  x="310" y="640" width="140" height="55"
/>
```

#### Review mode

`$review` is `true` during the preview step and `false` when actually printing. Use it to show draft watermarks or hide print-only elements:

```handlebars
{{#if $review}}
  <text fill="rgba(200,110,0,0.1)" font-size="80" transform="rotate(-45, 297, 421)">
    <tspan x="100" y="500">DRAFT</tspan>
  </text>
{{/if}}
```

#### Multi-page templates

Core supports multi-page certificates via the `data-page` attribute on SVG groups. See certificate-multipage.md for the full guide.

#### Custom helpers

Countryconfig can define additional Handlebars helpers in:

```
src/certificate/handlebars/helpers.ts   (Farajaland path — your countryconfig may vary)
```

Core compiles this file to JavaScript, serves it at `/handlebars.js`, and loads it before rendering any template. See certificate-custom-helpers.md for the full guide.

***

### Further Reading

| Topic                                                            | Document                                                                 |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------ |
| All template variables and built-in helpers (detailed reference) | [certificate-builtin-helpers.md](https://certificate-builtin-helpers.md) |
| Writing custom Handlebars helpers                                | [certificate-custom-helpers.md](https://certificate-custom-helpers.md)   |
| Multi-page certificate templates                                 | [certificate-multipage.md](https://certificate-multipage.md)             |

