---
description: Configuring multi-page PDF certificates
---

# Multi-Page Certificate Templates

OpenCRVS supports certificate templates that render as multiple PDF pages. Each page is defined as a `<g data-page="N">` group inside a single SVG file.

***

### How It Works

When OpenCRVS renders a certificate, it checks whether the SVG contains any elements with a `data-page` attribute. If it finds any:

1. It selects all elements matching `[data-page]`.
2. Each matching element becomes a **separate PDF page**.
3. The per-page height is calculated as `total SVG height ÷ number of pages`.
4. Each page element is wrapped in a copy of the root `<svg>` (inheriting all root attributes) and the `transform` attribute is removed.

If no `[data-page]` elements exist, the entire SVG is rendered as a single page — this is the standard single-page behaviour.

***

### SVG Dimensions

The root `<svg>` element must have its `height` set to the **total height of all pages combined**. The `width` stays the same as a single-page template.

```
total height = page height × number of pages
```

For a 2-page A4-portrait template (A4 ≈ 595 × 842 pt):

```xml
<svg
  width="595"
  height="1684"
  viewBox="0 0 595 1684"
  xmlns="http://www.w3.org/2000/svg"
>
  ...
</svg>
```

For a 3-page template of the same size:

```xml
<svg width="595" height="2526" viewBox="0 0 595 2526" ...>
```

The PDF page size is automatically derived:

```
PDF page height = SVG height ÷ page count
PDF page width  = SVG width (unchanged)
```

***

### Page Groups

Each page is a `<g>` element with a `data-page` attribute. The value can be any string — OpenCRVS just uses the presence of the attribute, not its value, to detect pages.

```xml
<g data-page="1">
  <!-- all content for page 1 goes here -->
</g>

<g data-page="2" transform="translate(0, 842)">
  <!-- all content for page 2 goes here -->
</g>
```

Convention: use `data-page="1"`, `data-page="2"`, etc. to match the visual order.

***

### The Transform Pattern

Here is the most important thing to understand about multi-page SVGs:

**Every page's content must be designed in the coordinate space `(0, 0)` to `(width, pageHeight)`** — not in the total SVG coordinate space.

But in the combined SVG, page 2 needs to sit visually below page 1. To achieve this, each page after the first gets a `transform="translate(0, offset)"` where `offset = (pageNumber - 1) × pageHeight`:

| Page   | transform                        |
| ------ | -------------------------------- |
| Page 1 | _(none)_                         |
| Page 2 | `transform="translate(0, 842)"`  |
| Page 3 | `transform="translate(0, 1684)"` |

When OpenCRVS extracts each page for rendering, it **removes the `transform` attribute**. The content then renders at its native coordinates (`y=0` to `y=pageHeight`), filling the PDF page correctly.

**Visual result in the SVG file vs PDF output:**

```
Combined SVG (for design tools)     PDF output
┌───────────────────────────┐       ┌───────────────────────────┐
│  <g data-page="1">        │       │  Page 1 content           │
│  y: 0 → 842               │  →→   │  rendered at y: 0-842     │
│                           │       └───────────────────────────┘
├───────────────────────────┤       ┌───────────────────────────┐
│  <g data-page="2"         │       │  Page 2 content           │
│    transform="translate   │  →→   │  rendered at y: 0-842     │
│    (0, 842)">             │       └───────────────────────────┘
│  y: 0 → 842 (native)      │
└───────────────────────────┘
```

The transform is only there so design tools (Figma, Inkscape, Illustrator) display both pages stacked vertically in a single canvas. The transform plays no role in the final PDF output.

***

### Step-by-Step: Creating a Multi-Page Template

#### 1. Decide your page dimensions

Pick a page size. Standard is 595 × 842 (A4 portrait in points).

```
page width  = 595
page height = 842
page count  = 2 (for example)
total SVG height = 842 × 2 = 1684
```

#### 2. Set root SVG dimensions

```xml
<svg
  width="595"
  height="1684"
  viewBox="0 0 595 1684"
  fill="none"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
>
```

#### 3. Wrap page 1 content

Content for page 1 uses coordinates from `y=0` to `y=842`. No transform needed.

```xml
<g data-page="1">
  <!-- page 1 content: y coordinates 0 to 842 -->
  <rect x="50" y="50" width="495" height="742" />
</g>
```

#### 4. Wrap page 2 content with a translate transform

Page 2 content also uses coordinates from `y=0` to `y=842` (as if it were its own page). Apply `transform="translate(0, 842)"` to shift it visually below page 1 in the combined SVG view.

```xml
<g data-page="2" transform="translate(0, 842)">
  <!-- page 2 content: y coordinates 0 to 842 (same range as page 1) -->
  <rect x="50" y="50" width="495" height="742" />
</g>
```

#### 5. Add Handlebars expressions normally

All template variables and helpers work exactly the same on every page. Access `$declaration`, `$metadata`, helpers, etc. just as you would on a single-page template.

```xml
<g data-page="1">
  <text>
    <tspan x="62" y="200">
      {{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}
    </tspan>
  </text>
</g>

<g data-page="2" transform="translate(0, 842)">
  <text>
    <tspan x="62" y="200">
      {{$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"}}
    </tspan>
  </text>
</g>
```

***

### Handlebars Variables Across Pages

All template variables are available on every page — there is no per-page scoping.

| Variable               | Available on page 2, 3, etc.? |
| ---------------------- | ----------------------------- |
| `$declaration`         | Yes                           |
| `$metadata`            | Yes                           |
| `$review`              | Yes                           |
| `$references`          | Yes                           |
| All built-in helpers   | Yes                           |
| Custom country helpers | Yes                           |

Handlebars is compiled once for the full SVG, then the DOM is split into pages. Variables and helpers are resolved before the split.

***

### Important Constraints

#### All visible content must be inside a `[data-page]` group

When OpenCRVS detects `[data-page]` elements, **only** those elements are rendered into PDF pages. Anything at the root level of the SVG (outside any `[data-page]` group) is excluded from the output.

```xml
<!-- This will NOT appear in the PDF: -->
<text x="100" y="100">This is outside any data-page group</text>

<g data-page="1">
  <!-- This WILL appear: -->
  <text x="100" y="100">Page 1 content</text>
</g>
```

#### Move `<defs>` inside each page group that uses them

Design tools like Figma export `<defs>` (clip paths, gradients, masks) at the root SVG level. When a page is extracted, its wrapper SVG only contains the page group — root-level `<defs>` are not copied over. If your page content references a `<clipPath>` or `<mask>` by ID, move the `<defs>` inside the page group:

```xml
<!-- Avoid: defs at root, referenced from inside the group -->
<defs>
  <clipPath id="clip1">...</clipPath>
</defs>
<g data-page="1">
  <g clip-path="url(#clip1)">...</g>  <!-- may not render correctly -->
</g>

<!-- Prefer: defs inside the page group -->
<g data-page="1">
  <defs>
    <clipPath id="clip1">...</clipPath>
  </defs>
  <g clip-path="url(#clip1)">...</g>  <!-- renders correctly -->
</g>
```

#### Page height is calculated from SVG dimensions, not content

If your `height` attribute is not an exact multiple of your page count, the PDF page height will be a fraction. Always set `height = pageHeight × pageCount`.

#### No page-level layout control

OpenCRVS does not support page-break hints, overflow, or automatic content flow across pages. You control exactly what appears on each page by placing content inside the appropriate `[data-page]` group.

***

### Complete Two-Page Example

This minimal example shows the full structure for a two-page A4 certificate.

```xml
<svg
  width="595"
  height="1684"
  viewBox="0 0 595 1684"
  fill="none"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
>
  <!-- ═══════════════════════════════════════════════ -->
  <!-- PAGE 1  (y: 0 → 842, no transform)             -->
  <!-- ═══════════════════════════════════════════════ -->
  <g data-page="1">

    <!-- Border -->
    <rect x="30" y="30" width="535" height="782" stroke="#C86E00" stroke-width="2" fill="white"/>

    <!-- Title -->
    <text fill="#C86E00" font-family="Noto Sans" font-size="18" font-weight="bold">
      <tspan x="297" y="100" text-anchor="middle">CERTIFICATE OF MEMBERSHIP</tspan>
    </text>

    <!-- Registration number -->
    <text font-family="Noto Sans" font-size="10">
      <tspan x="62" y="150" font-weight="bold">No. </tspan>
      <tspan>{{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}</tspan>
    </text>

    <!-- Applicant name -->
    <text font-family="Noto Sans" font-size="10" font-weight="bold">
      <tspan x="62" y="200">Full Name</tspan>
    </text>
    <text font-family="Noto Sans" font-size="10">
      <tspan x="310" y="200">{{$lookup $declaration "applicant.name.fullname"}}</tspan>
    </text>

    <!-- Date of birth -->
    <text font-family="Noto Sans" font-size="10" font-weight="bold">
      <tspan x="62" y="225">Date of Birth</tspan>
    </text>
    <text font-family="Noto Sans" font-size="10">
      <tspan x="310" y="225">{{$lookup $declaration "applicant.dob"}}</tspan>
    </text>

    <!-- Date of registration -->
    <text font-family="Noto Sans" font-size="10" font-weight="bold">
      <tspan x="62" y="250">Date of Registration</tspan>
    </text>
    <text font-family="Noto Sans" font-size="10">
      <tspan x="310" y="250">
        {{$lookup $metadata "legalStatuses.REGISTERED.createdAt"}}
      </tspan>
    </text>

    <!-- Show watermark in review mode only -->
    {{#if $review}}
    <text fill="rgba(200,110,0,0.15)" font-family="Noto Sans" font-size="80" font-weight="bold"
          transform="rotate(-45, 297, 421)">
      <tspan x="100" y="500">DRAFT</tspan>
    </text>
    {{/if}}

  </g>

  <!-- ═══════════════════════════════════════════════ -->
  <!-- PAGE 2  (y: 0 → 842, translated 842px down)    -->
  <!-- ═══════════════════════════════════════════════ -->
  <g data-page="2" transform="translate(0, 842)">

    <!-- Border (same coordinates as page 1 — same coordinate space) -->
    <rect x="30" y="30" width="535" height="782" stroke="#C86E00" stroke-width="2" fill="white"/>

    <!-- Page 2 heading -->
    <text fill="#C86E00" font-family="Noto Sans" font-size="14" font-weight="bold">
      <tspan x="297" y="100" text-anchor="middle">CERTIFICATION DETAILS</tspan>
    </text>

    <!-- Registrar name -->
    <text font-family="Noto Sans" font-size="10" font-weight="bold">
      <tspan x="62" y="200">Registered by</tspan>
    </text>
    <text font-family="Noto Sans" font-size="10">
      <tspan x="310" y="200">
        {{$lookup $metadata "legalStatuses.REGISTERED.createdBy.name"}}
      </tspan>
    </text>

    <!-- Registration office -->
    <text font-family="Noto Sans" font-size="10" font-weight="bold">
      <tspan x="62" y="225">Registration Office</tspan>
    </text>
    <text font-family="Noto Sans" font-size="10">
      <tspan x="310" y="225">
        {{$lookup $metadata "legalStatuses.REGISTERED.createdAtLocation.name"}}
      </tspan>
    </text>

    <!-- Date of certification -->
    <text font-family="Noto Sans" font-size="10" font-weight="bold">
      <tspan x="62" y="250">Date of Certification</tspan>
    </text>
    <text font-family="Noto Sans" font-size="10">
      <tspan x="310" y="250">{{$lookup $metadata "modifiedAt"}}</tspan>
    </text>

    <!-- Signature line -->
    <line x1="310" y1="700" x2="535" y2="700" stroke="#222222" stroke-width="1"/>
    <text font-family="Noto Sans" font-size="8">
      <tspan x="310" y="715">Signature of Registrar</tspan>
    </text>

    <!-- Registrar signature image -->
    <image
      xlink:href="{{$lookup ($action 'REGISTER') 'createdBySignature'}}"
      x="310" y="640" width="140" height="55"
    />

  </g>

</svg>
```

#### What happens during rendering

| Step                                  | Result                                                                                               |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| OpenCRVS finds `[data-page]` elements | 2 groups found                                                                                       |
| PDF page height calculated            | `1684 ÷ 2 = 842`                                                                                     |
| Page 1 extracted                      | `<svg width="595" height="1684" ...><g data-page="1">...</g></svg>` → PDF page 1                     |
| Page 2 extracted                      | `<svg width="595" height="1684" ...><g data-page="2">...</g></svg>` → PDF page 2 (transform removed) |
| PDF output                            | 2-page document, each page 595 × 842                                                                 |

The `transform="translate(0, 842)"` on page 2 is removed during extraction. Page 2's content (designed at y=0..842) renders correctly on the second PDF page.
