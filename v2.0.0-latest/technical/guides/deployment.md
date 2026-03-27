# Deployment

### 1. Introduction

Deployment is the process of installing and configuring OpenCRVS on server infrastructure for testing, staging, or production use. This section describes the environments, servers, and network requirements that countries must prepare in order to install OpenCRVS.

This section covers:

* Data center requirements
* Server environments and specifications
* Network configuration and VPN requirements
* Continuous deployment using GitHub Actions
* User access and security considerations
* Additional service requirements

\<aside> 🚨

**Production requirement** — OpenCRVS should only be provisioned on servers located in an equivalent minimum of a [certified Tier 2 or 3 Data Center](https://uptimeinstitute.com/tier-certification/tier-certification-list).

\</aside>

***

### 2. Data center requirements

OpenCRVS should only be provisioned on servers located in an equivalent minimum of a certified Tier 2 or 3 Data Center.

Implementers should refer to the "Uptime Institute" design documents for specific requirements associated with Tier 2 and 3 certification. At a high level, the data center should have:

* **Uninterrupted power supply** with independent, backup power generation
* **Air conditioning** for temperature control
* **24/7 security access** for authorized technical staff only
* **Automatic server backup** off-site
* **Failsafe internet connectivity**
* **Security policies and procedures** in place
* **Network administrator staff** capable of configuring and maintaining a scalable VPN solution

#### Minimum internet connectivity

We appreciate that connectivity is a challenge in many countries where we work. The data center should have **an absolute minimum of a 10Mbps internet connection** to the servers, otherwise deploying to the servers will be unworkable.

***

### 3. Server environments

Before proceeding to discuss server specifications, it is important to understand the following server environment glossary that we will be referring to in our example countryconfig reference implementation.

| **Environment** | **Description**                                                                                                                                                             | **Authentication**                                                  |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| production      | A live environment containing citizen data, for example, personally identifiable information (PII).                                                                         | 2FA codes generated for production user access                      |
| staging         | A mirror of a live environment, used for final Quality Assurance of a production deployment containing a daily restored backup of citizen data (PII) from the previous day. | 2FA codes generated for production user access                      |
| qa              | A quality assurance environment for tester, trainer, and developer use supporting the Quality Assurance of releases and training staff.                                     | Test 2FA codes of 6 zeros allow test user access                    |
| backup          | A low specification environment that simply stores encrypted backups from production for long-term recovery.                                                                | Not applicable. OpenCRVS software does not run on this environment. |
| development     | An environment you can use for training and development purposes only. NOT FOR PRODUCTION USE.                                                                              | Test 2FA codes of 6 zeros allow test user access                    |

***

### 4. VPN and network security

All servers must be protected behind a government **Virtual Private Network (VPN)**. It should not be possible to browse to OpenCRVS on the public internet in Chrome unless the user has successfully authenticated via a VPN client.

\<aside> 🔐

**Your country should provide the VPN** — OpenCRVS Core team cannot recommend which VPN to use nor how best to manage and maintain your VPN. We can advise how continuous deployment pipelines should connect to the servers through a VPN.

\</aside>

#### Continuous deployment via GitHub Actions

OpenCRVS provides a continuous deployment suite of automated scripts (pipelines) powered by GitHub Actions. Therefore a GitHub organization is required in order to deploy OpenCRVS.

These CD scripts connect through a VPN via a variety of configurable methods. Most commonly tools such as [openconnect](https://www.infradead.org/openconnect/) can be configured.

**Note:** Wireguard VPN does not support openconnect. This [Marketplace action](https://github.com/marketplace/actions/easy-wireguard-connection) is an option for Wireguard VPNs.

#### Bastion or jump server

An optional "jump" or "bastion" server can be configured to allow SSH access to servers behind a VPN without the need for a VPN client.

***

### 5. Server specifications

Refer to these minimum server specifications for the above environments.

| **Environment**      | **Specification**                                                                               |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| development / qa     | 16GB RAM / 4 CPUs / 320 GB Disk / Ubuntu 24.04 (LTS) x64, Headless                              |
| production / staging | 16GB RAM / 8 CPUs / diskspace calculated using formula below / Ubuntu 24.04 (LTS) x64, Headless |
| backup               | 1GB RAM / 2 CPUs / diskspace calculated using formula below / Ubuntu 24.04 (LTS) x64, Headless  |

\<aside> 💻

**Architecture support** — Our software is currently only supported on x86\_64 architectures and does not support ARM-based processors.

\</aside>

#### Disk space requirements

The disk space specifications above are illustrative. Depending on the population size and number of supporting documents that are required to be captured during civil registration business processes, you may require more disk space.

**Regardless, your system administrators must be capable of monitoring and increasing server disk space on demand.**

#### Calculating disk space for production, staging, and backup

Required disk space for production, staging, and backup environments is calculated using the expected number of records per year and the estimated average number of attachments.

**Use the following formula:**

```
attachments_per_year = number of records per year × average number of attachments × 0.4MB

record_data_per_year = number of records per year × 18.33kB

operating_system_requirements = 100GB

minimum_required_disk_space = operating_system_requirements + record_data_per_year + attachments_per_year
```

#### Example calculation

Using an average size country with population of 30M, crude birth rate of 17.299 births per 1000 people and crude death rate of 7.7 per 1000:

* **Births per year:** 518,970
* **Deaths per year:** 231,000
* **Number of records per year:** 749,970

Choosing an average number of attachments of 3:

* **Attachments:** 749,970 × 3 × 0.4 = 899,964 MB or **899 GB**
* **Record data:** 749,970 × 18.33 = 13,746,950 kB or **13.74 GB**

**Minimum required disk space for application servers:** 1,012.47 GB

**For backup servers:** We recommend storage size twice the size of application servers, so in this case **2,024.94 GB**.

\<aside> ⚙️

Work is ongoing in OpenCRVS to optimize storage in future versions.

\</aside>

***

### 6. Server clusters by project type

The number of servers required in a load-balanced cluster is configurable depending on the project and population size.

#### Proof-of-concept (P.O.C.)

For a proof-of-concept (P.O.C.) of OpenCRVS, we use 1 **qa** server with **no backup**, operating under the condition that no live citizen data is captured during a P.O.C.

* **qa** × 1

#### Pilot

A total of 4 servers are required for pilot implementations that capture citizen data. One for each environment:

* **qa** × 1
* **production** × 1
* **staging** × 1
* **backup** × 1

#### National scale

For national scale implementations, we recommend deploying to a production server cluster of 2 to 5 production servers depending on population size.

It is recommended to deploy the production environment on a cluster of at least 2 servers. This ensures high availability and prevents downtime or data loss in the event of a server failure.

| **Population size** | **Servers required**                                             |
| ------------------- | ---------------------------------------------------------------- |
| < 30M               | **qa** × 1, **production** × 2, **staging** × 1 & **backup** × 1 |
| 30M - 60M           | **qa** × 1, **production** × 3, **staging** × 1 & **backup** × 1 |
| 60M+                | **qa** × 1, **production** × 5, **staging** × 1 & **backup** × 1 |

***

### 7. Network architecture

Refer to the following network diagram as a reference example of how to network your server cluster.

***

### 8. SSH access and permissions

#### Server administrator SSH access

During provisioning, the server administrator requires SSH access through the provided VPN to all servers with **sudo**permissions.

During installation of OpenCRVS, SSH config to all servers will be modified, blocking password-based SSH authentication, root user access, configuring 2FA authentication and alerting for all future SSH access.

#### Ongoing SSH access

Once provisioned, there should be no need for technical staff to ever SSH into a server during day-to-day operations. Every SSH access going forward is audited via a Slack notification to all technical staff thanks to these provisioned alerts.

***

### 9. User access

The following users will access 3 of the environments (**qa**, **production**, and **staging**) via a VPN client:

1. **Existing Civil Registration staff** that access the OpenCRVS client using the Chrome browser on desktops/laptops/mobile devices.
2. **3rd party approved government staff** (for example, healthcare staff in hospitals) that access the OpenCRVS client using the Chrome browser on desktops/mobile devices.
3. **Your development and QA team** that access the OpenCRVS client using the Chrome browser on desktops/laptops/mobile devices.
4. **Potential future automated integrations** from approved healthcare services using our [APIs](https://documentation.opencrvs.org/technology/interoperability/event-notification-clients) with VPN access.
5. **Potential future automated integrations** from external government services using our [APIs](https://documentation.opencrvs.org/technology/interoperability/event-notification-clients) with VPN access.
6. **Automated continuous deployment scripts** from a private GitHub code repository.

All user workstations, tablets, smartphones, and integrating APIs will require compatible VPN clients and accounts.

***

### 10. Egress (outbound) internet access

In addition to serving user traffic, the OpenCRVS infrastructure needs to be able to communicate outbound. This egress traffic includes things like pulling in latest updates, monitoring, and emails.

Should your policies determine strict allowlisting in your network, the required domains are listed in the deployment documentation.

***

### 11. Email (SMTP) server

You must have a working SMTP server and SMTP user details to deploy OpenCRVS. Staff onboarding and monitoring requires an email service.

***

### 12. Ongoing costs of additional services

OpenCRVS is hardcoded to use the following 3rd party services which require subscriptions. The cost of these services is negligible, industry standard, and promotes best practice developer operations experience.

#### Required services

1. A Docker container registry [**organization**](https://docs.docker.com/admin/organization/orgs/) account on [Dockerhub](https://hub.docker.com/) for hosting OpenCRVS country config images.
2. An organization GitHub account in a minimum of a ["Team"](https://github.com/pricing) plan to configure automated provisioning and deployment.

#### Optional but recommended services

* A **Slack Pro** account
* A [\*\*Sentry](https://sentry.io/welcome/) Team\*\* account (a free plan is fine for development or proof-of-concept)
* A **password manager** such as [1Password Team](https://1password.com/business-pricing) or [Bitwarden Team](https://bitwarden.com/pricing)
