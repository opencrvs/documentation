# Upgrading EOL Ubuntu

## Prepare for upgrade

### Take Server Snapshot (Backup)
The upgrade process is a complicated procedure and can sometimes result in a broken server state. Having the latest backup to restore the server is critical. Before running an OS upgrade, it's important to back up the server.

Please refer to your cloud service provider or virtualization documentation for more information on how to back up a VM. Here are some examples:

- For Hetzner Cloud, use the "Take Snapshot" action.
- For AWS, Azure, VMware, etc., use their respective tools, usually called snapshots.

### Install additional software

Following additional software needs to be present on your server before upgrade:
- **`screen`** Screen or GNU Screen is a terminal multiplexer. In other words, it means that you can start a screen session and then open any number of windows (virtual terminals) inside that session. Processes running in Screen will continue to run when their window is not visible even if you get disconnected.
- **`telnet`**, **`curl`**, **`vim`**, **`nslookup`**. Please make sure at least these utils are installed, otherwise troubleshooting steps will be harder and sometimes impossible.

Example command:
```
sudo apt install -y screen vim curl dnsutils
```


### Upgrade software to latest verions

Upgrading to the latest available packages are required for successful Ubuntu distribution upgrade:

```
sudo apt update && sudo apt upgrade -y
sudo apt install -y ubuntu-release-upgrader-core update-manager-core
```

Reboot instance once all updates are applied:

```
reboot now
```

### Open additional tcp port on Firewall for ssh

Usually Ubuntu use UFW or IPTables firewalls.
Depending on system administrator choice run one of the following commands:

- For UFW:
    ```
    sudo ufw allow 1022/tcp comment 'Open port ssh TCP/1022 as failsafe for upgrades'
    sudo ufw status
    ```

- For IPTables:
    ```
    sudo /sbin/iptables -I INPUT -p tcp --dport 1022 -j ACCEPT
    ```


## Upgrade to the latest LTS release

### Verify configuration

Ensure the Prompt value in /etc/update-manager/release-upgrades is set to lts.

```
sudo sed -i 's/^Prompt=.*/Prompt=lts/' /etc/update-manager/release-upgrades
```

### Run upgrade

Depending on preffered way use one of the following methods:
- Interactive way: You will be asked about all modified files in
configuration directory:

    ```
    sudo do-release-upgrade
    ```
- Non-interactive: Keep in mind that you still need to answer questions, but only confirm configuration changes, mostly in `/etc` directory:
    ```
    sudo DEBIAN_FRONTEND=noninteractive do-release-upgrade -f DistUpgradeViewNonInteractive
    sudo reboot
    ```

# List of configuration files effected by upgrade

OpenCRVS modifies following configuration files while environment deployment:

- /etc/sudoers
- /etc/sysctl.conf
- /etc/logrotate.conf
- /etc/ssh/moduli

Other files might be effected also by system administrator while making custom configuration and security changes.

# Links
- https://ubuntu.com/server/docs/how-to-upgrade-your-release
- [https://www.cyberciti.biz/faq/how-to-upgrade-from-ubuntu-22-04-lts-to-ubuntu-24-04-lts/](https://www.cyberciti.biz/faq/how-to-upgrade-from-ubuntu-22-04-lts-to-ubuntu-24-04-lts/)
- Notice about `DistUpgradeViewNonInteractive` https://www.reddit.com/r/ubuntuserver/comments/11vmknx/doreleaseupgrade_without_prompts/
