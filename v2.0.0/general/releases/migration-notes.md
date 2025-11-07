# Migration notes

### Step 1: Prepare to migrate

{% hint style="warning" %}
If you are working on behalf of a government that is considering implementing OpenCRVS, we can help you to migrate your version of OpenCRVS.

Please contact us at [team@opencrvs.org](mailto:team@opencrvs.org?subject:WebsiteEnquiry)
{% endhint %}

Before you start migrating, consider these questions and the potential impacts of upgrading, which we would ask you if we were offering support:

1. What version number you are currently using?
2. What version number you wish to upgrade to?
3. Have you made any NodeJS or React code customisations of any kind to opencrvs-core?

We ask these questions because OpenCRVS is designed to be migrated incrementally, from the immediately proceeding version.

{% hint style="info" %}
Some countries fork and make customisations to opencrvs-core which means they need to merge or rebase changes to core (hosting their own opencrvs-core repository) as well as the country configuration server. Normally we do not advise people to make their own core customisations but instead work with our core team to open pull requests on core for any functionality you need. However some people choose to do this independently, so make sure you also merge/rebase your core repo too.
{% endhint %}

4\. Have you integrated OpenCRVS to another system using an API, or documented system client? Remember to schedule and QA any integrations after updating.

5\. Have you completely configured OpenCRVS? Conflicts in our countryconfig repo may not apply to your configuration. Some conflicts may be related to bug-fixes. Those are documented in the release notes.

6\. Have you setup real registrar users in the system? Do they need to be trained on any new business processes introduced by new features in the release?

7\. Are you already registering real citizens in testing or production? Do you have a backup and staging environment to ensure that citizen data is backed up successfully before you start?

8\. Have you deployed OpenCRVS to a server environment? If so, answer these additional questions:

* Please tell us if you have dedicated or shared servers
* Do you have independent development (staging), quality assurance and production servers to incrementally test the upgrade?
* Have you provisioned a backup server and automated staging restoration as documented?
* How much free disk space and RAM is available on each server. Do you have enough space and power for the upgrade?
* Are you running OpenCRVS on a cluster of 1, 3 or 5 servers? A cluster will all need re-provisioned.

{% hint style="info" %}
We ask these questions to make sure that you are aware that you should backup your data first and ensure that you can restore from a backup. We ask them to make sure you have healthy environments with enough RAM and disk space. You must test your migration first on a dedicated quality assurance and staging server before attempting to migrate a production server. You need to know that your configurations still work and your data is safe. If you have concerns, reach out to us for support.
{% endhint %}

### Step 2: Update locally

The most complex task really depends upon how much customisation you have made to your country configuration fork as you will be required to merge or rebase your fork with our release branch. **(You must be familiar with the concept of** [**Git merge**](https://git-scm.com/docs/git-merge) **or** [**Git rebase**](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase)**)**.

{% hint style="info" %}
Please refer to the release notes , which contains a video of an example code upgrade process, and our [release process including Gitflow](./) branching approach.
{% endhint %}

1. Navigate to your opencrvs-core directory, checkout the **master** branch and pull latest changes. Yarn install any dependency upgrades:

```
cd <path on your environment>/opencrvs-core
```

```
git fetch
```

```
git checkout release-v*.*.* <-- substitute version of choice!
```

or, alternatively checkout the master branch, unless it has moved on past the release you intend to upgrade to.

```
git pull
```

```
yarn --force
```

2\. You will now have the release opencrvs-core code locally to run alongside your updated countryconfig code. Your next step is to merge or rebase any changes you need from the country configuration repository fork.

3\. Navigate to your forked country configuration repo

```
cd <path on your environment>/opencrvs-<your country>
```

```
git fetch --all
```

4\. Create a new branch for a PR that will be a merge or rebase from our release.

```
git checkout -b upgrade-countryconfig-v<insert new version>
```

The following command pulls from a remote named "upstream" which should already point to our countryconfig repository. You set this up when [forking countryconfig](../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md)

```
git pull upstream release-v*.*.* <-- substitute version of choice!
```

```
yarn --force
```

5\. **You will likely need to fix some conflicts.**

6\. If you are running OpenCRVS locally, simply [start OpenCRVS](../../setup/3.-installation/3.1-set-up-a-development-environment/3.1.3-local-environment-maintenance.md). Migrations will automatically run on your local data and you have finished upgrading OpenCRVS locally.

{% hint style="info" %}
Test your upgrade locally before proceeding
{% endhint %}

7. Commit and push your changes to a pull request for peer review.
8. When you are satisfied, merge your PR into your main branch for development. A Docker image with a **githash** for your upgrade will be built and sent to Dockerub.

### Step 3: Upgrade your QA server **environments**

1. Run the `yarn environment:upgrade` command to initialize all necessary environment variables required for provisioning servers in QA environment. This step ensures that your environment is properly configured before running any further provisioning or deployment actions.
2. Every release likely contains dev-ops improvements and bug fixes to your servers. Run the [Provision](../../../v1.8.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.5-provisioning-servers) action on your QA server environment.
3. Run the Deploy script to your QA environment using the **new release number** for core and the **githash** for your countryconfig image, but **do not reset the environment**. There is no need. Migrations will run on your QA data, which you can monitor in Kibana, using Logstream and the **tag: migration**
4. Log in to QA when the migrations are complete and test your upgrade. Engage your QA team to do the same. When your QA team is satisfied with the upgrade you can proceed to the next step.

### Step 4: Upgrade your Staging server **environments**

1. Run the `yarn environment:upgrade` command to initialize all necessary environment variables required for provisioning servers in Staging environment. This step ensures that your environment is properly configured before running any further provisioning or deployment actions.
2. Run the Provision action on your Staging server environment. Then run the Deploy action.
3. As staging contains a mirror of all your citizen data, data migrations may take hours to complete. Once again, monitor the migrations in Kibana and **do not use the staging environment until the migrations are complete.**
4. Log in to Staging when the migrations are complete and test your upgrade. Engage your QA team to do the same. When your QA team is satisfied with the staging upgrade you can proceed to the next step.

### Step 5: Schedule downtime on Production & Backup for the upgrade

1. Use the "Email all users" feature to contact all staff and instruct them to cease operations and submit any offline drafts that they may be working on ensuring that they are synced online in the outbox by the date given when the downtime will occur. **This must be done because a user's browser cache is cleared on each upgrade requiring them to log out and log back in again.**

{% hint style="danger" %}
All un-submitted draft applications only exist locally in a users browser cache and are therefore not preserved when the application is updated. The browser cache is cleared. **Inform all staff to submit in-progress drafts before updating OpenCRVS in production.**
{% endhint %}

<figure><img src="../../../v1.7.0/.gitbook/assets/Screenshot 2024-12-11 at 08.44.32.png" alt=""><figcaption></figcaption></figure>

### Step 6: Upgrade your Production & Backup environments

Before you proceed, ensure that you have understood these warnings:

{% hint style="danger" %}
If you have hosted **AND CONFIGURED** OpenCRVS on a server and are capturing live registrations in production, **YOU MUST ENSURE THAT OPENCRVS BACKUPS ARE WORKING AND RESTORING ON A "STAGING" ENVIRONMENT. YOU SHOULD ALSO HAVE A HARD COPY OF RECENT BACKUPS.** This is so that you can restore in the event of any migration problems. [Read the backup instructions.](../../../v1.8.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.7-backup-and-restore)
{% endhint %}

{% hint style="danger" %}
A release of OpenCRVS can contain automatic database migrations. If you have been running OpenCRVS in production and you have live civil registrations for real citizens, these migrations may take several hours to complete depending on your scale. This will lead to reduced performance of OpenCRVS during this time. Therefore test your release on a "staging" environment first that has a restored backup of citizen data on it. Monitor migrations in Kibana, searching Observability > Logs using "tag: migration" to ensure there are no migration errors.
{% endhint %}

2. Run the `yarn environment:upgrade` command to initialize all necessary environment variables required for provisioning servers in Production environment. This step ensures that your environment is properly configured before running any further provisioning or deployment actions.
3. Run the Provision action on your Backup server environment.
4. Run the Provision action on your Production server environment. Then run the Deploy action.
5. Once again, monitor the migrations in Kibana and **do not use the production environment until the migrations are complete.**
6. Log in to production when the migrations are complete and test your upgrade. Engage your QA team to do the same. When your QA team is satisfied with the production upgrade you can contact all staff to recommence operations.
