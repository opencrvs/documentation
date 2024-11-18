# 4.3 Set-up a server-hosted environment



This section describes the environments, servers and network requirements that countries are required to prepare in order to install OpenCRVS.  This section also explains how OpenCRVS periodically backs up its data.  Additionally it describes step-by-step instructions on how to&#x20;

1. Generate environments on Github with the required secrets.
2. Provision server clusters using Ansible in order to run the environments.
3. Configure DNS
4. Run continuous deployment actions to deploy your OpenCRVS configuration to the server clusters depending on environment.&#x20;
5. Initially seed a deployed cluster with reference data as you would perform on a local development environment.&#x20;

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

We appreciate that connectivity is a challenge in many countries where we work.  The data centre should have **an absolute minimum of a 10Mbps internet connection** to the servers otherwise deploying to the servers will be unworkable.



### Server environments:&#x20;

Before proceeding to discuss server specifications, it is important to understand the following server environment glossary that we will be referring to in our example countryconfig reference implementation and further sections.

| Environment                           | Description                                                                                                                                                                  | Authentication                                                       |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **production**                        | A live environment containing citizen data e.g: personally identifiable information (PII).                                                                                   | 2FA codes generated for production user access                       |
| **staging** (pre-production / mirror) | A mirror of a live environment, used for final Quality Assurance of a production deployment containing a daily restored backup of citizen data (PII) from the previous day.  | 2FA codes generated for production user access                       |
| **qa**                                | A quality assurance environment for tester, trainer & developer use supporting the Quality Assurance of releases, training staff.                                            | Test 2FA codes of 6 zeros allow test user access.                    |
| **backup**                            | A low specification environment that simply stores encrypted backups from production for long term recovery.                                                                 | Not applicable.  OpenCRVS software does not run on this environment. |
| **development**                       | An environment you can use for training and development purposes only. NOT FOR PRODUCTION USE!!                                                                              | Test 2FA codes of 6 zeros allow test user access.                    |

Before proceeding to discuss network specifications, it is important to understand the following other server requirements:

| Concept                 | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **vpn**                 | <p>All servers must be protected behind a government "virtual private network" (VPN).  It should not be possible to browse to OpenCRVS on the public internet in Chrome unless the user has successfully authenticated via a VPN client.</p><p><br><strong>Your country should provide the VPN.</strong> </p><p></p><p>The OpenCRVS countryconfig reference implementation can be configured to install a basic <a href="https://www.wireguard.com/">Wireguard VPN</a> on a QA server (or a dedicated VPN server) in situations where an existing gov VPN does not exist, but the OpenCRVS Core team cannot advise on how to manage and maintain the Wireguard VPN long term. Wireguard may or may not be the most scalable VPN for your cross-government needs.</p> |
| **bastion** or **jump** | We recommend that the VPN server above is provisioned as a “jump” or “bastion” server whose IP address can be made publicly available to continuous deployment (CD) solutions such as Github Actions. The CD suite, using public/private key encryption can then use this server in order to deploy code automatically to the servers via a secure location.  If this is not possible, then the CD suite must be able to access the network using tools such as [openconnect](https://www.infradead.org/openconnect/).  Note that Wireguard does not support openconnect.                                                                                                                                                                                            |



### Server specifications

Refer to these minimum server specifications for the above environments.  Note that the hard-disk space specifications are illustrative. Depending on the population size and number of supporting documents that are required to be captured during civil registration business processes, you may require more disk-space.  Regardless your system administrators must be capable of monitoring and increasing server disk-space on demand. :

<table><thead><tr><th>Environment</th><th width="284">Specification</th></tr></thead><tbody><tr><td>production / staging / qa</td><td>16GB RAM / 4 or 8CPUs / 320 GB Disk / Ubuntu 22.04 (LTS) x64, Headless</td></tr><tr><td>backup</td><td>1GB RAM / 2CPUs / 500 GB Disk / Ubuntu 22.04 (LTS) x64, Headless</td></tr></tbody></table>

{% hint style="info" %}
Virtualisation: The following 2 environments are possibly virtualisable into a single, partitioned server, only if each can be configured to access the same 16GB RAM & 8CPU resources pool: **qa** & **staging.**  For national scale implementations, all servers should be physically separated so that they do not compete for resources.
{% endhint %}



### Server clusters by project

The number of servers required in a cluster is configurable depending on the project and population size.  Please take note of these recommendations.

#### Proof-of-concept (P.O.C.)

For a proof-of-concept (P.O.C.) of OpenCRVS, we use 1 **qa** server with **no backup**, operating under the condition that no live citizen data is captured during a P.O.C: **qa** x 1

#### Pilot

A total of 4 servers are required for pilot implementations that capture citizen data. One for each environment:  **qa** x 1, **production** x 1, **staging** x 1 & **backup** x 1.&#x20;

#### National scale

For national scale implementations, we recommend deploying to a production server cluster of 2 - 5 production servers depending on population size. &#x20;

| Population size | Servers required                                                 |
| --------------- | ---------------------------------------------------------------- |
| < 1M            | **qa** x 1, **production** x 1, **staging** x 1 & **backup** x 1 |
| 1M - 30M        | **qa** x 1, **production** x 2, **staging** x 1 & **backup** x 1 |
| 30M - 60M       | **qa** x 1, **production** x 3, **staging** x 1 & **backup** x 1 |
| 60M+            | **qa** x 1, **production** x 5, **staging** x 1 & **backup** x 1 |



### Network

Refer to the following network diagram as a reference example of how to network your server cluster.

<figure><img src="../../../.gitbook/assets/OpenCRVS Network &#x26; Servers.png" alt=""><figcaption></figcaption></figure>

### Server administrator SSH access & permissions:

During provisioning, the server administrator requires SSH access through the provided VPN to all servers with **sudo** permissions. &#x20;

During installation of OpenCRVS, SSH config to all servers will be modified, blocking password baseed SSH authentication, root user access, configuring 2FA authentication and alerting for all future SSH access. &#x20;

Once provisioned, there should be no need for technical staff to ever SSH into a server during day-to-day operations.  Every SSH access going forward is audited via a Slack notification to all technical staff thanks to these provisioned alerts.



### User access

The following users will access 3 of the environments: **qa**, **production** & **staging**, via a VPN client:

1. Existing Civil Registration staff that access the OpenCRVS client using the Chrome browser on desktops/laptops/mobile devices.
2. 3rd party approved government staff (e.g. Healthcare staff in hospitals) that access the OpenCRVS client using the Chrome browser on desktops/mobile devices.
3. Your development and QA team that access the OpenCRVS client using the Chrome browser on desktops/laptops/mobile devices.
4. Potential future automated integrations from approved healthcare services using our [APIs](https://documentation.opencrvs.org/technology/interoperability/event-notification-clients) with VPN access&#x20;
5. Potential future automated integrations external gov services using our [APIs](https://documentation.opencrvs.org/technology/interoperability/event-notification-clients) with VPN access&#x20;
6. Automated continuous deployment scripts from a private Github code repository.

{% hint style="info" %}
All user workstations / tablets / smartphones and integrating APIs will require compatible VPN clients and accounts.
{% endhint %}



### Egress (outbound) internet access

In addition to serving user traffic the OpenCRVS infrastructure needs to be able to communicate outbound. This egress traffic includes things like pulling in latest updates, monitoring and emails.\
\
The precise domains/addresses being used can be provided on request should your policies determine strict allowlisting in your firewall.

### Email (SMTP) server

You must have a working SMTP server and SMTP user details to deploy OpenCRVS.  Staff onboarding and monitoring requires an Email service.\
