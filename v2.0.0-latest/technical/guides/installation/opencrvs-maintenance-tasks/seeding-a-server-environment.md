# Seeding a server environment

### Introduction

Seeding, is the process of installing reference data created in configuration onto servers before they are ready to go-live.  Seeding is a one-time only operation and can only be reverted by re-setting.  After going live, configuration reference data is only manageable via APIs. &#x20;

### Before you begin

OpenCRVS helm chart seeds data at installation time and can be performed only on empty database.

### Data seed flows

There are few scenarios when you need to seed data again:

* **Changes to Country config codebase:** In that scenario please complete following steps:
  * [Run OpenCRVS deployment](../deploy-set-up-a-server-hosted-environment/deploy/running-a-opencrvs-deployment.md): Codebase will be deployed on target environment
  * [Reset a server environment](resetting-a-server-environment.md): Cleanup database for update with new schema and data
  * [Run "Seed data" workflow](seeding-a-server-environment.md#run-seed-data-workflow): Populate new schema and data
* **Reset environment to initial state:**
  * [Reset a server environment](resetting-a-server-environment.md)
  * [Run "Seed data" workflow](seeding-a-server-environment.md#run-seed-data-workflow)
* **Seed was not executed at installation time due to any kind of errors:** In this case run data seed manually, see [Run "Seed data" workflow](seeding-a-server-environment.md#run-seed-data-workflow)

### Run "Seed data" workflow

If for some reason data seed was not executed at OpenCRVS installation time, please use instructions from this page to seed your database.

1. Navigate to GitHub Actions within `infrastructure` repository
2. Select "Seed data" action
3. Select "Target environment" from dropdown menu, all environments created at the [Create a Github Environment](../deploy-set-up-a-server-hosted-environment/create-a-github-environment/) step should be listed here.
4. Click "Run workflow" button

If an error occurs, the environment must be reset before it can be seeded again. Resetting an environment is explained [here](resetting-a-server-environment.md).  **Resetting clears all data on the server.  Only a backup can restore a previous configuration.  Use with caution and see warning below.**

{% hint style="warning" %}
**After going live, a production server environment cannot be re-seeded.  To manage locations or users after going live, use the APIs or the Team management UI**
{% endhint %}
