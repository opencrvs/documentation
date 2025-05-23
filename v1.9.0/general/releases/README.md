# Releases

### **OpenCRVS Release Calendar**

The OpenCRVS Core team issue product releases once every 4 months with each release receiving 6 months of bug fix (hotfix) support.

{% embed url="https://www.figma.com/board/E7EHoztOf2hJEmsybO1kro/Releases%2C-Quality-Assurance-%26-Quality-gates?node-id=36-333&t=aTwRRNS3Mrhn6slM-1" %}

### **OpenCRVS Semantic Versioning**

| Version label                | Version number              | Description                                                                                                                                                                                                                                                                    | QA strategy                                                                                                                                                                                                                                                                 | Frequency      | Supported for                |
| ---------------------------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------- |
| Core: Major (breaking)       | n.0.0 (e.g. 2.0.0)          | <p>Major architectural redesign, including often non-backwards compatible, significant functional and design changes.<br>Impacts Core + Country Resource Package + Infrastructure release.</p>                                                                                 | <p>Creation of new test cases for new functionality.<br>Complete regression test.<br>Most likely new test data generator.<br>Data migration testing.<br>End-to-end testing (Playwright).</p>                                                                                |                |                              |
| Core: Minor (breaking)       | x.n.0 (breaking) e.g. 1.2.0 | Introduces new changes which are not backward-compatible. These changes can be process related or technical and require manual upgrade steps from implementing countries.                                                                                                      | <p>Creation of new test cases for new functionality.<br>Complete regression test.<br>Possibly changes to test data generator.<br>Data migration testing.<br>End-to-end testing (Playwright).</p>                                                                            | Every 4 months | Duration of 2 minor versions |
| Core: Minor (non-breaking)   | x.n.0 (e.g. 1.2.0)          | Introduces new backwards compatible functionality. May include data structure or other changes that are automatically migrated. SIs can safely upgrade their system to this version without implementation changes in integrations or country configuration.                   | <p>Creation of new test cases for new functionality.<br>Regression test pack to be defined.<br>Potential changes to test data generator.<br>End-to-end testing (Playwright).</p>                                                                                            | Every 4 months | Duration of 2 minor versions |
| Core: Hotfix                 | x.x.n (e.g. 1.2.1)          | Bug fixes or minor internal changes such as performance optimisations. Developed in parallel with a Minor Release (which requires the same fixes applied).                                                                                                                     | <p>Specific tests to QA the defects.<br>Small regression / smoke-test to ensure nothing impacted.<br>End-to-end testing (Playwright).</p>                                                                                                                                   | Bi-weekly      | N/A                          |
| Dependant software component | x.x.0-n (e.g. 1.2.0-1)      | Includes country resource packages, integrations, data generators etc. indicating the core release with which they are compatible, including a patch suffix. Releases are otherwise independent of core releases and changes to these components do not affect core releasing. | <p>Specific tests to QA the defects.<br>Small regression / smoke-test to ensure nothing impacted.<br><br>In the case of Farajaland, latest compatible version is always deployed in conjunction with the core version being tested.<br>End-to-end testing (Playwright).</p> | N/A            | N/A                          |

### **OpenCRVS Gitflow and "Quality Gates"**

We follow the "[Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)" branching model with a "Quality Gate" concept (which defines specific quality assurance flows for features, stable releases and hotfixes). It is imperative that implementers understand the concept of "Gitflow" when either contributing to core or merging in updates from the Farajaland country configuration package.

{% embed url="https://www.figma.com/board/E7EHoztOf2hJEmsybO1kro/Quality-Assurance-%26-Quality-gates?node-id=3-156&t=hywxqudS6k3j9B0u-1" %}

Referring to the Gitflow and Quality Gate diagrams, you should be able to understand the following:

A "stable" release has undergone not only automated testing but manual regression testing.

Any git hash tagged Dockerhub image is a new "feature" that has been recently merged into the active and unstable develop branch. These images are not in an official table release but available to experimenters and the core development team nonetheless.

OWASP security penetration tests by a CREST certified 3rd party occur once every 12 months or on every major release.

{% embed url="https://www.figma.com/board/E7EHoztOf2hJEmsybO1kro/Quality-Assurance-%26-Quality-gates?node-id=0-3&t=yrVF2ZewH8FG0Umf-1" %}

### **OpenCRVS Upgrade Process**

The following video demonstrates the process of upgrading OpenCRVS using a real-world example where a country is upgrading a non-breaking hotfix release version.

{% embed url="https://youtu.be/fqc12Qx3eyg" %}
