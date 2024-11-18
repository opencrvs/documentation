---
description: >-
  How to think about the use of OpenCRVS as an interoperable system within a
  government's digital landscape
---

# OpenCRVS within a government systems architecture

## System Architectures

OpenCRVS has been designed to be interoperable with other systems so that it can receive and share data in an efficient and secure way. You can find more detailed technical information in the section on [interoperability](../technology/interoperability/). It is important to consider how OpenCRVS will fit within the current digital landscape so that the benefits from interoperability can be fully realised.

In the diagram below you can see a generic view of potential integration points for OpenCRVS with other systems.

<figure><img src="https://lh7-us.googleusercontent.com/udL2MsWAHswGjO2tt9ehdh24EQSgldFiaTXqeAWjXt_dKyp6KRgwzTa0ce6xx9bPSAK-lmUqZogM_ggU9fU7-0rpO2T6BK4CptgYRcjrFwgO5DueXZnYMXxpwtHRhKKbrfcXleZTa9qcSX2FmcT0tw3e-w=s2048" alt=""><figcaption><p>Interoperability within the eGov ecosystem</p></figcaption></figure>

{% embed url="https://youtu.be/rBupieEHVy0" %}

Further examples of potential integration points are available [here](https://www.opencrvs.org/product/interoperability), including interoperability with other DPGs like MOSIP and OpenSPP.&#x20;

## OpenCRVS and Digital Public Infrastructure

Similar to the way that physical infrastructure like railways and roads drives economic development and innovation, Digital Public Infrastructure (DPI) provides the open technology standards and systems required to catalyse and enable countries to safely and efficiently deliver economic opportunities and social services in the digital world. We recommend the [Centre for DPI](https://cdpi.dev/) website for further guidance, definitions and practical resources on this important topic.

At OpenCRVS we are reimagining the way that civil registration systems work. We see the registration of life events as a foundational component of DPI, contributing to inclusive and equitable service delivery in the public and private sectors. The landscape is changing for digital civil registration systems as part of DPI and we must be aware of the key architectural principles which must be upheld to achieve maximum societal value.

The civil registration system plays a crucial role in providing a foundational and verifiable identity for individuals. In fact, you can’t get any more foundational than the system that recognises the very existence of people in a country, hence a well architected civil registration system is a true DPI:&#x20;

* Foundational Identity: The civil registration system forms the basis for creating unique digital identities for life. Birth registration for example triggers the creation of a unique identifier within the ID system, providing key biographical data such as name and date of birth.&#x20;
* Digitally signed certificates: The creation of verifiable credentials can be an output of the registration process, so that individuals are able to prove who they are to public and private institutions, without needing to request certified copies.&#x20;
* Enable access to government services: Civil registration provides the legal and trusted source of life events data and represents the universal data set for the provision of public services, such as social services, healthcare, education, and voting. In simple terms the civil registry answers important questions like:
  * Which families are entitled to a welfare grant (social protection)?
  * Who should be coming to school this year (education)?
  * Which children need to get vaccinated (healthcare)?
* Population Statistics and Planning: Civil registration provides a critical source of data for demographic analysis, population statistics, and future planning. Governments can use this data to make informed decisions about resource allocation, infrastructure development, and social policies.

<figure><img src="../.gitbook/assets/image (52).png" alt=""><figcaption><p>OpenCRVS and DPI</p></figcaption></figure>

OpenCRVS has the potential to be a true DPI and to do so means ensuring the following to unlock its full potential:&#x20;

* **Interoperability -** Open standards and specifications are required to share data in an efficient way and prevent fragmentation and functional silos.  &#x20;
* **Security and privacy by design** - Consent management protocols are required to allow safe sharing of personal data across systems and enforce data privacy. With civil registration data in a digital format the consent management process means that data subjects can choose to share their personal data on demand.
* **Modularity** - Maintaining civil registration components which are loosely coupled is valuable within a DPI context. Implementers can choose to use OpenCRVS as a fully fledged digital civil registration system or they can leverage modules (e.g. data validation, certificate printing) to incorporate them into their own solutions using open APIs.  &#x20;
