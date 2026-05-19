---
description: Configuring core actions
---

# Core actions

Core actions are actions defined by the OpenCRVS core and all event types implement these actions.

### Configurable action types

The action types listed in the schema table below must be configured in the `actions` array.

Other core action types (for example `ActionType.ASSIGN`, `ActionType.CREATE`) are strictly defined by the system and are not configured.



\<TODO>: remove table?

| Type                            | Typical use                                                                                               |
| ------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `ActionType.READ`               | Record-tab content                                                                                        |
| `ActionType.DECLARE`            | Submit a new declaration (includes `review` fields). This config is also shared with `ActionType.NOTIFY`. |
| `ActionType.EDIT`               | Edit record before registration                                                                           |
| `ActionType.REJECT`             | Reject a record before registration                                                                       |
| `ActionType.REGISTER`           | Register the record                                                                                       |
| `ActionType.PRINT_CERTIFICATE`  | Print a certificate                                                                                       |
| `ActionType.REQUEST_CORRECTION` | Request a correction on a registered record                                                               |
| `ActionType.ARCHIVE`            | Archive a record                                                                                          |

### Core action config schemas

{% openapi-schemas spec="events-develop" schemas="ReadActionConfig,DeclareActionConfig,EditActionConfig,RejectActionConfig,RegisterActionConfig,PrintCertificateActionConfig,RequestCorrectionActionConfig,ArchiveActionConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
