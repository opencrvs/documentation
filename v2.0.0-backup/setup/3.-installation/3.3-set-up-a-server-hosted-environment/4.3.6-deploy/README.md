# 4.3.5 Deploy

Deployment guide covers deployment process for the following components:

* Traefik: Ingress controller and traffic routing.
* OpenCRVS dependencies: Datastores, Monitoring
* OpenCRVS Core and Country config template: Core components and Configuration container

All OpenCRVS images except Country configuration template are hosted on [GitHub container registry](https://github.com/orgs/opencrvs/packages?ecosystem=container).

Country configuration template is hosted on DockerHub and we strongly recommend you register your own DockerHub account with private repository and configure continuous integration process fork of Country config repository before moving further with this guide.

