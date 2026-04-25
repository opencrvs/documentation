---
description: Step-by-step guide for upgrading the version of your OpenCRVS deployment
layout:
  width: default
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
---

# Version upgrades

{% hint style="danger" %}
### **Notice: This guide applies only to upgrading from v1.9 onwards.**

If you are running OpenCRVS v1.8 or earlier, follow the [v1.9 migration guide](https://documentation.opencrvs.org/general/migration-notes#upgrading-opencrvs-migration-guide) instead.
{% endhint %}

## Introduction

OpenCRVS supports incremental upgrades between versions. However, careful preparation is essential — especially for governments operating live civil registration systems.

This guide walks you through planning, testing, and safely upgrading to a newer version of OpenCRVS.

Upgrades impact your infrastructure, data, integrations, and users. Following this structured process helps minimise risk and ensures a smooth transition.

{% hint style="warning" %}
**Critical requirement** — OpenCRVS supports upgrading **one major/minor version at a time**.\
For example: v1.9.x → v2.0.x → v2.1.x (not v1.9 → v2.1 directly).
{% endhint %}

**Need help?** Contact us at [**team@opencrvs.org**](mailto:team@opencrvs.org).

***

## Upgrade process

This guide outlines a step-by-step process for safely upgrading OpenCRVS. Each step builds on the previous one and must be completed in sequence.

The process progresses through environments of increasing importance — local development, QA, staging, and finally production. This staged approach ensures issues are identified and resolved before affecting live systems.

**The upgrade process consists of 7 steps:**

{% stepper %}
{% step %}
#### [Preparation](version-upgrades.md#step-1-preparation)

Review your current setup, customisations, and readiness.
{% endstep %}

{% step %}
#### [Update code and test locally](version-upgrades.md#step-2-update-code-and-test-locally)

Update core and country configuration code, test locally, and commit changes.
{% endstep %}

{% step %}
#### [Update GitHub environments](version-upgrades.md#step-3-update-github-environments)

Update GitHub secrets and environment variables.
{% endstep %}

{% step %}
#### [Deploy to QA environment](version-upgrades.md#step-4-deploy-to-qa-environment)

Deploy and test the new version in QA.
{% endstep %}

{% step %}
#### [Deploy to staging environment](version-upgrades.md#step-5-deploy-to-staging-environment)

Deploy and validate using production-like data.
{% endstep %}

{% step %}
#### [Schedule downtime and notify staff](version-upgrades.md#step-6-schedule-downtime-and-notify-staff)

Prepare users and pause operations safely.
{% endstep %}

{% step %}
#### [Deploy to production](version-upgrades.md#step-7-deploy-to-production)

Run the upgrade in production and resume operations.
{% endstep %}
{% endstepper %}

***

### Step 1 — Preparation

Before upgrading, review the following areas. These are the same considerations used during implementation support, as they directly affect upgrade complexity.

**Version analysis**

* Which version of OpenCRVS are you currently running?
* Which version are you upgrading to?

**Core code customizations**

* Have you modified **opencrvs-core** (Node.js, React, or API logic)?
* Are you maintaining a fork of opencrvs-core?

{% hint style="info" %}
**Important** — If you maintain a fork, you must merge or rebase it with [opencrvs/opencrvs-core](https://github.com/opencrvs/opencrvs-core).

We strongly recommend contributing changes upstream instead of maintaining long-lived forks.
{% endhint %}

**External integrations**

* Have you integrated OpenCRVS with external systems (e.g. population registers, ID systems, HIS, notification services)?

All integrations must be retested after upgrading.

**Country configuration status**

* Is your country configuration fully complete (forms, events, locations, roles, messages, etc.)?

**Staff readiness**

* Are real users actively using the system?
* Will they require training for new workflows or UI changes?

**Data considerations**

* Are you already registering real citizens?
* Do you have reliable backups and a working staging database restore pipeline?

**Infrastructure checks**

If deployed to servers, confirm:

* Dedicated or shared infrastructure?
* Separate environments (Dev, QA, Staging, Production)?
* Automated backup and restore processes?
* Sufficient RAM, disk space, and CPU capacity?
* Cluster size (1, 3, or 5 nodes — all nodes must be reprovisioned)

{% hint style="info" %}
These checks ensure your infrastructure is healthy, backups are reliable, and upgrades can be safely tested before production deployment.
{% endhint %}

### Step 2 — **Update code and test locally**

The complexity of this step depends on the level of customisation in your country configuration.

**Update opencrvs-core**

```bash
cd <path>/opencrvs-core
git fetch
git checkout release-v*.*.*
git pull
yarn --force
```

You now have the target OpenCRVS release code locally.

**Update your country configuration fork**

```bash
cd <path>/opencrvs-<your-country>
git fetch --all
git checkout -b upgrade-v<target-version>
## Upgrade the toolkit package version to 2.0.0
yarn add @opencrvs/toolkit@2.0.0 --exact
## Run codemod tool, which upgrades your countryconfig to support v2.0
yarn opencrvs upgrade

## TODO: the command above should pull changes for infrastructure/ directory
## from opencrvs-countryconfig@release-2.0.0
## At this point the user might run in to merge conflicts under infrastructure/ dir.
## These must be fixed!

## At this point, we recommend autoformatting your code
yarn prettier --write src/
```

**Run locally**

Start OpenCRVS locally. Database migrations will run automatically.

**Test thoroughly**

Verify all key flows, integrations, and customisations before proceeding.

**Commit and push**

* Create a pull request for review
* Merge into your main branch

A new Docker image will be automatically built and pushed.

### Step 3 — Update GitHub environments

Back up all existing secrets and variables before making changes.

Each release may introduce:

* New secrets
* Renamed or removed variables
* DevOps improvements

To upgrade your environment details:

```bash
## This is ran in the root of your updated countryconfig repo
cd <path>/opencrvs-<your-country>
yarn environment:init
```

The script will:

* Prompt for missing secrets
* Generate new values where required
* Ask before overwriting existing values (**do not overwrite production secrets**)

### Step 4 — Deploy to QA environment

1. Run the **Provision** GitHub Action:
   1. Go to **Actions** in your repository
   2. Select **Provision** workflow
   3. Click **Run workflow**
   4. Choose **'qa'** as **'Machine to provision'**
   5. Click **Run workflow**
2. Run **Deploy** GitHub Action using:
   * New opencrvs-core release version
   * The new countryconfig Docker image git hash
3. **Do not reset** the environment (migrations run automatically)

Monitor migrations in Kibana using: `tag: migration`

Test your new QA deployment before proceeding!

### Step 5 — Deploy to staging environment

Repeat the steps used for QA, but for staging environment:

1. Provision
2. Deploy

Monitor migrations in **Observability → Logs** using `tag: migration`.

Do not use the deployment until migrations complete. Then perform full validation with your QA team.

{% hint style="info" %}
#### **Because staging contains real citizen data (from production backups), migrations may take hours.**

A release of OpenCRVS can contain automatic database migrations. If you have been running OpenCRVS in production and you have live civil registrations for real citizens, these migrations may take several hours to complete depending on your scale. This will lead to reduced performance of OpenCRVS during this time.
{% endhint %}

{% hint style="warning" %}
Ensure backups are working and can be restored to staging. Keep an offline and online copies of recent backups in case recovery is needed. [Read the backup instructions.](installation/opencrvs-maintenance-tasks/backup-and-restore/)
{% endhint %}

### Step 6 — Schedule downtime and notify staff

{% hint style="danger" %}
Browser caches are cleared during upgrades. Any unsubmitted drafts stored locally will be permanently lost.
{% endhint %}

Use **Email All Users** to instruct staff to:

* Stop work before the upgrade
* Submit all **offline drafts**
* Ensure their **outbox is empty**

### Step 7 — Deploy to production

{% hint style="danger" %}
**Never upgrade production without successfully restoring a backup to staging first.**
{% endhint %}

**Pre-upgrade checklist:**

* [ ] Ensure backups restore correctly on staging
* [ ] Maintain a **hard copy** of recent backups
* [ ] Expect database migrations to take **hours**
* [ ] Expect reduced system performance during migration
* [ ] Never upgrade production without validating on staging first

**Upgrade steps**

1. Provision **Backup** server
2. Provision **Production** server
3. **Deploy** using the new release and countryconfig image
4. Monitor migrations in Kibana (`tag: migration`)
5. Do not use production until migration finishes
6. Log in and test with your QA team
7. Notify staff that operations can resume
