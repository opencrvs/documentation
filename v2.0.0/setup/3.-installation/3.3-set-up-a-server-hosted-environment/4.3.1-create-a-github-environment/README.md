# 4.3.1 Create a Github environment

#### Before you begin

We have an automated script to generate [Github environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) for you along with all the application secrets that Github needs to run the continuous provisioning and deployment scripts.

Environment naming is not limited, but we recommend to use the naming convention described: Specifically: **qa, staging, production** and for training purposes a **development** (optional) server.

Github Actions use these environments to access the secret keys and configurations used when installing software on servers and deploying OpenCRVS.

Before running the script, you must prepare some secrets that the script requires. Please carefully check information on this page.

#### 1. Fork (or clone) repositories

{% hint style="info" %}
Fork Infrastructure repository required to store infrastructure configuration and GitHub environments: [https://github.com/opencrvs/infrastructure](https://github.com/opencrvs/infrastructure).  More information how to fork and configure repositories was described here, when forking the countryconfig repo: [4.2.1 Fork your own country configuration repository](../../3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md)
{% endhint %}

**Steps to fork infrastructure repository:**

1. Go to [https://github.com/opencrvs/infrastructure](https://github.com/opencrvs/infrastructure)
2. In the top right corner press "Fork" button
3. Provide "Owner" and "Repository name" values
4. Press "Create fork" button.
5. Create a [Github Personal Access Token ](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)with the required permissions in order for the script to programmatically create Github environments on your forked repository. The only required scope for the token is "repo".

{% hint style="warning" %}
**Set the token expiration time as you wish. Note that the token secret will need to be updated regularly for deployment actions to function when it expires.**
{% endhint %}

#### 2. Set up an individual and an organisation account on Dockerhub

{% hint style="info" %}
A DockerHub account is required as the registry for the countryconfig docker image.
{% endhint %}

Firstly, you will need a companion container registry account. Our scripts are hardcoded to use DockerHub, if you need to work with any other private registry, please modify provision and deploy scripts.

You will need a docker container registry [**organisation**](https://docs.docker.com/admin/organization/orgs/) account on [DockerHub](https://hub.docker.com/) to build and push your country configuration container (image) to a private repository.

An organisation is required with all of your developers (including yourself) individual accounts added to the organisation's "[members](https://docs.docker.com/admin/organization/members/)" (or teams) list, so that each developer can access the container.

Ensure that the DockerHub Team that your members belong to have permissions to write to the repository.

You will need your DockerHub **username** and a personal DockerHub account **access tokens** as secrets. Our scripts use these credentials to login to DockerHub programmatically. This is how you create a DockerHub access token: [https://docs.docker.com/security/for-developers/access-tokens/](https://docs.docker.com/security/for-developers/access-tokens/)

#### 3. Create companion service accounts for monitoring (optional, but recommended) & notifications

Our code is hardcoded to optionally track bugs in [Sentry](https://www.sentry.io)&#x20;

To take advantage, create a NodeJS project in Sentry for your chosen environment.

In the Sentry project settings, select "Client Keys", and **copy the DSN property**.  You will use this as the SENTRY\_DSN secret.

Any service error whether caught or uncaught will be visible in application logs that you can monitor in Kibana.  Any hardware alert will be broadcast via elastalert to an email account configured using the ALERT\_EMAIL property.

If you wish to collate service and hardware errors into a single location you can configure Sentry Alert Rules and email forwarding from ALERT\_EMAIL to the same location, such as a Slack Channel.

The benefits of using Slack, are that your entire development and quality assurance team can receive these notifications without a single individual becoming a bottleneck.

Notifications therefore use email by default and you should set SMTP details.  The SENDER\_EMAIL\_ADDRESS is the from address used in automated emails from the system.

SMS gateway information can be configured in secrets too, but you will be required to follow the code in order to do this yourself.

#### 4. Define hard-disk space available for optional encryption

OpenCRVS citizen data will be stored in the following location:

```
/data
```

It is optional to LUKS encrypt this location so that your data is encrypted at rest.   You will be asked if you wish to encrypt and how much server space you should apply to the encrypted disk.

This server has 280GB available after the operating system has been deployed.  You should set aside a further 50-75GB for Docker images.  So only 205GB - 230GB is available.  To use 200GB, you would enter "200g" when prompted.

```
root@yourserver:~$ df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/vda1            311G  320G  280G  67% /
/dev/vda15           105M  6.1M   99M   6% /boot/efi
```

The secret ENCRYPTION\_KEY is used on reboot to decrypt and mount this folder.   To take advantage of this feature, amend the location of the key to a secure location in `infrastructure/server_setup/group_vars/all.yml`:

```yaml
# Disk Encryption key location as an example (in production use a hardware security module)
disk_encryption_key_path: /root/disk-encryption-key.txt
```

{% hint style="success" %}
All the secrets are explained in more detail in the section [4.3.1.1 Environment secrets and variables explained.](4.3.1.1-environment-secrets-and-variables-explained.md)
{% endhint %}

#### 5. Runing the create github environment script to create a "qa" and (or) "development" environment

To run the script, open terminal window and cd into your forked infrastructure repository and run the following command:

{% hint style="info" %}
The script will create files that must be pushed to Git, so it is advisable to run the script in a new branch in order to open a pull request.
{% endhint %}

<pre><code><strong>yarn install
</strong><strong>yarn environment:init
</strong></code></pre>

The script will ask you to select the type of environment that you wish to create, then it will continue to ask you to enter all the relevant information for your Github repository.

The script will fail if it cannot connect to Github for whatever reason, then continue.

The script will ask for your Dockerhub credentials or skip if they already exist.

The script will ask you to provide Kubernetes and Runtime options:

* `DOMAIN`: Domain name to expose OpenCRVS instance
* `KUBE_API_HOST`: IP address or domain of your single, manager node
* `WORKER_NODES`: Optional parameter if you are planning to setup kubernetes cluster with multiple nodes. This property could be left empty for single node setup or you can add worker nodes later.
* `BACKUP_HOST`: Backup server, define this property if you would like to manage backup server as part of your environment. Check Backup and restore section for more information how to use configure backup server.

{% hint style="info" %}
Setting up a **staging** or **production** environment will ask for more details explained in the next step
{% endhint %}

The script will  generate strong database passwords for all the database technologies used in OpenCRVS. It will display all the secrets that the script will create and ask you if you want to continue to create the environment on Github.

The script will slowly create the Github environment and upload all the secrets OpenCRVS requires to provision and deploy OpenCRVS from Github Actions.  It will create Helm chart and values files ready for committing to your repository.

On the final step the script will proceed to create the Github environment and provide a command to bootstrap self-hosted runner on your server. Save the command from script output to a temporal file, you will need it later.

Run following command on your infrastructure repository:

```
git status
```

You should get a number of files modified:

```
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   .github/workflows/deploy-dependencies.yml
        modified:   .github/workflows/deploy-opencrvs.yml
        modified:   .github/workflows/github-to-k8s-sync-env.yml
        modified:   .github/workflows/k8s-reindex.yml
        modified:   .github/workflows/k8s-reset-data.yml
        modified:   .github/workflows/k8s-seed-data.yml
        modified:   .github/workflows/provision.yml
        modified:   .github/workflows/reset-2fa.yml
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        environments/development/
        infrastructure/server-setup/inventory/development.yml
```

Usually review is not required for files under the `.github` folder.

Review modified files:

* `infrastructure/server-setup/inventory/<environment name>.yml`: Configuration file for Ansible playbook responsible for server provision.&#x20;
* `environments/<environment name>`: Folder with `values,yaml` files for helm charts:
  * `environments/<environment name>/traefik/values.yaml`: Update this file with proper configuration to handle SSL certificate. Please follow documentation under [TLS / SSL & DNS](../4.3.3-tls-ssl-and-dns/)
  * `environments/<environment name>/opencrvs-services/values.yaml`: Review configuration and adjust according to your needs, **usually defaults are good for initial deployment**
  * `environments/<environment name>/dependencies/values.yaml`: Review configuration and adjust according to your needs, **usually defaults are good for initial deployment**.&#x20;



#### 6. Add SSH public keys for all users who require SSH access to the servers

In the `infrastructure/server-setup/inventory/<environment name>.yml` file, you must configure the users property to contain blocks for each user that requires SSH access to the server.  You will need each users public ssh key.

For more information please follow hints inside file.

Once all changes are adjusted commit and push all the configuration files to GitHub on your infrastructure repository.

{% hint style="danger" %}
The provision script will disable password SSH access for all users on the server and create new users from the `infrastructure/server-setup/inventory/<environment name>.yml` file. After provisioning, SSH will only be possible using public/private key pairs. &#x20;
{% endhint %}

{% hint style="success" %}
Users will be required to use Google Authenticator to SSH in after provisioning.  This 2FA approach is an important step to secure your infrastructure.
{% endhint %}

{% hint style="danger" %}
If any user is utilising the 1000 group, the script will fail.  Modify your available user groups to ensure this one is available.
{% endhint %}

{% hint style="danger" %}
The .env.\<your environment> file contains sensitive information about your environment configuration. Copy content of this file into secure place or password manager such as [Bitwarden](https://bitwarden.com/) or [1Password](https://1password.com/) and delete this file. **YOU MUST NEVER SHARE THIS FILE, NOR COMMIT IT TO GIT!!!** This file is not required by OpenCRVS.
{% endhint %}

You will notice that an environment now exists in your Github repo containing all the secrets required.

{% hint style="info" %}
If you made a mistake and wish to run the script for this environment again, you must delete the environment on Github by clicking the trash icon first. **The environment and all secrets will be deleted and recreated, enforcing you to start over.**
{% endhint %}

#### 7. Run the script again to create a "staging" & "production" environment

{% hint style="info" %}
You may run this step right after "development" and "qa" environment is created or later.
{% endhint %}

The script will ask you few additional questions since production and staging environments are used to store personally identifiable information (PII) for citizens.

* `GH_APPROVERS`: A comma separated list of valid GitHub accounts to approve deployments for particular environment.  Uses [this](https://github.com/trstringer/manual-approval) action.  It stops anyone accidentally performing deployment or provision actions on a server that contains PII without a second approval.  **HIGHLY RECOMMENDED!**
* `APPROVAL_REQUIRED`: Make approval required for this particular environment. If set to `true` all GitHub workflows will ask for approval, otherwise approval process will be optional even with defined `GH_APPROVERS` list. "Reset environment" workflow required 3 approvals to proceed, that additional requirement was made for security reasons. A single person is not able to take a decision for an environment reset on a server storing PII.
* `BACKUP_ENCRYPTION_PASSPHRASE` GitHub secret will be created for staging and production environments. That secret will be used to encrypt and decrypt backup zips of subfolders in the  `/data` folder, used in the configure backup and restore process, for more information please check Backup and Restore section.

