# Guide: Dashboard

#### 1. Introduction

This guide explains how to configure performance dashboards in OpenCRVS. Dashboards are powered by **Metabase** and embedded directly in the OpenCRVS navigation.

Use this guide when you are:

* Setting up dashboards for a new OpenCRVS deployment.
* Adding or removing dashboards available to users.
* Controlling which roles can access which dashboards.
* Configuring which event data flows into Metabase.

For an overview of what dashboards show and who uses them, see the [**Performance dashboards**](https://app.gitbook.com/s/TIJguU5Pzi7HeHrkXa4I/functional) page in the Functional section.



#### 2. Prerequisites

Before configuring dashboards:

* Metabase must be deployed and accessible. In production, it runs as a Docker service. In development, start it with `yarn metabase` from the country config root.
* You must have the Metabase admin credentials (`user@opencrvs.org` / `m3tabase` by default in development).
* Public dashboard sharing must be enabled in Metabase for each dashboard you want to embed.



#### 3. Define dashboards in client config

Dashboards available in the OpenCRVS UI are declared in `src/client-config.ts`  and `src/client-config.prod.ts` using the `DASHBOARDS` array. Each entry defines one dashboard menu item.

**3.1 Dashboard entry fields**

Each dashboard entry requires three fields:

* **`id`** — A unique string identifier for this dashboard. This ID is used in role configuration to grant access (see Section 4).
* **`title`** — An i18n message object with `id`, `defaultMessage`, and `description`.
* **`url`** — The public embed URL from Metabase for this dashboard.

**3.2 Example configuration**

```typescript
DASHBOARDS: [
  {
    id: 'registrations',
    title: {
      id: 'dashboard.registrationsTitle',
      defaultMessage: 'Registrations Dashboard',
      description: 'Menu item for registrations dashboard'
    },
    url: 'https://your-metabase/public/dashboard/03be04d6-bde0-4fa7-9141-21cea2a7518b#bordered=false&titled=false&refresh=300'
  },
  {
    id: 'completeness',
    title: {
      id: 'dashboard.completenessTitle',
      defaultMessage: 'Completeness Dashboard',
      description: 'Menu item for completeness dashboard'
    },
    url: 'https://your-metabase/public/dashboard/41940907-8542-4e18-a05d-2408e7e9838a#bordered=false&titled=false&refresh=300'
  },
  {
    id: 'registry',
    title: {
      id: 'dashboard.registryTitle',
      defaultMessage: 'Registry',
      description: 'Menu item for registry dashboard'
    },
    url: 'https://your-metabase/public/dashboard/dc66b77a-79df-4f68-8fc8-5e5d5a2d7a35#bordered=false&titled=false&refresh=300'
  }
]
```

**3.3 Getting the embed URL from Metabase**

To get a public embed URL for a dashboard:

1. Open the dashboard in Metabase.
2. Click the **Share** icon.
3. Enable **Public sharing**.
4. Copy the public link and append `#bordered=false&titled=false&refresh=300` to suppress Metabase's default chrome and set a refresh interval.



#### 4. Grant dashboard access to roles

Dashboard visibility is controlled per role using the `dashboard.view` scope in `src/data-seeding/roles/roles.ts`. Users only see dashboards whose IDs are listed in their role's granted scopes.

**4.1 The `dashboard.view` scope**

Add a `dashboard.view` scope entry to a role's scope list, specifying the dashboard IDs that role may access:

```typescript
{
  type: 'dashboard.view',
  options: { ids: ['registrations', 'completeness', 'registry'] }
}
```

The `ids` array must contain IDs that match entries in the `DASHBOARDS` array in `client-config.ts`. A user whose role does not include `dashboard.view` sees no dashboards.

**4.2 Limiting access to specific dashboards**

Different roles can be granted access to different subsets of dashboards. For example, a local registrar might only see the `registry` dashboard, while a performance manager sees all three:

```typescript
// Local registrar — operational view only
{ type: 'dashboard.view', options: { ids: ['registry'] } }

// Performance manager — full dashboard access
{ type: 'dashboard.view', options: { ids: ['registrations', 'completeness', 'registry'] } }
```

**4.3 `performance.read-dashboards` — the outer gate**

Two scopes must both be present for a user to access dashboards:

* **`performance.read-dashboards`** — gates the dashboard section in the sidebar and the `/dashboard/:id` route entirely. Without it, the section is invisible and the route is blocked, regardless of `dashboard.view`.
* **`dashboard.view`** — within the section, filters which individual dashboards are visible based on `ids`.

In practice, assign both together to any role that should see dashboards.



#### 5. Enable analytics on events

For an event type to appear in dashboard data, it must be opted in to the analytics pipeline at the event config level.

**5.1 The event-level `analytics` flag**

In your event config, set `analytics: true`:

```typescript
export const birthEvent = defineEvent({
  id: 'birth',
  analytics: true,
  // ... rest of event config
})
```

Events without `analytics: true` are ignored entirely by the analytics pipeline — no data from those event types is written to the analytics database.

**5.2 Registering events in the shared index**

All event configs must be exported from `src/events/index.ts` to be picked up by the analytics pipeline:

```typescript
import { tennisClubMembershipEvent } from './tennis-club-membership'
import { birthEvent } from './birth'
import { deathEvent } from './death'

export const eventConfigs = [tennisClubMembershipEvent, birthEvent, deathEvent]
```

The analytics pipeline reads `eventConfigs` and filters to entries where `analytics === true`.



#### 6. Mark analytics fields

Within each event's form configuration, individual fields must be marked to indicate they should be included in the analytics database. Only marked fields appear in Metabase.

**6.1 The field-level `analytics` flag**

Set `analytics: true` on any form field that should be tracked:

```typescript
field({
  id: 'child.dob',
  type: 'DATE',
  analytics: true,
  // ... rest of field config
})
```

**6.2 PII fields must never be marked**

Never set `analytics: true` on fields that contain personally identifiable information, including:

* Full names
* National ID numbers
* Phone numbers
* Email addresses
* Precise addresses

The purpose of the `analytics` flag is to produce aggregated, de-identified datasets. Marking PII fields defeats this and creates a data protection risk.



#### 7. Development workflow

Changes to Metabase dashboards must be made locally and committed to version control. Changes made directly in staging or production are overwritten on the next deployment.

**7.1 Start Metabase locally**

```bash
yarn metabase
```

Metabase starts at `http://localhost:4444`. Default credentials: `user@opencrvs.org` / `m3tabase`.

> **Note:** Metabase is not started by default as part of the standard OpenCRVS dev stack because it requires significant system resources.

**7.2 Make and save dashboard changes**

1. Open `http://localhost:4444` and log in.
2. Create or modify dashboards, questions, and models.
3. Stop the Metabase process (Ctrl+C). Changes are automatically saved to `infrastructure/metabase/metabase.init.db.sql`.
4. Commit the updated SQL file to version control.
5. Deploy — the updated `metabase.init.db.sql` is loaded on startup in all environments.



#### 8. Migration guide from v1.9

If you are upgrading from OpenCRVS v1.9, the Metabase locations model must be updated to reflect the new location data structure.

**8.1 Update the locations model query**

1. Log into local Metabase at `http://localhost:4444`.
2. Navigate to `http://localhost:4444/model/71-locations/query`.
3. Update the query to:

```sql
WITH RECURSIVE administrative_area_path AS (
    -- roots
    SELECT
        aa.id,
        aa.parent_id,
        aa.name,
        aa.name::text AS administrative_area_path,
        1 AS level
    FROM analytics.administrative_areas aa
    WHERE aa.parent_id IS NULL

    UNION ALL

    -- descendants
    SELECT
        aa.id,
        aa.parent_id,
        aa.name,
        aap.administrative_area_path || ',' || aa.name,
        aap.level + 1
    FROM analytics.administrative_areas aa
    JOIN administrative_area_path aap
        ON aa.parent_id = aap.id
),

pivot AS (
    SELECT
        id,

        split_part(administrative_area_path, ',', 1)  AS level_1_name,
        split_part(administrative_area_path, ',', 2)  AS level_2_name,
        split_part(administrative_area_path, ',', 3)  AS level_3_name,
        split_part(administrative_area_path, ',', 4)  AS level_4_name,
        split_part(administrative_area_path, ',', 5)  AS level_5_name,
        split_part(administrative_area_path, ',', 6)  AS level_6_name,
        split_part(administrative_area_path, ',', 7)  AS level_7_name,
        split_part(administrative_area_path, ',', 8)  AS level_8_name,
        split_part(administrative_area_path, ',', 9)  AS level_9_name,
        split_part(administrative_area_path, ',', 10) AS level_10_name

    FROM administrative_area_path
)

SELECT
	l.id::text AS id,
    l.name,
    l.location_type,
    l.administrative_area_id,

    aa.name AS administrative_area_name,

    aap.administrative_area_path,
    aap.level AS administrative_area_level,

    -- include location itself in the final full path
    CASE
        WHEN aap.administrative_area_path IS NOT NULL
            THEN aap.administrative_area_path || ',' || l.name
        ELSE l.name
    END AS full_path,

    p.level_1_name,
    p.level_2_name,
    p.level_3_name,
    p.level_4_name,
    p.level_5_name,
    p.level_6_name,
    p.level_7_name,
    p.level_8_name,
    p.level_9_name,
    p.level_10_name

FROM analytics.locations l

LEFT JOIN analytics.administrative_areas aa
    ON aa.id = l.administrative_area_id

LEFT JOIN administrative_area_path aap
    ON aap.id = aa.id

LEFT JOIN pivot p
    ON p.id = aa.id;
```

4. Save the model.
5. Stop Metabase, commit `infrastructure/metabase/metabase.init.db.sql`, and deploy.



#### 9. Configuration checklist

Before going live with dashboards, verify:

* [ ] Each dashboard is defined in `DASHBOARDS` in `src/client-config.ts` with a unique `id`, correct `title`, and working public embed `url`.
* [ ] Public sharing is enabled in Metabase for each dashboard.
* [ ] Each role that should see dashboards has a `dashboard.view` scope with the correct `ids`.
* [ ] Event configs that should feed analytics data have `analytics: true` set.
* [ ] No PII fields are marked with `analytics: true`.
* [ ] All event configs are exported from `src/events/index.ts`.
* [ ] Dashboard changes are committed to version control (not edited directly in staging/production).
