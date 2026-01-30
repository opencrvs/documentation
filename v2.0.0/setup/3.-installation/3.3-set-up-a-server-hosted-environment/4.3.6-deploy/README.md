# 4.3.5 Deploy

Deployment guide covers deployment process for the following components:

* Traefik: Ingress controller and traffic routing.
* OpenCRVS dependencies: Datastores, Monitoring
* OpenCRVS Core and Country config template: Core components and Configuration container

All OpenCRVS images except Country configuration template are hosted on [GitHub container registry](https://github.com/orgs/opencrvs/packages?ecosystem=container).

Country configuration template is hosted on DockerHub and we strongly recommend you register your own DockerHub account with private repository and configure continuous integration process fork of Country config repository before moving further with this guide. When you merge any pull request into the "main", "master" or "develop" branch, or if you explicitly run the "Publish image to Dockerhub" Github Action, a docker container image will be built and pushed to Dockerhub for your **countryconfig** microservice.

Now that you have configured repository secrets for Dockerhub access, you will notice that this action can be successfully run.

If you look at the logs for each build, you can see the image tag associated with the Docker container image. You use this tag in the Deploy action.

