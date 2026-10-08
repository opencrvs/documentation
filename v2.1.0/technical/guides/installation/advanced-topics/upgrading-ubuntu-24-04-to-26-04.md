# Upgrading Ubuntu 24.04 to 26.04

This guide upgrades the operating system of Kubernetes master and worker nodes in place with Ubuntu's `do-release-upgrade` tool. It follows the official [Ubuntu Server upgrade guide](https://ubuntu.com/server/docs/how-to/software/upgrade-your-release/) and adds the steps specific to OpenCRVS nodes. Read the [Ubuntu 26.04 LTS release notes](https://documentation.ubuntu.com/release-notes/26.04/) before you start.

{% hint style="danger" %}
**You must follow the upgrade order.** Upgrade each environment completely and verify it ([After all nodes are upgraded](#after-all-nodes-are-upgraded)) before you start the next one. Never upgrade production first.

1. development
2. qa
3. staging
4. production

Skip environments you do not have, but keep the order. Each environment is a test run for the next one. Staging is the closest test for production, because it mirrors production and holds a daily restore of its data.
{% endhint %}

{% hint style="warning" %}
By default the master node stores all OpenCRVS data, so OpenCRVS is unavailable while it is upgraded and rebooted. The same applies to any worker that holds data. Plan a maintenance window.
{% endhint %}

### Before you start

* **OpenCRVS v2.1 or later is required.** Ubuntu 26.04 support was added in v2.1. [Upgrade OpenCRVS](../../version-upgrades.md) and run the **Provision environment** action first, while the nodes are still on 24.04.
* Take a snapshot of every node with your cloud provider, and create a [manual backup](../opencrvs-maintenance-tasks/backup-and-restore/manual-backup-creation.md). If a node fails, restore its snapshot.
* Make sure you can reach the nodes through the provider's web console in case SSH does not come back.
* Make sure no GitHub Actions workflow (deployment, provisioning) is running for the environment. The in-cluster runner that executes them is stopped when its node is drained.
* Upgrade **one node at a time, workers first and the master last**.
* If you use a backup server, upgrade it separately and never while the master reboots. With [disk encryption](disk-encryption.md), the master fetches its encryption key from the backup server on boot. The backup server has no Kubernetes steps.

### 1. Drain the node

Drain every node, including the master. Run from the master node or from your workstation ([Kubernetes cluster access](kubernetes-cluster-access.md)). See [Safely drain a node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/).

```bash
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
```

The drain stops application pods gracefully, so databases shut down cleanly before the upgrade restarts containerd and reboots the node. Stateless pods move to other nodes. Data stores (PostgreSQL, MongoDB, Elasticsearch, InfluxDB) are pinned to the node that holds their data, by default the master, so they stay `Pending` until you uncordon the node. This is the expected downtime. Control plane pods (API server, etcd) are not evicted, so `kubectl` keeps working on the master.

The drain may print `Cannot evict pod as it would violate the pod's disruption budget` and retry every 5 seconds. This is normal and usually clears within a minute, once the replacement pod is ready on another node.

If the same pod stays blocked for a few minutes, its replacement has nowhere to start. This is typical on the master of a single-node cluster, for `calico-system/calico-apiserver-*`. That pod is stateless and serves only the Calico API. Pod networking keeps working, because `calico-node` runs as a DaemonSet. Delete just that pod to bypass its PodDisruptionBudget, and the drain continues:

```bash
kubectl delete pod -n calico-system <pod-name>
```

For any other blocked pod, find out why its replacement does not start (`kubectl get pdb -A`, `kubectl get pods -A -o wide`) before bypassing the budget.

The in-cluster GitHub runner pod (`actions-runner-system/opencrvs-infra-runner-*`) can take a minute or more to stop. The [Actions Runner Controller](https://github.com/actions/actions-runner-controller) first has to unregister the runner from GitHub, and it waits while a workflow job is running. If the pod stays `Terminating` for more than a few minutes, check that no job is running and look at the controller:

```bash
kubectl get pods -n actions-runner-system -o wide   # is the actions-runner-controller pod Running?
kubectl logs -n actions-runner-system <controller-pod> --all-containers --tail=30
```

If no job is running and the controller cannot finish (it is not running, or cannot reach GitHub), remove the pod's finalizer. The `RunnerDeployment` then creates a new runner pod:

```bash
kubectl patch pod -n actions-runner-system <runner-pod> --type=merge -p '{"metadata":{"finalizers":null}}'
```

### 2. Prepare the node

SSH to the node as an admin user and open a root shell. Run the node commands in steps 2-4 in it, so a `sudo` problem after the upgrade cannot lock you out.

```bash
sudo -i
```

Bring the node fully up to date, as [required by Ubuntu](https://ubuntu.com/server/docs/how-to/software/upgrade-your-release/):

```bash
apt update
apt dist-upgrade -o APT::Get::Always-Include-Phased-Updates=true   # also installs updates Ubuntu is still rolling out gradually
apt install -y screen ubuntu-release-upgrader-core update-manager-core
apt autoremove -y
apt-mark showhold          # should be empty, held packages can block the upgrade
df -h / /boot              # the upgrade downloads several GB
ls /run/reboot-required    # if the file exists, run "reboot", then reconnect and open the root shell again
```

`do-release-upgrade` starts a fallback SSH daemon on port 1022. The OpenCRVS [firewall](ubuntu-firewall-configuration.md) blocks it by default, so open it temporarily:

```bash
ufw allow 1022/tcp comment 'do-release-upgrade failsafe'
```

Check that Ubuntu offers the new release:

```bash
do-release-upgrade -c      # expect: New release '26.04.x LTS' available
```

Ubuntu offers LTS-to-LTS upgrades only after the first point release (26.04.1). If no release is offered, check that `Prompt=lts` is set in `/etc/update-manager/release-upgrades`. Do not use the `-d` flag on production nodes, it selects the development release.

### 3. Run the upgrade

```bash
screen -S upgrade          # reconnect after a dropped connection with: screen -r upgrade
do-release-upgrade
```

Answer the prompts as follows:

| Prompt | Answer |
| ------ | ------ |
| Continue running under SSH, start an additional sshd on port 1022, start the upgrade | Yes |
| A modified configuration file has a new package version, for example `/etc/ssh/sshd_config`, `/etc/pam.d/sshd` (2FA), `/etc/ssh/moduli`, `/etc/apt/apt.conf.d/50unattended-upgrades`, `/etc/default/grub` | **Keep the currently installed version** (the default). The list is not exhaustive: for any other file, press `D` to review the differences first |
| Restart services during package upgrades | Yes, the node is drained |
| Remove obsolete packages | Yes |
| Restart now | **No**, run the checks below first |

{% hint style="info" %}
The upgrader disables third-party apt repositories, including the Kubernetes (`pkgs.k8s.io`) and Docker repositories. Kubernetes and containerd keep running at their current versions. The repositories are restored in [After all nodes are upgraded](#after-all-nodes-are-upgraded).
{% endhint %}

### 4. Check before rebooting

```bash
sshd -t                    # no output means the SSH configuration is valid
visudo -c                  # must pass, otherwise see "Known issue: sudo-rs" below
```

If both pass, reboot:

```bash
reboot
```

### 5. Verify and return the node to the cluster

SSH back in, open the root shell (`sudo -i`) and run:

```bash
lsb_release -d             # Ubuntu 26.04.x LTS
findmnt /data              # master only, when disk encryption is enabled
systemctl is-active containerd kubelet
ufw delete allow 1022/tcp  # close the temporary firewall port
ufw status                 # must still be active
```

Then run `kubectl` from the master or your workstation. On the master, log in as your normal user, not root: `kubectl` is configured for user accounts, so leave the root shell first.

```bash
kubectl get nodes -o wide  # node is Ready, OS-IMAGE shows Ubuntu 26.04
kubectl uncordon <node-name>
kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded   # wait for "No resources found"
```

Repeat steps 1-5 for the next node.

### After all nodes are upgraded

1. Run the **Provision environment** GitHub action with the `all` tag ([Provisioning servers](../deploy-set-up-a-server-hosted-environment/provisioning-servers/README.md)). It re-adds the Kubernetes and Docker apt repositories for Ubuntu 26.04.
2. Check that the self-hosted runner is online under **Settings → Actions → Runners**.
3. Run the [validation checks](../deploy-set-up-a-server-hosted-environment/deploy/running-validation-checks.md).

### Known issue: sudo-rs

Ubuntu 26.04 replaces `sudo` with [sudo-rs](https://discourse.ubuntu.com/t/sudo-rs-is-now-default-for-questing-quokka/66497) by default. sudo-rs rejects wildcards in command arguments. OpenCRVS uses them for users with the `operator` role ([SSH access](ssh-access.md)). If you have such users, `visudo -c` fails and `sudo` stops working for **all** users with `wildcards are not allowed in command arguments`.

Until the sudoers rules are updated, switch back to the original sudo from your root shell, then run `visudo -c` again:

```bash
update-alternatives --set sudo /usr/bin/sudo.ws
```
