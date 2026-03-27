# Upgrading

### 1. Introduction

OpenCRVS supports incremental upgrades between versions, but preparation is essential, especially for governments running live civil registration services. This guide helps you plan, test, and execute a safe migration to a newer version of OpenCRVS.

Upgrading requires careful attention to your environment, data, integrations, and staff readiness. Following this structured approach minimises risk and ensures a smooth transition.

\<aside>

**Need support?** Contact us at [**team@opencrvs.org**](mailto:team@opencrvs.org) for migration assistance.

\</aside>

***

### 2. Migration overview

A successful OpenCRVS migration involves:

* **Preparation** — Assessing your current setup, customisations, and readiness
* **Local updates** — Updating code and resolving merge conflicts
* **Environment upgrades** — Updating GitHub secrets and variables
* **Staged deployment** — Testing in QA, then Staging, before Production
* **Production upgrade** — Scheduled downtime with staff notification

\<aside>

**Critical requirement** — OpenCRVS supports upgrades **one major/minor version at a time**. Skipping versions increases complexity and risk.

\</aside>

***

### 3. Migration process

This section provides a step-by-step guide to safely migrate OpenCRVS from one version to another. Each step must be completed in sequence, as later steps depend on the successful completion of earlier ones.

The process moves through progressively more critical environments, from local development through QA and staging, before finally upgrading production. This staged approach ensures that any issues are caught and resolved before they impact live operations.

#### 3.1 Prepare for migration

Before upgrading, confirm the following. These are the same questions we ask when supporting an implementation, as the answers significantly affect the migration effort.

**Version analysis**

* Which version of OpenCRVS are you currently running?
* Which version do you want to upgrade to?

**Core code customizations**

* Have you modified **opencrvs-core** (NodeJS, React, or API logic)?
* Have you forked opencrvs-core and maintain a custom version?

\<aside>

**Important** — If you maintain a core fork, you must merge or rebase your core fork as well as your countryconfig fork. We strongly recommend submitting PRs to the upstream opencrvs-core instead of maintaining long-lived forks.

\</aside>

**External integrations**

* Have you integrated OpenCRVS with external systems (e.g., population registers, ID platforms, HIS, notification services)?

All integrations must be retested after upgrading.

**Country configuration status**

* Have you fully configured your country's forms, events, locations, roles, messages, etc.?

Conflicts may arise when merging countryconfig. Some may simply be upstream bug fixes (see release notes).

**Staff readiness**

* Do you have real registrar or administrative users already using the system?
* Do they need training on new business processes or UI changes in the new release?

**Data considerations**

* Are you already registering real citizens?
* Do you have reliable backups and a working staging database restore pipeline?

\<aside>

**Never upgrade production without successfully restoring a backup to staging first.**

\</aside>

**Server environment checks**

If OpenCRVS is already deployed to servers, you must confirm:

* Dedicated or shared servers?
* Separate Dev, Staging, QA, and Production environments?
* Automated backup and restoration configured?
* Available RAM, disk space, and CPU capacity?
* Whether you are running a cluster of 1, 3, or 5 nodes (clusters must all be re-provisioned)

\<aside>

**Why we ask these questions** — To ensure you have working backups, your infrastructure is healthy, you test migration safely in QA and Staging, and your data is protected. If any concerns arise, contact us for support.

\</aside>

#### 3.2 Update locally

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
git checkout -b upgrade-countryconfig-v<target-version>
git pull upstream release-v*.*.*  # "upstream" should point to opencrvs-countryconfig
yarn --force
```

**Resolve merge conflicts**

Most upgrades require resolving configuration conflicts. Follow the release notes and upgrade video included with each release.

**Run OpenCRVS locally**

Start the system. Migrations run automatically on your local database.

Test thoroughly before continuing.

**Commit and push**

Create a PR for peer review, then merge to your main development branch. A Docker image with the updated git hash will automatically build and push to DockerHub.

#### 3.3 Upgrade GitHub environments

Back up all secrets and environment variables in your password manager.

Each release may introduce:

* New GitHub environment secrets
* Removed or renamed variables
* DevOps improvements

Run:

```bash
yarn environment:init
```

The script will:

* Ask whether to overwrite existing secrets (do **not** overwrite for live environments)
* Prompt you to add missing secrets
* Automatically generate new values where required

#### 3.4 Upgrade QA servers

1. Run the **Provision** GitHub action for your QA environment
2. Run **Deploy** using:
   * New opencrvs-core release version
   * The new countryconfig Docker image git hash
3. **Do not reset** the environment (migrations run automatically)

Monitor migrations in Kibana:

```
tag: migration
```

Test thoroughly in QA before proceeding.

#### 3.5 Upgrade staging servers

Repeat the steps used for QA:

1. Provision
2. Deploy

Because staging contains **real citizen data** (from production backups), migrations may take hours.

A release of OpenCRVS can contain automatic database migrations. If you have been running OpenCRVS in production and you have live civil registrations for real citizens, these migrations may take several hours to complete depending on your scale. This will lead to reduced performance of OpenCRVS during this time.

\<aside>

**Critical** — Ensure that OpenCRVS backups are working and restoring on a staging environment. You should also have a hard copy of recent backups. This is so that you can restore in the event of any migration problems. [Read the backup instructions.](../../../v1.9.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.7-backup-and-restore)

\</aside>

Monitor migrations in Kibana, searching **Observability > Logs** using `tag: migration` to ensure there are no migration errors.

Do not use staging until migrations complete. Once complete, test again with your QA team.

#### 3.6 Schedule production downtime and notify staff

Use **Email All Users** to instruct staff:

* Stop work
* Submit all **offline drafts** before the upgrade
* Ensure their **outbox is empty**

\<aside>

**Warning** — Browser caches are cleared on upgrade. Drafts stored locally in the browser will be **lost forever** if not submitted first.

\</aside>

#### 3.7 Upgrade production and backup environments

Before proceeding:

\<aside>

**Critical warnings**

* Ensure backups restore correctly on staging
* Maintain a **hard copy** of recent backups
* Expect database migrations to take **hours**
* Expect reduced system performance during migration
* Never upgrade production without validating on staging first \</aside>

**Upgrade steps**

1. Provision **Backup** server
2. Provision **Production** server
3. Deploy using the new release and countryconfig image
4. Monitor migrations in Kibana (`tag: migration`)
5. Do not use production until migration finishes
6. Log in and test with your QA team
7. Notify staff that operations can resume
