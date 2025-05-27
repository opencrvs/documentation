# Releasing

OpenCRVS follows a structured and coordinated release process to ensure stability and alignment between the core platform and country-specific configurations. Releases are versioned semantically (e.g., v1.4.0). Each release is accompanied by migration notes, upgrade instructions, and full changelogs to support system integrators and implementers.

## Initializing a Release

### Create the release pull request

The first step in launching a new release is to create the release pull request. To do so, execute the GitHub Action titled [`Release - Start a new release`](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) available in the [opencrvs-core](https://github.com/opencrvs/opencrvs-core) repository.

To trigger this action, you are required to provide only the release version.

{% hint style="warning" %}
**⚠️ Caution** 
- Ensure that the version number adheres to [semantic versioning](https://semver.org/) (e.g., `1.6.1`).
- For a hotfix release, ensure that the branch corresponding to the previous release exists in both the `core` and `countryconfig` repositories.
{% endhint %}

Once triggered, the action performs the following steps automatically:

- **Creates a release branch** following the naming convention: `release/{version_number}` (e.g., `release/1.6.1`).
- **Opens a pull request** to begin the release process.
- **Updates `CHANGELOG.md`** heading with the specified version number.
- **Modifies all `package.json` files** across the repository to reflect the new version.

### Deployment to a Release Environment

You can deploy a draft release to a dedicated release environment by running the [`Release - Provision Environment`](https://github.com/opencrvs/opencrvs-farajaland/blob/develop/.github/workflows/provision-release-environment.yml) workflow.
This workflow requires two input parameters:
- **`Environment`**: A short identifier for the environment.  
  *Tip:* If you are creating a release for version `v1.9.0`, enter `v19` as the input. This will result in a deployment like `v19.opencrvs.dev`.  
  If you are releasing a patch version such as `v1.9.1`, you should still use `v19`.  
  New environments are created only for minor releases.
- **`Core image tag`**: The Docker image tag for, core that you want to deploy.

{% hint style="warning" %}
⚠️ **Caution**  
Make sure to run the workflow from the release branch.
{% endhint %}

Once triggered, this workflow will:
- Create a server for the release environment
- Provision the environment
- Deploy the release environment

This provides a fully functional environment for validating and reviewing the release.

## Publishing the Release

Once the release pull request has been generated via the [`Release - Start a new release`](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) workflow, a significant number of final tasks still remain to fully complete the release process.
During this phase, it's common for issues to be discovered or additional pull requests to be merged into the release branch. Proceed carefully and ensure all necessary changes are included.

{% hint style="warning" %}
**⚠️ Caution**  
Before proceeding to the next steps, make sure **there are no open pull requests** that need to be included in the release—this applies to both the `countryconfig` and `core` repositories.
{% endhint %}

### 1. Publish Docker Images to Container Registry

You can publish all Docker images to our container registry by running the [`Publish Release`](https://github.com/opencrvs/opencrvs-core/blob/develop/.github/workflows/publish-release.yml) workflow in the `opencrvs-core` repository. For `opencrvs-countryconfig` you can publish all Docker images through [`Publish image to Dockerhub`](https://github.com/opencrvs/opencrvs-countryconfig/actions/workflows/publish-to-dockerhub.yml) workflow. 

> 💡 This step ensures that all release-related images are built and made available in the appropriate container registry.


### 2. Tag the Release

Create a Git tag from the `HEAD` of the release branch. For example, to tag version `1.7.0`, run:

```bash
git tag v1.7.0
git push origin tag v1.7.0
```
{% hint style="warning" %}
**⚠️ Caution** 
Before creating a new Git tag, confirm that a tag with the same version number does not already exist in either the `countryconfig` or `core` repositories.
{% endhint %}

### 3. Verify Docker Images

- ✅ Verify that the Docker images have been published to the appropriate registry:
  - **CountryConfig** and **Core** (pre `v1.7.0`): [Docker Hub](https://hub.docker.com/r/opencrvs/ocrvs-countryconfig/tags?name=v)
  - **Core** (`v1.7.0` and later): [GitHub Container Registry (GHCR)](https://github.com/orgs/opencrvs/packages?repo_name=opencrvs-core)
- Compare the size of the new images with those from the previous release.
- If there is a significant difference in size, report it to the maintainers for investigation.

{% hint style="warning" %}
**⚠️ Caution** 
Check Docker Hub (or the GitHub Container Registry for versions post `1.7.0` in core) to confirm that Docker images have been built and published using the correct release version name.
{% endhint %}

### 4. Finalize GitHub Release

- Copy the content from `CHANGELOG.md` into the GitHub Release notes.
- Paste any changed "Copy" items into the release notes. You can generate these with [this tool](https://gist.github.com/rikukissa/9415b88016c0acfc0e0d4e00add45993).
- Once finalized, **publish** the GitHub release.

### 5. Publish NPM Release

- In the core repository, ensure that the corresponding NPM package is published to reflect the new version.

### 6. Version Control Management

- In both the `core` and `countryconfig` repositories, **merge the release branch into `master`**.  
  ⚠️ **Do not squash merge** — use a regular merge to preserve history.
-  Also **merge the release branch back into the `develop` branch** after the release is finalized to keep `develop` up to date with the latest changes.

### 7. Documentation Management

- Add the new release notes to the official documentation.
- Create a placeholder for the next version's documentation.
- Update OpenAPI specification URLs to point to the new release branch.
- Publish the updated documentation.
- Merge any open pull requests in the documentation repository, if appropriate.

### 8. Environment Management

- Merge the latest `countryconfig` updates into your country-specific repository.
- **For minor releases**: Deploy the new version to **production**.
- **For hotfix releases**: Deploy the new version to **staging**.

### 9. Team Communication

- Announce the newly published version to your team and stakeholders, ensuring they are informed and aligned.

### 10. Post Verification Steps 

- **Confirm GitHub release publication**  
  After publishing the GitHub release, open the repository’s **Releases** tab and verify that the release is publicly available and correctly labeled.

- **Verify NPM package publication (core only)**  
  For the `core` repository, ensure the NPM release has been published successfully. You can confirm this by checking for the presence of the corresponding version under the [@opencrvs/toolkit](https://www.npmjs.com/package/@opencrvs/toolkit?activeTab=versions) package on NPM.

---

By following this structured checklist, you ensure a smooth, transparent, and high-quality release process.



