# v1.2.\* to v1.3.\* Migration notes

{% hint style="warning" %}
**Are you just upgrading from v1.3\* to a newer hotfix, e.g.: v1.3.1?**  If so, just use the new version in your deploy scripts.
{% endhint %}

### Step 1: Prepare to migrate

{% hint style="warning" %}
If you are working on behalf of a government that is considering implementing OpenCRVS, we can help you to migrate your version of OpenCRVS.&#x20;

Please contact us at [team@opencrvs.org](mailto:team@opencrvs.org?subject:WebsiteEnquiry)
{% endhint %}

Before you start migrating, consider these questions which we would ask you if we were offering support:

1. What version number you are currently using?
2. What version number you wish to upgrade to?

{% hint style="info" %}
It is not possible to upgrade from v1.1 to v1.3 without first upgrading to v1.2 for example.
{% endhint %}

3\. Have you made any NodeJS or React code customisations of any kind to opencrvs-core?

{% hint style="info" %}
Some people make customisations to opencrvs-core which means they need to merge or rebase changes to core as well as the country configuration server.  Normally we do not advise people to make their own core customisations but instead work with our core team to open pull requests on core for any functionality you need.  However some people choose to do this independently, so make sure you also merge/rebase your core repo too.
{% endhint %}

4\. Have you integrated OpenCRVS to another system using an API, or documented system client?

{% hint style="info" %}
As of OpenCRVS 1.3\* we have refactored the folder structure of our country configuration server considerably. We recommend that you migrate on a Quality Assurance or Staging server and test that your migrations work in a test environment first.  Reach out to us if you need help.
{% endhint %}

5\. Have you completely configured OpenCRVS?

6\. Have you setup real registrar users in the system?

7\. Are you already registering real citizens in testing or production?

8\. Have you deployed OpenCRVS to a server environment? If so, answer these additional questions:

* Please tell us if you have dedicated or shared servers
* Do you have independent development (staging), quality assurance and production servers? Tell us what you have.
* What are the specifications of your servers?
* Are you running OpenCRVS on a cluster of 1, 3 or 5 servers?
* Have you provisioned a backup server and automated emergency backups as documented?
* How much free disk space and RAM is generally available on each server?

{% hint style="info" %}
We ask these questions to make sure that you are aware that you should [backup your data first and ensure that you can restore from a backup](../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.8-automated-and-manual-backup-and-manual-restore.md). We ask them to make sure you have healthy environments with enough RAM and disk space.  You must test your migration first on a dedicated quality assurance / staging / test server before attempting to migrate a production server.  You need to know that your configurations still work and your data is safe.  If you have concerns, reach out to us for support.
{% endhint %}



### Step 2: Convert your OpenCRVS 1.2 form configuration

One of the biggest architectural changes we have made in OpenCRVS 1.3, was the difficult decision to deprecate the form configuration UI that we introduced in 1.0. &#x20;

Please refer to [form migration instructions.](v1.2-to-v1.3-form-migration.md)



### Step 3: Upgrade your code

The next task really depends upon how much customisation you have made to your country configuration fork as you will be required to merge or rebase your fork with our release branch.  **(You must be familiar with the concept of** [**Git merge**](https://git-scm.com/docs/git-merge) **or**  [**Git rebase**](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase)**)**. Please refer to the [release notes](../v1.1.0-release-notes.md) and our [release process including Gitflow](../) branching approach.

{% hint style="info" %}
Replace the \* with the latest minor hotfix release in all the following steps. &#x20;
{% endhint %}

1. Navigate to your opencrvs-core directory, checkout the **release-v1.3.0** or **master** branch and pull latest changes.  Yarn install any dependency upgrades:

```
cd <path on your environment>/opencrvs-core
```

```
git fetch
```

```
git checkout release-v1.3.0

or 

git checkout master (Always aligned to the latest release)
```

```
git pull
```

```
yarn --force
```

2\. You will now have the release code.  Your next step is to merge or rebase any changes you need from the country configuration repository fork.

3\. Navigate to your forked country configuration repo

```
cd <path on your environment>/opencrvs-<your country>
```

4\. Ensure that the branches you have set up are ready according to the new forking instructions [here](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md).  Specifically from [step 9 to 17](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md).

{% hint style="info" %}
If you have made no customisations to the Farajaland country configuration, other than updating your csv files for [administrative divisions](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions/), [offices and health facilities](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production/3.2.3.2-prepare-source-file-for-production-employees.md), [employees](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production/) and created new [backups](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.6-create-factory-reset-reference-data-backups.md), the merge or rebase process should be easy.  If you have customised any routes or developed new API integrations, you may need to be a bit more careful with merging conflicts.
{% endhint %}

5\. Fetch all our latest branches as [**step 17 will have added Farajaland as a remote**](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md):

```
git fetch --all
```

6\. Checkout your **master-\<your country code>** branch, and merge or rebase from our release. &#x20;

{% hint style="info" %}
**It is generally easier to**[ **merge than rebase (advanced)**](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)**.**
{% endhint %}

{% hint style="warning" %}
Merge/Rebase note: Prioritise your current backup zip files over our incoming Farajaland backups otherwise you will need to [regenerate your backups](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.6-create-factory-reset-reference-data-backups.md) after the process ends.  Prioritise incoming changes for any other conflicts and refactor your code if you have developed your own customisations. Refer to our [release notes ](../v1.2.0-release-notes.md)for hints and any new translation keys that you will need to fix conflicts for.
{% endhint %}

```
git checkout master-<your country alpha3 code>
```

```
git merge farajaland/release-v1.3.0

or 

git merge farajaland/master  (Always aligned to the latest release)
```

```
yarn --force
```

7\. _(Optional: if you are actively developing new features in your country configuration)_ Checkout and merge your **master-\<your country code>** branch onto any other Git branches that are appropriate to you such as **develop-\<your country code>** . **Then checkout back to your master-\<your country code> branch before proceeding!**

8\. If you are running OpenCRVS locally, simply [start OpenCRVS](../../../setup/3.-installation/3.1-set-up-a-development-environment/3.1.3-starting-and-stopping-opencrvs.md).  Migrations will automatically run on your data and you have finished upgrading OpenCRVS locally.  Proceed to the next section if you have already deployed OpenCRVS to a remote server cluster.



### Step 4: Upgrade your server **environments**

{% hint style="warning" %}
**THESE NOTES ARE FOR USERS MIGRATING FROM v1.2.\* to v1.3.\* ONLY!!!!**
{% endhint %}

Before you commence, ensure that you have understood these warning operational steps:



**Warning 1: Backup and test a restore of your v1.2\* data on a new v1.2.\* test server**

{% hint style="danger" %}
If you have hosted **AND CONFIGURED** OpenCRVS on a server and are capturing live registrations in production, **YOU MUST:** [**make an emergency backup of your data before proceeding**](../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.8-automated-and-manual-backup-and-manual-restore.md) so that you can restore in the event of any migration problems. **THIS BACKUP MUST BE DOWNLOADED, SO YOU HAVE A 2ND COPY STORED EXTERNALLY FROM YOUR SERVER BEFORE PROCEEDING.  THIS BACKUP MUST BE RESTORED SUCCESSFULLY ON A QUALITY ASSURANCE / STAGING / TEST SERVER TO ENSURE IT WORKS BEFORE CONTINUING.** &#x20;
{% endhint %}



**Warning 2: Prepare operationally for a v1.3.\* migration.  Test the following steps on a test server first. Schedule the production migration when staff can cease operations.** &#x20;

{% hint style="danger" %}
In OpenCRVS v1.3.\* we have some large data migrations to run.  If you have been running OpenCRVS in production and you have live civil registrations for real citizens, these migrations may take several hours to complete.  This will lead to reduced performance of OpenCRVS during this time. Therefore we recommend performing a data migration on an entirely new set of v1.3.\* servers that have been restored wth a v.1.2\* backup created in Warning 1.  When you have tested your migrated servers and data, you can then change your DNS settings to point to your new server with confidence.  **COMPLETE A MIGRATION ON A TEST SERVER BEFORE RUNNING ON PRODUCTION.  CEASE CIVIL REGISTRATION ACTIVITIES DURING A PRODUCTION MIGRATION. CONSIDER PERFORMING A PRODUCTION MIGRATION DURING NATIONAL HOLIDAYS TO AVOID RISK OF DATA LOSS.**
{% endhint %}

1. If you have hosted an entirely new v1.2\* OpenCRVS on a server, and you have a successful restoration from a v1.2\* backup running on this server, and you have a 2nd copy of the backup of your configuration hosted elsewhere just in case, you are ready to proceed.
2. Configure a new set of v1.3.\* servers following **ALL** the [steps 3.3.1](../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.1-provision-your-server-nodes-with-ssh-access.md) to [3.3.5](../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.5-setup-dns-a-records.md).
3. Deploy v1.3\* following the[ new deploy instructions](../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.6-deploy-automated-and-manual.md) including the new secrets&#x20;
4. Check you can login to OpenCRVS v1.3 successfully.
5. OpenCRVS v1.3 is successfully installed, so now we must empty the database and restore it with your v1.2\* data.  Follow these manual clear, restore and migrate process using these [steps](../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.8-automated-and-manual-backup-and-manual-restore.md).
6. You can then login to OpenCRVS v1.3.\* and test that all your data has migrated successfully. &#x20;
