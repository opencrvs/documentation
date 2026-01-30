# Add Custom GitHub secrets to Kubernetes

GitHub secrets are widely used to store sensitive information for CI/CD and Runtime. Secrets examples are DockerHub credentials, Disk encryption key, Kibana credentials, Postgres and Elasticsearch admin passwords, etc.

GitHub secrets are grouped per environment and at repository level, secret defined for environment will override value at repository level.

## Default secrets mapping

OpenCRVS Helm chart stores database connection properties and other sensitive data like SMTP configuration, backup credentials as Kubernetes secrets.

Check following link for default secrets specification at [Authentication configuration](https://github.com/opencrvs/infrastructure/blob/develop/charts/opencrvs-services/README.md#authentication-configuration) (helm chart README.md)

## SMTP secret mapping example

Country config image requires SMTP server configuration for emails. Following environment variables are required for container:

* SENDER\_EMAIL\_ADDRESS
* SMTP\_HOST
* SMTP\_PASSWORD
* SMTP\_PORT
* SMTP\_SECURE
* SMTP\_USERNAME
* ALERT\_EMAIL

Full descrition is at [4.3.1.1 Environment secrets and variables explained](../3.3-set-up-a-server-hosted-environment/4.3.1-create-a-github-environment/4.3.1.1-environment-secrets-and-variables-explained.md)

Steps to add GitHub secrets to Kubernetes

1. Create required variables at GitHub. E.g if you need SMTP configuration, make sure all variables from the list above are present under GitHub environment or repository level.
2.  Define relation between Kubernetes secret and list all GitHub secrets you need to create at templates file:<br>

    <pre class="language-yaml" data-title="Example for mapping all GitHub secrets required for country config SMTP configuration into single Kubermetes secret &#x22;smtp-config&#x22;"><code class="lang-yaml">smtp-config:
      - SENDER_EMAIL_ADDRESS
      - SMTP_HOST
      - SMTP_PASSWORD
      - SMTP_PORT
      - SMTP_SECURE
      - SMTP_USERNAME
      - ALERT_EMAIL
    </code></pre>

    1. For mapping secrets in dependencies: [.github/TEMPLATES/secret-mapping-deps.yml](https://github.com/opencrvs/infrastructure/blob/develop/.github/TEMPLATES/secret-mapping-deps.yml)
    2. For mapping secrets in OpenCRVS:  [.github/TEMPLATES/secret-mapping-opencrvs.yml](https://github.com/opencrvs/infrastructure/blob/develop/.github/TEMPLATES/secret-mapping-opencrvs.yml)
3.  Map values from secret to particular container in helm chart values:\
    Check documentation for more information: [Mapping secrets](https://github.com/opencrvs/infrastructure/blob/develop/charts/opencrvs-services/README.md#mapping-secrets) (Helm chart README.md)

    <pre class="language-yaml" data-title="Example of mapping secret keys from &#x22;smtp-config&#x22; secret to countryconfig service"><code class="lang-yaml">countryconfig:
      secrets:
        smtp-config:
          - ALERT_EMAIL
          - SENDER_EMAIL_ADDRESS
          - SMTP_HOST
          - SMTP_PASSWORD
          - SMTP_PORT
          - SMTP_SECURE
          - SMTP_USERNAME
    </code></pre>
