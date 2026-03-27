# Quality assurance

### 1. Introduction

Quality Assurance (QA) is the systematic process of ensuring that your OpenCRVS configuration is fully tested and ready for live use. While the OpenCRVS Core Product has been rigorously tested to ensure that all functionality is reliable across a variety of devices and connectivity levels, it is essential that you conduct your own testing prior to releasing the application to users.

OpenCRVS has been thoroughly tested to ensure:

* **Functional reliability** — all core features work as designed.
* **Device compatibility** — the application works on a variety of devices and browsers.
* **Connectivity resilience** — the application can handle various levels of connectivity, including offline scenarios.
* **Performance** — the minimum server configuration has been successfully stress tested with loads of up to 200 birth declarations per minute, with multiple concurrent users experiencing response times consistently less than 5 seconds.
* **Security** — independent cyber-security penetration tests have been carried out with no significant vulnerabilities found.

This section provides guidance on testing types, test cases, and procedures to ensure your configured instance meets your quality standards.

***

### 2. Why testing is essential

Although the OpenCRVS Core Product has been rigorously tested, your specific configuration or customisations require your own testing to ensure:

* **Configuration correctness** — your forms, workflows, business rules, and certificates work as designed.
* **Context-specific requirements** — the system meets your country's legal and operational requirements.
* **Performance at scale** — the system can handle your expected user load and transaction volume.
* **Security** — your deployment is protected against vulnerabilities in your specific environment.
* **User readiness** — the system is usable and meets the needs of your frontline staff.

Testing should be conducted in phases, from lab testing through field testing to wider rollout.

***

### 3. Testing types

The following testing types should be considered as part of your quality assurance process.

#### 3.1 Product test

Product tests are systematic procedures conducted to evaluate the functionality, usability, and reliability of the deployed software. These tests aim to ensure that the product meets the specified requirements and functions as per the configuration design.

**Steps:**

1. Identify test cases based on requirements and user stories.
2. Execute test cases to validate functionality, including inputs, outputs, and system behavior.
3. Document and report any defects found during testing.
4. Repeat testing iteratively as new features are added or changes are made.

#### 3.2 User Acceptance Testing (UAT)

UAT is the final phase of testing where end-users validate the software to ensure it meets their requirements and expectations before deployment. It focuses on confirming that the system behaves as intended in real-world scenarios.

**Steps:**

1. Define acceptance criteria based on user requirements.
2. Invite stakeholders or representative users to perform testing.
3. Execute test cases covering typical user workflows and scenarios.
4. Gather feedback and address any issues or discrepancies identified.
5. Obtain formal approval from stakeholders to proceed with deployment.

#### 3.3 Regression tests

Regression tests verify that recent changes to the software have not adversely affected existing functionality. These tests help maintain product stability over time by ensuring that new features or bug fixes do not introduce unintended side effects.

**Steps:**

1. Develop a comprehensive suite of regression test cases covering critical functionalities.
2. Execute regression tests after each software update or change.
3. Automate repetitive regression tests to streamline the testing process.
4. Investigate and address any failures, either due to regression issues or changes in requirements.

#### 3.4 Smoke tests

Smoke tests are preliminary tests performed to verify basic functionality and stability of the software build. They aim to quickly identify major issues that could prevent further testing or deployment.

**Steps:**

1. Select a subset of essential test cases covering core features.
2. Execute smoke tests on each new build or deployment.
3. Verify basic functionalities such as login, navigation, and critical workflows.
4. If smoke tests pass, proceed with more extensive testing or deployment; otherwise, halt further testing and address issues.

#### 3.5 Performance tests

Performance tests evaluate the responsiveness, speed, and scalability of a software application under various load conditions. These tests help identify performance bottlenecks and optimize system resources.

A set of non-functional requirements are defined which will need to be adapted to your country context.

**Steps:**

1. Define performance metrics and objectives based on user expectations.
2. Create test scenarios simulating realistic usage patterns and load conditions.
3. Use load testing tools to simulate concurrent users, transactions, or data volume.
4. Measure and analyse system response times, throughput, and resource utilization.
5. Optimise resource usage to improve performance as needed.

#### 3.6 Technical tests

Technical tests, such as failover and backup procedures, ensure the reliability and availability of the software system in the event of hardware failures, disasters, or data loss.

**Steps:**

1. Develop failover and disaster recovery plans detailing procedures for system recovery.
2. Test failover mechanisms by intentionally simulating hardware failures or network disruptions.
3. Verify backup procedures by regularly backing up critical data and restoring from backups.
4. Document and update technical tests and procedures based on system changes or improvements.
5. Conduct periodic drills or tabletop exercises to validate the effectiveness of failover and backup procedures.

#### 3.7 Penetration testing

Penetration testing involves simulating cyber-attacks on a software system and its infrastructure to identify vulnerabilities and assess its security posture. It is a mandatory testing phase before live use of OpenCRVS to mitigate risks that personally identifiable information (PII) could be accessed or misused.

This testing should be organised with an accredited partner, for example with [CREST](https://www.crest-approved.org/) and [CyberEssentials](https://www.ncsc.gov.uk/cyberessentials/overview) certification.

**Steps:**

1. Define objectives, scope, and rules of engagement for the test.
2. Gather information about target systems and potential vulnerabilities.
3. Assess identified weaknesses for potential exploitation.
4. Attempt to exploit vulnerabilities to gain unauthorized access.
5. Document findings and provide recommendations for strengthening security.

{% hint style="warning" %}
**Mandatory before go-live** — Penetration testing is mandatory before launching OpenCRVS for live use. This protects citizen data and ensures regulatory compliance.
{% endhint %}

***

### 4. Test case repository

The OpenCRVS testing team has developed a set of testing assets that can be used to support your own testing needs.

#### Test case resources

* [**OpenCRVS Test Case Repository**](https://docs.google.com/spreadsheets/d/1ifIdSu7z3DKs1PPI2H28Qab8tY1Fnn78QCYsuBQWqDw/edit?gid=0#gid=0) — contains all of the test cases used for testing the core product, which can be reused or modified for your own testing purposes.
* [**Regression Test Report**](https://docs.google.com/spreadsheets/d/1hoFtm6ZesYDX_weGsd48HyCfwtaSsbDsifZScz6dQAA/edit?gid=0#gid=0) — regression test results on web-online and sanity tests on mobile-offline.

These resources provide a comprehensive starting point for developing your own test suites.

***

### 5. Configuration and release notes

OpenCRVS publishes configuration template files and release notes to help you configure your instance and stay up to date with the latest version.

Check out the [Configuration, testing and technical configuration files](../../../v1.9.0/general/releases/) for detailed guidance on configuration and version-specific documentation.

***

### 6. Raising OpenCRVS defects

If you suspect that you have discovered a defect in the OpenCRVS Core Product, please share details with the OpenCRVS team using the following procedure.

#### Where to report issues

You can view existing issues and raise new ones at [https://github.com/opencrvs/opencrvs-core/issues](https://github.com/opencrvs/opencrvs-core/issues).

#### How to prepare a defect report

Your issue will be fixed much faster if you spend about half an hour preparing it, including the exact reproduction steps and a demo.

**Steps to complete a detailed defect report:**

1. **Describe the bug** — a clear and concise description of what the bug is.
2. **Which feature of OpenCRVS does your bug concern?** — identify the module or feature affected.
3. **To reproduce** — steps required to reproduce the behavior, for example:
   * Login as a Registrar
   * Go to '...'
   * Click on '....'
   * Scroll down to '....'
   * See error
4. **Expected behavior** — a clear and concise description of what you expected to happen.
5. **Actual behavior** — describe what happened, including screenshots and video.
6. **OpenCRVS Core Version** — for example, v1.7.0 (Git branch: master / release-v1.7.0).
7. **Country Configuration Version** — for example, v1.7.0 (Git branch: master / release-v1.7.0).
8. **Device** — include:
   * OS (for example, iOS, Windows, Android)
   * Browser (for example, Chrome, Firefox, Safari)
   * Version (for example, 22)
9. **Possible fixes** — if you can, link to the line of code that might be responsible for the problem.

Following this format ensures that the OpenCRVS team has all the information needed to investigate and resolve the issue efficiently.
