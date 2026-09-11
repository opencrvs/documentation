# How to add new locations & administrative areas

This guide covers adding a **new** location or administrative area to an already-seeded, live hierarchy — for example a new health facility opening, or a new district being introduced. For the initial, one-time seed of a country's full hierarchy, see [How to populate administrative hierarchy](how-to-populate-administrative-hierarchy.md). See [Updates & versioning](updates-and-versioning.md) for the underlying data model.

## Prerequisites

- The hierarchy has already been seeded at least once.
- Your user or system client holds the `location.edit` scope. This scope must be added to a role in your country configuration — it is not granted by default after go-live.

## Creating a location

Send a request to create the location, either via the REST endpoint `POST /locations` or the equivalent tRPC `locationRouter.create` mutation:

- `name` — the location's name.
- `administrativeAreaId` — the administrative area it belongs to, or `null` for a location placed directly under the country.
- `locationType` — a country-defined type string (e.g. `CRVS_OFFICE`, `HEALTH_FACILITY`).
- `externalId` (optional) — an external reference code. Must not already be active on another location from the same date onward.
- `status` (optional) — defaults to `active`.
- `effectiveFrom` (optional) — defaults to the beginning-of-time sentinel, meaning the location is considered to have always existed. Set this explicitly if the location should only become selectable from a specific future date.

The response is the created location, with a single initial version in its `versions` history.

## Creating an administrative area

Creating an administrative area works the same way, via `POST /administrative-areas` (or `administrativeAreaRouter.create`), with `parentId` in place of `administrativeAreaId` and no `locationType`:

- `name`
- `parentId` — the parent administrative area, or `null` for a top-level area.
- `externalId` (optional)
- `status` (optional, defaults to `active`)
- `effectiveFrom` (optional, defaults to the beginning-of-time sentinel)

## Idempotent retries

Both endpoints accept an optional `id` and `versionId` in the request. Supplying them lets a retried request after a network failure be recognised as the same creation rather than producing a duplicate — generate and reuse the same `id`/`versionId` pair for a given creation attempt.

## What this does not cover

- Renaming, recoding or deactivating an existing location or area — see [How to update & deactivate locations & administrative areas](how-to-update-and-deactivate-locations-and-administrative-areas.md).
- Moving a location or area to a different parent — re-parenting isn't supported directly; see the transfer recipe in [Updates & versioning](updates-and-versioning.md).
