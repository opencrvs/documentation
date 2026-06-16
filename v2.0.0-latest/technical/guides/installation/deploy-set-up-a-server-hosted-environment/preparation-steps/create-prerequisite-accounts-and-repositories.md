# Create prerequisite accounts and repositories

### 1. Ongoing costs of additional services

OpenCRVS is hardcoded to use the following 3rd party services which require subscriptions. The cost of these services is negligible, industry standard and promotes best practice developer operations experience.

1. A docker container registry [**organisation**](https://docs.docker.com/admin/organization/orgs/) account on [Dockerhub](https://hub.docker.com/) for hosting OpenCRVS Country config images.
2. An organisation Github account in a minimum of a ["Team"](https://github.com/pricing) plan to configure automated provisioning and CI/CD for the require repositories explained below.
3. System alerts can be broadcast to an email address. It's usually important that alert notifications are not silo-ed to a single individual for auditing purposes, therefore it is optional, but recommended to have a team messaging system such as Slack to receive these notifications: A Slack Pro account [https://app.slack.com/plans](https://app.slack.com/plans)
4. Application bug reports can be delivered to a [Sentry](https://sentry.io/welcome/) Team account. A free plan is fine for development / proof-of-concept, or if you are less worried about report volume and longevity.
5. Critical server secrets and passwords are created when initialising an environment and creating National System Admin users. A password manager such as 1Password Team [https://1password.com/business-pricing](https://1password.com/business-pricing) or Bitwarden Team [https://bitwarden.com/pricing](https://bitwarden.com/pricing) is an industry standard location to store such secrets safely, providing sufficient governance.

### 2. Set up an individual and an organisation account on Dockerhub

{% hint style="info" %}
A DockerHub account is required as the registry for the countryconfig docker image.
{% endhint %}

You will need your DockerHub **username** and a personal DockerHub account **access tokens** as secrets. Our scripts use these credentials to login to DockerHub programmatically. This is how you create a DockerHub access token: [https://docs.docker.com/security/for-developers/access-tokens/](https://docs.docker.com/security/for-developers/access-tokens/)

### 3. Create companion service accounts for monitoring and notifications

{% hint style="info" %}
This step is optional, but recommended
{% endhint %}

Our code includes optional integration with [Sentry](https://www.sentry.io) for error tracking. To take advantage, create a NodeJS project in Sentry for the environment you want to monitor.

In the Sentry project settings, select "Client Keys", and **copy the DSN property**. You will use this as the `SENTRY_DSN` secret later.

Any service error whether caught or uncaught will be visible in application logs that you can monitor in Kibana. Any hardware alert will be broadcast via elastalert to an email account configured using the `ALERT_EMAIL` environment secret.

If you wish to collate service and hardware errors into a single location you can configure Sentry Alert Rules and email forwarding from `ALERT_EMAIL` to the same location, such as a Slack or GChat Channel via an email re-direct.

The benefits of using a shared messaging platform like Slack, are that your entire development and quality assurance team can receive these notifications without a single individual becoming a bottleneck.

Notifications are sent by email by default, so you should configure SMTP settings. The `SENDER_EMAIL_ADDRESS` environment secret stores the email address used as the sender for automated system emails.

Notification gateways via SMS or other platform such as WhatsApp are configurable in countryconfig code.

### 4. Enforce two-factor authentication and PR approvals on your GitHub organisation

The GitHub organisation hosting your opencrvs-countryconfig fork holds the keys to your production deployment: CI/CD workflows, environment secrets, infrastructure-as-code, and the ability to deploy. Treat compromise of a single member account as compromise of your production environment, and apply organisation-level controls accordingly.

#### 4.1 Require two-factor authentication for every member

Enable organisation-wide 2FA enforcement so that no member, outside collaborator, or owner can access the org without a second factor. Existing members who do not have 2FA configured will be removed when enforcement is enabled, so plan a short grace period and notify the team first.

&#x20;GitHub's documentation: [Requiring two-factor authentication in your organization](https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-two-factor-authentication-for-your-organization/requiring-two-factor-authentication-in-your-organization).

#### 4.2 Require reviewed pull requests on protected branches

Configure a branch protection rule (or repository ruleset) on the default branch — typically main — and on any branch used to deploy to a production environment, with at least the following:

* Require a pull request before merging — direct pushes to the protected branch are disallowed.
* Require at least 2 approving reviews from organisation members before a PR can be merged.
* Require status checks to pass before merging — at minimum the CI test suite.

GitHub's documentation: [About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) and [Managing rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets).
