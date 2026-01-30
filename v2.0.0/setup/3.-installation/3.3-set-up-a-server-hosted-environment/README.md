# 4.3 Set-up a server-hosted environment

In this chapter, you will learn how to create and configure the infrastructure and all required components for an OpenCRVS deployment using GitHub Actions workflows.

These workflows perform most of the installation and configuration for you, but before running them you must complete the following preparation steps:

* [ ] Provision servers (virtual machines).
* [ ] Configure DNS and obtain SSL certificates.
* [ ] Set up an SMTP server.
* [ ] Create the required accounts:
  * [ ] GitHub
  * [ ] Docker Hub
  * [ ] 1Password (or another secrets manager)
  * [ ] Optional: other services such as Slack and Sentry
* [ ] Fork the `countryconfig` repository and configure its CI process to push images to your container registry. See [3.2.1-fork-your-own-country-configuration-repository.md](../3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md "mention") and [4.2.10-build-country-config-docker-image.md](../3.2-set-up-your-own-country-configuration/4.2.10-build-country-config-docker-image.md "mention")
* [ ] Fork the infrastructure repository.

All steps are described in details later in this chapter at [4.3.1-preparation-steps](4.3.1-preparation-steps/ "mention") section.

Once the preparation steps are complete, proceed with the installation steps:

* [ ] [4.3.1-create-a-github-environment](4.3.1-create-a-github-environment/ "mention"): Generate configuration files and environments in GitHub, including the required secrets.
* [ ] [4.3.2-bootstrap-servers.md](4.3.2-bootstrap-servers.md "mention"): Bootstrap the servers with GitHub self-hosted runners.
* [ ] [4.3.5-provisioning-servers](4.3.5-provisioning-servers/ "mention"): Provision the infrastructure using Ansible so that the environments can run.
* [ ] [4.3.6-deploy](4.3.6-deploy/ "mention"): Run continuous deployment workflows to deploy your OpenCRVS configuration to the server clusters for each environment.

