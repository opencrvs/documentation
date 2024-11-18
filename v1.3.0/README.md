# 👋 Introduction

OpenCRVS is an open-source digital solution for civil registration, designed specifically for low-resource settings and available as a Digital Public Good.

This documentation can be used by governments, system integrators and development partners to design, configure, operate and maintain an OpenCRVS application that meets your country's needs.

* to explore the OpenCRVS functionality, check out the [Product Specifications](product-specifications/functional-architecture.md) and the [Default Configuration for Farajaland](default-configuration/intro-to-farajaland.md)
* to understand how OpenCRVS works technically, go to [Technology](technology/architecture/)
* to setup you own OpenCRVS instance and get it quickly into the hands of users, then go to [Setup](setup/1.-establish-team.md)
* to see what's coming next for OpenCRVS, see the [Product Roadmap](general/product-roadmap.md)

{% hint style="info" %}
We recommend that you use this documentation in combination with the [CRVS Digitisation Guidebook](http://www.crvs-dgb.org/en/), an online resource that provides step-by-step guidance for countries to implement digitized systems and automated processes for CRVS.
{% endhint %}

### Why is OpenCRVS needed?

Civil registration is the foundation of legal identity and rights-based service delivery. A Civil Registration and Vital Statistics (CRVS) system records the details of all major life events, such as births, deaths, marriage and divorce. It is an essential component of the "leave no one behind" agenda and without it working effectively, it is virtually impossible to ensure inclusive growth.

Unfortunately, in many countries CRVS systems are broken. 1 in 4 children under the age of 5 have not had their birth registered and hence do not officially exist. As a result, they struggle to access basic rights like education, healthcare and social protection. Two thirds of the world's deaths are not recorded, meaning that governments cannot design effective public health policies or measure their impact.

Through our extensive research of CRVS systems around the world (including Pakistan, Bangladesh, Indonesia, Malawi, Uganda and Ghana) we understand many of the specific challenges that are often experienced by civil registration staff and the families trying to register vital events:

* The civil registration processes are bureaucratic and time-consuming, with requests for supporting documents that family members do not possess and unofficial payments.
* Family members need to travel long distances to register vital events with several trips often required before the registration process is complete and a certificate is obtained.
* Systems are not integrated so birth registration does not lead to automatic access to other rights e.g. vaccination programmes, enrolment in social protection schemes etc.

### Configuration

OpenCRVS is engineered for adaptability, allowing for configuration to comply with diverse country-specific laws and regulations. The following section provides a brief overview of the configurable aspects in version 1.3. Detailed explanations of these features will be subsequently elaborated throughout this documentation.

#### Application config:

* Application name
* Application logo
* Login background colour or image
* Registration time periods
* Registration fees
* Phone number format
* Currency
* National ID format
* Registration number format (developer)

#### Formsconfig:

* Birth declaration form
* Death declaration form
* Marriage declaration form (developer)

#### Certificates config:

* Birth certificate template
* Death certificate template
* Marriage certificate template
* Allow printing certificate off in advance of issuance

#### Integrations config:

* Health system integration
* National ID integration
* Record search
* Custom webhook

### Product Commitments

We continue to stand by our original product commitments for OpenCRVS and these help steer the strategic direction of the product.

1. Fully open-source, with no license fees or ties to specific vendors
2. Configurable for all country contexts
3. Interoperable with other government systems
4. Highly accessible to ensure inclusion, even in remote areas
5. Safe and secure to keep personal data protected
6. Easy to deploy and use in low resource settings
7. Enabling new models of civil registration that can help achieve universal registration

### Design Principles

We are passionate about designing a product that fulfils our mission - to make civil registration easy and valuable for everyone by making high-quality and cost-effective digital systems widely available and sustainable. Our design principles are here to provide a clear framework to all those working on OpenCRVS of how to make design decisions that will affect how the product works.

#### **Start with users' needs**

Listen to, engage with and observe users. Spend time to understand their needs, assume nothing, and work with your users to create designs.

#### **Prioritise offline**

Every product feature must work offline and in areas of low connectivity. Where connectivity is required to complete an action, tell the user what's happening and always consider the loading state.

#### **Give guidance throughout**

The user shouldn't have any questions about what to do - it should be intuitive. Make the product simple and offer clear guidance every step of the way.

#### **Test, learn and iterate**

The best way to develop new features is to get an early version into the hands of users, then listen -> learn -> iterate.

#### **Enable rights**

We want to empower and protect those who use and are served by OpenCRVS. Is what you are designing likely to exclude or discriminate anyone? How can this be avoided?

#### **Be consistent**

Every part of the product should look and feel part of the whole - always use of the component library.

#### **Be hyper-accessible**

Our users are from across the world with varying levels of digital literacy. Whatever we design must be intuitive, legible and as accessible as possible.

#### **Words matter**

Every word should be understood by users, with no room for ambiguity. When drafting text, avoid use of administrative language and test it with local users.

#### **Design with data**

Use data generated from the system to inform design improvements.

#### **Consider other contexts**

OpenCRVS is a global product. Consider the variability of what you are designing - will it work in other countries and contexts, and how will it be easily configured?
