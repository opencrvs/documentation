---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.3-set-up-a-server-hosted-environment
---

# 4.3 Deploy: Set-up a server-hosted environment

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
* [ ] Fork the `countryconfig` repository and configure its CI process to push images to your container registry. See [4.2.1 Fork your own country configuration repository](../3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md) and [4.2.10 Build country config docker image](../3.2-set-up-your-own-country-configuration/4.2.10-build-country-config-docker-image.md)
* [ ] Fork the `infrastructure` repository.

All steps are described in detail in this chapter.

Once the [4.3.1 Preparation steps](4.3.1-preparation-steps/) are complete, proceed with the installation steps **in order**.
