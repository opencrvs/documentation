---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.3-set-up-a-server-hosted-environment
---

# 4.3 Deploy: Set-up a server-hosted environment

This section describes the environments, servers and network requirements that countries are required to prepare in order to install OpenCRVS. This section also explains how OpenCRVS periodically backs up its data. Additionally it describes step-by-step instructions on how to

1. Generate environments on Github with the required secrets.
2. Provision server clusters using Ansible in order to run the environments.
3. Configure DNS
4. Run continuous deployment actions to deploy your OpenCRVS configuration to the server clusters depending on environment.
5. Initially seed a deployed cluster with reference data as you would perform on a local development environment.

### Data Center

OpenCRVS should only be provisioned on servers located in an equivalent minimum of a [certified Tier 2 or 3 Datacenter](https://uptimeinstitute.com/tier-certification/tier-certification-list).

Implementers should refer to the “Uptime Institute” design documents for specific requirements associated with Tier 2 & 3 certification. At a high-level, the datacenter should have:

* Uninterrupted power supply with independent, backup power generation
* Air conditioning
* 24/7 security access for authorised technical staff only
* Automatic server backup off-site
* Failsafe internet connectivity
* Security policies and procedures in place
* Network administrator staff capable of configuring and maintaining a scalable VPN solution

We appreciate that connectivity is a challenge in many countries where we work. The data centre should have **an absolute minimum of a 10Mbps internet connection** to the servers otherwise deploying to the servers will be unworkable.

### Server environments:

Before proceeding to discuss server specifications, it is important to understand the following server environment glossary that we will be referring to in our example countryconfig reference implementation and further sections.

| Environment                           | Description                                                                                                                                                                 | Authentication                                                      |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| **production**                        | A live environment containing citizen data e.g: personally identifiable information (PII).                                                                                  | 2FA codes generated for production user access                      |
| **staging** (pre-production / mirror) | A mirror of a live environment, used for final Quality Assurance of a production deployment containing a daily restored backup of citizen data (PII) from the previous day. | 2FA codes generated for production user access                      |
| **qa**                                | A quality assurance environment for tester, trainer & developer use supporting the Quality Assurance of releases, training staff.                                           | Test 2FA codes of 6 zeros allow test user access.                   |
| **backup**                            | A low specification environment that simply stores encrypted backups from production for long term recovery.                                                                | Not applicable. OpenCRVS software does not run on this environment. |
| **development**                       | An environment you can use for training and development purposes only. NOT FOR PRODUCTION USE!!                                                                             | Test 2FA codes of 6 zeros allow test user access.                   |

Before proceeding to discuss network specifications, it is important to understand the following other concepts:

| Concept                                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **vpn**                                                     | <p>All servers must be protected behind a government "virtual private network" (VPN). It should not be possible to browse to OpenCRVS on the public internet in Chrome unless the user has successfully authenticated via a VPN client.</p><p><br><strong>Your country should provide the VPN.</strong></p><p>OpenCRVS Core team cannot recommend which VPN to use nor how best to manage and maintain your VPN. We can advise how the following CD pipelines should connect to the servers through a VPN.</p>                                                                                                                                                                                                                                                           |
| **Continuous provisioning & deployment via Github Actions** | OpenCRVS provides a continuous deployment suite of automated scripts (pipelines) powered by Github Actions. Therefore a Github organisation is required in order to deploy OpenCRVS. These CD scripts connect through a VPN via a variety of configurable methods. Most commonly tools such as [openconnect](https://www.infradead.org/openconnect/) can be configured. Note that Wireguard VPN does not support openconnect - (This Marketplace action is an option for Wireguard VPNs: [https://github.com/marketplace/actions/easy-wireguard-connection](https://github.com/marketplace/actions/easy-wireguard-connection)). Finally, it is possible for the CD pipelines to connect using a ["bastion" / "jump"](https://en.wikipedia.org/wiki/Bastion_host) server. |
| **bastion** or **jump**                                     | An optional “jump” or “bastion” server can be configured to allow SSH access to servers behind a VPN without the need for a VPN client.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

### Server specifications

Refer to these minimum server specifications for the above environments. Note that the hard-disk space specifications are illustrative. Depending on the population size and number of supporting documents that are required to be captured during civil registration business processes, you may require more disk-space. Regardless your system administrators must be capable of monitoring and increasing server disk-space on demand. :

<table><thead><tr><th>Environment</th><th width="284">Specification</th></tr></thead><tbody><tr><td>development (suitable for learning or proof-of-concept) / qa</td><td>16GB RAM / 4CPUs / 320 GB Disk / Ubuntu 24.04 (LTS) x64, Headless</td></tr><tr><td>production / staging</td><td>16GB RAM / 8CPUs / diskspace calculated using formula below / Ubuntu 24.04 (LTS) x64, Headless</td></tr><tr><td>backup</td><td>1GB RAM / 2CPUs / diskspace calculated using formula below / Ubuntu 24.04 (LTS) x64, Headless</td></tr></tbody></table>

{% hint style="warning" %}
Our software is currently only supported on x86\_64 architectures and does not support ARM-based processors.
{% endhint %}

### Production / staging / backup diskspace requirements

Required disk space for production, staging and backup environments is calculated using the expected number of records per year and the estimated average number of attachments. The number of participating locations should be taken into account.

Please use the following formula:\
\
\&#xNAN;_attachments\_per\_year = number of births, deaths.. records per year \* average number of attachments \* 0.4MB_

_record\_data\_per\_year = number of births, deaths.. records per year \* 18.33kB_\
\&#xNAN;_operating\_system\_requirements = 100GB_

_minimum\_required\_disk\_space = operating\_system\_requirements + record\_data\_per\_year + attachments\_per\_year_

Using an average size country with population of 30M, crude birth rate of 17.299 births per 1000 people and crude death rate of 7.7 per 1000 we can calculate an estimate of records submitted every year\
\
Births per year: 518 970

Deaths per year: 231 000

Number of records per year: 749 970 per year

Choosing an average number of attachments of 3 we can calculate the total space needed per year

Attachments: 749 970 \* 3 \* 0.4 = 899 964 MB or 899 GB

Record data: 749 970 \* 18.33 = 13 746 950 kB or 13.74 GB

Combining that with the minimum disk space reserved for the system, we conclude the minimum required disk space for application servers in this example is 1012.47 GB.

For backup servers, we recommend storage size twice the size of application servers so in this case 2024.94 Gb.

Work is ongoing in OpenCRVS to optimise storage in future versions.

### Server clusters by project

The number of servers required in a load balanced cluster is configurable depending on the project and population size. Please take note of these recommendations.

#### Proof-of-concept (P.O.C.)

For a proof-of-concept (P.O.C.) of OpenCRVS, we use 1 **qa** server with **no backup**, operating under the condition that no live citizen data is captured during a P.O.C: **qa** x 1

#### Pilot

A total of 4 servers are required for pilot implementations that capture citizen data. One for each environment: **qa** x 1, **production** x 1, **staging** x 1 & **backup** x 1.

#### National scale

For national scale implementations, we recommend deploying to a production server cluster of 2 - 5 production servers depending on population size.

{% hint style="warning" %}
It is recommended to deploy the production environment on a cluster of at least 2 servers. This ensures high availability and prevents downtime or data loss in the event of a server failure.
{% endhint %}

| Population size | Servers required                                                 |
| --------------- | ---------------------------------------------------------------- |
| < 30M           | **qa** x 1, **production** x 2, **staging** x 1 & **backup** x 1 |
| 30M - 60M       | **qa** x 1, **production** x 3, **staging** x 1 & **backup** x 1 |
| 60M+            | **qa** x 1, **production** x 5, **staging** x 1 & **backup** x 1 |

### Network

Refer to the following network diagram as a reference example of how to network your server cluster.

<figure><img src="../../../.gitbook/assets/OpenCRVS Network &#x26; Servers.png" alt=""><figcaption></figcaption></figure>

### Server administrator SSH access & permissions:

During provisioning, the server administrator requires SSH access through the provided VPN to all servers with **sudo** permissions.

During installation of OpenCRVS, SSH config to all servers will be modified, blocking password baseed SSH authentication, root user access, configuring 2FA authentication and alerting for all future SSH access.

Once provisioned, there should be no need for technical staff to ever SSH into a server during day-to-day operations. Every SSH access going forward is audited via a Slack notification to all technical staff thanks to these provisioned alerts.

### User access

The following users will access 3 of the environments: **qa**, **production** & **staging**, via a VPN client:

1. Existing Civil Registration staff that access the OpenCRVS client using the Chrome browser on desktops/laptops/mobile devices.
2. 3rd party approved government staff (e.g. Healthcare staff in hospitals) that access the OpenCRVS client using the Chrome browser on desktops/mobile devices.
3. Your development and QA team that access the OpenCRVS client using the Chrome browser on desktops/laptops/mobile devices.
4. Potential future automated integrations from approved healthcare services using our [APIs](https://documentation.opencrvs.org/technology/interoperability/event-notification-clients) with VPN access
5. Potential future automated integrations external gov services using our [APIs](https://documentation.opencrvs.org/technology/interoperability/event-notification-clients) with VPN access
6. Automated continuous deployment scripts from a private Github code repository.

{% hint style="info" %}
All user workstations / tablets / smartphones and integrating APIs will require compatible VPN clients and accounts.
{% endhint %}

### Egress (outbound) internet access

In addition to serving user traffic the OpenCRVS infrastructure needs to be able to communicate outbound. This egress traffic includes things like pulling in latest updates, monitoring and emails.\
\
Should your policies determine strict allowlisting in your network, the required domains are listed in the next section.

### Email (SMTP) server

You must have a working SMTP server and SMTP user details to deploy OpenCRVS. Staff onboarding and monitoring requires an Email service.

### Ongoing costs of additional services

OpenCRVS is hardcoded to use the following 3rd party services which require subscriptions. The cost of these services is negligible, industry standard and promotes best practice developer operations experience.

1. A docker container registry [**organisation**](https://docs.docker.com/admin/organization/orgs/) account on [Dockerhub](https://hub.docker.com/) for hosting OpenCRVS Country config images.
2. An organisation Github account in a minimum of a ["Team"](https://github.com/pricing) plan to configure automated provisioning and deployment.
3. Optional, but recommended:

* A Slack Pro account [https://app.slack.com/plans](https://app.slack.com/plans)
* A [Sentry](https://sentry.io/welcome/) Team account. A free plan is fine for development / proof-of-concept.
* A password manager such as 1Password Team [https://1password.com/business-pricing](https://1password.com/business-pricing) or Bitwarden Team [https://bitwarden.com/pricing](https://bitwarden.com/pricing)
