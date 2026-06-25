# Forking the repos

## Forking the OpenCRVS Country Configuration

The first step towards creating your own country configuration is to fork the OpenCRVS country configuration template, which is based on the demonstration country **Farajaland**.

Repository:

`https://github.com/opencrvs/opencrvs-countryconfig`

The following steps explain how to create your own fork and prepare it for configuring your country's implementation.

### 1. Pre-fork preparation

Before creating your fork, ensure the following prerequisites are met.

#### Use a GitHub Organisation

The country configuration repository should be forked into a **GitHub Organisation**, not a personal GitHub account.

Your organisation should:

* use a **GitHub Team** or **Enterprise** plan (required for branch protection rules)
* grant you **Administrator** permissions on the repository

Using an organisation simplifies collaboration, governance and access management throughout the lifetime of the project.

#### Choose a repository name

When you installed OpenCRVS locally, the `setup.sh` script cloned the Farajaland country configuration repository into the same parent directory as `opencrvs-core`.

Rename this local directory to represent your own country implementation.

We recommend the following naming convention:

```
opencrvs-<country-name>
```

For example:

```
opencrvs-rwanda
opencrvs-sierra-leone
opencrvs-fiji
```

Using a consistent naming convention makes it easier to manage multiple country configurations.

#### Plan your branching strategy

We recommend adopting a Gitflow-style branching strategy to separate development, testing and production releases.

| Branch               | Purpose                                |
| -------------------- | -------------------------------------- |
| `main` (or `master`) | Production-ready country configuration |
| `develop`            | QA or staging configuration            |
| `feature/*`          | New configuration work                 |
| `hotfix/*`           | Urgent production fixes                |

This allows configuration changes to be developed independently, tested in the `develop` branch and promoted to `main` only when approved.

#### Define repository governance

Before development begins, configure your repository permissions.

This typically includes:

* adding implementation team members
* assigning code reviewers
* identifying repository administrators
* granting DevOps engineers appropriate deployment permissions

***

### 2. Fork the template repository

Navigate to the OpenCRVS Country Configuration repository:

`https://github.com/opencrvs/opencrvs-countryconfig`

Select **Fork** and choose your GitHub Organisation as the destination.

Clone your new repository locally:

```
git clone git@github.com:<your-org>/opencrvs-<country-name>.git
cd opencrvs-<country-name>
```

Next, add the official OpenCRVS repository as an upstream remote:

```
git remote add upstream https://github.com/opencrvs/opencrvs-countryconfig.git
```

Maintaining an upstream remote allows you to pull future improvements from the OpenCRVS template as new releases become available.

***

### 3. Configure branch protection

To protect your production configuration and enforce code review, configure branch protection rules for your repository.

Navigate to:

**Settings → Branches → Add Branch Protection Rule**

Create a protection rule for the `main` branch (and optionally `develop`) with the following recommended settings:

* Require pull request reviews before merging
* Require status checks to pass before merging (when CI is configured)
* Require signed commits (recommended)
* Restrict who can push directly to protected branches

Once configured, test the protection rules by creating and merging a test pull request.

Branch protection helps ensure that all configuration changes are reviewed, validated and traceable before they are deployed.
