---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/technology/interoperability/national-id/mosip/registration-integration
---

# Configuration

The countryconfig-mosip example contains a fully operational configuration for birth and death forms that includes:

* In-form authentication / verification with E-Signet
* Registration integration with MOSIP

{% embed url="https://github.com/opencrvs/opencrvs-countryconfig-mosip" %}

Helper functions that wrap your form components are written and contained within the opencrvs/mosip library for inclusion using package.json

{% embed url="https://github.com/opencrvs/mosip" %}

The mosip-api middleware is the key Docker container that must be deployed and configured with appropriate secrets to communicate with both E-Signet & MOSIP.

{% embed url="https://github.com/opencrvs/mosip/tree/main/packages/mosip-api" %}





