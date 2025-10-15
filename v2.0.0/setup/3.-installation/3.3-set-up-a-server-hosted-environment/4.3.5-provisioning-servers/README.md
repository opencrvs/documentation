# 4.3.5 Provisioning servers

Now that your Github environments are set up you can proceed to provision your servers using our automated ["Ansible"](https://www.ansible.com/) powered actions.

The Provision environment action will automate a number of tasks on your servers. The individual tasks that Ansible runs are explained in this [list](4.3.5.3-ansible-tasks-when-provisioning.md). It is very helpful for you to understand what Ansible is doing on your servers so please refer to the list.

{% hint style="danger" %}
**IMPORTANT SERVER ACCESS NOTE**: As a security step, the Ansible script will disable root SSH access to your server and all password access for SSH users. [SSH key](https://www.ssh.com/academy/ssh-keys) authentication is enforced using the public keys for the users in your inventory files. Additionally. SSH users will be required to install [**Google Authenticator**](https://en.wikipedia.org/wiki/Google_Authenticator) and use a 2FA code to access. SSH access procedures to a server after Provisioning completes is explained [here](4.3.5.1-ssh-access.md).
{% endhint %}

### Provision the QA server

Click on the "Actions" tab in Github and select the "Provision environment" action. Click the "Run workflow" button.

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-11-11 at 16.48.25.png" alt=""><figcaption></figcaption></figure>

* In the "Machine to provision" select, choose "**QA**".
* In the "Select group tag you want to execute" select, choose "**all**".
* Click the green "Run workflow" button to commence the provisioning of this server.

The process can take anything up to around **20-30** minutes to complete.

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-11-13 at 08.13.37.png" alt=""><figcaption><p>Github Action logs can help you debug any issues. In this example a package installation was interrupted - perhaps due to a random Network error. ChatGPT can help you understand any errors you may encounter and potential steps to resolve them. Error messages often explain to you the solution required.</p></figcaption></figure>

If you see a red cross, it means that a certain step failed and requires to be debugged. There might be a problem with your Ansible inventory files, your Github environment secrets, or there may be network connectivity issues between Github, your VPN and your servers that require your attention.

{% hint style="info" %}
Ansible will perform a huge amount of Ubuntu commands that you would normally be required to run manually one-by-one. It saves you a large amount of time as you can see by the [list](4.3.5.3-ansible-tasks-when-provisioning.md). However computers are sensitive to all sorts of conditions in your data center and errors can occur. You need experience with Ubuntu and confidence with servers to debug issues. In the above example, the solution was as simple as SSH-ing into the server and running the command as instructed in the error message, then re-running the Provision action again.
{% endhint %}

<figure><img src="../../../../.gitbook/assets/Screenshot 2024-11-13 at 08.38.28.png" alt=""><figcaption><p>Success!</p></figcaption></figure>

If the server provisioning works, you will eventually see a green tick to mark that the server provisioned successfully.

### Provision the backup server

Repeat the process for the Backup server, but this time in the "Machine to provision" select, choose "**Backup**".

### Provision the staging server

Repeat the process for the Staging server, but this time in the "Machine to provision" select, choose "**Staging**".

### Finally, provision the production server

Repeat the process for the Production server, but this time in the "Machine to provision" select, choose "**Production**".

### Ansible tasks explained

In the "Select group tag you want to execute" select, when you choose "**all**", you are instructing Ansible to run every one of the infrastructure task commands listed in the [**infrastructure/server-setup/tasks**](https://github.com/opencrvs/opencrvs-countryconfig/tree/develop/infrastructure/server-setup/tasks) directory and explained in this [list](4.3.5.3-ansible-tasks-when-provisioning.md).

It is possible for you to choose to run any one of these tasks individually at any time, such as an example given when refreshing [static TLS certificates](../3.3.5-setup-dns-a-records/4.3.2.3-static-tls-certificates.md).
