---
description: Overview of how OpenCRVS uses best-practice technology standards
---

# Standards

**We implement as per the U.N. Guidelines for Civil Registration.**

Because OpenCRVS is a core component of Digital Public Infrastructure, we are committed to conforming to interoperable data standards.

**Civil Registration standards:** [**Digital Convergence Initiative**](https://spdci.org/events/crvs-and-sp-mis-standards-released-v1-0-0/)

OpenCRVS are a [Standards Committee Member ](https://standards.spdci.org/standards/v/crvs-v1.0-1/resources/standards-committee)of the Digital Convergence Initiative, [CRVS and SP-MIS](https://standards.spdci.org/standards/v/crvs-v1.0-1/crvs/crvs-with-sp-mis-standards) interfaces. We helped author these standards and interoperate with social protection systems such as [OpenSPP](https://openspp.org/).

**DPI standards:** [Centre for Digital Public Infrastructure](https://cdpi.dev/) - [G2PConnect](https://g2pconnect.global/)

OpenCRVS has contributed to and conforms to the G2PConnect [standardised API](https://github.com/opencrvs/dci-crvs-api) using the DCI payloads above.

**Healthcare standards:** By using FHIR as a standard for our NoSQL datastore, Hearth and OpenCRVS compatibility with OpenHIE standard interoperability layer OpenHIM, OpenCRVS seamlessly connects civil registration to health services. We can receive birth and death notifications from the hospital setting and expose registration events to any other technical system, such as National ID, via our FHIR standard API gateways.

[FHIR](https://hl7.org/FHIR/) was created by [Health Level Seven International (HL7)](http://hl7.org/), a not-for-profit, ANSI-accredited, standards organization dedicated to providing a comprehensive framework and related standards for the exchange, integration, sharing and retrieval of electronic health information that supports clinical practice and the management, delivery and evaluation of health services.

We have extended FHIR's model to include custom codes and extensions that assist the Civil Registration context. To understand more about how and why we use FHIR, click [here](fhir-documents/).

**Other:** Systems can interoperate with OpenCRVS using FHIR or via Webhooks which follow WebSub process and standards. Our friends at MOSIP have demonstrated ease of integration with OpenCRVS using these methods.
