# Architecture

OpenCRVS technical architecture is designed using modular, event-driven [microservices](https://en.wikipedia.org/wiki/Microservices). Each microservice and every OpenCRVS component is configurable, scalable and protects data sovereignty by being provisionable in on-premise private tier 2/3 data centres using included [Docker Swarm](https://docs.docker.com/engine/swarm/) configurations.

{% embed url="https://youtu.be/u8dZcDpS6XU" %}

To learn about the server hosting & network architecture required for hosting OpenCRVS visit [this section.](../../setup/3.-installation/3.3-set-up-a-server-hosted-environment)

OpenCRVS provides:

* Easy country configuration via a dedicated config microservice, simple csv files and a configuration UI.
* Standards-based multi-language content management.
* A market-leading, powerful search, audit and de-duplication engine powered by [Elasticsearch](https://www.elastic.co/).
* An Amazon S3 compatible object store for storing supporting documentation attachments powered by [Minio](https://min.io/).
* An automated continuous integration, delivery and testing suite.
* A single JS, [TypeScript](https://www.typescriptlang.org/) codebase for backend, desktop and mobile using [Progressive Web Application technology](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Introduction) for offline and low-connectivity access.
* External server and application health monitoring using [Kibana](https://www.elastic.co/kibana/)
* Automatic [LetsEncrypt](https://letsencrypt.org/) SSL configuration
* SMS 2-Factor Authentication with well defined user role authorization privileges
* HTTP hooks for programmatically extending the backend business logic

OpenCRVS is a full-stack that is designed to give you the lowest possible ["total cost of ownership"](https://en.wikipedia.org/wiki/Total_cost_of_ownership).

{% embed url="https://www.figma.com/board/iT4utAw7tGpGZx6wrEI3mC/OpenCRVS-Architecture-2.0?node-id=0-1&p=f&t=NiJIN0DOj4S60kqs-0" %}

### Docker Swarm

[Docker Swarm](https://docs.docker.com/engine/swarm/) was chosen by our architects in 2018 because, at the time, dependencies supporting bare-metal installations for Kubernetes architectures were in their infancy and difficult to understand. &#x20;

Many countries cannot legally support international data storage of citizen data on a public cloud so were dependant on something quick and easy to install in a Tier-2 data centre.   &#x20;

#### **Kubernetes available in OpenCRVS 2.0**

Since 2018, Kubernetes bare-metal tooling has advanced significantly.  Our work-in-progress [Kubernetes](https://kubernetes.io/) installation will be easier to use and configure.  As of OpenCRVS 1.9, Docker Swarm is still the supported deployment mechanism.

Previously unskilled system administrators can quickly up-skill in the techniques of Docker infrastructure management using Docker Swarm.&#x20;

### **Databases**

OpenCRVS uses [Elasticsearch](https://www.elastic.co/), an industry standard, NoSQL document orientated, real-time de-duplication & search engine. Lightning fast, intelligent civil registration record returns are possible, even with imprecise “fuzzy” search parameters.

De-duplication management to ensure data integrity is essential to any civil registration system. A fast search engine lowers operational costs and improves the user experience for frontline staff.

Elasticsearch is also used with [Kibana](https://www.elastic.co/kibana) for application and server health monitoring.

Event data is stored in [PostgreSQL](https://www.postgresql.org/)

Some legacy code in OpenCRVS 1.9 still uses [MongoDB](https://www.mongodb.com/) and [InfluxData](https://www.influxdata.com/).  These dependencies will be deprecated.

Analytics are developed in [Metabase](https://www.metabase.com/), but any BI tool can be used as a substitute.

### OpenCRVS microservice packages

The core of OpenCRVS is a monorepo organised using [Lerna](https://github.com/lerna/lerna). Each package represents a single microservice. Following the [microservice](https://en.wikipedia.org/wiki/Microservices), 1 service per container model, every package is independently scalable in a single [docker](https://www.docker.com/) container.

![](<../../.gitbook/assets/image (8).png>) ![](<../../.gitbook/assets/image (4).png>) ![](<../../.gitbook/assets/image (27).png>)\\

The OpenCRVS microservice architecture enables continuous evolution of its business requirements.

The microservices are written in [TypeScript](https://github.com/microsoft/TypeScript) (a strictly typed superset of JavaScript that compiles to JavaScript)

Each microservice in OpenCRVS has no knowledge of other services or business requirements in the application, and each exposes it’s capabilities via [JWT](https://auth0.com/blog/a-look-at-the-latest-draft-for-jwt-bcp/) secured APIs.

<div align="left"><img src="https://static.wixstatic.com/media/93440e_8452ed95c717459e86c95ed0e17378ad~mv2.png/v1/fill/w_136,h_70,al_c,q_80,usm_0.66_1.00_0.01/PWA-Progressive-Web-App-Logo.webp" alt=""></div>

<div align="left"><img src="https://static.wixstatic.com/media/93440e_50ed7c9e719e44daa7ca7d3e183f4071~mv2.png/v1/fill/w_121,h_55,al_c,q_80,usm_0.66_1.00_0.01/react.webp" alt=""></div>

Client applications are built using [React](https://reactjs.org/) and [progressive web application](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Introduction) technology. This means that we can take advantage of offline functionality and native mobile features using [Workbox](https://developers.google.com/web/tools/workbox), without the overhead of maintaining multiple web and mobile codebases and respective App/Play Store releases.

In remote areas, registrars can save a configurable number of registrations offline on their mobile phone, using [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API).
