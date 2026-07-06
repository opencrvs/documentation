# Ubuntu unattended-upgrades

### General information

OpenCRVS infrastructure uses Ubuntu unattended-upgrades to automatically install operating system updates while preventing automatic upgrades of Kubernetes components.

The following updates are installed automatically through unattended-upgrades:

* Ubuntu package updates from the operating system repositories
* Ubuntu security updates
* Ubuntu Pro ESM application security updates (if enabled)
* Ubuntu Pro ESM infrastructure security updates (if enabled)

OpenCRVS configures unattended-upgrades to automatically remove unused kernel packages and obsolete dependencies.

Automatic server reboots are disabled by default.

Kubernetes packages are explicitly excluded from unattended-upgrades:

* kubeadm
* kubelet
* kubectl
* kubernetes-cni

Kubernetes upgrades must be performed manually using the OpenCRVS GitHub provisioning workflow.

This prevents unexpected Kubernetes version changes and allows operators to upgrade cluster nodes in a controlled manner.

### Checking upgrade status

Review unattended-upgrades logs:

```bash
sudo journalctl -u unattended-upgrades
```

View recent unattended-upgrades activity:

```bash
sudo tail -f /var/log/unattended-upgrades/unattended-upgrades.log
```

Display effective unattended-upgrades configuration:

```bash
apt-config dump | grep Unattended-Upgrade
```

Perform a dry run:

```bash
sudo unattended-upgrade --dry-run --debug
```

### Upgrading Kubernetes

Kubernetes upgrades should be performed using the OpenCRVS GitHub provisioning workflow.

The workflow upgrades Kubernetes packages and applies any required cluster changes in a controlled and supported manner.

Refer to [provision](../deploy-set-up-a-server-hosted-environment/provisioning-servers/) documentation and Release Notes for more information.

Refer to the Kubernetes upgrade documentation for version-specific instructions.
