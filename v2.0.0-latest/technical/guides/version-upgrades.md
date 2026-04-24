---
description: Step-by-step guide for upgrading the version of your OpenCRVS deployment
---

# Version upgrades

{% hint style="danger" %}
### **Notice: This guide only applies to upgrading from v1.9 onwards.**

If your current OpenCRVS version is v1.8 or older, please see the [v1.9 documentation](https://documentation.opencrvs.org/general/migration-notes#upgrading-opencrvs-migration-guide) instead!
{% endhint %}

### Introduction

OpenCRVS supports incremental upgrades between versions, but preparation is essential — especially for governments running live civil registration services. This guide helps you plan, test, and execute a safe upgrade to a newer version of OpenCRVS.

Upgrading requires careful attention to your environment, data, integrations, and staff readiness. Following this structured approach minimises risk and ensures a smooth transition.

**Need support?** Contact us at [**team@opencrvs.org**](mailto:team@opencrvs.org) for assistance.

***

### Upgrading overview

{% hint style="warning" %}
**Critical requirement** — OpenCRVS supports upgrading **one major/minor version at a time**. This means you must upgrade v1.9 to v2.0.
{% endhint %}

A successful OpenCRVS upgrade involves:

* **Preparation** — Assessing your current setup, customisations, and readiness
* **Local updates** — Updating code and resolving merge conflicts
* **Environment upgrades** — Updating GitHub secrets and variables
* **Staged deployment** — Testing in QA, then Staging, before Production
* **Production upgrade** — Scheduled downtime with staff notification

***

### Upgrade process

This section provides a step-by-step guide to safely upgrade OpenCRVS from one version to another. Each step must be completed in sequence, as later steps depend on the successful completion of earlier ones.

The process moves through progressively more critical environments, from local development through QA and staging, before finally upgrading production. This staged approach ensures that any issues are caught and resolved before they impact live operations.

#### Step 1 — Prepare for upgrading

Before upgrading, confirm the following. These are the same questions we ask when supporting an implementation, as the answers significantly affect the upgrade effort.

**Version analysis**

* Which version of OpenCRVS are you currently running?
* Which version do you want to upgrade to?

**Core code customizations**

* Have you modified **opencrvs-core** (NodeJS, React, or API logic)?
* Have you forked opencrvs-core and maintain a custom version?

{% hint style="info" %}
**Important** — If you maintain a OpenCRVS core fork, you must merge or rebase your core fork with [opencrvs/opencrvs-core](https://github.com/opencrvs/opencrvs-core). We strongly recommend submitting PRs to the upstream opencrvs-core instead of maintaining long-lived forks.
{% endhint %}

**External integrations**

* Have you integrated OpenCRVS with external systems (e.g., population registers, ID platforms, HIS, notification services)?

All integrations must be retested after upgrading.

**Country configuration status**

* Have you fully configured your country's forms, events, locations, roles, messages, etc.?

**Staff readiness**

* Do you have real users already using the system?
* Do they need training on new business processes or UI changes in the new release?

**Data considerations**

* Are you already registering real citizens?
* Do you have reliable backups and a working staging database restore pipeline?

{% hint style="danger" %}
**Never upgrade production without successfully restoring a backup to staging first.**
{% endhint %}

**Server environment checks**

If OpenCRVS is already deployed to servers, you must confirm:

* Dedicated or shared servers?
* Separate Dev, Staging, QA, and Production environments?
* Automated backup and restoration configured?
* Available RAM, disk space, and CPU capacity?
* Whether you are running a cluster of 1, 3, or 5 nodes (clusters must all be re-provisioned)

{% hint style="info" %}
**Why we ask these questions** — To ensure you have working backups, your infrastructure is healthy, you test upgrade safely in QA and Staging, and your data is protected. If any concerns arise, contact us for support.
{% endhint %}

#### Step 2 — Update locally

The complexity of this stage depends on how many customizations you have made to your countryconfig fork.

**Update opencrvs-core**

```bash
cd <path>/opencrvs-core
git fetch
git checkout release-v*.*.*  # or master if appropriate
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

**Run OpenCRVS locally**

Start the system using the new versions. Migrations run automatically on your local database.

**Test thoroughly before continuing!**

At this point you should test your deployment thoroughly.

**Commit and push**

Create a PR for peer review, then merge to your main development branch. A Docker image with the updated git hash will automatically build and push to DockerHub.

#### Step 3 — Upgrade GitHub environments

Back up all secrets and environment variables in your password manager.

Each release may introduce:

* New GitHub environment secrets
* Removed or renamed variables
* DevOps improvements

To upgrade your environment details:

```bash
## This is ran in the root of your updated countryconfig repo
cd <path>/opencrvs-<your-country>
yarn environment:init
```

The script will:

* Ask whether to overwrite existing secrets (do **not** overwrite for live environments)
* Prompt you to add missing secrets
* Automatically generate new values where required

#### Step 4 — Upgrade QA servers

1. Run the **Provision** GitHub Action for your QA environment. On GitHub:
   1. Navigate to 'Actions' on your country configuration repository
   2. Find the 'Provision' action
   3. Press 'Run workflow'
   4. Select 'qa' as 'Machine to provision'
   5. Press 'Run workflow'
2. Run **Deploy** GitHub Action using:
   * New opencrvs-core release version
   * The new countryconfig Docker image git hash
3. **Do not reset** the environment (migrations run automatically)

Monitor migrations in Kibana (`tag: migration`)

Test thoroughly in QA before proceeding.

#### Step 5 — Upgrade staging servers

Repeat the steps used for QA, but for staging environment:

1. Provision
2. Deploy

Monitor migrations in Kibana, searching **Observability > Logs** using `tag: migration` to ensure there are no migration errors.

Do not use staging until migrations complete. Once complete, test again with your QA team.

{% hint style="info" %}
#### **Because staging contains real citizen data (from production backups), migrations may take hours.**

A release of OpenCRVS can contain automatic database migrations. If you have been running OpenCRVS in production and you have live civil registrations for real citizens, these migrations may take several hours to complete depending on your scale. This will lead to reduced performance of OpenCRVS during this time.
{% endhint %}

{% hint style="warning" %}
Ensure that OpenCRVS backups are working and restoring on a staging environment. You should also have a hard copy of recent backups. This is so that you can restore in the event of any migration problems. [Read the backup instructions.](../../../v1.9.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.7-backup-and-restore)
{% endhint %}

#### Step 6 — Schedule production downtime and notify staff

{% hint style="danger" %}
Browser caches are cleared on upgrade. Drafts stored locally in the browser will be **lost forever** if not submitted first.
{% endhint %}

Use **Email All Users** to instruct staff:

* Stop work
* Submit all **offline drafts** before the upgrade
* Ensure their **outbox is empty**

#### Step 7 — Upgrade production and backup environments

**Critical checks before proceeding:**

* Ensure backups restore correctly on staging
* Maintain a **hard copy** of recent backups
* Expect database migrations to take **hours**
* Expect reduced system performance during migration
* Never upgrade production without validating on staging first \</aside>

**Upgrade steps**

1. Provision **Backup** server
2. Provision **Production** server
3. **Deploy** using the new release and countryconfig image
4. Monitor migrations in Kibana (`tag: migration`)
5. Do not use production until migration finishes
6. Log in and test with your QA team
7. Notify staff that operations can resume
