# How to update & deactivate locations & administrative areas

This guide covers renaming, recoding, deactivating, or scheduling a future change to an existing location or administrative area. See [Updates & versioning](updates-and-versioning.md) for how these changes are stored and resolved.

## Prerequisites

Your user or system client holds the `location.edit` scope. This scope must be added to a role in your country configuration.

## Appending a new version

Updating a location or administrative area works by appending a new version to its history — nothing in an existing version is edited or removed. Send the update via the REST endpoint `PUT /api/events/locations/{id}` (or `PUT /api/events/administrative-areas/{id}`; tRPC `locations.update` / `administrativeAreas.update`), with a **full snapshot** of every versioned field:

- `name`
- `externalId` (optional)
- `status` — `active` or `inactive`
- `effectiveFrom` (optional) — defaults to today, and must be **strictly later** than the `effectiveFrom` of the latest version already in the history. Set a future date to schedule the change ahead of time.
- `lastVersionId` — the `versionId` of the **last element** in the entity's `versions` array, used as an optimistic-concurrency check.
- `versionId` (optional) — pins the id of the version being appended, for idempotent retries.

Fields are not merged with the previous version — if you're only changing the status, you still need to send the current `name` and `externalId` alongside it. Identity fields (`administrativeAreaId`/`parentId`, `locationType`) cannot be included in this request; they are rejected outright since they can't change after creation.

## Deactivating a location or area

Deactivating uses the same update endpoint, sending `status: 'inactive'`. Once inactive at a given `effectiveFrom`, the location or area:

- stops appearing as a selectable option on form fields configured with [`activeOnly: true`](how-to-limit-location-and-administrative-area-options-in-event-declaration.md#limiting-options-by-version-status-and-date),
- keeps appearing in existing records and certificates dated before it, resolved to whatever version was in effect then,
- keeps appearing in office/health-facility search selectors (so past records assigned to it remain findable), even though it can no longer be selected on form fields configured with [`activeOnly: true`](how-to-limit-location-and-administrative-area-options-in-event-declaration.md#limiting-options-by-version-status-and-date) going forward.

## Scheduling a future change

Setting `effectiveFrom` to a future date schedules the new version without it taking effect immediately — the current version stays in effect until then. This is useful for planned closures, renames or recodes announced ahead of time.

## Withdrawing a scheduled change

A version that hasn't taken effect yet can be withdrawn — send `DELETE /api/events/locations/{id}/versions/{versionId}` (or `DELETE /api/events/administrative-areas/{id}/versions/{versionId}`; tRPC `locations.withdrawVersion` / `administrativeAreas.withdrawVersion`) with the pending version's `versionId`. This removes the scheduled version entirely, as if it had never been added. Once its `effectiveFrom` is today or earlier, a version can no longer be withdrawn; append a further version instead. A change made today cannot be withdrawn the same day.

## Moving a location or area to a different parent (transfer)

Re-parenting is not supported as a single operation — `administrativeAreaId`/`parentId` is part of a location or area's fixed identity. To move one to a different parent:

1. Deactivate the existing location or area (append an `inactive` version, as above).
2. Create a new location or area under the correct parent, following [How to add new locations & administrative areas](how-to-add-locations-and-administrative-areas.md).

These are two separate calls, each independently idempotent and retryable, rather than one atomic transfer.

## Errors

A successful update or withdrawal returns `200`, not `201`. Beyond `401` (invalid/missing token) and `403` (missing the `location.edit` scope):

- `404` — unknown `id` (or `versionId`, for withdraw).
- `409` — a conflicting write: another version already has that `effectiveFrom` (and this isn't your own retried request), `lastVersionId` no longer matches the latest version (someone else updated it first — refresh and retry), the recoded `externalId` is already active elsewhere from that date, or (withdraw only) the version is the entity's only one, or its `effectiveFrom` is today or earlier.
- `422` — `effectiveFrom` is not strictly later than the latest version's (update only).
