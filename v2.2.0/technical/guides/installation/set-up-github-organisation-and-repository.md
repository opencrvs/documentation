# Set up GitHub organisation and repository

The GitHub organisation that hosts your OpenCRVS country configuration repository holds the keys to your production deployment. It controls the CI/CD workflows, the environment secrets, the infrastructure-as-code, and the ability to deploy.

Before you deploy OpenCRVS to a server, set up the GitHub organisation and the country configuration repository as described on this page. If you have not created a country configuration yet, follow the [Quick Start](quick-start.md).

#### 1. Use a GitHub organisation

Store the country configuration repository in a **GitHub organisation**. Do not store it in a personal GitHub account.

The GitHub organisation must:

* Use a GitHub [**Team** or **Enterprise**](https://github.com/pricing) plan. You need this plan for branch protection rules and GitHub Actions minutes.
* Give you **Administrator** permissions on the repository.

A GitHub organisation makes collaboration, governance and access management easier during the life of the project.

#### 2. Require two-factor authentication for every member

Treat the compromise of one member account as the compromise of your production environment. Apply controls at organisation level.

Enable two-factor authentication (2FA) enforcement for the whole organisation. Then no member, outside collaborator or owner can access the organisation without a second factor.

When you enable enforcement, GitHub removes the existing members who do not have 2FA configured. Tell the team before you start. Plan a short grace period.

GitHub documentation: [Requiring two-factor authentication in your organization](https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-two-factor-authentication-for-your-organization/requiring-two-factor-authentication-in-your-organization).

#### 3. Create and push source code to repositories

By default toolkit will create 2 repositories for you:
- `<country-name>-countryconfig`: keep countryconfig source code and other customisations including workflow files for Docker image build, etc.
- `<country-name>-infrastructure`: keep infrastructure code and configuration including provision, deployment and maintance workflows.

#### 4. Plan your branching strategy

Use a Gitflow-style branching strategy to separate development, testing and production releases.

| Branch               | Purpose                   |
| -------------------- | ------------------------- |
| `main` (or `master`) | Deployment configuration  |
| `develop`            | Development configuration |

With this strategy, you develop configuration changes independently and test them in the `develop` branch. You promote them to `main` only after approval.

#### 5. Define repositories governance

Before development begins, configure the repository permissions.

This typically includes these tasks:

* Add the implementation team members.
* Assign code reviewers.
* Identify the repository administrators.
* Give DevOps engineers the permissions to deploy.

#### 6. Require reviewed pull requests on protected branches

Protect your production configuration and enforce code review. Configure a branch protection rule (or repository ruleset) on these branches:

* The default branch, typically `main`.
* Each branch that you use to deploy to a production environment.
* Optional: the `develop` branch.

To create a branch protection rule, go to:

**Settings → Branches → Add Branch Protection Rule**

Include these settings as a minimum:

* Require a pull request before merging. Do not allow direct pushes to the protected branch.
* Require at least 2 approving reviews from organisation members before a pull request can be merged.
* Require status checks to pass before merging. As a minimum, require the CI test suite.

We recommend that you also require signed commits.

When the rule is configured, create and merge a test pull request to test the protection rules.

Branch protection makes sure that all configuration changes are reviewed, validated and traceable before you deploy them.

GitHub documentation: [About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) and [Managing rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets).
