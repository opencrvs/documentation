# Publish image to container registry

Before you deploy OpenCRVS to a server, build the Docker image of your country configuration and push it to a container registry. During deployment, the servers pull the image from the same registry.

Use any container registry that implements the OCI Registry v2 API, for example GitHub Container Registry (`ghcr.io`) or Docker Hub (`docker.io`). The examples on this page use Docker Hub.

{% hint style="info" %}
You must publish your own country configuration image to your own container registry. All other OpenCRVS images are hosted in the [GitHub container registry](https://github.com/orgs/opencrvs/packages?ecosystem=container).
{% endhint %}

Before you start, set up your GitHub organisation and repository. See [Set up GitHub organisation and repository](set-up-github-organisation-and-repository.md).

#### 1. Create a private repository in the container registry

In the container registry:

1. Create an **organisation**. Add all developers as members, so they can publish and access images.
2. Create a **single private repository** to store your country configuration image. Your development team and your OpenCRVS servers both access this repository.
3. Create an **access token** that has permission to push and pull images.

{% hint style="info" %}
**Example: Docker Hub**

Docker Hub's free plan includes one private repository. This is sufficient for a typical OpenCRVS implementation.

Create a private Docker Hub repository for your country configuration image:

<figure><img src="../../../.gitbook/assets/image (1) (2).png" alt=""><figcaption></figcaption></figure>

Make sure that the Docker Hub members have permission to write to the repository:

<figure><img src="../../../.gitbook/assets/image (25).png" alt=""><figcaption></figcaption></figure>

To create a Docker Hub access token, see [Create an access token](https://docs.docker.com/security/for-developers/access-tokens/).
{% endhint %}

#### 2. Add the registry values to the countryconfig repository

You manage the registry values manually in the country configuration repository. The publish workflow uses them to log in to the registry and to name the image.

In the country configuration repository, go to **Settings → Secrets and variables → Actions**. Add these values:

| Name                    | Type                | Description                                                                                         | Docker Hub example    |
| ----------------------- | ------------------- | --------------------------------------------------------------------------------------------------- | --------------------- |
| `REGISTRY_HOST`         | Repository variable | Host name of the container registry. Do not include the protocol or a path. The default is `docker.io`. | `docker.io`           |
| `REGISTRY_ORGANISATION` | Repository secret   | Organisation (or user) in the registry. This is the part of the image URL before the slash.         | `my-organisation`     |
| `REGISTRY_REPOSITORY`   | Repository secret   | Name of the private repository. This is the part of the image URL after the slash.                  | `ocrvs-my-country`    |
| `REGISTRY_USERNAME`     | Repository secret   | User name that the workflow uses to log in to the registry.                                         | `my-docker-id`        |
| `REGISTRY_TOKEN`        | Repository secret   | Access token with permission to push and pull images.                                               | Docker Hub access token |

The workflow builds the image name from these values:

```
<REGISTRY_HOST>/<REGISTRY_ORGANISATION>/<REGISTRY_REPOSITORY>:<tag>
```

For example: `docker.io/my-organisation/ocrvs-my-country:a1b2c3d`.

Save a copy of the five values in a safe place, for example in your password manager. GitHub does not show the value of a secret after you save it. You need the same values later, when you [create a GitHub environment](deploy-set-up-a-server-hosted-environment/create-a-github-environment/): the `environment:init` script asks for them and validates them against the registry.

The servers pull the image with the same values. OpenCRVS stores the credentials in the `registry-credentials` image pull secret on the servers.

#### 3. Publish the image

The **Publish image to container registry** workflow (`publish-to-registry.yml`) builds and pushes the image. The country configuration template includes this workflow.

The workflow starts in these cases:

* You merge a pull request into the `main`, `master`, `develop` or `release*` branch, or you push a tag.
* You run the workflow manually: go to **Actions → Publish image to container registry → Run workflow**. Select the branch to build from. To build images for ARM, select **Build ARM images**.

The workflow builds and pushes two images for the **countryconfig** microservice:

* `<tag>`: the country configuration image.
* `<tag>-assets`: the assets image.

{% hint style="info" %}
The image tag is the Git tag of the commit, if the commit has one. Otherwise, the tag is the 7-character short commit hash. You use this tag when you deploy.
{% endhint %}

In the logs of each workflow run, find the image tag. You use this tag in the **Deploy** action.

{% hint style="warning" %}
If your repository does not have the `publish-to-registry.yml` workflow, copy it from the country configuration template. Do not delete `publish-to-dockerhub.yml`. Replace its content with the deprecated version from the template, because release branches can still use it.
{% endhint %}

When the workflow successfully builds and pushes the image to your registry, continue to the next step.
