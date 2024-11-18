---
description: >-
  These are the steps you need to do after receiving an IP address and root user
  before you can run the provisioning pipeline.
cover: >-
  .gitbook/assets/DALL·E 2023-12-14 11.18.59 - A whimsical scene from the 90s,
  featuring a baby computer in a crib, designed to resemble an early personal
  computer with a small, boxy shape, a monoc.png
coverY: 75.29599999999999
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# First steps with a fresh server

First, login as root, or if you only have sudoer access, do `sudo su root`.

#### Verify the Ubuntu version is >23.04

```
riku@farajaland-prod:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 23.04
Release:	23.04
Codename:	lunar
```

If not, either recreate the server or refer to:

{% content-ref url="servers/upgrading-eol-ubuntu.md" %}
[upgrading-eol-ubuntu.md](servers/upgrading-eol-ubuntu.md)
{% endcontent-ref %}

#### Verify the disk has been partitioned correctly

```
riku@farajaland-prod:~$ df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/vda1            311G  206G  105G  67% /
/dev/vda15           105M  6.1M   99M   6% /boot/efi
```

We want to ensure there partition mounted to / has enough disk space. Like we se here, we have 311G in total which would be than enough. Some service providers might provide a setup where you have two physical disks: one for the OS and one for storage.&#x20;

If you only see a smaller disk mounted to /,  check what you see in `lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL`. If you just found another another disk there, refer to Cameroon project's ansible playbook.

#### Create a user named `provision`

The next commands will create a user named **provision**,  make it a sudoer (needed for provisioning) and finally generate an SSH key **for logging in as the user.** The SSH private key will not persist on the server as it should only be stored in Github Secrets.

```
adduser --gecos "OpenCRVS Provisioning user" --disabled-password provision
usermod -aG sudo provision
echo 'provision ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers
su provision
```

#### Create SSH keys for accessing `provision`

If you are setting up a cluster, then only create the key on the manager node and copy over the authorized\_keys file to provision user on all nodes!

<pre><code><strong>mkdir -p /home/provision/.ssh
</strong>ssh-keygen -f /tmp/ssh-key -N ""
cat /tmp/ssh-key.pub >> /home/provision/.ssh/authorized_keys
chmod 600 /home/provision/.ssh/authorized_keys
echo -e "\n\nThis is the SSH_KEY you add to Github Environments:\n\n"
cat /tmp/ssh-key
rm /tmp/ssh-key*
</code></pre>

After running the commands, you see the SSH private key in the terminal window. Use this key with the "Create Github environment" script as the `SSH_KEY`. `SSH_USER` should be set to `provision`.
