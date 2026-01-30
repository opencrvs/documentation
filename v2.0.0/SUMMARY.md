# Table of contents

* [👋 Welcome!](README.md)

## CRVS Systems

* [Understanding CRVS](crvs-systems/understanding-crvs.md)
* [Effective digital CRVS systems](crvs-systems/effective-digital-crvs-systems.md)
* [OpenCRVS within a government systems architecture](crvs-systems/opencrvs-within-a-government-systems-architecture.md)
* [OpenCRVS Value Proposition](crvs-systems/opencrvs-value-proposition.md)

## Product Specifications

* [Functional Architecture](product-specifications/functional-architecture.md)
* [Workflow management](product-specifications/workflow-management.md)
* [Status Flow Diagram](product-specifications/status-flow-diagram.md)
* [User roles & scopes](product-specifications/users/README.md)
  * [Examples](product-specifications/users/examples.md)
* [Core functions](product-specifications/core-functions/README.md)
  * [1. Notify event](product-specifications/core-functions/1.-notify-event.md)
  * [2. Declare event](product-specifications/core-functions/2.-declare-event.md)
  * [3. Validate event](product-specifications/core-functions/3.-validate-event.md)
  * [4. Register event](product-specifications/core-functions/4.-register-event.md)
  * [5. Print certificate](product-specifications/core-functions/5.-print-certificate.md)
  * [6. Search for a record](product-specifications/core-functions/6.-search-for-a-record.md)
  * [7. View record](product-specifications/core-functions/7.-view-record.md)
  * [9. Correct record](product-specifications/core-functions/8.-correct-record.md)
  * [10. Archive record](product-specifications/core-functions/10.-archive-record.md)
  * [11. Vital statistics export](product-specifications/core-functions/11.-vital-statistics-export.md)
* [Support functions](product-specifications/support-functions/README.md)
  * [12. Login](product-specifications/support-functions/10.-login.md)
  * [14. Audit](product-specifications/support-functions/11.-audit.md)
  * [14. Deduplication](product-specifications/support-functions/12.-deduplication.md)
  * [15. Performance management](product-specifications/support-functions/13.-performance-management.md)
  * [16. Payment](product-specifications/support-functions/14.-payment.md)
  * [17. Learning](product-specifications/support-functions/15.-learning.md)
  * [18. User support](product-specifications/support-functions/16.-user-support.md)
  * [19. User onboarding](product-specifications/support-functions/20.-user-onboarding.md)
* [Admin functions](product-specifications/admin-functions/README.md)
  * [20. User management](product-specifications/admin-functions/17.-user-management.md)
  * [21. Comms management](product-specifications/admin-functions/18.-comms-management.md)
  * [22. Content management](product-specifications/admin-functions/19.-content-management.md)
  * [23. Config management](product-specifications/admin-functions/20.-config-management.md)
* [Data functions](product-specifications/data-functions/README.md)
  * [24. Legacy data import](product-specifications/data-functions/21.-legacy-data-import.md)
  * [25. Legacy paper import](product-specifications/data-functions/22.-legacy-paper-import.md)

## Technology

* [Architecture](technology/architecture/README.md)
  * [Performance tests](technology/architecture/performance-tests.md)
* [Standards](technology/standards.md)
* [Security](technology/security.md)
* [Interoperability](technology/interoperability/README.md)
  * [APIs requiring OAuth credentials](technology/interoperability/apis-requiring-oauth-credentials/README.md)
    * [Authenticate a client](technology/interoperability/apis-requiring-oauth-credentials/authenticate-a-client.md)
    * [Event Notification clients](technology/interoperability/apis-requiring-oauth-credentials/event-notification-clients.md)
    * [Record Search clients](technology/interoperability/apis-requiring-oauth-credentials/record-search-clients.md)
  * [APIs for system administrators](technology/interoperability/fhir-location-rest-api.md)
  * [National ID](technology/interoperability/national-id/README.md)
    * [Registration integration](technology/interoperability/national-id/registration-integration.md)
    * [In-form authentication / verification](technology/interoperability/national-id/in-form-authentication-verification.md)
    * [MOSIP](technology/interoperability/national-id/mosip/README.md)
      * [Registration integration](technology/interoperability/national-id/mosip/registration-integration.md)
      * [In-form authentication / verification with E-Signet](technology/interoperability/national-id/mosip/in-form-authentication-verification-with-e-signet.md)
      * [Deployment](technology/interoperability/national-id/mosip/deployment.md)

## Default configuration

* [Intro to Farajaland](default-configuration/intro-to-farajaland.md)
* [Civil registration in Farajaland](default-configuration/civil-registration-in-farajaland.md)
* [OpenCRVS configuration in Farajaland](default-configuration/opencrvs-configuration-in-farajaland/README.md)
  * [Application settings](default-configuration/opencrvs-configuration-in-farajaland/application-settings.md)
  * [User roles](default-configuration/opencrvs-configuration-in-farajaland/user-role-mapping.md)
  * [Declaration forms](default-configuration/opencrvs-configuration-in-farajaland/declaration-forms.md)
  * [Certified Copies templates](default-configuration/opencrvs-configuration-in-farajaland/certificate-templates.md)
* [Business process flows in Farajaland](default-configuration/business-process-flows-in-farajaland.md)

## Setup

* [1. Planning an OpenCRVS Implementation](setup/1.-planning-an-opencrvs-implementation.md)
* [2. Establish project and team](setup/1.-establish-project-and-team.md)
* [3. Gather requirements](setup/2.-gather-requirements/README.md)
  * [3.1 Mapping business processes](setup/2.-gather-requirements/3.1-mapping-business-processes.md)
  * [3.2 Mapping offices and user types](setup/2.-gather-requirements/3.2-mapping-offices-and-user-types.md)
  * [3.3 Define your application settings](setup/2.-gather-requirements/3.3-define-your-application-settings.md)
  * [3.4 Designing event declaration forms](setup/2.-gather-requirements/3.4-designing-event-declaration-forms.md)
  * [3.5 Designing a certified copy](setup/2.-gather-requirements/3.5-designing-a-certificate-template.md)
* [4. Installation](setup/3.-installation/README.md)
  * [Quick start](setup/3.-installation/quick-start.md)
  * [4.1 Set-up a local development environment](setup/3.-installation/3.1-set-up-a-development-environment/README.md)
    * [4.1.1 Install the required dependencies](setup/3.-installation/3.1-set-up-a-development-environment/3.1.1-install-the-required-dependencies.md)
    * [4.1.2 Install OpenCRVS locally](setup/3.-installation/3.1-set-up-a-development-environment/3.1.2-install-opencrvs-locally-k8s.md)
    * [4.1.3 Local environment maintenance](setup/3.-installation/3.1-set-up-a-development-environment/3.1.3-local-environment-maintenance-k8s.md)
    * [4.1.4 Log in to OpenCRVS locally](setup/3.-installation/3.1-set-up-a-development-environment/3.1.4-log-in-to-opencrvs-locally.md)
    * [4.1.5 Tooling](setup/3.-installation/3.1-set-up-a-development-environment/3.1.5-tooling/README.md)
      * [4.1.5.1 WSL Support](setup/3.-installation/3.1-set-up-a-development-environment/3.1.5-tooling/4.1.5.1-wsl-support.md)
  * [4.2 Configure: Set-up your own, local, country configuration](setup/3.-installation/3.2-set-up-your-own-country-configuration/README.md)
    * [4.2.1 Fork your own country configuration repository](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.1-fork-your-own-country-configuration-repository.md)
    * [4.2.2 Set up administrative address divisions](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions/README.md)
      * [4.2.2.1 Prepare source file for administrative structure](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions/3.2.2.1-prepare-source-file-for-administrative-structure.md)
      * [4.2.2.2 Prepare source file for statistics](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions/3.2.2.2-prepare-source-file-for-statistics.md)
    * [4.2.3 Set up CR offices and Health facilities](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.3-set-up-cr-offices-and-health-facilities/README.md)
      * [4.2.3.1 Prepare source file for CRVS Office facilities](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.3-set-up-cr-offices-and-health-facilities/3.2.3.1-prepare-source-file-for-crvs-office-facilities.md)
      * [4.2.3.2 Prepare source file for health facilities](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.3-set-up-cr-offices-and-health-facilities/3.2.3.2-prepare-source-file-for-health-facilities.md)
    * [4.2.4 Set up employees & roles for testing or production](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production/README.md)
      * [4.2.3.1 Prepare source file for employees](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production/3.2.3.1-prepare-source-file-for-test-employees.md)
      * [4.2.3.2 Configure user roles](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production/4.2.3.2-configure-role-titles.md)
    * [4.2.5 Set up application settings](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/README.md)
      * [4.2.5.1 Managing language content](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/3.2.9.1-managing-language-content/README.md)
        * [4.2.5.1.1 Informant and staff notifications](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/3.2.9.1-managing-language-content/3.3.3-provision-a-comms-gateway.md)
    * [4.2.6 Configure events](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/README.md)
      * [4.2.6.1 Working with events](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/4.2.7.1-configuring-an-event-form.md)
      * [4.2.6.2 Configure an event declaration form](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/4.2.6.2-configure-an-event-declaration-form.md)
      * [4.2.6.3 Configure certificate templates](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/3.2.6-configure-certificate-templates.md)
    * [4.2.7 Configure Metabase Analytics](setup/3.-installation/3.2-set-up-your-own-country-configuration/4.2.5.2-configuring-metabase-dashboards.md)
    * [4.2.8 Seeding & clearing your local databases](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.8-seeding-your-local-database.md)
    * [4.2.9 Other configurable countryconfig API endpoints explained](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.9-countryconfig-apis-explained/README.md)
      * [4.2.9.1 Configurable workqueue API](setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.9-countryconfig-apis-explained/4.2.9.1-configurable-workqueue-api.md)
    * [4.2.10 Build Country config docker image](setup/3.-installation/3.2-set-up-your-own-country-configuration/4.2.10-build-country-config-docker-image.md)
  * [4.3 Deploy: Set-up a server-hosted environment](setup/3.-installation/3.3-set-up-a-server-hosted-environment/README.md)
    * [4.3.1 Preparation steps](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-preparation-steps/README.md)
      * [4.3.1.1 Setup infrastructure](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-preparation-steps/4.3.1.1-setup-infrastructure.md)
      * [4.3.1.2 Configure DNS](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-preparation-steps/4.3.1.2-configure-dns.md)
      * [4.3.1.3 Issue SSL Certificates](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-preparation-steps/4.3.1.3-issue-ssl-certificates.md)
      * [4.3.1.4 Create prerequisite accounts and repositories](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-preparation-steps/4.3.1.4-create-prerequisite-accounts-and-repositories.md)
    * [4.3.2 Create a Github environment](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-create-a-github-environment/README.md)
      * [4.3.2.1 Environment secrets and variables explained](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.1-create-a-github-environment/4.3.1.1-environment-secrets-and-variables-explained.md)
    * [4.3.3 Bootstrap servers](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.2-bootstrap-servers.md)
    * [4.3.4 Provisioning servers](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.5-provisioning-servers/README.md)
      * [4.3.3.4 Ansible tasks when provisioning](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.5-provisioning-servers/4.3.5.4-ansible-tasks-when-provisioning.md)
    * [4.3.5 Deploy](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.6-deploy/README.md)
      * [4.3.5.1 Running Dependencies deployment](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.6-deploy/4.3.5.1-running-a-dependencies-deployment.md)
      * [4.3.5.2 Running an OpenCRVS deployment](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.6-deploy/4.3.5.2-running-a-opencrvs-deployment.md)
      * [4.3.5.3 Login to an OpenCRVS server](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.6-deploy/4.3.5.3-login-to-an-opencrvs-server.md)
    * [4.3.6 Migration from Docker swarm guide](setup/3.-installation/3.3-set-up-a-server-hosted-environment/4.3.6-migration-from-docker-swarm-guide.md)
  * [4.4 OpenCRVS maintenance tasks](setup/3.-installation/4.4-opencrvs-maintenance-tasks/README.md)
    * [4.4.1 Seeding a server environment](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.6.2-seeding-a-server-environment.md)
    * [4.4.2 Resetting a server environment](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.6.5-resetting-a-server-environment.md)
    * [4.4.3 Backup & Restore](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.7-backup-and-restore/README.md)
      * [4.4.3.1 Automated backup configuration](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.7-backup-and-restore/4.4.3.1-automated-backup-configuration.md)
      * [4.4.3.2 Manual backup creation](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.7-backup-and-restore/4.4.3.2-manual-backup-creation.md)
      * [4.4.3.3 Automated restore configuration](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.7-backup-and-restore/4.3.7.1-restoring-a-backup.md)
      * [4.4.3.4 Manual restore / Disaster recovery](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.7-backup-and-restore/4.4.3.4-manual-restore-disaster-recovery.md)
    * [4.4.4 Off-boarding from OpenCRVS](setup/3.-installation/4.4-opencrvs-maintenance-tasks/4.3.7.2-off-boarding-from-opencrvs.md)
  * [4.5 Advanced topics](setup/3.-installation/4.4-advanced-topics/README.md)
    * [4.5.1 TLS/SSL Configuration for traefik](setup/3.-installation/4.4-advanced-topics/4.5.1-tls-ssl-configuration-for-traefik/README.md)
      * [4.5.1.1 LetsEncrypt https challenge in development environments](setup/3.-installation/4.4-advanced-topics/4.5.1-tls-ssl-configuration-for-traefik/4.3.3.1-letsencrypt-https-challenge-in-development-environments.md)
      * [4.5.1.2 LetsEncrypt DNS challenge in production](setup/3.-installation/4.4-advanced-topics/4.5.1-tls-ssl-configuration-for-traefik/4.3.3.2-letsencrypt-dns-challenge-in-production.md)
      * [4.5.1.3 Static TLS certificates](setup/3.-installation/4.4-advanced-topics/4.5.1-tls-ssl-configuration-for-traefik/4.3.3.3-static-tls-certificates.md)
    * [4.5.2 SSH access](setup/3.-installation/4.4-advanced-topics/4.3.5.1-ssh-access.md)
    * [4.5.3 Kubernetes cluster access](setup/3.-installation/4.4-advanced-topics/4.3.5.2-kubernetes-cluster-access.md)
    * [4.5.4 Add Custom GitHub secrets to Kubernetes](setup/3.-installation/4.4-advanced-topics/4.5.4-add-custom-github-secrets-to-kubernetes.md)
    
* [5. Functional configuration](setup/5.-functional-configuration/README.md)
  * [5.1 Configure application settings](setup/5.-functional-configuration/5.1-configure-application-settings.md)
  * [5.2 Configure registration periods and fees](setup/5.-functional-configuration/5.2-configure-registration-periods-and-fees.md)
  * [5.3 Managing system users](setup/5.-functional-configuration/5.3-managing-system-users.md)
* [6. Quality assurance testing](setup/5.-testing.md)
* [7. Go-live](setup/6.-go-live/README.md)
  * [7.1 Pre-Deployment Checklist](setup/6.-go-live/3.3.4-set-up-an-smtp-server-for-opencrvs-monitoring-alerts.md)
* [8. Operational Support](setup/8.-operational-support.md)
* [9. Monitoring](setup/7.-monitoring/README.md)
  * [9.1 Application logs](setup/7.-monitoring/7.1-application-logs.md)
  * [9.2 Infrastructure health](setup/7.-monitoring/7.2-infrastructure-health.md)
  * [9.3 Routine monitoring checklist](setup/7.-monitoring/7.3-routine-monitoring-checklist.md)
  * [9.4 Setting up alerts](setup/7.-monitoring/7.4-setting-up-alerts.md)
  * [9.5 Managing a Docker Swarm](setup/7.-monitoring/7.5-managing-a-docker-swarm.md)

## General

* [Community](general/community.md)
* [Contributing](general/contributing.md)
* [Migration notes](general/migration-notes.md)
* [Release notes](general/release-notes.md)
* [Releases and upgrades](general/releases-and-upgrades.md)
* [Roadmap](general/product-roadmap.md)

## Developers

* [Infrastructure](developers/infrastructure/README.md)
  * [Local Setup](developers/infrastructure/local-setup.md)
* [Country configuration](developers/country-configuration/README.md)
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * ```yaml
    props:
      models: false
    type: builtin:openapi
    dependencies:
      spec:
        ref:
          kind: openapi
          spec: cc-develop
    ```
  * [Certificate templates](developers/country-configuration/certificate-templates/README.md)
    * [Variables & functions](developers/country-configuration/certificate-templates/variables-and-functions.md)
