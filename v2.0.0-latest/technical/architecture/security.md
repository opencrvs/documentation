# Security

### 1. Introduction

OpenCRVS treats the security of the application and the personally identifiable information (PII) it stores with utmost care. Security is critical for protecting citizen data and maintaining public trust in the civil registration system.

Every release of the OpenCRVS application and infrastructure has been security penetration tested by an independent, [CREST](https://www.crest-approved.org/) and [CyberEssentials](https://www.ncsc.gov.uk/cyberessentials/overview) certified 3rd party to UK government standards.

Penetration tests of OpenCRVS have been performed by [MDSec](https://www.mdsec.co.uk/), [The Guardian Project](https://guardianproject.info/code/) on behalf of UNICEF, and [Gofore](https://gofore.com/)- [NORAD's](https://www.norad.no/) preferred security testing provider.

***

### 2. Feature overview

OpenCRVS provides a comprehensive security model to protect citizen data and system infrastructure.

#### Core capabilities

With security features, OpenCRVS supports:

* **Two-factor authentication** (2FA) for user login and server access, using SMS or Google Authenticator.
* **Role-based access controls** that segregate personally identifiable data to only users who need it.
* **Full audit trails** of all access to declarations and registrations, tracking who viewed what data and when.
* **Encrypted data in transit** via TLS certificates, automatically provisioned and rotated.
* **Encrypted data at rest** using Docker Secrets and Github Secrets, never stored in plain text.
* **Rate limiting** to prevent denial of service and brute force attacks.
* **Firewall and SSH protection** automatically provisioned on each node.
* **Infrastructure monitoring** with automated alerting for security-relevant events.

Security in OpenCRVS is:

* **Tested** — every release is independently penetration tested to industry standards.
* **Layered** — multiple controls protect data at different levels (authentication, access control, encryption, monitoring).
* **Auditable** — all access to records and infrastructure is logged immutably.

\<aside> 💡

**Security posture** — As Gofore's Cyber Security Consultant noted: _"Already from the results of the first assessment, it was evident that the OpenCRVS web application had a good security posture. The web application security fundamentals were sound."_

\</aside>

***

### 3. Penetration testing

OpenCRVS undergoes regular security assessments by independent, certified third-party security firms.

#### Testing providers

Penetration tests have been performed by:

* [**MDSec**](https://www.mdsec.co.uk/) — CREST certified security testing firm.
* [**The Guardian Project**](https://guardianproject.info/code/) — on behalf of UNICEF.
* [**Gofore**](https://gofore.com/) — NORAD's preferred security testing provider, CyberEssentials certified.

#### Testing methodology

Security assessments typically include:

* **Code review** — manual review of application source code for vulnerabilities.
* **Automated enumeration scans** — scanning via the public internet to identify exposed services and potential weaknesses.
* **Fuzzing with diverse input** — testing how the system handles unexpected or malicious input.
* **Manual penetration testing** — simulating an adversary attacking the system to identify exploitable vulnerabilities.

Testing is conducted in two rounds:

1. **Initial assessment** — identify and report vulnerabilities.
2. **Reassessment** — verify that reported vulnerabilities have been resolved.

All tests are conducted to UK government standards and follow proven ethical hacking methodologies.

***

### 4. Authentication and access control

OpenCRVS uses multiple layers of authentication and access control to ensure that only authorized users can access the system and view sensitive data.

#### 4.1 Two-factor authentication

All user authentication requires two factors:

* **Something you know** — username and password.
* **Something you have** — 2FA code sent to the user's mobile device via SMS or Google Authenticator.

This ensures that only users with access to authenticated hardware can log in to OpenCRVS, even if their password is compromised.

#### 4.2 Role-based access controls

User types and access controls are managed to segregate personally identifiable data to only the users who need it.

* **Roles and scopes** define what actions users can perform and what data they can access.
* **Jurisdictional constraints** restrict users to records from specific administrative areas.
* **Team management** is handled via the Team GUI, accessible by National and Local System Administrators.

#### 4.3 Audit trail

Every access to a specific declaration or registration is audited, tracking:

* Who viewed the data.
* When they viewed it.
* What actions they performed.

This protects citizen rights and provides accountability for all system access.

***

### 5. Infrastructure security

OpenCRVS automatically provisions secure infrastructure with multiple layers of protection.

#### 5.1 Firewall and SSH access

* **Firewall** — OpenCRVS automatically provisions a secure firewall on each node using Ansible.
* **SSH 2FA** — SSH users are configured to use Google Authenticator 2FA when connecting via a Terminal.
* **Automated alerts** — every SSH access prompts an automated alert to technical teams via Slack.

\<aside> 🚨

**VPN requirement** — OpenCRVS should only be installed behind a separately configured and managed, government-owned VPN.

\</aside>

#### 5.2 TLS certificate

OpenCRVS data is encrypted in transit via an SSL certificate that can be automatically provisioned and rotated by [Traefik](https://traefik.io/), signed by [LetsEncrypt](https://letsencrypt.org/), depending on DNS and VPN configuration.

#### 5.3 Database encryption

Encryption keys to the databases, API keys, and sensitive environment secrets are never stored in `.env` files.

Instead, they are stored in RAM in inaccessible locations:

* [**Docker Secrets**](https://docs.docker.com/engine/swarm/secrets/) — secrets are provided to deployment in encrypted form.
* [**Github Secrets**](https://docs.github.com/en/actions/security-guides/encrypted-secrets/) — deployment secrets are stored encrypted in Github.

#### 5.4 Infrastructure monitoring

All access to OpenCRVS servers and infrastructure health is logged and monitored in [Kibana](https://www.elastic.co/observability/infrastructure-monitoring).

***

### 6. Rate limiting

OpenCRVS authentication and API gateway is rate limited to prevent abusive attacks such as:

* **Denial of Service (DoS)** — overwhelming the system with requests to make it unavailable.
* **Brute Force attacks** — repeatedly attempting to guess passwords or access tokens.

Rate limiting controls the number of requests a user or system can make to an API or service within a specified timeframe, preventing abuse and ensuring fair resource distribution.

***

### 7. Data Security Framework

OpenCRVS is designed to digitally store and process personally identifiable information (PII) and create copies of official documentation including unique identifiers for citizens. While OpenCRVS is regularly penetration tested and provides technical solutions to mitigate common threats, it is used within the context of human day-to-day work and interaction with the outside world.

#### 7.1 The evolving threat landscape

Criminals continually adapt and attempt to gain access to valuable citizen data. The constantly evolving cyber-security landscape includes:

* **Social engineering methods** — manipulating staff to gain access.
* **Machine learning and artificial intelligence** — automated techniques to exploit vulnerabilities.
* **Insider threats** — staff who misuse their access to the system.

Reacting to such threats often falls outside the scope of what a technical system is capable of independently defending against.

#### 7.2 The need for policies and procedures

Data security policies and procedures must be developed and adhered to by implementing project teams and operational staff when setting up and using OpenCRVS.

These policies and procedures should be:

* **Context-specific** — appropriate to the government's specific needs and threat environment.
* **Comprehensive** — covering design, implementation, monitoring, maintenance, and day-to-day usage.
* **Informed by best practice** — drawing on publicly available data security guidance, not exclusively from this document.

#### 7.3 Data Security Framework document

OpenCRVS provides a **Data Security Framework** document to support governments in developing their own policies and procedures.

This document is explained further with a video in [this section](https://documentation.opencrvs.org/setup/6.-go-live/3.3.4-set-up-an-smtp-server-for-opencrvs-monitoring-alerts).

The purpose of this document is to provide organizations with:

* An understanding of data security and privacy risks.
* An understanding of the technical steps taken in OpenCRVS to mitigate against these risks.
* A guidance framework for the development of context-specific data security policies and procedures.
* Security guidance for project managers and all staff involved on a temporary or continual basis in the following stages of an OpenCRVS project:
  * Design and implementation
  * Monitoring and maintenance
  * Day-to-day usage of OpenCRVS

Data security policies and procedures must be defined, implemented, and updated by governments appropriate to their own contextual needs. Example reference links are provided in the appendix of the Data Security Framework document.
