# 4.3.5 Deploy

This deployment guide covers deployment processes for the following components:

* Traefik: Ingress controller and traffic routing.
* OpenCRVS Dependencies: Datastores, Monitoring
* OpenCRVS Core and Country config template: Core components and Configuration container

All OpenCRVS images except the country configuration template are hosted in the [GitHub container registry](https://github.com/orgs/opencrvs/packages?ecosystem=container).

### Publishing your countryconfig container to Dockerhub

The default country configuration container is hosted on our DockerHub.

You will need to register your own DockerHub account and create a private repository.

The DockerHub login information that you set during Github environment creation is used to compile and store a container image of your countruyconfig microservice. When you merge any pull request into the "main", "master" or "develop" branch, or if you explicitly run the **"Publish image to Dockerhub"** Github Action, a docker container image will be built and pushed to Dockerhub for your **countryconfig** microservice.

Now that you have configured repository secrets for Dockerhub access, you will notice that this action can be successfully run.

If you look at the logs for each build, you can see the image tag associated with the Docker container image. You use this tag in the Deploy action.

Once you are certain that your image is successfully being built and hosted on DockerHub, you can continue.
