# Deploy

This deployment guide covers deployment processes for the following components:

* Traefik: Ingress controller and traffic routing.
* OpenCRVS Dependencies: Datastores, Monitoring
* OpenCRVS Core and Country config template: Core components and Configuration container

All OpenCRVS images except the country configuration template are hosted in the [GitHub container registry](https://github.com/orgs/opencrvs/packages?ecosystem=container).

### Publishing your countryconfig image to Dockerhub

The default country configuration image is hosted on our DockerHub.

You will need to register your own DockerHub account and create a private repository.

The DockerHub login information that you set during Github environment creation is used to compile and store a container image of your countruyconfig microservice. When you merge any pull request into the "main", "master" or "develop" branch, or if you explicitly run the **"Publish image to Dockerhub"** Github Action, a docker container image will be built and pushed to Dockerhub for your **countryconfig** microservice.

Now that you have configured repository secrets for Dockerhub access, you will notice that this action can be successfully run.

If you look at the logs for each build, you can see the image tag associated with the Docker container image. You use this tag in the Deploy action.

Once you are certain that your image is successfully being built and hosted on DockerHub, you can continue.

#### Using a container registry other than Docker Hub

Any container registry that implements the OCI Registry v2 API (for example GHCR) can be used. The secrets `DOCKERHUB_ACCOUNT`, `DOCKERHUB_REPO`, `DOCKER_USERNAME` and `DOCKER_TOKEN` are renamed to `REGISTRY_ORGANISATION`, `REGISTRY_REPOSITORY`, `REGISTRY_USERNAME` and `REGISTRY_TOKEN`. The repository variable `REGISTRY_HOST` (default `docker.io`) sets the registry, and the image pull secret `dockerhub-credentials` is now `registry-credentials`. `environment:init` asks for these values and validates them against the registry.

The previous names are still read, so existing deployments keep working. To publish with the new names, add the `publish-to-registry.yml` workflow from the country configuration template to your repository. Do not delete `publish-to-dockerhub.yml`; replace its content with the template's deprecated version, as release branches may still use it.

{% hint style="warning" %}
We strongly recommend that you have enabled an [approval](../create-a-github-environment/approval-process-for-production-environments.md) process for all deployment scripts to **production** and **staging** environments.
{% endhint %}
