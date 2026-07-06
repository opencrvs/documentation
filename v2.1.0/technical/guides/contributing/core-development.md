# Core development

This page describes how to contribute changes to [opencrvs-core](https://github.com/opencrvs/opencrvs-core). It assumes you already have a running OpenCRVS installation; see the setup guides if not.

### Workflow at a glance

1. Find or open a GitHub issue.
2. Create a branch named `ocrvs-<issue-number>`.
3. Make your change with tests.
4. Open a PR titled `[OCRVS-<issue-number>] <short description>` against `develop`.
5. Get CI green, request a review, and shepherd the PR until it merges.

All contributions to core are made through pull requests against the `develop` branch. Releases are cut from `develop` on a cadence, so anything merged will ship in the next release.

### 1. Start from a linked issue

We strongly recommend that every PR is linked to a GitHub issue. This keeps a clean chain from requirement → issue → PR → release → deployment, which we rely on for changelog generation and traceability.

Pick the template that fits your contribution:

* [Bug report](https://github.com/opencrvs/opencrvs-core/issues/new?template=---bug.md)
* [Feature request](https://github.com/opencrvs/opencrvs-core/issues/new?template=---feature.md)
* [User story](https://github.com/opencrvs/opencrvs-core/issues/new?template=---user-story.md)
* [Improvement](https://github.com/opencrvs/opencrvs-core/issues/new?template=--improvement.md)
* [Tech task](https://github.com/opencrvs/opencrvs-core/issues/new?template=tech-task.md)

The one common exception is purely technical work that doesn't change behaviour — dependency upgrades, for example — where an issue is optional.

### 2. Branch naming

Create your branch from the latest `develop`:

```
git checkout develop
git pull
git checkout -b ocrvs-<issue-number>
```

Using the `ocrvs-<issue-number>` convention is important when your change spans multiple repositories — we match branches by name across them (see _Cross-repository changes_ below).

### 3. Make the change

#### Tests

Almost every core contribution touches either a unit test or a Storybook test. Find the existing suite that covers the area you're changing, or add a new one. Prefer real assertions over snapshots — a snapshot that future contributors blindly regenerate doesn't catch much.

#### Cross-repository changes

OpenCRVS code is split across several repositories. If your change requires updates in more than one, open a PR in each repository using **the same branch name** (`ocrvs-<issue-number>`):

* **`opencrvs-countryconfig`** — Open a paired PR if your change requires country-config updates (for example, a new configuration option, or any user-facing copy change, which lives in the country config). Link this PR from the description of your core PR.
* **`opencrvs-farajaland`** — If your change needs e2e test updates, sync your `opencrvs-countryconfig` branch into `opencrvs-farajaland` too. Commits to a Farajaland PR also trigger the e2e pipeline, so this is where you iterate on e2e changes.

Keeping branch names identical across repositories is what lets CI find the matching counterparts.

### 4. Open the pull request

#### Title

Use the format:

```
[OCRVS-<issue-number>] Short title for the change
```

#### Description

Write a **concise** summary of what's changing and why. Please avoid long AI-generated descriptions — short and accurate is more useful than long and generic. Screenshots or short screen recordings are very welcome; they help reviewers verify the change has actually been exercised.

If you have paired PRs in `opencrvs-countryconfig` or `opencrvs-farajaland`, link them here.

#### CI

Make sure all CI checks pass before requesting a review. You can also request a first pass from GitHub Copilot — this catches obvious issues early and saves reviewer time.

#### Reviewers

Request a review from one or more core contributors. You'll typically get a faster response if you also reach out directly on Slack or in person — a review request that's only visible in GitHub is easy to miss.

### 5. Your PR is yours until it merges

You're responsible for your PR through to merge. That means responding to review comments, rebasing or resolving conflicts against `develop`, and keeping CI green as the branch evolves.

PRs that go quiet are closed automatically after 30 days. If yours is stalled because you're waiting on something from us, ping a reviewer — we'd rather unblock you than have the PR time out.

***

Once your PR merges into `develop`, it will be included in the next release. Thanks for contributing.
