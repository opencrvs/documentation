# Architecture

OpenCRVS technical architecture is designed using modular, event-driven [microservices](https://en.wikipedia.org/wiki/Microservices). Each micro service and every OpenCRVS component is configurable, scalable and protects data sovereignty by being provisionable in on-premise private tier 2/3 data centres using included [Docker Swarm](https://docs.docker.com/engine/swarm/) configurations. &#x20;

{% embed url="https://youtu.be/u8dZcDpS6XU" %}

To learn about the server hosting & network architecture required for hosting OpenCRVS visit [this section.](../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/)

OpenCRVS provides:

* Easy country configuration via a dedicated config microservice, simple csv files and a configuration UI.
* Standards-based multi-language content management.
* A market-leading, powerful search, audit and de-duplication engine powered by [ElasticSearch](https://www.elastic.co/).
* Real-time performance analytics powered by the time-series database [Influx](https://www.influxdata.com/).
* An Amazon S3 compatible object store for storing supporting documentation attachments powered by [Minio](https://min.io/).
* Increased performance by the use of [GraphQL](https://graphql.org/), reducing HTTP requests between client and server.
* An automated continuous integration, delivery and testing suite.
* A single JS, [TypeScript](https://www.typescriptlang.org/) codebase for backend, desktop and mobile using [Progressive Web Application technology](https://developer.mozilla.org/en-US/docs/Web/Progressive\_web\_apps/Introduction) for offline and low-connectivity access.
* External server and application health monitoring using [Kibana](https://www.elastic.co/kibana/)
* Automatic [LetsEncrypt](https://letsencrypt.org/) SSL configuration
* SMS 2-Factor Authentication with well defined user role authorization privileges

OpenCRVS is a full-stack that is designed to give you the lowest possible ["total cost of ownership"](https://en.wikipedia.org/wiki/Total\_cost\_of\_ownership).

Our international development teams work in an Agile way, in tandem with local development resources and human-centred designers, following the [Scrum](https://www.atlassian.com/agile/scrum) methodology, to rapidly design, build, deploy, test and maintain OpenCRVS releases.

{% embed url="https://www.figma.com/file/vM1n322kWGHjcU9RPfUDDx/OpenCRVS-Architecture?node-id=0:1&t=ZGZuBLSL6gR6eEZ6-1" %}

{% file src="../../.gitbook/assets/Application services and network diagram (1).png" %}

### Dependencies

The following dependencies are automatically provisioned alongside the OpenCRVS Core in [docker](https://www.docker.com/) containers in a Docker Swarm on Ubuntu.



### Docker Swarm

[Docker Swarm](https://docs.docker.com/engine/swarm/) was chosen by our architects in 2018 for it's lack of requirement of other essential dependencies, it's close alignment with Docker and it's simplicity in terms of installation and monitoring on a [Tier 2 private data centre](https://en.wikipedia.org/wiki/Data\_center), on bare metal servers with headless [Ubuntu OS](https://en.wikipedia.org/wiki/Ubuntu). Why not use AWS, public cloud SaaS or serverless you might be thinking?

* Many countries may be located far from a high-quality data-centre above Tier 2.
* Many countries may not legally support international data storage of citizen data on a public cloud. Getting the legal approval for external storage of citizen data requires regulatory change which can take a considerable amount of time.
* Because some countries may not be able to maintain complex software independently, we are considering a SaaS solution, provided enough countries get regulatory approval. Over time, this situation appears to be slowly evolving and we are monitoring it closely.

Previously unskilled system administrators can quickly up-skill in the techniques of private cloud infrastructure management using Docker Swarm. We wanted to democratise containerisation benefits for all countries.

#### **Is there a plan for Kubernetes?**

We are working on a [Kubernetes](https://kubernetes.io/) migration now that Kubernetes has become a more mature, easier to use and configure solution, thanks to dependencies like Helm and other plugins increasing popularity since 2018. In the meantime, Docker Swarm makes it easy to commence containerised microservice package distribution privately, automatically configures a "round robin" load balanced cluster, and provides Service Discovery out-the-box.

###

<div align="left">

<img src="https://static.wixstatic.com/media/93440e_d04078ae922a4126b8e9dd3f96066505~mv2.png/v1/fill/w_136,h_39,al_c,q_80,usm_0.66_1.00_0.01/FHIR_Foundation.webp" alt="">

</div>

### **FHIR Standard MongoDB Database layer**



The OpenCRVS data layer is [HL7 (Fast Healthcare Interoperability Resources) or FHIR](https://www.hl7.org/fhir/). FHIR is a global standard for exchanging electronic health records.

In order to support configuration for limitless country scale, OpenCRVS was designed for [NoSQL](https://en.wikipedia.org/wiki/NoSQL), built on [MongoDB](https://www.mongodb.com/), and aligned to a globally recognised healthcare standard.

Massively scalable and extensible, [Hearth](https://github.com/opencrvs/hearth) is an OpenSource NoSQL database server originally built by the OpenCRVS founding member [Jembi Health Systems](https://www.jembi.org/), using interoperable [Health Level 7](https://www.hl7.org) [FHIR](https://www.hl7.org/fhir/) v4 ([ANSI](https://www.ansi.org/) Accredited, Fast Healthcare Interoperability Resources) as standard.

We extended [FHIR](https://www.hl7.org/fhir/) to support the civil registration context. Our civil registration FHIR standard is described [here](../standards/fhir-documents/).

<div align="left">

<img src="https://static.wixstatic.com/media/93440e_21c72b72ff3a405596448e33f80a719c~mv2_d_3422_1781_s_2.png/v1/fill/w_136,h_70,al_c,q_80,usm_0.66_1.00_0.01/Elasticsearch-Logo-Color-V.webp" alt="">

</div>

### **ElasticSearch**

OpenCRVS uses [ElasticSearch](https://www.elastic.co/), an industry standard, NoSQL document orientated, real-time de-duplication & search engine. Lightning fast, intelligent civil registration record returns are possible, even with imprecise “fuzzy” search parameters.

De-duplication management to ensure data integrity is essential to any civil registration system. A fast search engine lowers operational costs and improves the user experience for frontline staff.

ElasticSearch is also used with [Kibana](https://www.elastic.co/kibana) for application and server health monitoring.\


<div align="left">

<img src="https://static.wixstatic.com/media/93440e_7ae07f5f77c6407080656fff4e0cdcd3~mv2.jpg/v1/fill/w_134,h_26,al_c,q_80,usm_0.66_1.00_0.01/influxdata-2.webp" alt="">

</div>

### **InfluxData**

The hyper-efficient [Influx](https://www.influxdata.com) "time series database" is used in our stack for "big data" performance insights. Millisecond level query times facilitate civil registration statistical queries over years of data, disaggregated by gender, location and configurable operational and statistical parameters.\


### OpenCRVS microservice packages

The core of OpenCRVS is a monorepo organised using [Lerna](https://github.com/lerna/lerna). Each package represents a single  microservice.  Each microservice has over 80% unit test coverage in [Jest](https://jestjs.io/). Following the [microservice](https://en.wikipedia.org/wiki/Microservices), 1 service per container model, every package is independently scalable in a single [docker](https://www.docker.com/) container.

![](<../../.gitbook/assets/image (8).png>) ![](<../../.gitbook/assets/image (4).png>) ![](<../../.gitbook/assets/image (27).png>)\\

The OpenCRVS microservice architecture enables continuous evolution of its business requirements.

The microservices are written in [TypeScript](https://github.com/microsoft/TypeScript) (a strictly typed superset of JavaScript that compiles to JavaScript) and NodeJS using the [HapiJS](https://github.com/hapijs/hapi) framework.

Each microservice in OpenCRVS has no knowledge of other services or business requirements in the application, and each exposes it’s capabilities via [JWT](https://auth0.com/blog/a-look-at-the-latest-draft-for-jwt-bcp/) secured APIs.

The microservice API Gateway uses [GraphQL](https://graphql.org/) . [GraphQL](https://graphql.org/) allows OpenCRVS to perform much faster and more responsively in remote areas by drastically reducing the number of HTTP requests that are required in order to render a view in the presentation layer. The OpenCRVS GraphQL Gateway is a JWT protected [Apollo](https://www.apollographql.com/) server that requests and resolves [FHIR](https://www.hl7.org/fhir/) resources from [Hearth](https://github.com/jembi/hearth)  into GraphQL, for easy interoperability or client consumption.

<div align="left">

<img src="https://static.wixstatic.com/media/93440e_d1ec46ba4c2d4c1dbb6afe6b9b7143de~mv2.png/v1/fill/w_133,h_40,al_c,q_80,usm_0.66_1.00_0.01/graphql.webp" alt="">

</div>

<div align="left">

<img src="https://static.wixstatic.com/media/93440e_8452ed95c717459e86c95ed0e17378ad~mv2.png/v1/fill/w_136,h_70,al_c,q_80,usm_0.66_1.00_0.01/PWA-Progressive-Web-App-Logo.webp" alt="">

</div>

<div align="left">

<img src="https://static.wixstatic.com/media/93440e_50ed7c9e719e44daa7ca7d3e183f4071~mv2.png/v1/fill/w_121,h_55,al_c,q_80,usm_0.66_1.00_0.01/react.webp" alt="">

</div>

Client applications are built using [React](https://reactjs.org/) and [progressive web application](https://developer.mozilla.org/en-US/docs/Web/Progressive\_web\_apps/Introduction) technology. This means that we can take advantage of offline functionality and native mobile features using [Workbox](https://developers.google.com/web/tools/workbox), without the overhead of maintaining multiple web and mobile codebases and respective App/Play Store releases.

In remote areas, registrars can save a configurable number of registrations offline on their mobile phone, using [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB\_API).



<div align="left">

<img src="https://static.wixstatic.com/media/93440e_bdd011d5e3744e7b84684e6789c1f5c7~mv2.png/v1/fill/w_136,h_40,al_c,q_80,usm_0.66_1.00_0.01/openhim-logo-green.webp" alt="">

</div>

### **(Optional) OpenHIM enterprise service bus, interoperability Layer**

The [OpenHIM (Health Information Mediator)](https://github.com/jembi/openhim-core-js) is the interoperability layer of choice in the [Open Health Information Exchange (OpenHIE) architectural standard](https://ohie.org/) and interoperates natively using [HL7 (Fast Healthcare Interoperability Resources) or FHIR](https://www.hl7.org/fhir/).&#x20;

OpenHIM is built in NodeJS and is designed to ease interoperability between OpenCRVS and external healthcare systems. It provides external access to the system via secure APIs. OpenHIM is fully compatible with OpenCRVS and can be optionally included in the stack.
