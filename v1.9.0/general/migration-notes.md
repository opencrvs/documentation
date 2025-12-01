# Migration notes

## 🔄 Upgrading OpenCRVS — Migration Guide

OpenCRVS supports **incremental upgrades**, but preparation is essential—especially for governments running live civil registration services. This guide helps you plan, test, and execute a safe migration.

If you require support, please contact us at:\
📧 **team@opencrvs.org**

***

## ✅ **Step 1 — Prepare for Migration**

Before upgrading, confirm the following. These are the same questions we ask when supporting an implementation, as the answers significantly affect the migration effort.

***

### 🔍 1. Version analysis

* **Which version of OpenCRVS are you currently running?**
* **Which version do you want to upgrade to?**

> ℹ️ OpenCRVS supports upgrades **one major/minor version at a time**.\
> Skipping versions increases complexity and risk.

***

### 🧩 2. Core code customisations

* Have you modified **opencrvs-core** (NodeJS, React, or API logic)?
* Have you forked opencrvs-core and maintain a custom version?

If so:

> ⚠️ You must merge or rebase your **core fork** as well as your **countryconfig** fork.\
> We strongly recommend submitting PRs to the upstream opencrvs-core instead of maintaining long-lived forks.

***

### 🔗 3. External integrations

* Have you integrated OpenCRVS with external systems (e.g., population registers, ID platforms, HIS, notification services)?

> 🔄 All integrations must be **retested** after upgrading.

***

### 📦 4. Country configuration status

* Have you fully configured your country’s forms, events, locations, roles, messages, etc.?

Conflicts may arise when merging countryconfig; some may simply be upstream bug fixes (see release notes).

***

### 👥 5. Staff readiness

* Do you have real registrar or administrative users already using the system?
* Do they need training on new business processes or UI changes in the new release?

***

### 🗄 6. Data considerations

* Are you already registering **real citizens**?
* Do you have reliable **backups** and a working **staging database restore pipeline**?

> ⚠️ **Never upgrade production without successfully restoring a backup to staging first.**

***

### 🖥 7. Server environment checks

If OpenCRVS is already deployed to servers:

#### You must confirm:

* Dedicated or shared servers?
* Separate **Dev/Staging/QA/Production** environments?
* Automated backup & restoration configured?
* Available **RAM**, **disk space**, and CPU capacity?
* Whether you are running a **cluster of 1, 3, or 5 nodes**\
  (clusters must all be re-provisioned)

***

> 🚨 **Why we ask these questions**\
> To ensure:
>
> * You have working backups
> * Your infrastructure is healthy
> * You test migration safely in QA and Staging
> * Your data is protected\
>   If any concerns arise, contact us for support.

***

## ✅ **Step 2 — Update Locally**

The complexity of this stage depends on how many customisations you have made to your countryconfig fork.

***

### 1. Update opencrvs-core

```bash
cd <path>/opencrvs-core
git fetch
git checkout release-v*.*.*   # or master if appropriate
git pull
yarn --force
```

You now have the target OpenCRVS release code locally.

***

### 2. Update your country configuration fork

```bash
cd <path>/opencrvs-<your-country>
git fetch --all
git checkout -b upgrade-countryconfig-v<target-version>
git pull upstream release-v*.*.*     # “upstream” should point to opencrvs-countryconfig
yarn --force
```

***

### 3. Resolve merge conflicts

Most upgrades require resolving configuration conflicts.\
Follow the release notes and upgrade video included with each release.

***

### 4. Run OpenCRVS locally

Start the system; migrations run automatically on your local database.

> 🧪 **Test thoroughly before continuing.**

***

### 5. Commit and push

Create a PR for peer review, then merge to your main development branch.\
A Docker image with the updated git hash will automatically build and push to DockerHub.

***

## ✅ **Step 3 — Upgrade GitHub Environments**

Back up **all secrets and environment variables** in your password manager.

Each release may introduce:

* new GitHub environment secrets,
* removed/renamed variables, or
* DevOps improvements.

Run:

```bash
yarn environment:init
```

The script will:

* Ask whether to overwrite existing secrets (do **not** overwrite for live environments)
* Prompt you to add missing secrets
* Automatically generate new values where required

***

## ✅ **Step 4 — Upgrade QA Servers**

1. Run the **Provision** GitHub action for your QA environment.
2. Run **Deploy** using:
   * new _opencrvs-core_ release version
   * the new _countryconfig_ Docker image git hash
3. **Do not reset** the environment; migrations run automatically.

Monitor migrations in Kibana:

```
tag: migration
```

> 🧪 Test thoroughly in QA before proceeding.

***

## ✅ **Step 5 — Upgrade Staging Servers**

Repeat the steps used for QA:

1. Provision
2. Deploy

Because staging contains **real citizen data** (from production backups), migrations may take hours.

{% hint style="danger" %}
A release of OpenCRVS can contain automatic database migrations. If you have been running OpenCRVS in production and you have live civil registrations for real citizens, these migrations may take several hours to complete depending on your scale. This will lead to reduced performance of OpenCRVS during this time. Therefore test your release on a "staging" environment first that has a restored backup of citizen data on it. Monitor migrations in Kibana, searching Observability > Logs using "tag: migration" to ensure there are no migration errors.
{% endhint %}

> ⚠️ Do not use staging until migrations complete.

Once complete, test again with your QA team.

***

{% hint style="danger" %}
If you have hosted **AND CONFIGURED** OpenCRVS on a server and are capturing live registrations in production, **YOU MUST ENSURE THAT OPENCRVS BACKUPS ARE WORKING AND RESTORING ON A "STAGING" ENVIRONMENT. YOU SHOULD ALSO HAVE A HARD COPY OF RECENT BACKUPS.** This is so that you can restore in the event of any migration problems. [Read the backup instructions.](../setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.7-backup-and-restore)
{% endhint %}

## ✅ **Step 6 — Schedule Production Downtime & Notify Staff**

<figure><img src="../.gitbook/assets/Screenshot 2024-12-11 at 08.44.32.png" alt=""><figcaption></figcaption></figure>

Use **Email All Users** to instruct staff:

* Stop work
* Submit all **offline drafts** before the upgrade
* Ensure their **outbox is empty**

> ⚠️ Browser caches are cleared on upgrade.\
> Drafts stored locally in the browser will be **lost forever** if not submitted first.

***

## ✅ **Step 7 — Upgrade Production & Backup Environments**

Before proceeding:

> 🚨 **Critical warnings**
>
> * Ensure backups restore correctly on staging
> * Maintain a **hard copy** of recent backups
> * Expect database migrations to take **hours**
> * Expect reduced system performance during migration
> * Never upgrade production without validating on staging first

***

#### Upgrade steps

1. Provision **Backup** server
2. Provision **Production** server
3. Deploy using the new release and countryconfig image
4. Monitor migrations in Kibana (`tag: migration`)
5. Do not use production until migration finishes
6. Log in and test with your QA team
7. Notify staff that operations can resume

