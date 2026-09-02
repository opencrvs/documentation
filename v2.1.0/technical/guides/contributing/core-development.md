# Core development

This page describes how to contribute changes to [opencrvs-core](https://github.com/opencrvs/opencrvs-core). It assumes you already have a running OpenCRVS installation; see the setup guides if not.

The reference country configuration and the end-to-end test suite live inside `opencrvs-core` as packages, so a task that once needed pull requests in several repositories is now usually a single one.

### Workflow at a glance

1. Find or open a GitHub issue.
2. Create a branch, conventionally `ocrvs-<issue-number>`.
3. Make your change, with tests.
4. Open a PR against `develop` with a [conventional commit](https://www.conventionalcommits.org/) title.
5. Get CI green, request a review, and shepherd the PR until it merges.

All contributions to core are made through pull requests against the `develop` branch. Releases are cut from `develop` on a cadence, so anything merged will ship in the next release.

### 1. Start from a linked issue

We strongly recommend that every PR is linked to a GitHub issue. This keeps a clean chain from requirement → issue → PR → release → deployment, which we rely on for traceability.

Open your issue from the [issue chooser](https://github.com/opencrvs/opencrvs-core/issues/new/choose) and pick the type that fits. The available types are described in [Contributing](./).

The one common exception is purely technical work that doesn't change behaviour — dependency upgrades, for example — where an issue is optional.

### 2. Branch naming

Create your branch from the latest `develop` when contributing to the upcoming minor release, or from `release/<number>` for a hotfix to an existing release.

```
git checkout develop
git pull
git checkout -b ocrvs-<issue-number>
```

`ocrvs-<issue-number>` is a recommended default, not an enforced rule. The one thing to keep in mind is that a change also needing work in [`opencrvs/e2e`](https://github.com/opencrvs/e2e) requires a branch of the same name there (See *Related repositories* below).

### 3. Make the change

#### Which country configuration do I change?

Core ships two country configuration packages. They serve different purposes, and a change to configuration behaviour or to user-facing copy usually belongs in **both**.

| | [`packages/testland`](https://github.com/opencrvs/opencrvs-core/tree/v2.1.0-beta/packages/testland) | [`packages/countryconfig-template`](https://github.com/opencrvs/opencrvs-core/tree/v2.1.0-beta/packages/countryconfig-template) |
| ------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| What it is          | The reference country configuration                                                                 | The scaffolding template                                                                                                         |
| In local dev        | Starts by default with `pnpm dev`; pass `--no-testland` to run your own country config instead       | Never runs — it is excluded from `start` and `start:prod`                                                                        |
| What depends on it  | End-to-end tests, CI feature environments, seed data                                                | `@opencrvs/create-countryconfig`, which implementers use to scaffold a new country configuration                                  |

Rule of thumb: change **testland** so that end-to-end tests and feature environments exercise your change, and change **countryconfig-template** so that newly scaffolded country configurations get it too. CI enforces this pairing for translations, but for nothing else — so it is on you to check.

#### Tests

Almost every core contribution touches at least one of three kinds of test:

* **Unit tests** for business logic, front and backend
* **Storybook interaction tests** for component behaviour
* **End-to-end tests** in [`packages/testland/e2e`](https://github.com/opencrvs/opencrvs-core/tree/v2.1.0-beta/packages/testland/e2e), for user-facing functional changes

Prefer real assertions over snapshots — a snapshot that future contributors blindly regenerate doesn't catch much.

Before writing an end-to-end test, read [How to write a test (that is not flaky)](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0-beta/packages/testland/e2e/HOW-TO-WRITE-A-TEST.md), which documents the helpers that keep tests reliable when the suite runs in parallel. The [e2e README](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0-beta/packages/testland/e2e/README.md) covers running the suite locally or against a deployed environment and walks through debugging a CI failure, and [SHARDING.md](https://github.com/opencrvs/opencrvs-core/blob/v2.1.0-beta/packages/testland/e2e/SHARDING.md) explains how the suite is split across CI.

#### Related repositories

Infrastructure changes might require companion pull requests in the following repositories:

* [**`opencrvs/e2e`**](https://github.com/opencrvs/e2e) — owns the workflow that deploys your branch to a feature environment and runs the end-to-end suite against it. Core resolves which branch of that repository to use: a branch matching your PR's head branch if one exists, otherwise one matching your PR's base branch, otherwise `develop`. Give your branch there the same name as core's and it is picked up automatically; with nothing to add, the fallback covers you and you do nothing.
* [**`opencrvs-testland-infrastructure`**](https://github.com/opencrvs/opencrvs-testland-infrastructure) — environment definitions for the testland deployments, which might need the same changes as the e2e repo. The branch does not have to share the same branch name, though naming it the same does no harm.

### 4. Open the pull request

#### Title

Use a [conventional commit](https://www.conventionalcommits.org/) title, scoped to the package you changed:

```
feat(events): limit user.list input to 100 ids
fix(client): truncate long location names in LocationPicker
chore(testland): refresh e2e shard weights
```

The scope matters more in a monorepo than it used to — it tells a reader which package a change lands in without opening the diff.

#### Description

Write a **concise** summary of what's changing and why, and link the issue it closes. Please avoid long AI-generated descriptions — short and accurate is more useful than long and generic. Screenshots or short screen recordings are very welcome; they help reviewers verify the change has actually been exercised.

#### Changelog

A relevant changelog entry should be added to `CHANGELOG.md`, a bot comments on any PR that doesn't.

The changelog is read by country implementers, who are not always familiar with OpenCRVS internals. Keep entries high-level and avoid references to internal code. For each entry, answer:

* What's new?
* Why was the change made?
* Why should I care?

If the change is breaking, include a migration guide answering "what do I need to do to upgrade?".

#### CI

Make sure all checks pass before requesting a review. You can also request a first pass from GitHub Copilot — this catches obvious issues early and saves reviewer time.

Two labels change what CI does with your PR:

* **`Skip e2e`** — runs lint and unit tests only, for faster feedback while iterating. Remove it before merging, or your change merges without the end-to-end suite ever having run.
* **`🔒 Keep e2e`** — keeps your feature environment's namespace alive beyond the scheduled cleanup. Feature environments are **not** torn down when tests fail; they live for at least three hours before a cron job collects them, which is enough for most debugging. You only need this label for the rarer case of a long-lived environment. It is removed automatically when the PR merges.

#### Reviewers

Request a review from one or more core contributors. You'll typically get a faster response if you also reach out directly on Slack or in person — a review request that's only visible in GitHub is easy to miss.

### 5. Your PR is yours until it merges

You're responsible for your PR through to merge. That means responding to review comments, rebasing or resolving conflicts against `develop`, and keeping CI green as the branch evolves.

{% hint style="warning" %}
PRs with 100s of changed files and many commits may be rejected outright.  You may need to split your feature into multiple PRs.
{% endhint %}

A PR that goes quiet is labelled `Stale` after 20 days and closed automatically after 30. If yours is stalled because you're waiting on something from us, ping a reviewer — we'd rather unblock you than have the PR time out.

***

Once your PR merges into `develop`, or the appropriate release branch, it will be included in the next release. Thanks for contributing.
