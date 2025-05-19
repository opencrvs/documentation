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

## Deployment to a Release Environment

You can deploy a draft release to a dedicated release environment, which is highly beneficial for validation and testing purposes. The process is streamlined and straightforward.

To initiate the deployment, simply run the [`Create Hetzner Server`](https://github.com/opencrvs/opencrvs-farajaland/actions/workflows/create-hetzner-server.yml) GitHub Action. This workflow automates the server provisioning process and requires only two input parameters:

- **`env_name`**: A short identifier for the environment (preferably 3–5 characters).  
  *Tip:* Use the release version as a reference, such as `v17` for version `1.7.0`.

- **`env_type`**: Specify the environment configuration.  
  Use `multi-node` for production deployments and `single-node` for all other cases.

Once triggered, the action will handle the rest of the setup automatically.

## Comprehensive Guide to Completing the Release

Once the release pull request has been generated via the [`Release - Start a new release`](https://github.com/opencrvs/opencrvs-core/actions/workflows/init-release.yml) workflow, a few final tasks remain to fully complete the release process.


### 1. Tag the Release

Create a Git tag from the `HEAD` of the release branch. For example, to tag version `1.7.0`, run:

```bash
git tag v1.7.0
git push origin tag v1.7.0
```

### 2. Verify Docker Images

- Confirm that the Docker images have been published to [Docker Hub](https://hub.docker.com/r/opencrvs/ocrvs-countryconfig/tags?name=v). For post v1.7.0 check Github Container regestry.
- Compare the size of the new images with those from the previous release.
- If there is a significant difference in size, report it to the maintainers for investigation.

### 3. Finalize GitHub Release

- Copy the content from `CHANGELOG.md` into the GitHub Release notes.
- Paste any changed "Copy" items into the release notes. You can generate these with [this tool](https://gist.github.com/rikukissa/9415b88016c0acfc0e0d4e00add45993).
- Once finalized, **publish** the GitHub release.

### 4. Publish NPM Release

- In the core repository, ensure that the corresponding NPM package is published to reflect the new version.

### 5. Version Control Management

- In both the `core` and `countryconfig` repositories, **merge the release branch into `master`**.  
  ⚠️ **Do not squash merge** — use a regular merge to preserve history.

### 6. Documentation Management

- Add the new release notes to the official documentation.
- Create a placeholder for the next version's documentation.
- Update OpenAPI specification URLs to point to the new release branch.
- Publish the updated documentation.
- Merge any open pull requests in the documentation repository, if appropriate.

### 7. Environment Management

- Merge the latest `countryconfig` updates into your country-specific repository.
- **For minor releases**: Deploy the new version to **production**.
- **For hotfix releases**: Deploy the new version to **staging**.

### 8. Team Communication

- Announce the newly published version to your team and stakeholders, ensuring they are informed and aligned.

---

By following this structured checklist, you ensure a smooth, transparent, and high-quality release process.

## Verification Steps During a Release

During the release process, it is critical to exercise extra caution and perform thorough validation at each stage to ensure accuracy and completeness. Below are essential verification tasks you must carry out:

- **Check for pending pull requests**  
  Ensure there are no open pull requests that need to be included in the release—this applies to both the `countryconfig` and `core` repositories.

- **Verify Git tags**  
  Before creating a new Git tag, confirm that a tag with the same version number does not already exist in either the `countryconfig` or `core` repositories.

- **Validate Docker image availability**  
  Check Docker Hub (or the GitHub Container Registry for versions post `1.7.0`) to confirm that Docker images have been built and published using the correct release version name.

- **Confirm GitHub release publication**  
  After publishing the GitHub release, open the repository’s **Releases** tab and verify that the release is publicly available and correctly labeled.

- **Verify NPM package publication (core only)**  
  For the `core` repository, ensure the NPM release has been published successfully. You can confirm this by checking for the presence of the corresponding version under the [@opencrvs/toolkit](https://www.npmjs.com/package/@opencrvs/toolkit?activeTab=versions) package on NPM.

> ✅ Conducting these checks diligently helps avoid release inconsistencies and ensures a smooth experience for downstream users.

