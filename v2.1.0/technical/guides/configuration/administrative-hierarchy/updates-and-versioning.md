# Updates & versioning

**TL;DR**

1. Every location and administrative area keeps a `versions` history — an ordered list of `{ name, externalId, status, effectiveFrom }` entries.
2. Identity (`id`, parent/administrative area, location type) is fixed at creation and never changes. Only name, code and status are versioned.
3. Each record and certificate resolves the version that was in effect at the record's own date (its anchor), not the current name.
4. Updates only append a new version — nothing is edited or removed in place. A future-dated version can be withdrawn before it takes effect.
5. Re-parenting a location or administrative area is not supported. Moving one to a different parent means inactivating the old one and creating a new one.
6. Writing locations or administrative areas after go-live requires the `location.edit` scope.

### Why versioning exists

Names, codes and active/inactive status of offices, facilities and administrative areas change over time — a health facility closes, a district office is renamed, a village is merged into another. Historical records must keep showing the name and status that applied when they were captured, while current forms and searches must reflect what's true today. A single mutable `name`/`status` field cannot do both at once, so each location and administrative area instead keeps a small history of versions.

### The `versions` array

Each element of `versions` has:

- `versionId` — a UUID identifying the version itself.
- `effectiveFrom` — a plain date (`YYYY-MM-DD`) from which this version applies.
- `name`
- `externalId` — optional, used for point-in-time code uniqueness (see below).
- `status` — `active` or `inactive`.

Versions are sorted ascending by `effectiveFrom`. The very first version of a location is dated `0001-01-01` — a beginning-of-time sentinel — so that every location always resolves to _some_ version, however far back a record's date reaches.

Everything else about a location or administrative area — its `id`, its parent (`administrativeAreaId` / `parentId`), and a location's `locationType` — is set once at creation and cannot change. Renames and status changes only ever append a new version; nothing is edited or deleted in place.

### Resolving a version — the anchor date

Because a location's name and status vary over time, any UI or API that renders one needs an **anchor date**: the date the name/status should be resolved at. The anchor is the record's own date of event, or `createdAt` when the configured date-of-event field is empty (e.g. a partial notification) — the same fallback convention used elsewhere for date-of-event resolution.

Resolution takes the version with the greatest `effectiveFrom` that is still on or before the anchor, falling back to the earliest version when the anchor precedes all of them. In practice this means:

- A record captured before a rename shows the old name in the record view and on the certificate, even after the location has since been renamed.
- A record captured before a location is deactivated still shows it as it was, even though it's no longer selectable in new declarations.
- A location doesn't appear at all as an option in forms until its first version's `effectiveFrom` has arrived — a location scheduled for the future stays hidden until then.

Client applications never read a flat `name`/`status` off a cached location — that would go stale the moment a version takes effect without the device re-syncing. Every read is resolved from `versions` against the anchor at render time.

### Withdrawing a pending change

A version that has not taken effect yet (its `effectiveFrom` is still in the future) can be withdrawn — this removes it from the history outright, as if it had never been scheduled. Once a version's `effectiveFrom` has passed, it can no longer be withdrawn; a further version must be appended instead to change course.

### Transfers: no re-parenting

A location's administrative area, and an administrative area's parent, are part of its immutable identity — they cannot be changed by appending a version. Moving a health facility or office to a different administrative area (or moving an administrative area under a different parent) is therefore done as two separate, independent operations:

1. Inactivate the existing location/area (append an `inactive` version).
2. Create a new location/area under the correct parent.

Both operations are idempotent and safe to retry individually; they are not combined into a single atomic call.

### Point-in-time code uniqueness

Where an `externalId` (an external reference code) is set, it must be unique among **active** holders at any given point in time — not across all of history. A new location can reuse a code that a different, since-inactivated location used to hold, but it cannot take over a code that's still active (or scheduled to become active) elsewhere from the same date onward.

### Configuring form selectors

`LOCATION`, `ADMINISTRATIVE_AREA` and `ADDRESS` fields have their own `activeOnly` / `anchorToDateOfEvent` configuration options for controlling which versions a form selector offers — see [How to limit location and administrative area options in event declaration](how-to-limit-location-and-administrative-area-options-in-event-declaration.md#limiting-options-by-version-status-and-date).

### Access control

Locations and administrative areas can only be written through the write API described in [How to add new locations & administrative areas](how-to-add-locations-and-administrative-areas.md) and [How to update & deactivate locations & administrative areas](how-to-update-and-deactivate-locations-and-administrative-areas.md). Both require the `location.edit` scope, which must be assigned to a role in your country configuration before any user can manage locations this way.
