# Configuration

## Country configuration options

### 1. Introduction

OpenCRVS separates the core product from the country-specific configuration required to run it in a real national context. This means the same OpenCRVS Core can be used by different countries, while each implementation defines its own events, forms, reference data, content, certificates, integrations and deployment settings.

This page provides a high-level overview of the configuration options enabled by the OpenCRVS country configuration and infrastructure repositories. The detailed implementation steps are covered in the following guides.

**Where this sits:** Country configuration is defined during Design & Specification, implemented during Configuration, and deployed through the project’s infrastructure environments in [installation](../installation/deploy-set-up-a-server-hosted-environment/).

***

### 2. What the country configuration repository enables

The [country configuration](https://github.com/opencrvs/opencrvs-countryconfig) repository contains the country-specific logic, files and APIs required by OpenCRVS Core.

At a high level, it enables configuration of:

**Application settings** — general settings that control how the OpenCRVS application behaves for the country implementation.

**Administrative structure and locations** — the country’s geographic and administrative hierarchy, including locations used for registration, reporting and dashboards.

**Users and roles** — initial users, system administrators and role titles mapped to OpenCRVS user types.

**Registration forms** — versioned form definitions for vital events, including birth, death and other supported event types.

**Form validation and conditional logic** — country-specific rules that determine how form fields are validated and when questions or sections appear.

**Language content** — translated and country-specific application content used across the OpenCRVS user interface.

**Certificates** — certificate templates and related assets used to issue official documentation.

**Statistics and reporting inputs** — population and vital statistics reference data used to calculate registration completeness and support dashboards.

**Notifications** — integration points for sending messages to staff or citizens by SMS, email or other country-specific communication channels.

**Event registration integrations** — business-critical integration points that can run at the point of legal registration, such as generating identifiers or communicating with external systems.

**Hosted assets** — country logos, maps and other files required by the application, emails or dashboards.

{% hint style="info" %}
The country configuration repository contains an [infrastructure](https://github.com/opencrvs/opencrvs-countryconfig/tree/develop/infrastructure) folder which supports: **Backwards compatibility for OpenCRVS versions 1.9 and below still using DockerSwarm.  It will be deprecated in 2.1**
{% endhint %}

***

### 3. What the infrastructure repository enables

The [infrastructure](https://github.com/opencrvs/infrastructure) repository supports the deployment and operation of OpenCRVS across environments.  Follow the [installation > deploy](../installation/deploy-set-up-a-server-hosted-environment/) guides .

At a high level, it enables configuration of:

**Deployment environments** — development, test, staging and production environments used to run OpenCRVS.

**Containerised services** — the Kubernetes and Helm configuration required to deploy OpenCRVS Core, dependencies and country configuration services.

**Networking and routing** — ingress, routing and service exposure needed for users and systems to access OpenCRVS.

**Environment-specific settings** — configuration values that differ between environments, such as image versions, domains, secrets and service endpoints.

**Operational services** — supporting infrastructure required to run OpenCRVS reliably, including databases, search, logging and other platform dependencies.

**Local development tooling** — developer environments that allow technical teams to build, test and iterate on country configuration safely before deploying it.

***

### 4. How the repositories work together

The country configuration repository defines what makes OpenCRVS specific to a country. The infrastructure repository defines how OpenCRVS is deployed and operated in each environment.

Together, they allow an implementation team to:

* configure OpenCRVS without changing OpenCRVS Core
* test country-specific changes in local and non-production environments
* seed the system with the required reference data
* deploy the validated configuration consistently across environments
* maintain a clear separation between product code, country configuration and infrastructure

This separation is important because it allows countries to tailor OpenCRVS to their legal, operational and technical context while still benefiting from upgrades to the shared OpenCRVS Core platform.

***

### 5. When country configuration is complete

Country configuration is complete when:

* [ ] the required application settings have been defined
* [ ] administrative locations and reference data have been loaded
* [ ] users, roles and scopes have been configured
* [ ] event forms, validation rules and conditional logic have been implemented
* [ ] language content and country assets have been added
* [ ] certificate templates have been configured
* [ ] notifications and required integrations have been implemented
* [ ] infrastructure settings are ready for each environment
* [ ] the complete configuration has been tested against the signed-off requirements

***

### 6. Resources and support

For further guidance, see:

* [**opencrvs-countryconfig**](https://github.com/opencrvs/opencrvs-countryconfig) — the template repository for defining country-specific configuration, APIs, forms, content and reference data.
* [**opencrvs/infrastructure**](https://github.com/opencrvs/infrastructure) — the repository for deploying and operating OpenCRVS infrastructure using the supported deployment approach.
* **Technical configuration guides** — step-by-step guidance **in this section** for implementing country configuration.
* [**Installation**](../installation/) — step-by-step guidance for deploying OpenCRVS into each environment.

