# 4.3.6 Deploy

Now that your servers are provisioned, you can proceed to deploy OpenCRVS onto them. You should never need to run the provision actions again until you next upgrade OpenCRVS or perhaps if your static TLS certificates expire.

The "Deploy" (development)" and the "Deploy" (production)" actions are probably the most common Github Actions that you will run on a regular basis.

Before running the actions, it is important to understand how Docker Compose files work and complete the steps in this page before proceeding.

### Deploy Actions introduction

The "Deploy" (development)" Action is used to deploy OpenCRVS onto a **development, qa** or **staging** environment. The "Deploy" (production)" Action is used to deploy OpenCRVS onto a **production** or **staging** environment. Some environment variables are configured in the following docker compose files to control the behaviour of functional features within the Docker containers on these environments:

docker-compose.deploy.yml (base config)

docker-compose.development-deploy.yml (environment specific)

docker-compose.qa-deploy.yml (environment specific)

docker-compose.staging-deploy.yml (environment specific)

docker-compose.production-deploy.yml (environment specific)

Each core microservice is represented as a block in these compose files.

{% hint style="info" %}
OpenCRVS uses multiple Compose files (often to customize or extend the setup depending on the environment). OpenCRVS makes use of the Docker Compose behaviour that combines them into a unified configuration by merging the contents of each file in a specific order. This enables us to have a base configuration "docker-compose.deploy.yml" and layer additional settings as needed for each specific environment.
{% endhint %}

Refer back to section [4.3.2.1](../../3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production/3.2.3.1-prepare-source-file-for-test-employees.md) employees source files to understand how user access is different for each environment.

### Configure your docker-compose files

There are a few environment variables you need to manually set in docker compose files for your installation such as those that are relevant for your [TLS/SSL Certificate approach](../../../../../v1.8.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment/3.3.5-setup-dns-a-records). Make sure that you make those changes before proceeding.

a) Replace any instance of the comma separated available language alpha-2 ISO codes for your localisation needs. These strings tell services how to parse some values. The first item in the comma separated languages string sets the default language. In this example, English is the default language and French language is also available in the application.:

```
LANGUAGES=en,fr
```

b) Replace any instance of the COUNTRY code. E.G.:

```
COUNTRY=FAR
```

c) Optional: If you are going to use any external service using any custom Github Secrets you have created such as for an SMS or WhatsApp API gateway to deliver beneficiary comms, you will need to amend **countryconfig:** environment variables in docker compose. We have example code in the countryconfig service which uses the Infobip SMS gateway environment variables.

### Configure permissions in the repository & Deploy (production) workflow

In order to stop the Deploy (production) action from being accidentally run, an approval check has been implemented. When the action runs, a Git issue will open requiring repository administrators to reply approve or deny in order for the action to continue.

<figure><img src="../../../../../v1.7.0/.gitbook/assets/Screenshot 2024-02-13 at 17.39.46.png" alt=""><figcaption><p>Example of Deploy(production) approval</p></figcaption></figure>

In the .github/workflows/deploy-prod.yml change the approvers to a comma separated list of Github usernames for administrators in your repository, and commit the updated workflow to Git:

```
steps:
  - uses: trstringer/manual-approval@v1
    with:
      secret: ${{ github.TOKEN }}
      approvers: euanmillar,rikukissa # change these usernames appropriately
```

Your Git repository must be configured to allow Issues and additionally Workflows must have read/write permissions.

<figure><img src="../../../../../v1.7.0/.gitbook/assets/Screenshot 2024-02-13 at 17.34.21.png" alt=""><figcaption></figcaption></figure>

### Commit any changes

{% hint style="danger" %}
Commit any changes to docker-compose and deploy workflow files to Git before proceeding.
{% endhint %}
