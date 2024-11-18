# 4.3.4 Provision environments

[Ansible](https://docs.ansible.com/) is run by the "Provision environment" Github Action to install on your server all the software dependencies, configure scheduled tasks such as automated backup, install and configure a firewall.  The pipeline will also secure your server by only allowing your defined system administrator users SSH access to the servers using two factor authentication. &#x20;



### Configure the Ansible inventory files for your environments

The first step is to configure the [YAML inventory file](https://docs.ansible.com/ansible/latest/inventory\_guide/intro\_inventory.html) that Ansible will use for your environment.

Look in the **infrastructure/server-setup** directory and you will see the following files:&#x20;

&#x20;**development.yml**

**qa.yml**

**staging.yml**

**production.yml**

**backup.yml**

### Starting with the **development.yml** file ... &#x20;

In the users block you can add SSH public keys for server super admins.  These are individuals in your organisation who will be able to SSH into the environment for debugging purposes.  Ansible will create these users and set up 2FA authentication for them when they connect.

You must also replace the server hostname and the IP address for the development server.

```
all:
  vars:
    users:
      # If you need to remove access from someone, do not remove them from this list, but instead set their state: absent
      - name: <REPLACE WITH THE SSH USERNAME>
        ssh_keys:
          - <REPLACE WITH SSH PUBLIC KEY FOR THE USER>
        state: present
        sudoer: true

docker-manager-first:
  hosts:
    <REPLACE WITH THE SERVER HOSTNAME>:
      ansible_host: '<IP ADDRESS FOR THE SERVER>'
      data_label: data1

# QA and staging servers are not configured to use workers.
docker-workers: {}
```

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 13.05.00.png" alt=""><figcaption></figcaption></figure>

### Next, observe the **qa.yml** file ...

Once again,  add SSH public keys for super admins and amend the hostname and IP address as above.

There are some optional blocks here depending on what you need to do.

In our example setup, we are repurposing our QA server as the VPN & "jump" server. &#x20;

You will see the option to add a "jump" user that doesnt require 2FA to connect, as this user will be used by the Github action to then SSH into downstream servers using their "provision" user.  So you must paste in the public keys for each relevant server. &#x20;

If you are using your own VPN and you have your own jump server in your network, you can delete this block.

```
- name: jump
    state: present
    sudoer: false
    two_factor: false
    ssh_keys:
        - <Here you must paste the public keys for the provision user for other servers>
```

You will also notice this block.  This is used by some countries who wish to repurpose the QA server as a backup server in order to reduce costs.  If you have a separate backup server, you can delete this block. &#x20;

```yaml
additional_keys_for_provisioning_user
```



### Next, observe the **staging.yml** file ...&#x20;

Add SSH public keys for super admins and amend the hostname and IP address as above.



A staging server is used as a pre-production environment that is a mirror of production.  Production backs up every night to the backup server, and the staging server restores the previous days backup onto it. &#x20;

In this way we know that:

1. Production data is safely backed up and restorable
2. We have an environment we can deploy to for final Quality Assurance to ensure that no upgrade negatively affects production data.  Indeed we can use staging to test that database migrations run successfully on real data before deploying to production.

Note these variables:

**"only\_allow\_access\_from\_addresses"** secures your server from SSH access only from a whitelist of servers such as Github's [meta](https://api.github.com/meta) servers (IPs used by Github Actions), a static IP address for your super server admins, or a "jump" server IP.

**"enable\_backups"** is set to false on staging.  Staging will not backup data.

**"periodic\_restore\_from\_backup"** is set to true on staging.  Staging will only restore backup data from production.

```
only_allow_access_from_addresses:
    - <REPLACE WITH WHITELIST OF IPS / JUMP SERVER IP etc>
enable_backups: false
periodic_restore_from_backup: true
```

Note the following variable:

**"ansible\_ssh\_common\_args"** contains the same command as SSH\_ARGS used in [step 3.3.2](../4.3.3-create-a-github-environment/). &#x20;

It is required to be manually set here again because unfortunately Github doesnt allow us to configure Ansible core to allow variables to be passed to inventory files.  You can remove these args if you are not using a "jump" server.

```
ansible_ssh_common_args: '-J jump@<REPLACE WITH YOUR JUMP SERVER IP> -o StrictHostKeyChecking=no'
```

Note the backups block which is set on the staging server so that the staging server has access to the backup environment to retrieve daily backups.

```
backups:
  hosts:
    <REPLACE WITH THE BACKUP SERVER HOSTNAME>:
      ansible_host: '<IP ADDRESS FOR THE BACKUP SERVER>'
```



### Next, observe the production.yml file ...

The variables are similar to the staging environment.  Notice that the **"enable\_backups"** variable is set to true as this environment will backup every day.

```
enable_backups: true
```

Production servers can be deployed across a cluster of 2, 3 or 5 servers.  If you are deploying to a cluster then you must add a docker worker for each additional server in your cluster:

```
docker-workers:
  hosts:
    <REPLACE WITH THE WORKER SERVER HOSTNAME>:
      ansible_host: 'REPLACE WITH THE WORKER SERVER IP'
      data_label: data2 (Note: this must be unique for every worker)
      ansible_ssh_common_args: ''
```

{% embed url="https://youtu.be/LhMWxbNjAm0" %}

### Commit the inventories and run the provision action for each environment

Amend the inventory files as appropriate and commit the files to Git.

{% hint style="warning" %}
If you are going to use the QA server as a jump server, then you should provision the QA server first.
{% endhint %}

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 15.36.15.png" alt=""><figcaption></figcaption></figure>

{% embed url="https://youtu.be/8x4cssPvPB0" %}

### Set-up 2FA SSH access for all your super admins

Now that your servers are provisioned and A records exist for them, you can SSH in using either the IP address or the domain, plus your super admin username. &#x20;

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 15.51.38.png" alt=""><figcaption></figcaption></figure>

SSH'ing into a **production** or **staging** server that has been configured with a "jump" server, will require you to pass the arguments appropriate to your setup.

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 16.04.22.png" alt=""><figcaption></figcaption></figure>

You will be asked to set up 2FA with Google Authenticator.  You must have the Google Authenticator app on your mobile phone.

Scan the QR code then enter the 6-digit 2FA code to access the server.

For all the questions that are asked, accept defaults by typing "y"

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 15.52.40.png" alt=""><figcaption><p>QR Code for Google Authenticator</p></figcaption></figure>

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 15.52.57.png" alt=""><figcaption><p>Accept defaults</p></figcaption></figure>

You will also notice that root SSH access is now disabled as a security posture.

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-02-13 at 15.57.53.png" alt=""><figcaption></figcaption></figure>

Now that all your servers are provisioned, you are ready to deploy OpenCRVS provided your country confguration Docker container image has pushed to Docker successfully.
