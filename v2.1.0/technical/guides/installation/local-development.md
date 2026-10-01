# Local development

You can run OpenCRVS on your computer to develop and test your country configuration. OpenCRVS runs on Kubernetes, also locally: [Tilt](https://tilt.dev/) builds your country configuration and deploys it together with OpenCRVS Core into a local Kubernetes cluster.

Follow these pages in order:

1. [Prerequisites](prerequisites.md): prepare your computer, install the required tools and start a local Kubernetes cluster.
2. [Quick Start](quick-start.md): create your country configuration and start OpenCRVS.
3. [Log in to OpenCRVS locally](log-in-to-opencrvs-locally.md): test users for each role.
4. [Working with Tilt](working-with-tilt.md): use the Tilt UI, develop your country configuration, reset data and access OpenCRVS services.

{% hint style="warning" %}
The local environment is for development only. It runs in non-secure mode with default passwords. To run OpenCRVS for real users, [deploy it to a server](deploy-set-up-a-server-hosted-environment/README.md).
{% endhint %}
