---
description: How to add custom certificate helpers
---

# Custom Handlebars.js helpers

Custom helpers let your country config add new Handlebars functions to certificate templates — anything from simple text formatting to complex multi-language address rendering. They are the escape hatch when the built-in helpers (`$lookup`, `$join`, `$intl`, etc.) aren't enough.

***

### What Custom Helpers Are

Custom helpers are country-specific Handlebars functions that you define in TypeScript and that become available to your certificate SVG templates as new template tags.

For example, if you define a helper called `formatNationalId`, your SVG template can call:

```handlebars
{{formatNationalId ($lookup $declaration "applicant.nationalId")}}
```

Built-in helpers (`$lookup`, `$intl`, `$join`, etc.) are defined in `opencrvs-core` and are always available. Custom helpers extend that set with anything your country's certificates need that the core doesn't provide.

***

### How They Work End-to-End

```
Country config server starts
  → handler.ts reads helpers.ts
  → esbuild compiles TypeScript → JavaScript (ESM)
  → compiled JS is served at GET /handlebars.js

Client loads the app
  → referenceApi.importHandlebarHelpers() fetches /handlebars.js
  → all named exports are stored in memory as the helpers registry

User prints or reviews a certificate
  → compileSvg() is called
  → for each helper name in the registry:
       customHelpers[helperName]({ intl })   ← factory called with intl
       Handlebars.registerHelper(name, result)
  → Handlebars.compile(svgTemplate)(data) runs
  → custom helper is called wherever {{helperName ...}} appears in SVG
```

The key line in core (pdfUtils.ts:289-298):

```ts
for (const helperName of Object.keys(customHelpers)) {
  const helper = customHelpers[helperName]({ intl })
  Handlebars.registerHelper(helperName, helper)
}
```

Every export from your `helpers.ts` is called with `{ intl }` and expected to return a `Handlebars.HelperDelegate`. This is the factory pattern — your export is not the helper itself, it's a function that receives context and returns the helper.

***

### Where to Write Them

```
src/certificate/handlebars/helpers.ts   ← write your helpers here
src/certificate/handlebars/handler.ts   ← do not touch, serves the file
```

The handler compiles `helpers.ts` to JavaScript via esbuild and serves it at the `/handlebars.js` route. You never need to change the handler.

***

### The Factory Pattern

Every export must be a **factory function**: a function that accepts `{ intl }` (optionally) and returns the actual Handlebars helper function.

```ts
// ✅ Correct — factory returns helper
export function myHelper(): Handlebars.HelperDelegate {
  return function(value: string) {
    return value.toUpperCase()
  }
}

// ✅ Correct — factory uses intl, returns helper
export function myHelper({ intl }: { intl: IntlShape }): Handlebars.HelperDelegate {
  return function(key: string) {
    return intl.formatMessage({ id: key, defaultMessage: key })
  }
}

// ❌ Wrong — this IS the helper, not a factory
export function myHelper(value: string) {
  return value.toUpperCase()
}
```

**Why the factory?** Core needs to inject `intl` (the active locale's translation engine) into your helper at render time. Because `intl` is created fresh per certificate render (with the correct locale), it can't be imported statically — it must be passed in. The factory pattern is how core hands it to you.

Type definition from core:

```ts
// From referenceApi.ts
type InjectedUtilities = {
  intl: IntlShape
}

export type LoadHandlebarHelpersResponse = Record<
  string,
  (injectedUtilities: InjectedUtilities) => Handlebars.HelperDelegate
>
```

***

### How Many Parameters You Can Pass

The Handlebars `HelperDelegate` type signature allows **up to 6 positional arguments** before the mandatory `options` object:

```ts
// From Handlebars type definitions:
interface HelperDelegate {
  (context?: any, arg1?: any, arg2?: any, arg3?: any, arg4?: any, arg5?: any, options?: HelperOptions): any
}
```

In practice `context` acts as your first positional argument. So the count is:

```
{{myHelper arg1 arg2 arg3 arg4 arg5 arg6}}
             ↑                          ↑
         your first arg            your sixth arg
                                   (options is added automatically after this)
```

Your helper function receives them in order, with `options` silently appended as the final argument by Handlebars:

```ts
export function myHelper(): Handlebars.HelperDelegate {
  return function(
    arg1: string,   // {{myHelper "a" ...}}
    arg2: string,   // {{myHelper "a" "b" ...}}
    arg3: number,   // {{myHelper "a" "b" 3 ...}}
    arg4: string,   // {{myHelper "a" "b" 3 "d" ...}}
    arg5: string,   // {{myHelper "a" "b" 3 "d" "e" ...}}
    arg6: string,   // {{myHelper "a" "b" 3 "d" "e" "f"}}
    options: Handlebars.HelperOptions  // always last, always present
  ) {
    return arg1 + arg2
  }
}
```

**Practical advice:** 3–4 positional arguments is the comfortable ceiling before templates become hard to read. If you find yourself needing more, consider splitting into multiple helpers or passing a structured value via `$lookup` and reading the rest from `options.data.root`.

```handlebars
{{! 1 arg }}
{{removeDateSuffix ($lookup $declaration "child.dob")}}

{{! 2 args }}
{{differenceInYears ($lookup $declaration "deceased.dob") ($lookup $metadata "dateOfEvent")}}

{{! 5 args — still readable }}
{{ternary ($lookup $declaration "deceased.dobUnknown") "===" "true" "Unknown" ($lookup $declaration "deceased.dob")}}
```

> You don't have to declare `options` in your function signature — Handlebars passes it regardless. Only declare it when you actually need to use it.

***

### The `options` Object

Handlebars **always** passes an `options` object as the very last argument to every helper call, whether you declare it or not. Its type is:

```ts
interface HelperOptions {
  fn:      TemplateDelegate        // the inner block content (block helpers only)
  inverse: TemplateDelegate        // the {{else}} block content (block helpers only)
  hash:    Record<string, any>     // named key=value parameters
  data?:   {
    root:  Record<string, any>     // the full top-level template context
    key?:  string                  // current key inside {{#each}}
    index?: number                 // current index inside {{#each}}
    first?: boolean                // true for first item inside {{#each}}
    last?:  boolean                // true for last item inside {{#each}}
  }
}
```

#### `options.fn` and `options.inverse`

Used only for **block helpers** — helpers that wrap a content block like `{{#helper}}...{{/helper}}`.

* `options.fn(this)` renders the inner block
* `options.inverse(this)` renders the `{{else}}` block

```ts
export function showIfRegistered(): Handlebars.HelperDelegate {
  return function(this: any, options: Handlebars.HelperOptions) {
    const { $metadata } = options.data.root
    if ($metadata?.legalStatuses?.REGISTERED) {
      return options.fn(this)      // render the block
    }
    return options.inverse(this)   // render {{else}}
  }
}
```

In template:

```handlebars
{{#showIfRegistered}}
  <tspan>Registration number: {{$lookup $metadata "legalStatuses.REGISTERED.registrationNumber"}}</tspan>
{{else}}
  <tspan>Not yet registered</tspan>
{{/showIfRegistered}}
```

#### `options.hash`

Named `key=value` arguments passed in the template call. Useful when you want optional, named configuration instead of positional args.

```ts
export function formatName(): Handlebars.HelperDelegate {
  return function(value: string, options: Handlebars.HelperOptions) {
    const separator = options.hash.separator ?? ' '
    const uppercase = options.hash.uppercase ?? false
    const result = value.trim().split(/\s+/).join(separator)
    return uppercase ? result.toUpperCase() : result
  }
}
```

In template:

```handlebars
{{formatName ($lookup $declaration "child.name.fullname") separator="-" uppercase=true}}
```

#### `options.data.root`

The most commonly used property. It gives you the **entire top-level template context** from inside a helper, regardless of how deeply nested the call is.

In V2 templates, `options.data.root` contains:

| Key            | What it is                                                                 |
| -------------- | -------------------------------------------------------------------------- |
| `$declaration` | Stringified form field data (same as what `$lookup $declaration` accesses) |
| `$metadata`    | Resolved event metadata (same as what `$lookup $metadata` accesses)        |
| `$review`      | Boolean — `true` during review/preview, `false` during print               |
| `$references`  | `{ locations: Map, users: Array }` — raw reference data                    |

```ts
export function buildAddressLine(): Handlebars.HelperDelegate {
  return function(lang: string, options: Handlebars.HelperOptions) {
    const { $declaration, $metadata, $review, $references } = options.data.root

    // Read any field from declaration
    const district = $declaration?.['child.birthLocation']?.district ?? ''
    const country  = $declaration?.['child.birthLocation']?.country ?? ''

    // Check if in review mode
    if ($review) {
      return `[DRAFT] ${district}, ${country}`
    }

    return [district, country].filter(Boolean).join(', ')
  }
}
```

#### `options.data` iteration keys

When your helper is called from inside a `{{#each}}` block, `options.data` also carries iteration context:

```ts
export function listItem(): Handlebars.HelperDelegate {
  return function(value: string, options: Handlebars.HelperOptions) {
    const index = options.data?.index   // 0-based position
    const isFirst = options.data?.first  // true for first item
    const isLast = options.data?.last    // true for last item
    const key = options.data?.key        // current object key (for {{#each object}})

    return isFirst ? `[START] ${value}` : value
  }
}
```

***

### Example of custom handlebar helpers

#### 1. Simple Helper (no intl)

When your helper doesn't need translation, just ignore the factory argument.

```ts
import * as Handlebars from 'handlebars'

// Removes ordinal suffixes: "15th March 2024" → "15 March 2024"
export function removeDateSuffix(): Handlebars.HelperDelegate {
  return function(value: string) {
    if (!value) return 'N/A'
    return value.replace(/\b(\d+)(st|nd|rd|th)\b/, '$1')
  }
}
```

In template:

```handlebars
{{removeDateSuffix ($lookup $declaration "child.dob")}}
```

***

#### 2. Helper with i18n translation

When you need to translate something that the built-in `$intl` helper can't handle — for example, translating a country code with a language-specific fallback, or combining multiple translation lookups with custom logic.

```ts
import * as Handlebars from 'handlebars'
import { type IntlShape } from 'react-intl'

type FactoryProps = { intl: IntlShape }

// Translates a nationality code like "NOR" into a localized string
export function nationality({ intl }: FactoryProps): Handlebars.HelperDelegate {
  return function(countryCode: string) {
    if (!countryCode) return 'N/A'
    return intl.formatMessage({
      id: `nationality.${countryCode}`,
      defaultMessage: countryCode
    })
  }
}
```

In template:

```handlebars
{{nationality ($lookup $declaration "father.nationality")}}
```

***

#### 3. Helper with multiple arguments

Positional arguments come before `options`. Declare `options` only if you need it.

```ts
// Conditional value — returns firstValue if condition is met, else secondValue
export function ternary(): Handlebars.HelperDelegate {
  return function(
    conditionValue1: string,
    operator: string,
    conditionValue2: string,
    firstValue: string,
    secondValue: string
    // options would be next if needed
  ) {
    switch (operator) {
      case '===': return conditionValue1 === conditionValue2 ? firstValue : secondValue
      case '!==': return conditionValue1 !== conditionValue2 ? firstValue : secondValue
      default:    return ''
    }
  }
}
```

In template:

```handlebars
{{ternary ($lookup $declaration "deceased.dobUnknown") "===" "true" "Unknown" ($lookup $declaration "deceased.dob")}}
```

Another example — time formatting with a single argument:

```ts
export function convertTo12HourFormat(): Handlebars.HelperDelegate {
  return function(time24?: string): string {
    if (!time24) return 'N/A'
    const [hours, minutes] = time24.split(':').map(Number)
    const period = hours >= 12 ? 'PM' : 'AM'
    const modifiedHours = hours % 12 || 12
    return `${modifiedHours}:${minutes.toString().padStart(2, '0')} ${period}`
  }
}
```

***

#### 4. Debug helper — inspect template context

When building or debugging a template, add a `debug` helper to dump all available variables to the browser console.

```ts
export function debug(): Handlebars.HelperDelegate {
  return function(this: any, options: Handlebars.HelperOptions) {
    console.log('Template context (this):', this)
    console.log('Root context:', options.data?.root)
  }
}
```

In template — call it anywhere in the SVG:

```handlebars
{{debug}}
```

`options.data.root` will show `{ $declaration, $metadata, $review, $references }` for V2 templates.

> Remove this before going to production.

***

#### 5. Accessing all template variables via `options.data.root`

For helpers that need to read multiple fields at once — for example, composing a full address from several declaration fields — use `options.data.root` instead of passing each value as an argument.

```ts
export function certificationLocation(): Handlebars.HelperDelegate {
  return function(
    lang: string,
    lineNumber: number,
    options: Handlebars.HelperOptions
  ) {
    const { $metadata } = options.data.root

    const name     = $metadata?.updatedAtLocation?.name ?? ''
    const district = $metadata?.updatedAtLocation?.district ?? ''
    const country  = $metadata?.updatedAtLocation?.country ?? ''

    switch (lineNumber) {
      case 1: return name
      case 2: return [district, country].filter(Boolean).join(', ')
      default: return ''
    }
  }
}
```

In template:

```handlebars
<tspan>{{certificationLocation "en" 1}}</tspan>
<tspan>{{certificationLocation "en" 2}}</tspan>
```

***

#### 6. Block helpers with `options.fn` and `options.inverse`

Block helpers wrap content and control whether to render it, render the `{{else}}`, or both.

```ts
export function ifHasValue(): Handlebars.HelperDelegate {
  return function(
    this: any,
    value: any,
    options: Handlebars.HelperOptions
  ) {
    if (value && value !== '' && value !== 'N/A') {
      return options.fn(this)      // render the block
    }
    return options.inverse(this)   // render {{else}}
  }
}
```

In template:

```handlebars
{{#ifHasValue ($lookup $declaration "father.name.fullname")}}
  <tspan>Father: {{$lookup $declaration "father.name.fullname"}}</tspan>
{{else}}
  <tspan>Father: Not provided</tspan>
{{/ifHasValue}}
```

***

#### 7. Named hash parameters

Hash parameters let callers pass optional named configuration:

```ts
export function joinFields(): Handlebars.HelperDelegate {
  return function(
    val1: string,
    val2: string,
    options: Handlebars.HelperOptions
  ) {
    const separator = (options.hash.separator as string) ?? ', '
    const fallback  = (options.hash.fallback as string) ?? ''
    const result = [val1, val2].filter(Boolean).join(separator)
    return result || fallback
  }
}
```

In template:

```handlebars
{{joinFields
  ($lookup $declaration "child.birthLocation.district")
  ($lookup $declaration "child.birthLocation.country")
  separator=" / "
  fallback="Location unknown"
}}
```

***

#### 8. Generating SVG tspan elements

The most advanced pattern. When a certificate paragraph is too long for a single `<tspan>` — or needs to be assembled from many data fields with computed layout — the helper generates SVG markup and returns it as a string.

Use **triple braces** `{{{ }}}` in the template to inject raw SVG without HTML escaping.

```ts
const MAX_CHARS = 75
const LINE_HEIGHT = 18

function splitIntoLines(text: string): string[] {
  const words = text.split(' ').filter(Boolean)
  return words.reduce<string[]>((lines, word) => {
    const last = lines[lines.length - 1]
    if (last.length + word.length < MAX_CHARS) {
      lines[lines.length - 1] = last + word + ' '
    } else {
      lines.push(word + ' ')
    }
    return lines
  }, [''])
}

export function multiLineText(): Handlebars.HelperDelegate {
  return function(
    startX: number,
    startY: number,
    text: string
  ) {
    let y = startY
    return splitIntoLines(text)
      .map(line => {
        const tspan = `<tspan x="${startX}" y="${y}">${line.trim()}</tspan>`
        y += LINE_HEIGHT
        return tspan
      })
      .join('')
  }
}
```

In template — triple braces for raw SVG:

```handlebars
<text font-family="Noto Sans" font-size="9.7">
  {{{multiLineText 81 200 ($lookup $declaration "child.name.fullname")}}}
</text>
```

***

### Using Custom Helpers in SVG Templates

Once a helper is exported from `helpers.ts`, it's available by name in any SVG template, alongside all built-in helpers.

```handlebars
{{! Simple value transformation }}
{{removeDateSuffix ($lookup $declaration "child.dob")}}

{{! Multiple arguments }}
{{ternary ($lookup $declaration "deceased.dobUnknown") "===" "true" "Age unknown" ($lookup $declaration "deceased.dob")}}

{{! intl-aware translation }}
{{nationality ($lookup $declaration "father.nationality")}}

{{! Named hash parameters }}
{{joinFields ($lookup $declaration "district") ($lookup $declaration "country") separator=" / "}}

{{! Block helper }}
{{#ifHasValue ($lookup $declaration "mother.name.fullname")}}
  <tspan>{{$lookup $declaration "mother.name.fullname"}}</tspan>
{{/ifHasValue}}

{{! Raw SVG output — triple braces }}
{{{buildCertificateParagraph 81 300 "en"}}}

{{! Compose with built-in helpers }}
{{$join ", " (nationality ($lookup $declaration "mother.nationality")) ($lookup $metadata "updatedAtLocation.country")}}
```

***

### TypeScript Imports

```ts
import * as Handlebars from 'handlebars'
import { type IntlShape } from 'react-intl'

type FactoryProps = {
  intl: IntlShape
}
```

You can import utilities from within your own package — but be careful: `helpers.ts` is compiled as a standalone browser ESM bundle by esbuild. Anything you import must be resolvable and safe to run in the browser.

> Do not import server-only Node.js modules (e.g. `fs`, `path`, `crypto`) — `helpers.ts` runs in the browser.

***

### Limitations

| Constraint                                 | Detail                                                                                                                                                                 |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Browser-only runtime                       | The compiled JS runs in the browser. No Node.js APIs.                                                                                                                  |
| Only `{ intl }` is injected by the factory | Core only passes `intl` to your factory. If you need `locations`, `users`, or `administrativeAreas`, read them from `options.data.root.$references` inside the helper. |
| All exports become helpers                 | Every `export function` in `helpers.ts` is registered as a Handlebars helper. Keep private utility functions unexported.                                               |
| No async helpers                           | Handlebars helpers are synchronous. Don't use `async/await` or return Promises.                                                                                        |
| Max 6 positional arguments                 | The `HelperDelegate` type signature supports up to 6 positional args before `options`.                                                                                 |
| esbuild target is browser ESM              | Imports work, but only for packages that have browser-safe builds.                                                                                                     |
| Helper names are global                    | If you name a helper the same as a built-in (e.g. `$lookup`), yours will override it. Avoid names starting with `$`.                                                   |

***

### Real-World Examples

These are patterns commonly needed in country certificate templates:

#### Age calculation from two dates

Useful on death certificates to show the deceased's age in years and remaining months.

```ts
function dateDiffInYears(from: Date, to: Date): number {
  let diff = to.getFullYear() - from.getFullYear()
  if (
    to.getMonth() < from.getMonth() ||
    (to.getMonth() === from.getMonth() && to.getDate() < from.getDate())
  ) diff--
  return diff
}

export function differenceInYears(): Handlebars.HelperDelegate {
  return function(fromDateString: string, toDateString: string) {
    const from = new Date(fromDateString)
    const to = new Date(toDateString)
    return dateDiffInYears(from, to)
  }
}
```

In template:

```handlebars
{{differenceInYears ($lookup $declaration "deceased.dob") ($lookup $metadata "dateOfEvent")}} years
```

***

#### Nationality / country code translation with locale override

When the built-in `$intl` helper isn't flexible enough — for example, when certain country codes need custom overrides that differ from your i18n message file.

```ts
export function nationality({ intl }: FactoryProps): Handlebars.HelperDelegate {
  return function(countryCode: string, lang: string) {
    if (!countryCode) return 'N/A'
    // Country-specific override example
    if (countryCode === 'FAR') {
      return lang === 'en' ? 'Farajalandian' : 'فرجلاندي'
    }
    return intl.formatMessage({
      id: `nationality.${countryCode}`,
      defaultMessage: countryCode
    })
  }
}
```

***

#### Ternary — conditional value inline

More flexible than `ifCond` for inline expressions where you want a value, not a block.

```ts
export function ternary(): Handlebars.HelperDelegate {
  return function(conditionValue1: string, operator: string, conditionValue2: string, firstValue: string, secondValue: string) {
    switch (operator) {
      case '===': return conditionValue1 === conditionValue2 ? firstValue : secondValue
      case '!==': return conditionValue1 !== conditionValue2 ? firstValue : secondValue
      default:    return ''
    }
  }
}
```

***

#### First non-empty value

When the same logical piece of data might be stored under different field IDs depending on which form was used.

```ts
export function firstNonEmpty(): Handlebars.HelperDelegate {
  return function(...args: any[]) {
    // args[-1] is options, skip it
    const values = args.slice(0, -1) as string[]
    return values.find(v => typeof v === 'string' && v !== '') ?? 'N/A'
  }
}
```

In template:

```handlebars
{{firstNonEmpty
  ($lookup $declaration "child.birthLocation.district")
  ($lookup $declaration "child.birthLocation.other.district")
  ($lookup $declaration "child.birthLocation.privateHome.district")
}}
```

***

#### Localized gender string

```ts
export function gender(): Handlebars.HelperDelegate {
  return function(genderValue: string, lang: string) {
    const translations: Record<string, Record<string, string>> = {
      Male:   { en: 'Male',   ar: 'ذكر' },
      Female: { en: 'Female', ar: 'أنثى' }
    }
    return translations[genderValue]?.[lang] ?? genderValue
  }
}
```

***

#### Generate a multi-line certificate paragraph

Combines multiple declaration fields and produces formatted SVG `<tspan>` elements. Output is injected raw with `{{{ }}}`.

```ts
export function buildBirthCertificateParagraph({ intl }: FactoryProps): Handlebars.HelperDelegate {
  return function(
    this: any,
    startX: number,
    startY: number,
    lang: string,
    options: Handlebars.HelperOptions
  ) {
    const { $declaration, $metadata } = options.data.root
    const lines: string[] = []
    const LINE_HEIGHT = 18

    const childName    = $declaration?.['child.name']?.fullname ?? ''
    const registrar    = $metadata?.legalStatuses?.REGISTERED?.createdBy?.name ?? ''
    const regLocation  = $metadata?.legalStatuses?.REGISTERED?.createdAtLocation?.name ?? ''

    lines.push(`I, ${registrar}, Registrar of ${regLocation}, certify that:`)
    lines.push(`${childName} has been duly registered.`)

    return lines
      .map((line, i) => `<tspan x="${startX}" y="${startY + i * LINE_HEIGHT}">${line}</tspan>`)
      .join('')
  }
}
```

In template:

```handlebars
<text font-family="Noto Sans" font-size="9.7">
  {{{buildBirthCertificateParagraph 81 300 "en"}}}
</text>
```

***

### Summary

| Task                            | Pattern                                                                           |
| ------------------------------- | --------------------------------------------------------------------------------- |
| Format a single value           | Simple helper — `export function x(): HelperDelegate { return fn }`               |
| Translate with locale           | intl helper — `export function x({ intl }: FactoryProps): HelperDelegate { ... }` |
| Compare / choose between values | Multi-arg with `ternary` or custom comparison                                     |
| Optional named config           | Hash parameters via `options.hash`                                                |
| Conditional block rendering     | Block helper using `options.fn` / `options.inverse`                               |
| Read multiple fields at once    | `options.data.root` for full context access                                       |
| Generate multi-line SVG text    | Return SVG string, use `{{{ }}}` in template                                      |
| Debug what's available          | Export `debug()`, call `{{debug}}`, check browser console                         |
