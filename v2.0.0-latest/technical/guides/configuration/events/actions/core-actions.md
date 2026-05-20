---
description: Configuring core actions
---

# Core actions

Core actions are actions defined by the OpenCRVS core and all event types implement these actions.

### Configurable action types

The action types listed in the schema table below must be configured in the `actions` array.

Other core action types (for example `ActionType.ASSIGN`, `ActionType.CREATE`) are strictly defined by the system and are not configured.

### Core action config schemas

{% openapi-schemas spec="events-develop" schemas="ReadActionConfig,DeclareActionConfig,EditActionConfig,RejectActionConfig,RegisterActionConfig,PrintCertificateActionConfig,RequestCorrectionActionConfig,ArchiveActionConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}
