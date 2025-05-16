# Releasing

OpenCRVS follows a structured and coordinated release process to ensure stability and alignment between the core platform and country-specific configurations. Releases are versioned semantically (e.g., v1.4.0). Each release is accompanied by migration notes, upgrade instructions, and full changelogs to support system integrators and implementers.

## Create the release pull request

The first step in launching a new release is to create the release pull request—arguably the simplest part of the process. To do so, execute the GitHub Action titled `Release - Start a new release` available in the [opencrvs-core](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) repository.

To trigger this action, you are required to provide only the release version.

{% hint style="warning" %}
Ensure that the version number adheres to [semantic versioning](https://semver.org/) (e.g., `1.6.1`).
{% endhint %}

## Deployment to a Release Environment

You can deploy a draft release to a dedicated release environment, which is highly beneficial for validation and testing purposes. The process is streamlined and straightforward.

To initiate the deployment, simply run the [`Create Hetzner Server`](https://github.com/opencrvs/opencrvs-farajaland/actions/workflows/create-hetzner-server.yml) GitHub Action. This workflow automates the server provisioning process and requires only two input parameters:

- **`env_name`**: A short identifier for the environment (preferably 3–5 characters).  
  *Tip:* Use the release version as a reference, such as `v17` for version `1.7.0`.

- **`env_type`**: Specify the environment configuration.  
  Use `multi-node` for production deployments and `single-node` for all other cases.

Once triggered, the action will handle the rest of the setup automatically.

## Comprehensive guide till completion the release

TODO

## Verification steps during release

TODO
