# Infrastructure

The OpenCRVS infrastructure setup includes:

- **Ansible-based server provisioning automation** that transforms bare Ubuntu servers into production-ready application and backup servers.  
- **Configuration files** for deploying services on Docker Swarm.  
- **Deployment automation pipelines** implemented with GitHub Actions.  

If you are deploying OpenCRVS for your country, it is critical to understand and adapt these processes and configurations to align with your government's IT environment.

## OpenCRVS Local Infrastructure Setup Guide

Setting up OpenCRVS servers locally allows infrastructure developers to experiment with provisioning and deployment automation in a safe environment, without needing to perform real deployments to remote servers. It enables quick iteration on Ansible playbooks, inventory configurations, and service orchestration, providing hands-on experience with how the infrastructure is composed and managed.

This guide will help you set up the OpenCRVS infrastructure locally for development and testing purposes. It covers all essential steps, from cloning the country configuration repository to provisioning servers.

## Prerequisites

Before you begin, ensure you meet the following requirements:

- At least **30 GB** of free disk space
- A Unix-based operating system (Linux or macOS)

---

## Step 1: Clone the Country Configuration Repository

Start by cloning the [OpenCRVS Country Configuration](https://github.com/opencrvs/opencrvs-countryconfig) repository to your local machine.

### Git Command:

```bash
git clone https://github.com/opencrvs/opencrvs-countryconfig.git
cd opencrvs-countryconfig
```

---

## Step 2: Install a Virtual Machine Manager

Depending on your operating system, install the appropriate virtualisation tool:

- **Linux**: [Multipass](https://multipass.run/)
- **macOS**: [OrbStack](https://orbstack.dev/) (formerly `orbfleet`)

These tools are used to provision lightweight virtual machines for running OpenCRVS services.

---

## Step 3: Install Ansible

Ensure [Ansible](https://www.ansible.com/) is installed to run the infrastructure provisioning scripts.
Follow the [official Ansible installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for your OS.

---

## Step 4: Check Available Disk Space

Make sure you have **at least 30 GB** of free storage to allow for provisioning and service deployment.

### Check Disk Space:

```bash
df -h
```

---

## Step 5: Run the Provisioning Notebook in VS Code

Open the provisioning Jupyter notebook in Visual Studio Code to automate the infrastructure setup process.

### Instructions:

1. Create and activate a virtual Python environment:

   ```bash
   python -m venv venv
   source venv/bin/activate  
   ```

2. Install `ipykernel` in your virtual environment:

   ```bash
   pip install ipykernel
   python -m ipykernel install --user --name=venv
   ```

3. Ensure the Jupyter extension is installed in VS Code.
4. Open the following notebook file:

   ```bash
   opencrvs-countryconfig/infrastructure/local-development/provision.ipynb
   ```

5. Select the `venv` kernel and run each cell sequentially to provision your local OpenCRVS environment.

If you haven’t used Jupyter in VS Code before, follow [this guide](https://code.visualstudio.com/docs/datascience/jupyter-notebooks) to get started.


---

## ✅ You're Ready!

After these steps, your local OpenCRVS environment will be up and running—ready for testing, development, or configuration exploration.