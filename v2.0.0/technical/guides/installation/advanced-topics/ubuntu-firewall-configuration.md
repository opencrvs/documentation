# Ubuntu Firewall configuration

### Overview

The firewall follows a default-deny approach:

* All inbound traffic is denied by default.
* Only ports required for cluster operation are opened.
* Firewall rules are managed automatically by Ansible.
* Existing OpenCRVS-managed rules are removed and recreated during each deployment to ensure configuration consistency.

### Unrestricted access

* `SSH`: All nodes allow inbound SSH connections on TCP port 22.
* `HTTP/HTTPS`: Control plane node (master) allows inbound traffic on 80 and 443 ports. These ports are used by Traefik to expose OpenCRVS services.

### Kubernetes API

Control plane node allows access to the Kubernetes API server on TCP port 6443 from:

* All Kubernetes cluster nodes
* Additional CIDR ranges specified through the `kubernetes_api_allowed_cidrs` configuration option

This allows cluster components to communicate with the API server while enabling operators to restrict administrative access to trusted networks.

### Internal Cluster Communication

OpenCRVS automatically discovers all Kubernetes node IP addresses and creates firewall rules allowing communication between cluster members only.

The master node's IP address comes from `KUBE_API_HOST`, and the worker addresses come from `KUBE_WORKER_NODES`. These must be the addresses the nodes use to reach each other. If the master node has both a public and a private network interface, set `KUBE_API_HOST` to the private IP address. Otherwise the firewall blocks traffic from the master to the worker nodes, and commands such as `kubectl logs` fail with `dial tcp <worker IP>:10250: i/o timeout`.

The following ports are opened between cluster nodes:

| Port  | Protocol | Purpose                         |
| ----- | -------- | ------------------------------- |
| 6443  | TCP      | Kubernetes API Server           |
| 10250 | TCP      | Kubelet API                     |
| 10251 | TCP      | kube-scheduler                  |
| 10252 | TCP      | kube-controller-manager         |
| 179   | TCP/UDP  | Calico BGP                      |
| 4789  | UDP      | Calico VXLAN overlay networking |
| 7946  | TCP/UDP  | Cluster networking components   |
| 8472  | UDP      | VXLAN overlay networking        |

{% hint style="info" %}
`etcd` communication ports (2379 and 2380) are not exposed publicly and are intended only for control plane communication within the cluster.

To support Calico networking, inbound traffic is allowed on the following interfaces:

* `cali+`
* `vxlan.calico`
{% endhint %}

### Configuration options

| GitHub variable/secret    | Ansible variable          | Description                                                                                                         |
| ------------------------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| KUBE\_API\_HOST           | kube\_api\_host           | Kubernetes master node IP address. On a master node with several network interfaces, use the IP address from shared with the worker nodes subnet. |
| KUBE\_API\_ALLOWED\_CIDRS | kube\_api\_allowed\_cidrs | Subnets approved to access Kubernetes API server (master). Comma-separated list (e/g: `10.0.0.0/16,192.168.0.0/24`) |
| KUBE\_WORKER\_NODES       | n/a                       | Kubernetes worker nodes. Comma-separated list (e/g: `10.0.0.2,10.0.0.3,10.0.0.4`)                                   |

