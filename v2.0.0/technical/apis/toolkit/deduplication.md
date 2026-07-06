# Deduplication

Deduplication rules are built with the `field`, `and`, `or`, and `not` functions from `@opencrvs/toolkit/events/deduplication`. These are separate from the conditionals module — they produce `ClauseInput` objects (not `JSONSchema`) and are evaluated by the search index.

***

#### `field` (deduplication)

Builds a field matcher for use in a deduplication rule.

**Signature**

```ts
import { field } from '@opencrvs/toolkit/events/deduplication'

field(fieldId: string): {
  fuzzyMatches(options?: FuzzyMatcherOptions): ClauseInput
  strictMatches(options?: StrictMatcherOptions): ClauseInput
  dateRangeMatches(options: DateRangeMatcherOptions): ClauseInput
}
```

**Parameters**

| Parameter | Type     | Description                                               |
| --------- | -------- | --------------------------------------------------------- |
| `fieldId` | `string` | The form field ID to match against (e.g. `'child.name'`). |

**`.fuzzyMatches(options?)`**

Fuzzy text match — tolerates minor spelling differences.

| Option         | Type               | Default      | Description                                                    |
| -------------- | ------------------ | ------------ | -------------------------------------------------------------- |
| `fuzziness`    | `string \| number` | `'AUTO:4,7'` | Edit distance: ≤3 chars → 0 edits, 4–6 → 1 edit, ≥7 → 2 edits. |
| `boost`        | `number`           | `1`          | Scoring weight multiplier.                                     |
| `matchAgainst` | `string`           | —            | Match this field's value against a different field ID instead. |

**`.strictMatches(options?)`**

Exact value match.

| Option         | Type     | Default | Description                                                                |
| -------------- | -------- | ------- | -------------------------------------------------------------------------- |
| `value`        | `string` | —       | Constant value both records must share. Omit to match any identical value. |
| `boost`        | `number` | `1`     | Scoring weight multiplier.                                                 |
| `matchAgainst` | `string` | —       | Compare against a different field ID.                                      |

**`.dateRangeMatches(options)`**

Date proximity match — records within ±`days` of each other score as potential duplicates.

| Option         | Type     | Required | Description                                                                                                             |
| -------------- | -------- | -------- | ----------------------------------------------------------------------------------------------------------------------- |
| `days`         | `number` | Yes      | Half-width of the match window in days.                                                                                 |
| `pivot`        | `number` | No       | Day distance at which the relevance score is halved. Defaults to `⌊(days * 2) / 3⌋`.                                    |
| `boost`        | `number` | No       | Scoring weight multiplier (default `1`).                                                                                |
| `matchAgainst` | `string` | No       | When set, matches this field against `matchAgainst` instead of against itself; useful for cross-field age/dob matching. |

**Example 1 — match births with similar child names and nearby dates**

```ts
import { field, and } from '@opencrvs/toolkit/events/deduplication'

export const dedupConfig = and(
  field('child.name').fuzzyMatches(),
  field('child.dob').dateRangeMatches({ days: 5 })
)
```

**Example 2 — match only when an ID document is identical (or not provided)**

```ts
import { field, or, not } from '@opencrvs/toolkit/events/deduplication'

const idMatchesIfGiven = or(
  not(field('mother.idType').strictMatches()),          // different ID types → skip
  field('mother.idType').strictMatches({ value: 'NONE' }), // no ID → skip
  field('mother.nid').strictMatches(),                  // same NID
  field('mother.passport').strictMatches()              // same passport
)
```

***

#### `and` (deduplication)

All clauses must match for the pair to be considered a duplicate.

**Signature**

```ts
function and(...clauses: ClauseInput[]): ClauseInput
```

**Example 1 — full birth deduplication rule**

```ts
import { field, and, or } from '@opencrvs/toolkit/events/deduplication'

export const dedupConfig = and(
  field('child.name').fuzzyMatches(),
  field('child.dob').dateRangeMatches({ days: 5 }),
  field('mother.name').fuzzyMatches(),
  or(
    field('mother.dob').dateRangeMatches({ days: 365 }),
    field('mother.age').dateRangeMatches({ days: 365 })
  )
)
```

**Example 2 — death deduplication**

```ts
export const dedupConfig = and(
  field('deceased.name').fuzzyMatches(),
  field('eventDetails.date').dateRangeMatches({ days: 5 }),
  field('deceased.dob').dateRangeMatches({ days: 365 })
)
```

***

#### `or` (deduplication)

At least one clause must match.

**Signature**

```ts
function or(...clauses: ClauseInput[]): ClauseInput
```

**Example 1 — cross-field age/dob matching**

```ts
import { field, or } from '@opencrvs/toolkit/events/deduplication'

// Matches if mother's age and dob are consistent across records,
// even when one record uses dob and the other uses age
const similarAgedMother = or(
  field('mother.dob').dateRangeMatches({ days: 365 }),
  field('mother.age').dateRangeMatches({ days: 365 }),
  field('mother.dob').dateRangeMatches({ days: 365, matchAgainst: 'mother.age' }),
  field('mother.age').dateRangeMatches({ days: 365, matchAgainst: 'mother.dob' })
)
```

**Example 2 — multiple duplicate detection strategies**

```ts
// Flag as duplicate if EITHER: names+dob match, OR names+a 9-month dob window match
export const dedupConfig = or(
  and(
    field('child.name').fuzzyMatches(),
    field('child.dob').dateRangeMatches({ days: 5 }),
    field('mother.name').fuzzyMatches()
  ),
  and(
    field('child.name').strictMatches(),
    field('child.dob').dateRangeMatches({ days: 270 }),
    field('mother.name').fuzzyMatches()
  )
)
```

***

#### `not` (deduplication)

Inverts a deduplication clause.

**Signature**

```ts
function not(clause: ClauseInput): ClauseInput
```

**Example 1 — skip ID check when ID types differ**

```ts
import { field, not } from '@opencrvs/toolkit/events/deduplication'

const differentIdTypes = not(field('mother.idType').strictMatches())
```

**Example 2 — exclude records marked as authenticated**

```ts
const notAuthenticated = not(field('mother.verified').strictMatches({ value: 'authenticated' }))
```
