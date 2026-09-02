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

Search through existing [issues](https://github.com/opencrvs/opencrvs-core/issues), to see if we already have an issue for this requirement.

#### Reporting bugs

If you would like to report a problem:

1. **Search existing issues** — Check [GitHub Issues](https://github.com/opencrvs/opencrvs-core/issues) to see if someone has already reported the same problem
2. **Discuss on GitHub** — Chat with us on [GitHub Discussions](https://github.com/opencrvs/opencrvs-core/discussions)



#### Step 2: Contact the OpenCRVS team

Get in touch with us by opening a [GitHub Discussion](https://github.com/opencrvs/opencrvs-core/discussions) and link to an existing issue, or create a new issue below. We need to understand:

* Whether this is truly a gap in functionality or if there is a work-around
* Your project timeline and dependencies
* Which release the feature can go into depending on our schedule



#### Step 3: Create a detailed issue

Open an issue with the correct template and complete as much information as possible.  Issues lacking in required information are unlikely to be understood.

* Issues must be written from a user perspective (we operate a human-centric approach to all user experience design)
* For non-functional requirements, a descriptive title is required
* Include [Acceptance Criteria](https://www.atlassian.com/work-management/project-management/acceptance-criteria) so that QA teams can write test cases and developers can write unit tests
* Link to your issue in the GitHub discussion

When creating a bug report, include:

* **Release number** of OpenCRVS (critical information)
* **Screenshots or screen recording** — [Loom](https://www.loom.com/) is a great tool to record a video
* **Steps to reproduce** — Include all steps required to reproduce the bug
* **Expected behavior** — Describe what should have happened
* **Actual behavior** — Describe what actually happened
* **Create a bug issue** — If you are certain this is a new, unreported bug, open an issue using the [Bug template](https://github.com/opencrvs/opencrvs-core/issues/new?template=---bug.md)

To determing bug severity and priority, in your GitHub Discussion explain:

* Your issue and the issue number
* The country implementation you are working on
* The severity of your problem
* Your project timeline and dependencies

#### Step 4: Submit test cases

Attach test cases to the issue so that we can review them and add them to our regression test plan for the specific release train and all future releases.

#### Step 5: Provide UX/UI design

Submit a UX/UI design in Figma using UI components that already exist in the components package in opencrvs-core.

If a UI component or template does not exist, discuss with us what you need and our design team can review your proposal.

#### Step 6: Await our internal triage

Every Thursday, our "Impact Expansion Team" reviews incoming community requests.  Based on your project need and our internal roadmap, we assign priority to the issue and set the release milestone.

{% embed url="https://roadmap.opencrvs.org/" %}

Clicking on a milestone tells you the due date allowing you to project plan [version upgrades](../version-upgrades.md).

We need to understand bug severity factors in order to expedite the priority of a hotfix. Please be as honest as you can in order to be respectful to all other contributors and country needs.

If your issue is triaged and a release number is **not** assigned, either there is a workaround proposed to you in GitHub discussion, or your issue is not deemed high priority enough to be included in the product. &#x20;

You can decide to fork our repositories to code what you want at any time.  But we will not support any forked code nor help debug any forked configuration without being officially engaged as a delivery partner.

#### Step 7: Break down into developer tasks

Technical architects must work with developers to write developer tasks in the ticket. Each task that contributes to the overall feature should be roughly 2 days of work. Aim to split larger tasks into smaller ones.

This helps us understand capacity and estimate overall time to develop depending on the size of your team.

#### Step 8: Begin development

The assigned milestone tells you which base branch in GitHub to use for development of your pull request.  You can begin development yourself or await for our internal development team to have capacity to commence development.

<figure><img src="../../../.gitbook/assets/Screenshot 2026-08-19 at 15.11.48.png" alt=""><figcaption><p>Issue #13246 was given the milestone 1.9.16</p></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Screenshot 2026-08-19 at 15.10.46.png" alt=""><figcaption><p>The linked pull request is based from the release/1.9.16 branch</p></figcaption></figure>

You may be required to open similar pull requests in any of `opencrvs-core`, `opencrvs-countryconfig`, `opencrvs-testland` (used for our regression testing), or `opencrvs-infrastructure` repositories depending on the requirements of the task.

Your development team can begin work on the tasks only when **all of the above steps have been completed**. The issue will be added to the release backlog and moved into a **Ready to build** status.

#### Step 9: Write tests

We operate Test-Driven-Development methodology:

* **Unit tests** for business functionality must be written (for both front and backend logic)
* **End-to-end tests** must be written for functional requirements using [Playwright](https://playwright.dev/)
* All current E2E tests are located in the [Farajaland repository](https://github.com/opencrvs/opencrvs-farajaland/tree/develop/e2e)

#### Step 10: Submit for code review

When development and tests are complete, the issue can be moved into a **Code Review** status:

1. Open a pull request and add the label **Waiting For Review**
2. Maintainers from across our community will review the issue, business requirements, code, and experience
3. Pay attention to questions and address feedback to satisfy the maintainers

#### Step 11: QA testing

Once code review is complete:

1. Your code will be merged and deployed to our QA environment
2. Our QA team will review the feature and open any associated bugs
3. Your team must resolve all associated bugs with the feature that you built
4. Once the feature is bug free, it will be merged into develop and ready for the release train

#### Step 12: Release regression testing

Once all other issues in the release train are ready, the release regression QA will commence:

* If bugs are found in this stage or in penetration testing related to your feature, your team must act quickly to resolve them
* Once regression is complete, the release will be published 🎉

**Become a maintainer** — If you successfully complete the above steps to contribute new functionality to the global community, and become a maintainer contributing to this global public good by code-reviewing other features, you will receive wonderful honour and recognition

#### License

By contributing to the OpenCRVS code, you are conforming to the terms of the [license](https://github.com/opencrvs/opencrvs-core/blob/develop/LICENSE).

***

### 5. Contribute to the security of OpenCRVS

Our mission is to ensure that **every person on the planet is recognised, protected and provided for from birth**. Keeping the sensitive personal information held in civil registration systems secure is fundamental to that mission.

By reporting potential vulnerabilities responsibly and applying security updates promptly, you help protect the details of children, parents and families—and maintain the trust placed in OpenCRVS.&#x20;

#### 5.1 Reporting vulnerabilities

If you believe you have discovered a security issue in OpenCRVS, please report it privately through **Security → Report a vulnerability** in the [`opencrvs-core`](https://github.com/opencrvs/opencrvs-core/security)[ GitHub repository](https://github.com/opencrvs/opencrvs-core/security).

Please do not post details in a public GitHub issue, Discussion or community channel. Private reporting gives our team time to investigate the issue, develop a fix and help implementations upgrade safely.

Every responsible report makes a meaningful contribution—not only to the security of the software, but also to protecting the people whose information is entrusted to OpenCRVS. Thank you for helping us maintain that trust. 🙏

#### 5.2 Join our security notification list

We are establishing a restricted notification list for:

* 🌍 Countries operating or actively implementing OpenCRVS; and
* 🛠️ System integrators formally supporting an OpenCRVS implementation.

Verified contacts may receive confidential advance notice of important security updates, giving their teams an opportunity to plan and apply an upgrade before details of the vulnerability are made public.

Because these notifications may contain sensitive information, this is not a general mailing list for individual developers or community members. Applicants will need to provide documentation confirming their organisation, their involvement in an OpenCRVS implementation and their authority to receive security information on its behalf.

#### 5.3 How to apply

To request access, please email: [team@opencrvs.org](mailto:team@opencrvs.org) and provide:

* Your name, role and organisational email address;
* The country or system integrator you represent;
* Your relationship to the OpenCRVS implementation; and
* Supporting documentation or a contact who can verify your role.

All applications will be reviewed and verified by the OpenCRVS team. Approved recipients must keep advance security information confidential and share it only with authorised colleagues responsible for securing or upgrading their implementation.

Thank you for helping us keep children’s and families’ details safe—and for contributing to a world where every person is recognised, protected and provided for from birth.

***

### 6. Community support & direct contact

#### 6.1 GitHub Community

If you need to talk to us at any time regarding technical issues or feature ideas, please join our community in [GitHub Discussions](https://github.com/opencrvs/opencrvs-core/discussions).

#### 6.2 Direct contact

For urgent matters or detailed discussions about your implementation:

* **Email:** [team@opencrvs.org](mailto:team@opencrvs.org)

