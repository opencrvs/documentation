# 4.1 Quick start: Set-up a local development environment

{% hint style="warning" %}
#### Important! Please read

The following instructions will guide you on how to set up a local, development environment of OpenCRVS, on your laptop, using our fictional country configuration: "Farajaland" for development and configuration purposes. To learn how to deploy OpenCRVS to a server host, the documentation is at [3.3 Set-up a server-hosted environment.](../3.3-set-up-a-server-hosted-environment)
{% endhint %}

{% hint style="danger" %}
While you can run these commands on a Virtual Machine, you cannot convert the running software into a deployed server. These scripts only run OpenCRVS dependencies in Docker and the rest of the node services run outside of containers. To deploy an OpenCRVS server that you can access over a network, follow the documentation here: [3.3 Set-up a server-hosted environment.](../3.3-set-up-a-server-hosted-environment)
{% endhint %}

{% hint style="warning" %}
We recommend that you setup OpenCRVS on your local laptop to work with our fictional country repo before proceeding to fork and create your own country configuration.

In order to run OpenCRVS, we expect that you have a working knowledge of Linux / Unix operating systems and can run terminal commands. You should also be familiar with Docker and NodeJS.
{% endhint %}

First, you will have to install some dependencies on your local computer.
