# Releasing

OpenCRVS follows a structured and coordinated release process to ensure stability and alignment between the core platform and country-specific configurations. Releases are versioned semantically (e.g., v1.4.0). Each release is accompanied by migration notes, upgrade instructions, and full changelogs to support system integrators and implementers.

## Create the release pull request


The first step in launching a new release is to create the release pull request—arguably the simplest part of the process. To do so, execute the GitHub Action titled `Release - Start a new release` available in the [opencrvs-core](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) repository.

To trigger this action, you are required to provide only the release version.

{% hint style="warning" %}
Ensure that the version number adheres to [semantic versioning](https://semver.org/) (e.g., `1.6.1`).
{% endhint %}
