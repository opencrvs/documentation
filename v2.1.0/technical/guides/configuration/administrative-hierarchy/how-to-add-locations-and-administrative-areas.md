# How to add new locations & administrative areas

This guide covers adding a **new** location or administrative area to an already-seeded, live hierarchy — for example a new health facility opening, or a new district being introduced. For the initial, one-time seed of a country's full hierarchy, see [How to populate administrative hierarchy](how-to-populate-administrative-hierarchy.md). See [Updates & versioning](updates-and-versioning.md) for the underlying data model.

## Prerequisites

- The hierarchy has already been seeded at least once.
- Your user or system client holds the `location.edit` scope. This scope must be added to a role in your country configuration — it is not granted by default after go-live.

## Creating a location

Send a request to create the location, either via the REST endpoint `POST /api/events/locations` or the equivalent tRPC `locations.create` mutation:

- `name` — the location's name.
- `administrativeAreaId` — the administrative area it belongs to, or `null` for a location placed directly under the country. An unknown id is not rejected with a clean validation error, so double-check it beforehand.
- `locationType` — a country-defined type string (e.g. `CRVS_OFFICE`, `HEALTH_FACILITY`). Not validated against the country's configured types — any string, or `null`, is accepted as-is.
- `externalId` (optional) — an external reference code. Must not already be active on another location from the same date onward.
- `status` (optional) — defaults to `active`.
- `effectiveFrom` (optional) — defaults to the beginning-of-time sentinel, meaning the location is considered to have always existed. Set this explicitly if the location should only become selectable from a specific future date.

The response is the created location. A location created with a future `effectiveFrom` comes back with its top-level `status` already resolved as `inactive` — even though the version itself is `active` — since it isn't in effect yet, and it's excluded from `list({ isActive: true })` until that date arrives. An idempotent replay against an existing location returns that location as it now stands, with its complete `versions` history — which may hold more than the one initial version, if it's since been updated.

## Creating an administrative area

Creating an administrative area works the same way, via `POST /api/events/administrative-areas` (or `administrativeAreas.create`), with `parentId` in place of `administrativeAreaId` and no `locationType`:

- `name`
- `parentId` — the parent administrative area, or `null` for a top-level area. An unknown id is not rejected with a clean validation error, so double-check it beforehand.
- `externalId` (optional)
- `status` (optional, defaults to `active`)
- `effectiveFrom` (optional, defaults to the beginning-of-time sentinel)

## Idempotent retries

Both endpoints accept an optional `id` in the request. Supplying it lets a retried request after a network failure be recognised as the same creation rather than producing a duplicate: if a location or area with that `id` already exists and its identity and initial version match the request, the existing one is returned rather than erroring. An optional `versionId` may also be supplied for the initial version, but it is not itself compared for idempotency — only `id` and the rest of the payload are.

## Errors

A successful create returns `200`, not `201`. Beyond `401` (invalid/missing token) and `403` (missing the `location.edit` scope), `400` covers a malformed payload. `409` covers a conflicting write: an `id` that already exists with **different** identity or initial-version values than the request (a matching `id` with matching values is the idempotent-retry case above, and isn't an error), or an `externalId` already active elsewhere on or after the given `effectiveFrom`.

## What this does not cover

- Renaming, recoding or deactivating an existing location or area — see [How to update & deactivate locations & administrative areas](how-to-update-and-deactivate-locations-and-administrative-areas.md).
- Moving a location or area to a different parent — re-parenting isn't supported directly; see the transfer recipe in [Updates & versioning](updates-and-versioning.md).
