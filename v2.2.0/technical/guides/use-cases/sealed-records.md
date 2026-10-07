---
description: >-
  A worked example of composing flags, custom actions, conditionals, scopes and
  workqueues to seal especially sensitive records.
---

# Sealed records

Some records hold especially sensitive information — adoptions, gender recognition, protected witnesses, court-ordered restrictions — and must stay in the registry while their visibility and use are tightly controlled. OpenCRVS supports this via configuration, through **sealing**: a record can be marked as **sealed**, which restricts who can find it, who can view its contents, and which actions can be taken on it. Sealing never changes the underlying data, and every seal, unseal and view is auditable.

This is the **technical** companion to the functional overview in [sealed-records.md](../../../functional/markdown/records/sealed-records.md "mention"). There is no dedicated "sealing" subsystem — sealing is assembled from features you already have:

<table><thead><tr><th>Capability</th><th>Mechanism</th><th data-hidden>Example source code</th></tr></thead><tbody><tr><td>Mark a record as sealed</td><td>a custom <code>sealed</code> <a data-mention href="../configuration/events/flags.md">flags.md</a></td><td><a href="https://github.com/opencrvs/opencrvs-core/blob/339f6e4bde7854dbbdd13eea74adfe9290ce5faa/packages/testland/src/events/birth/index.ts#L155-L163">opencrvs-core/packages/testland/src/events/birth/index.ts</a></td></tr><tr><td>Seal / unseal a record</td><td><code>SEAL</code> and <code>UNSEAL</code> <a data-mention href="../configuration/events/actions/custom-actions.md">custom-actions.md</a> that add / remove the flag</td><td></td></tr><tr><td>Show the sealed state, hide fields, gate actions</td><td><a data-mention href="../configuration/events/conditionals.md">conditionals.md</a> using <code>flag('sealed')</code></td><td></td></tr><tr><td>Control who can find and view sealed records</td><td><code>record.search</code> / <code>record.read</code> <a data-mention href="../configuration/users/roles-and-scopes.md">roles-and-scopes.md</a> with a <code>flags</code> filter</td><td></td></tr><tr><td>Mask a found-but-not-readable record</td><td>field <code>secured</code> conditions driven by the flag</td><td></td></tr><tr><td>Keep sealed records out of workqueues</td><td>the search scope (automatically) + optional <a data-mention href="../configuration/workqueues.md">workqueues.md</a> <code>flags</code> filter</td><td></td></tr></tbody></table>

The worked examples below come from the reference country configuration (Farajaland). Sealing is **not** enabled in the scaffolded `countryconfig-template` by default — it is an opt-in you assemble per event. Full example source can be found in: [`opencrvs-core/packages/testland/src`](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/testland) .

## Define the `sealed` flag

`sealed` is a [flags.md](../configuration/events/flags.md "mention"). Flags are computed from the record's accepted action history rather than stored, so a record is "sealed" exactly while its latest sealing action is a `SEAL`. Define it once under the event's `flags`:

```typescript
// src/events/birth/index.ts
flags: [
  // ...other flags
  {
    id: "sealed",
    label: {
      id: "event.birth.flag.sealed",
      defaultMessage: "Sealed",
      description: "Flag label for sealed",
    },
    requiresAction: false,
  },
];
```

## Seal and unseal with custom actions

Two [custom-actions.md](../configuration/events/actions/custom-actions.md "mention") toggle the flag: `SEAL` adds it, `UNSEAL` removes it. Their `conditionals` make each available only in the right state, and both collect a reason so the change is recorded in the audit history. Add the two `customActionType`s to the event's `actionOrder`, then define them under `actions`.

{% tabs %}
{% tab title="Seal" %}
Shown only on a registered record that is not already sealed:

```typescript
{
  type: ActionType.CUSTOM,
  customActionType: 'SEAL',
  icon: 'Lock',
  label: { defaultMessage: 'Seal', /* ... */ },
  form: [
    // Examples what you might want on the sealing action form:
    // - reason / legal basis (SELECT: court order, other...),
    // - court order reference (TEXT), requesting party (TEXT),
    // - supporting document — court order copy (FILE, uncorrectable)
  ],
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: and(status('REGISTERED'), not(flag('sealed')))
    }
  ],
  flags: [{ id: 'sealed', operation: 'add' }],
  auditHistoryLabel: { defaultMessage: 'Sealed', /* ... */ }
}
```
{% endtab %}

{% tab title="Unseal" %}
Shown only while the record is sealed:

```typescript
{
  type: ActionType.CUSTOM,
  customActionType: 'UNSEAL',
  icon: 'Unlock',
  label: { defaultMessage: 'Unseal', /* ... */ },
  form: [ /* For example: reason (TEXTAREA) */ ],
  conditionals: [
    { type: ConditionalType.SHOW, conditional: flag('sealed') }
  ],
  flags: [{ id: 'sealed', operation: 'remove' }],
  auditHistoryLabel: { defaultMessage: 'Unsealed', /* ... */ }
}
```
{% endtab %}
{% endtabs %}

The flag is added the moment `SEAL` is accepted (and removed by `UNSEAL`), so every rule below reacts automatically — you never toggle sealed state by hand.

## React to the flag across the record

With the flag in place, use [conditionals.md](../configuration/events/conditionals.md "mention") — all via the `flag('sealed')` helper from `@opencrvs/toolkit/events` — to change how the record behaves while sealed.

### Show a sealed indicator

A lock icon and a [#banners](../configuration/events/summary.md#banners "mention") make the sealed state obvious to users who can see the record:

```typescript
icon: {
  FileLock: and(
    event.hasStatus(EventStatus.enum.REGISTERED),
    event.hasFlag("sealed"),
  );
}
```

```typescript
summary: {
  banners: [
    {
      type: "negative",
      icon: "FileLock",
      heading: { defaultMessage: "Record is protected" /* ... */ },
      description: {
        defaultMessage: "Request to unseal to view this record" /* ... */,
      },
      conditionals: [
        { type: ConditionalType.SHOW, conditional: flag("sealed") },
      ],
    },
  ];
}
```

### Hide sensitive summary fields

Add `not(flag('sealed'))` to a summary field's `SHOW` conditional so it drops out of the record overview while sealed:

```typescript
{
  fieldId: 'child.nid',
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: and(not(field('child.nid').isFalsy()), not(flag('sealed')))
    }
  ]
}
```

### Gate actions

The same `not(flag('sealed'))` on an action's `SHOW` or `ENABLE` conditional disables it while the record is sealed — for example to prevent printing a certificate or requesting a correction on a sealed record.

## Control who can find and view sealed records

Access is governed by two [user scopes](../configuration/users/roles-and-scopes.md):

* `record.search` — can the user **find** the record (in search, workqueues, listings and counts)?
* `record.read` — can the user **view** its contents?

Each scope takes an optional `flags` filter (`ContainsFlags`: `anyOf` / `noneOf` / `allOf`).

**The model is exclusion, not inclusion.** By default a scope returns records regardless of flags. To keep sealed records **out** of a role's reach, add `flags: { noneOf: ['sealed'] }`; omit the filter to let the role reach them. Configure this in the country's `roles.ts` with `defineScopes`:

```typescript
// src/data-seeding/roles/roles.ts
import { defineScopes } from "@opencrvs/toolkit/scopes";

// A role that must not see sealed records at all:
scopes: defineScopes([
  {
    type: "record.search",
    options: {
      placeOfEvent: "administrativeArea",
      flags: { noneOf: ["sealed"] },
    },
  },
  {
    type: "record.read",
    options: {
      placeOfEvent: "administrativeArea",
      flags: { noneOf: ["sealed"] },
    },
  },
]);
```

Because search and read are separate scopes, you can grant **find-but-not-view**. The reference `LOCAL_REGISTRAR` can locate sealed records but only sees a masked version:

```typescript
// LOCAL_REGISTRAR — searches sealed records, cannot read them
{ type: 'record.search', options: { placeOfEvent: 'administrativeArea' } },
{ type: 'record.read',   options: { placeOfEvent: 'administrativeArea', flags: { noneOf: ['sealed'] } } }
```

A role that may fully view sealed records simply omits the filter. The reference `NATIONAL_REGISTRAR` (Registrar General) has unrestricted search and read:

```typescript
// NATIONAL_REGISTRAR
{ type: 'record.search' },
{ type: 'record.read' }
```

The `flags` filter composes with the scope's other options (`placeOfEvent`, `event`, jurisdiction), so a role can never reach sealed records outside the event types or jurisdictions it is otherwise allowed. Use this to limit sealed access to, for example, national-level or specialised roles.

{% hint style="info" %}
The functional overview describes this as an `incl=sealed` capability. In configuration it is expressed the other way round: records are reachable by default, and roles are **restricted** with `flags: { noneOf: ['sealed'] }`.
{% endhint %}

## Mask a found-but-not-readable record

A user who can search but not read a sealed record must see only enough to identify it — never its contents. This is enforced by **securing** the record's declaration fields: the search index redacts any field marked `secured` for users who lack the read scope.

Rather than marking each field by hand, the reference config secures every data field of a page for as long as the record is sealed, with a small helper:

```typescript
// src/events/utils/sealing.ts
export function securePageWhileSealed<T extends PageConfig>(page: T): T {
  return { ...page, fields: page.fields.map(secureFieldWhileSealed) };
}
// secureFieldWhileSealed sets `secured: flag('sealed')` on any data-carrying
// field that isn't already secured.
```

Apply it when assembling the declaration form:

```typescript
// src/events/birth/forms/declaration.ts
securePageWhileSealed(page);
```

Now a user with `record.search` but not sealed `record.read` finds the record and sees a masked entry — falling back to the event's `fallbackTitle` where the title itself is masked — while the full contents stay hidden. Applying it to the whole page keeps this true for fields added later, instead of relying on each field remembering to declare `secured`. See [`sealing.ts`](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/testland/src/events/utils/sealing.ts).

## Sealed records in workqueues

Workqueues query the event index using the signed-in user's search scope, so **a role without sealed search access never sees sealed records in any workqueue, listing or count** — the scope in step 4 does the work, with no per-workqueue change needed.

Where you want explicit control, a [workqueues.md](../configuration/workqueues.md "mention") query can filter on the flag with the same `anyOf` / `noneOf` shape used elsewhere:

{% tabs %}
{% tab title="Exclude sealed records" %}
```typescript
// Exclude sealed records from an ordinary workqueue
query: {
  flags: {
    noneOf: ["sealed"];
  } /* ...other query clauses */
}
```
{% endtab %}

{% tab title="Dedicated sealed records workqueue" %}
Only meaningful for roles that can search sealed records:

```typescript
query: {
  flags: {
    anyOf: ["sealed"];
  } /* ...other query clauses */
}
```
{% endtab %}
{% endtabs %}

## Configuration checklist

When enabling sealed records for an event, decide and configure:

* **Which events** may be sealed — add the `sealed` flag and the `SEAL` / `UNSEAL` actions to each.
* **What sealing captures** — the `SEAL` form fields (reason, legal basis, court-order reference, supporting document) your legal and audit needs require.
* **What sealing hides** — which summary fields and actions to gate with `not(flag('sealed'))`, and secure the declaration fields with `securePageWhileSealed` so masked search results leak nothing.
* **Who can find and view** sealed records — add `flags: { noneOf: ['sealed'] }` to the `record.search` / `record.read` scopes of every role that must be kept out, and omit it (or split search vs. read) for roles that may find and/or view them.
* **Which jurisdictions** — rely on the existing `placeOfEvent` / jurisdiction options on those scopes to keep sealed access within a role's normal reach.

Configured this way, sealing changes only who can find, view and act on a record — never the underlying data — and remains explicit, auditable, and reversible only by appropriately authorised users.
