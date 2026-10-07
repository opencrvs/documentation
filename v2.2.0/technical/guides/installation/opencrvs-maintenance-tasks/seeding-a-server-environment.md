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
3. Select "Target environment" from dropdown menu, all environments created in the [Create a Github Environment](../deploy-set-up-a-server-hosted-environment/create-a-github-environment/) step, should be listed here.
4. Click "Run workflow" button

If the data seed fails, check the job logs to find out whether anything was written, see [Seed-data validation and failures](seeding-a-server-environment.md#seed-data-validation-and-failures). If the database holds incomplete seed-data, the environment must be reset before it can be seeded again. Resetting an environment is explained [here](resetting-a-server-environment.md).  **Resetting clears all data on the server.  Only a backup can restore a previous configuration.  Use with caution and see warning below.**

{% hint style="warning" %}
**After going live, a production server environment cannot be re-seeded.  To manage locations or users after going live, use the APIs or the Team management UI**
{% endhint %}

### Seed-data validation and failures

The data seed job validates all seed-data provided by your country configuration before it writes anything to the database, and reports every problem it finds in one pass.

The following is checked up front:

* Duplicate email addresses, mobile numbers and usernames between initial users
* Every mobile number matches the phone number pattern configured in the country configuration
* Every user's primary office exists in the location seed-data
* Every location's parent exists, and locations link to valid administrative areas
* User and role definitions are valid, every user's role exists, and role ids are unique
* At least one initial user has the `config.update-all` scope
* Usernames follow the same rules as users created in OpenCRVS, and usernames, passwords and names are not empty
* A location version's `effectiveFrom` is a plain date (`YYYY-MM-DD`)
* Locations, location versions and initial users contain no unrecognised keys (for example a misspelled `versions`)

The data seed job runs once and is not restarted on failure. Read its logs with:

```
kubectl logs job/data-seed -n opencrvs-<environment>
```

or in Kibana **Observability > Discover** by filtering `container.name : "data-seed"`.

**Validation failure — nothing was written.** Each problem identifies the initial user by its position in the seed-data and its username. The log ends with `nothing was seeded`:

```
4 problems found; nothing was seeded.
  initial user 44 (k.mweene): email "k.mweene@x.com" duplicates initial user 12 — emails must be unique
```

Fix the seed-data in your country configuration, deploy it, and run the ["Seed data" workflow](seeding-a-server-environment.md#run-seed-data-workflow) again. No reset is needed.

**Write failure — incomplete seed-data.** If writing still fails after validation (for example a constraint violation or a network fault), the log names the failing initial user and states that the database holds incomplete seed-data:

```
Seeding failed while creating initial users.

  initial user 44 (k.mweene): DUPLICATE_EMAIL — email "k.mweene@example.org" is already in use

The database now holds incomplete seed-data. Clear the database before you seed again.
```

In this case [reset the environment](resetting-a-server-environment.md) before running the "Seed data" workflow again.
