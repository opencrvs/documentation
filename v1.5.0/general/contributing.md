---
description: How to contribute to the Digital Public Good for CRVS
---

# Contributing

The value of open-source products as digital public goods is that an active community of contributors will help to maintain and grow the product.

The [Open Source Guides](https://opensource.guide/) website has a collection of resources for individuals, communities, and companies who want to learn how to run and contribute to an open source project. Contributors and people new to open source will find the following guides especially useful:

* [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
* [Building Welcoming Communities](https://opensource.guide/building-community/)

We need your support to ensure that every individual on the planet is recognised, protected and provided for from birth. In this video we explain our product backlog, how to submit issues and how to contribute code.

{% embed url="https://youtu.be/PgwuIWDemCo" %}

## Requesting a new feature <a href="#working-on-opencrvs-code" id="working-on-opencrvs-code"></a>

If you would like to request a new feature or enhancement based on your country's requirements or for improved user / developer experience read the following steps closely.



1. Perform detailed business analysis on the use case so that you can open a Github "Issue" with a "Feature" (for functional requirements) or "Tech" (for non-functional requirements) label.  Alternatively search for existing issues in our Github Project Backlog to see if we already have an issue for this that you will be requiring.
2. Get in touch with us at team@opencrvs.org to introduce us to your needs so that we can understand if this truly is a gap in functionality or if there is a work-around that may suffice.  We will need to understand your project timeline and dependencies in order to evaluate which release the feature can go into depending on our schedule.
3. Open an issue with [t](https://github.com/facebook/docusaurus/issues/new?template=feature.md)he [feature template](https://github.com/opencrvs/opencrvs-core/issues/new?assignees=\&labels=%E2%98%95%EF%B8%8F+Discussion\&template=---feature.md\&title=) and write the issue following [Agile Scrum](https://www.scrum.org/resources/what-scrum-module) User Story methodology.&#x20;
4. Issues must be written from a user perspective as we operate a human-centric approach to all user experience design.&#x20;
5. For non-functional requirements, a descriptive title is required.  The issue must include Agile Scrum Acceptance Criteria so that your Quality Assurance engineering team can write Test Cases and so that your developers can write unit tests that cover the business functionality.
6. Email the Test Cases to us so that we can review them and add them to our regression test pack in Test Cafe for the specific release train and all future releases.
7. Submit a UX/UI design in Figma using UI components that already exist in the "components" package in opencrvs-core.  If a UI component or template does not exist, you should discuss with us what you need and our design team can review your proposal.
8. Technical architects must work with developers to write developer tasks in the ticket.  Each task that contributes to the overall feature should be roughly 2 days of work. We use a points score of 3 points per technical task.  This helps us to understand capacity and estimate overall time to develop depending on the size of your team.
9. Your development team can begin work on the tasks only when ALL of the above steps have been completed.  The issue will be added to the release backlog and moved into a "Ready to build" status
10. We operate Test-Driven-Development methodology.  Unit tests for business functionality must be written (for both front & back end logic).  We expect at least 80% test coverage on your pull request.
11. For functional requirements, an end-to-end test must be written.  We are currently using Cypress for this.  Our development team can guide you how to set up Cypress and show you where tests must be written.
12. When steps 9-11 are complete, the issue can be moved into a "Code Review" status. Open a pull-request and add the label "Waiting For Review".  Maintainers from across our community will review the issue, business requirements and check your code and experience in order to decide if the acceptance criteria have been met. Pay attention to questions and address feedback to satisfy the maintainers.
13. Once code review has completed your code will be merged and deployed to our QA environment.  Your QA team can review the feature and open any associated bugs.  Your team must resolve all associated bugs with the feature that you built.
14. Once the feature is bug free, it will be merged into develop and ready for the release train.
15. Once all other issues in the release train are ready, the release regression QA will commence.  If more bugs are found in this stage or in penetration testing related to your feature, your team must act quickly to resolve them.  Once regression is complete, the release will be published.

We sincerely look forward to welcoming you to our maintainer community.  If you successfully complete the above steps to contribute new functionality to the global community, and become a maintainer contributing to this global public good, code-reviewing other fetaures that are raised, you will receive wonderful honour! &#x20;

## Contributing code <a href="#working-on-opencrvs-code" id="working-on-opencrvs-code"></a>

OpenCRVS uses [GitHub](https://github.com/opencrvs/opencrvs-core) as its source of truth. All contributors work in Github. Please review the [contributing](https://github.com/opencrvs/opencrvs-core/blob/master/CONTRIBUTING.md) file.

### License <a href="#gitter" id="gitter"></a>

By contributing to the OpenCRVS code, you are conforming to the terms of the[ license](https://github.com/opencrvs/opencrvs-core/blob/develop/LICENSE).

### Github Discussions <a href="#gitter" id="gitter"></a>

If you need to talk to us at any time regarding technical issues or feature ideas please refer to [Github Discussions](https://github.com/opencrvs/opencrvs-core/discussions).&#x20;

### Reporting bugs <a href="#reporting-new-issues" id="reporting-new-issues"></a>

If you would like to report a problem, search in existing Github Issues and see if someone has already opened an issue regarding the same problem and chat with us on [Github Discussions](https://github.com/opencrvs/opencrvs-core/discussions).&#x20;

If you are certain this is a new, unreported bug, you can submit a bug issue. Open an issue and add the label "Bug".  Use the "Bug" template and complete all the required information.  Critical information includes the release number of OpenCRVS.

Take screenshots or record your screen. [Loom](https://www.loom.com/) is a great tool you can use to record a video and paste a link to it into your bug.&#x20;

Include all the steps required to reproduce the bug and describe the expected behaviour that did not occur.

Get in touch with us by email to explain your issue, the country implementation you are working on, include the issue number, and explain the severity of your problem.  We need to understand your project timeline and dependencies in order to expedite the priority of a hot-fix.  Please be as honest as you can in order to be respectful to all other contributors and country's needs.

