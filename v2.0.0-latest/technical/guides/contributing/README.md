# Contributing

### 1. Introduction

OpenCRVS is a digital public good for civil registration and vital statistics. The value of open-source products as digital public goods is that an active community of contributors helps to maintain and grow the product.

We need your support to ensure that every individual on the planet is recognised, protected and provided for from birth. This guide explains how you can contribute to OpenCRVS through feature requests, bug reports, and code contributions.

***

### 2. Our values

As you join the OpenCRVS community, we request that you collaborate in the spirit of our joint values.

#### Better together

We know that the impact of our combined efforts is greater than any individual effort alone. That's why we are passionate community builders, creating spaces where diverse opinions and voices come together to create smart solutions.

We nurture meaningful partnerships built on mutual trust and friendship and grounded in a shared vision of the future.

#### Open, always

We have an open attitude, ready to work on each new challenge with optimism and a fresh perspective.

We are radically transparent, openly sharing our ideas, our designs, our tools, and our code.

We are open-minded and curious. We actively listen to others then take action with integrity.

#### Because we care

We work hard because we believe profoundly in our mission.

We care deeply about the quality of our product and its implementation, knowing that it will profoundly affect people's lives.

We act with purpose and determination because we know that time is running out to ensure we leave no one behind.

***

### 3. Getting started with open source

The [Open Source Guides](https://opensource.guide/) website has a collection of resources for individuals, communities, and companies who want to learn how to run and contribute to an open source project. Contributors and people new to open source will find the following guides especially useful:

* [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
* [Building Welcoming Communities](https://opensource.guide/building-community/)

***

### 4. Requesting a new feature

If you would like to request a new feature or enhancement based on your country's requirements or for improved user experience, follow these steps:

#### Step 1: Research and identify the need

Perform detailed business analysis on the use case so that you can open a GitHub Issue with a **Feature** label (for functional requirements) or **Tech** label (for non-functional requirements).

Alternatively, search for existing issues in our [GitHub Project Backlog](https://github.com/opencrvs/opencrvs-core/issues) to see if we already have an issue for this requirement.

#### Step 2: Contact the OpenCRVS team

Get in touch with us at [**team@opencrvs.org**](mailto:team@opencrvs.org) to introduce us to your needs. We need to understand:

* Whether this is truly a gap in functionality or if there is a work-around
* Your project timeline and dependencies
* Which release the feature can go into depending on our schedule

#### Step 3: Create a detailed issue

Open an issue with the [feature template](https://github.com/opencrvs/opencrvs-core/issues/new?template=---feature.md) and write the issue including [User Stories](https://www.atlassian.com/agile/project-management/user-stories).

* Issues must be written from a user perspective (we operate a human-centric approach to all user experience design)
* For non-functional requirements, a descriptive title is required
* Include [Acceptance Criteria](https://www.atlassian.com/work-management/project-management/acceptance-criteria) so that QA teams can write test cases and developers can write unit tests

#### Step 4: Submit test cases

Email the test cases to us so that we can review them and add them to our regression test plan for the specific release train and all future releases.

#### Step 5: Provide UX/UI design

Submit a UX/UI design in Figma using UI components that already exist in the components package in opencrvs-core.

If a UI component or template does not exist, discuss with us what you need and our design team can review your proposal.

#### Step 6: Break down into developer tasks

Technical architects must work with developers to write developer tasks in the ticket. Each task that contributes to the overall feature should be roughly 2 days of work. Aim to split larger tasks into smaller ones.

This helps us understand capacity and estimate overall time to develop depending on the size of your team.

#### Step 7: Begin development

Your development team can begin work on the tasks only when **all of the above steps have been completed**. The issue will be added to the release backlog and moved into a **Ready to build** status.

#### Step 8: Write tests

We operate Test-Driven-Development methodology:

* **Unit tests** for business functionality must be written (for both front and backend logic)
* **End-to-end tests** must be written for functional requirements using [Playwright](https://playwright.dev/)
* All current E2E tests are located in the [Farajaland repository](https://github.com/opencrvs/opencrvs-farajaland/tree/develop/e2e)

#### Step 9: Submit for code review

When development and tests are complete, the issue can be moved into a **Code Review** status:

1. Open a pull request and add the label **Waiting For Review**
2. Maintainers from across our community will review the issue, business requirements, code, and experience
3. Pay attention to questions and address feedback to satisfy the maintainers

#### Step 10: QA testing

Once code review is complete:

1. Your code will be merged and deployed to our QA environment
2. Our QA team will review the feature and open any associated bugs
3. Your team must resolve all associated bugs with the feature that you built
4. Once the feature is bug free, it will be merged into develop and ready for the release train

#### Step 11: Release regression testing

Once all other issues in the release train are ready, the release regression QA will commence:

* If bugs are found in this stage or in penetration testing related to your feature, your team must act quickly to resolve them
* Once regression is complete, the release will be published

\<aside> 🎉

**Become a maintainer** — If you successfully complete the above steps to contribute new functionality to the global community, and become a maintainer contributing to this global public good by code-reviewing other features, you will receive wonderful honour and recognition!

\</aside>

***

### 5. Contributing code

OpenCRVS uses [GitHub](https://github.com/opencrvs/opencrvs-core) as its source of truth. All contributors work in GitHub.

Please review the [contributing guidelines](https://github.com/opencrvs/opencrvs-core/blob/master/CONTRIBUTING.md) before submitting code.

#### License

By contributing to the OpenCRVS code, you are conforming to the terms of the [license](https://github.com/opencrvs/opencrvs-core/blob/develop/LICENSE).

***

### 6. Reporting bugs

If you would like to report a problem:

1. **Search existing issues** — Check [GitHub Issues](https://github.com/opencrvs/opencrvs-core/issues) to see if someone has already reported the same problem
2. **Discuss on GitHub** — Chat with us on [GitHub Discussions](https://github.com/opencrvs/opencrvs-core/discussions)
3. **Create a bug issue** — If you are certain this is a new, unreported bug, open an issue using the [Bug template](https://github.com/opencrvs/opencrvs-core/issues/new?template=---bug.md)

#### Bug report requirements

When creating a bug report, include:

* **Release number** of OpenCRVS (critical information)
* **Screenshots or screen recording** — [Loom](https://www.loom.com/) is a great tool to record a video
* **Steps to reproduce** — Include all steps required to reproduce the bug
* **Expected behavior** — Describe what should have happened
* **Actual behavior** — Describe what actually happened

#### Bug severity and priority

Get in touch with us by email to explain:

* Your issue and the issue number
* The country implementation you are working on
* The severity of your problem
* Your project timeline and dependencies

We need to understand these factors in order to expedite the priority of a hotfix. Please be as honest as you can in order to be respectful to all other contributors and country needs.

***

### 7. Community support

#### GitHub Discussions

If you need to talk to us at any time regarding technical issues or feature ideas, please refer to [GitHub Discussions](https://github.com/opencrvs/opencrvs-core/discussions).

#### Direct contact

For urgent matters or detailed discussions about your implementation:

* **Email:** [team@opencrvs.org](mailto:team@opencrvs.org)
* **GitHub:** [opencrvs/opencrvs-core](https://github.com/opencrvs/opencrvs-core)
