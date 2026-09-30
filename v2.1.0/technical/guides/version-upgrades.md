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
  actions:
    visible: true
---

# Version upgrades

{% hint style="danger" %}
### **Notice: This guide applies only to upgrading from v1.9 onwards.**

If you are running OpenCRVS v1.8 or earlier, follow the [v1.9 migration guide](https://documentation.opencrvs.org/v1.9/general/migration-notes) instead.
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

* Is your country configuration fully complete? I.e. have you gone through all the steps on [configuration](configuration/ "mention")

**Staff readiness**

* Are real users actively using the system?
* Will they require training for new workflows or UI changes?

**Data considerations**

* Are you already registering real citizens?
* Do you have reliable backups and a working staging database restore pipeline?

**Infrastructure checks**

If deployed to servers, confirm:

* Are you using Docker Swarm or Kubernetes?
* Do you have dedicated or shared infrastructure?
* What are your environments (dev, QA, staging, production)?
* What are your automated backup and restore processes?
* Do you have sufficient RAM, disk space, and CPU capacity? See [#minimum-server-specifications](installation/deploy-set-up-a-server-hosted-environment/preparation-steps/setup-infrastructure.md#minimum-server-specifications "mention")
* What is the cluster size (1, 3, or 5 nodes — all nodes must be reprovisioned)? See [#server-environments](installation/deploy-set-up-a-server-hosted-environment/preparation-steps/setup-infrastructure.md#server-environments "mention")

{% hint style="info" %}
These checks ensure your infrastructure is healthy, backups are reliable, and upgrades can safely be tested before production deployment.
{% endhint %}

**Version-specific changes**

Read the notes for the version you are upgrading to, for example [#version-specific-notes-for-2.1](version-upgrades.md#version-specific-notes-for-2.1 "mention"), and the [release notes](../../releases/release-notes.md). They list the manual steps that the automated upgrade does not do for you.

### Step 2 — Update code and test locally

The complexity of this step depends on the level of customisation in your country configuration.

**Update opencrvs-core**

```bash
cd <path>/opencrvs-core
git fetch --tags
git checkout v<target-version>
pnpm install
```

You now have the target OpenCRVS release code locally.

**Update your country configuration fork**

```bash
cd <path>/opencrvs-<your-country>

## Create a temporary upgrade branch
git checkout -b upgrade-v<target-version>

## Upgrade the toolkit package version to the target version
yarn add @opencrvs/toolkit@2.x.x --exact

## Run codemod tool, which upgrades your countryconfig to support v2.1
## If you are still on Docker Swarm (instead of kubernetes), use the --docker-swarm flag!
## If this flag is set, the /infrastructure directory is kept.
## Otherwise it is deleted in favour of a separate infrastucture repository.
yarn opencrvs upgrade [--docker-swarm]

## At this point you might run in to merge conflicts under the /infrastructure directory.
## Now is the time to fix these!

## Update npm dependencies
yarn --force

## Finally, we recommend autoformatting your code
yarn prettier --write src/
## If you are still on Docker Swarm (instead of kubernetes):
yarn prettier --write infrastructure/
```

**Run locally**

Start OpenCRVS locally. Database migrations will run automatically.

**Test thoroughly**

Verify all key flows, integrations, and customisations before proceeding.

**Updating infrastructure repository** (only for users on kubernetes)

{% hint style="warning" %}
Infrastructure-repository is only used for kubernetes deployments, skip this if you are on docker-swarm!
{% endhint %}

```bash
cd <path>/opencrvs-<your-country>-infrastructure

## Ensure upstream points to opencrvs/infrastructure
git remote -v

git fetch --all

## Create a temporary upgrade branch
git checkout -b upgrade-v<target-version>

## Upgrade repository from upstream opencrvs/infrastructure
git merge upstream/release/2.x.x
```

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
## IF on docker swarm
cd <path>/opencrvs-<your-country>

## IF on kubernetes
cd <path>/opencrvs-<your-country>-infrastructure

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

<div align="center"><figure><img src="../../.gitbook/assets/Screenshot 2026-06-18 at 17.00.24.png" alt="" width="563"><figcaption><p>Email all users - available to users with the <code>config.update-all</code> scope</p></figcaption></figure></div>

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

***

## Version-specific notes for 2.1

These are the changes in v2.1 that need a decision or a manual step from you. Work through them alongside the seven steps above. The full list of changes is in the [release notes](../../releases/release-notes.md).

{% hint style="danger" %}
**Upgrading from v1.9.x? Upgrade to v2.0.0 first.**

v2.1 removes MongoDB and deletes the tooling that migrates MongoDB data into PostgreSQL. v2.0.0 is the only release that can migrate your data. Deploy v2.0.0, confirm the migration finished, and only then upgrade to v2.1.

* **Kubernetes:** the migration runs automatically as a Helm `pre-install,pre-upgrade` hook when `data_migration_legacy.enabled` is `true` (the default). If you disabled it, re-enable it while on v2.0.0.
* **Docker Swarm:** the `legacy-data-migration` service runs the first time you deploy v2.0.0. If it was removed before it ran, restore it from the v2.0.0 release and run it while still on v2.0.0.

Upgrading from v2.0.x needs nothing here: your data was migrated during the v2.0.0 upgrade.
{% endhint %}

### Country configuration (Step 2)

`npx @opencrvs/toolkit upgrade` (run as `yarn opencrvs upgrade` above) makes these changes for you. Review each one in the diff:

* Removes the Sentry wiring (`SENTRY_DSN`, the `hapi-sentry` plugin and its types).
* Renames user and system trigger routes from `/triggers/...` to `/trigger/...`. It lists any reference it could not rewrite, for example a path built at runtime. Rename those by hand.
* Adds the `password-reset-link` and `username-reminder-link` notification templates. Account recovery is now done with a single-use link, and it fails for every user if these templates are missing. Recovery links are built from `LOGIN_URL`, so check that value in every environment.
* Adds explicit `APPROVE_CORRECTION` and `REJECT_CORRECTION` action configurations where `REQUEST_CORRECTION` has `flags` or `conditionals`. These actions no longer inherit the request's configuration.
* Adds new translations.

Check these yourself:

* **Archiving no longer clears the `incomplete` flag.** An incomplete record stays incomplete through archive and unarchive. To keep the old behaviour, add `{ id: InherentFlags.INCOMPLETE, operation: 'remove' }` to the `flags` of your `ARCHIVE` action. See [flags.md](configuration/events/flags.md "mention").
* **Confirming asynchronous actions.** If your country configuration confirms actions asynchronously (it returns `202` from an action trigger and accepts or rejects later), that call must now be made with a system client holding `record.action.accept` / `record.action.reject`. The user's token and the old token-exchange grant no longer work. See [action-confirmation.md](configuration/action-triggers/action-confirmation.md "mention").
* **MOSIP.** The MOSIP integration is released with core. Give `mosip-api` its own system client holding `record.action.accept` and `record.read`, include `eventId` in the payload sent to `/events/registration`, and make sure `MOSIP_WEBSUB_SECRET` equals the `hub.secret` your WebSub subscription was created with. See [mosip-deployment.md](configuration/integrations/mosip-deployment.md "mention").
* **Location API clients.** `POST /locations` and `POST /administrative-areas` no longer update existing entries, and `validUntil` is no longer returned. Scripts that re-post locations to change them must use `PUT`. See [updates-and-versioning.md](configuration/administrative-hierarchy/updates-and-versioning.md "mention").
* **Attachment uploads.** Integrations that upload attachments should send `eventId`. `path` is deprecated.
* **Unarchive.** The new `record.unarchive` scope is not granted to any role in the reference country configuration. Add it to the roles that should be able to restore archived records.

### Infrastructure repository and GitHub environments (Steps 2 and 3)

After merging the upstream infrastructure release into your fork:

```bash
cd <path>/opencrvs-<your-country>-infrastructure
yarn install

## Moves each inventory file to environments/<environment>/inventory.yml
## and refreshes the environment lists in the GitHub workflows.
## environment:init refuses to run until this has been done.
yarn environment:upgrade

## Run once per environment
yarn environment:init
```

Running `yarn environment:init` for each environment:

* Stores the backup and restore server addresses as the GitHub variables `BACKUP_HOST` and `RESTORE_HOST`. They are no longer read from the SSH secret. **Run it for every environment that backs up or restores before you deploy v2.1**, otherwise backup and restore jobs have no host. Use IP addresses: the network policy for backups is built from them.
* Regenerates `environments/<environment>/**/values.yaml`. The generated files turn on Kubernetes network policies (deny by default), OpenTelemetry tracing and `OPENCRVS_ENVIRONMENT`. They are overwritten on every run, so keep your own settings in the matching `values.override.yaml`.

Also:

* **Delete the `SENTRY_DSN` secret.** Sentry has been removed.
* **Remove the `MONGODB_ADMIN_USER` / `MONGODB_ADMIN_PASSWORD` secrets** if they are still present.
* **Check `CONFIG_TOKEN_EXPIRY_SECONDS`.** It is now the lifetime of the short-lived access token and must not be set above `600`. If you raised it to make sessions longer, remove the override and set `CONFIG_REFRESH_TOKEN_EXPIRY_SECONDS` instead (default one week).
* **Check disk headroom.** Logs are now kept for 30 days instead of 2. See [#logging-disk-space-requirements](installation/deploy-set-up-a-server-hosted-environment/preparation-steps/setup-infrastructure.md#logging-disk-space-requirements "mention").

{% hint style="warning" %}
**Still on Docker Swarm?** `yarn opencrvs upgrade` deletes the `infrastructure/` directory of your country configuration unless you pass `--docker-swarm`. That directory holds the "Migration swarm to k8s" workflow. If you plan to move to Kubernetes, do it while still on v2.0.x. See [migration-from-docker-swarm-guide.md](installation/deploy-set-up-a-server-hosted-environment/migration-from-docker-swarm-guide.md "mention").
{% endhint %}

### After deploying

* The public `events.<domain>` route has been removed. Integrations must reach the events API through the gateway.
