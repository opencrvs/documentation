---
description: >-
  Our vision for future OpenCRVS versions and the technical changes we need to
  achieve
---

# Projects & milestones

The intent for documentation is to

* Describe our vision for future versions of OpenCRVS&#x20;
* Steer technical design
* Track and visualise the progress and direction of our long-term architecture projects





```mermaid fullWidth="true"
gantt
    dateFormat  YYYY-MM-DD
    title       Long-term progress and milestones
    axisFormat %Y/%m

    section Deprecating Hearth & OpenHIM
    v1.3.0 :milestone, 2023-10-03, 2023-10-03
    State transitions / Workflow event refactor            :active,     2023-10-03, 2024-03-01
    Create a Hearth-bypassing record read service :done, 2023-10-03, 2023-11-01
    Reusable OpenCRVS -> FHIR transformer :done, 2023-11-01, 2023-12-01
    Define OpenCRVS models & read OpenCRVS models:, 2024-01-01, 2024-03-01
    Bypass Hearth in write endpoints, write directly to hearth-dev :, 2024-03-01, 2M
    Define OpenCRVS MongoDB collections for records & metadata,: 1M
    Read & write data in OpenCRVS format,: 2M
    FHIR removed from internal architecture :milestone,:
　　 OpenCRVS -> FHIR API: 2M
    section Rich form field configuration
    v1.4.0 :milestone, 2024-03-01, 2024-03-01
    Research approach :active, 1M
    Create link between submitted data and form configuration: 1M
    Customisable analytics fields :milestone,
    Configurable id fields :milestone,
    Create link between stored data and form configuration: 1M
    Country can label a field as PII :milestone,
```

###











