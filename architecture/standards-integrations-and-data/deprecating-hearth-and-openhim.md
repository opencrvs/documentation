---
description: >-
  Effort to replace both OpenHIM and Hearth with solutions that are safer in
  terms of data security, more performant for our data and integrations needs
  and more fitting for our specific use case.
---

# Deprecating Hearth & OpenHIM

**Why is this important**

* **Modularity & integrations:** Moving the FHIR layer outside the core business logic will make OpenCRVS more prepared to integrate with other healthcare standards and interfaces such as MOSIP and GovStack.
* **Security:** Hearth is the primary database of OpenCRVS, however it hasn't been updated in many years and exposes OpenCRVS to security risks we cannot accurately quantify. We do not really understand how it's built and it doesn't have a community behind if
* **Performance:** The database structure enforced by Hearth significantly increases complexity. This has caused performance issues in relatively small deployments of OpenCRVS. The added complexity also significantly increases feature development time and defects.&#x20;
* **Onboarding new developers:** Because of its unnecessary complexity, it's one of the most difficult to understand for new developers. From our experience even professional developers with years of job experience struggle with the number of data models we have in use.



### Diagrams

* [Data architecture changes in steps](https://ng.myschenker.fi/npseuranta/tracking.aspx?id=888003748405)

### Status 

```mermaid fullWidth="true"
gantt
    dateFormat  YYYY-MM-DD
    title       OpenHIM/Hearth deprecation
    axisFormat %Y/%m

    section Progress
    v1.3.0 :milestone, 2023-10-03, 2023-10-03
    State transitions / Workflow event refactor            :active,     2023-10-03, 2024-03-01
    Create a Hearth-bypassing record read service :done, 2023-10-03, 2023-11-01
    Reusable OpenCRVS -> FHIR transformer :done, 2023-11-01, 2023-12-01
    v1.4.0 :milestone, 2024-03-01, 2024-03-01
    Define OpenCRVS models & read OpenCRVS models:, 2024-01-01, 2024-03-01
    Bypass Hearth in write endpoints, write directly to hearth-dev :, 2024-03-01, 2M
    Define OpenCRVS MongoDB collections for records & metadata,: 1M
    Read & write data in OpenCRVS format,: 2M
    FHIR removed from internal architecture :milestone,:
　　 OpenCRVS -> FHIR API: 2M
```
