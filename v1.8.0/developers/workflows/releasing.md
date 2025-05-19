# Releasing

OpenCRVS follows a structured and coordinated release process to ensure stability and alignment between the core platform and country-specific configurations. Releases are versioned semantically (e.g., v1.4.0). Each release is accompanied by migration notes, upgrade instructions, and full changelogs to support system integrators and implementers.

## Create the release pull request

The first step in launching a new release is to create the release pull request—arguably the simplest part of the process. To do so, execute the GitHub Action titled [`Release - Start a new release`](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) available in the [opencrvs-core](https://github.com/opencrvs/opencrvs-core) repository.

To trigger this action, you are required to provide only the release version.

{% hint style="warning" %}
Ensure that the version number adheres to [semantic versioning](https://semver.org/) (e.g., `1.6.1`).
{% endhint %}

Once triggered, the action performs the following steps automatically:

- **Creates a release branch** following the naming convention: `release/{version_number}` (e.g., `release/1.6.1`).
- **Opens a pull request** to begin the release process.
- **Updates `CHANGELOG.md`** heading with the specified version number.
- **Modifies all `package.json` files** across the repository to reflect the new version.
- **Creates a draft GitHub release** associated with the specified version.

## Deployment to a Release Environment

You can deploy a draft release to a dedicated release environment, which is highly beneficial for validation and testing purposes. The process is streamlined and straightforward.

To initiate the deployment, simply run the [`Create Hetzner Server`](https://github.com/opencrvs/opencrvs-farajaland/actions/workflows/create-hetzner-server.yml) GitHub Action. This workflow automates the server provisioning process and requires only two input parameters:

- **`env_name`**: A short identifier for the environment (preferably 3–5 characters).  
  *Tip:* Use the release version as a reference, such as `v17` for version `1.7.0`.

- **`env_type`**: Specify the environment configuration.  
  Use `multi-node` for production deployments and `single-node` for all other cases.

Once triggered, the action will handle the rest of the setup automatically.

## Comprehensive Guide to Completing the Release

Once the release pull request and draft release have been generated via the [`Release - Start a new release`](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) workflow, a few final tasks remain to fully complete the release process.

### 1. Verify Docker Images

- Confirm that the Docker images have been published to [Docker Hub](https://hub.docker.com/r/opencrvs/ocrvs-countryconfig/tags?name=v).
- Compare the size of the new images with those from the previous release.
- If there is a significant difference in size, report it to the maintainers for investigation.

### 2. Finalize GitHub Release

- Copy the content from `CHANGELOG.md` into the GitHub Release notes.
- Paste any changed "Copy" items into the release notes. You can generate these with [this tool](https://gist.github.com/rikukissa/9415b88016c0acfc0e0d4e00add45993).
- Once finalized, **publish** the GitHub release.

### 3. Publish NPM Release

- In the core repository, ensure that the corresponding NPM package is published to reflect the new version.

### 4. Version Control Management

- In both the `core` and `countryconfig` repositories, **merge the release branch into `master`**.  
  ⚠️ **Do not squash merge** — use a regular merge to preserve history.

### 5. Documentation Management

- Add the new release notes to the official documentation.
- Create a placeholder for the next version's documentation.
- Update OpenAPI specification URLs to point to the new release branch.
- Publish the updated documentation.
- Merge any open pull requests in the documentation repository, if appropriate.

### 6. Environment Management

- Merge the latest `countryconfig` updates into your country-specific repository.
- **For minor releases**: Deploy the new version to **production**.
- **For hotfix releases**: Deploy the new version to **staging**.

### 7. Team Communication

- Announce the newly published version to your team and stakeholders, ensuring they are informed and aligned.

---

By following this structured checklist, you ensure a smooth, transparent, and high-quality release process.

## Verification steps during release

TODO
