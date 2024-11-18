# Security

{% hint style="info" %}
We treat the security of OpenCRVS and the personally identifiable citizen data it stores with utmost care.
{% endhint %}

Every release of the OpenCRVS application and infrastructure has been security penetration tested by an independent, [CREST](https://www.crest-approved.org/) and [CyberEssentials](https://www.ncsc.gov.uk/cyberessentials/overview) certified 3rd party to UK government standards. &#x20;

Penetration tests of OpenCRVS have been performed by [MDSec](https://www.mdsec.co.uk/), [The Guardian Project](https://guardianproject.info/code/) on behalf of UNICEF, and [GoFore](https://gofore.com/) - [NORAD's](https://www.norad.no/) preferred security testing provider.

As an example, [GoFore](https://gofore.com/) Plc conducts security assessments for public and private organisations in the form of white hat penetration testing (aka ethical hacking) to simulate an adversary attacking the system and identifying vulnerabilities that may be exploited to compromise data confidentiality, integrity and availability.

Gofore pentesters utilise proven pentesting methods of code review, automated enumeration scans via the public internet, fuzzing with diverse input, and manual tests. The security assessment was conducted in two rounds, first to identify and report vulnerabilities, and then reassessed to ensure reported vulnerabilities were resolved.

> _"Already from the results of the first assessment, it was evident that the OpenCRVS web application had a good security posture. The web application security fundamentals were sound."_&#x20;
>
> GoFore Cyber Security Consultant

### **Key security points**

#### **Two factor authentication**

Our server SSH access, mobile application and microservices are secure, protected by [2-Factor Authentication](https://en.wikipedia.org/wiki/Multi-factor\_authentication) utilising [OAuth JWT best practices](https://tools.ietf.org/id/draft-ietf-oauth-jwt-bcp-02.html).  2FA codes are sent to the user's mobile device in order log in either via SMS or Google Authenticator.  These codes ensure that only  users with access to authenticated hardware can access OpenCRVS.

#### Access controls and audit trail

User types and access controls are managed in order to segregate personally identifiable data to only to the users who need it. These user types can be set up in the Team GUI accessible by National and Local System Administrators.  Every access to a specific declaration or registration is audited in order to track who viewed the data thus protecting citizen rights.  All access to OpenCRVS servers and infrastructure health is logged and monitored in [Kibana](https://www.elastic.co/observability/infrastructure-monitoring).  SSH access to servers requires Google Authenticator 2FA.

#### Ansible provisioned firewall & VPN

OpenCRVS automatically provisions a secure firewall to OpenCRVS on each node.  OpenCRVS should only be installed behind a separately configured and managed, government owned VPN.  OpenCRVS can automatically provision a Wireguard VPN for use in pilot projects only - not for use in production.

#### TLS certificate

OpenCRVS data is encrypted in transit via an SSL certificate that can be automatically provisioned and rotated by [Traefik](https://traefik.io/) signed by [LetsEncrypt](https://letsencrypt.org/), depending on DNS and VPN configuration.

#### Database encryption

Encryption keys to the databases, API keys and sensitive environment secrets are never stored in .env files but instead are stored in RAM in inaccessible [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/) and provided to deployment by inaccessible [Github Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).





### Data security framework

OpenCRVS is software to digitally enable civil registration processes and as such is designed to digitally store and process personally identifiable information (PII) and also create copies of official documentation including unique identifiers for citizens. It is a technical solution that is regularly penetration tested to industry standards, and where technically possible, OpenCRVS provides solutions to mitigate against common threats. &#x20;

However, OpenCRVS is used within the context of human day-to-day work and interaction with the outside world. This is a world where we should expect criminals to continually adapt and attempt to gain access to valuable citizen data.  The constantly evolving cyber-security landscape includes social engineering methods, machine learning and artificial intelligence. Criminals may adopt these techniques to exploit staff who use OpenCRVS and attack the servers and networks on which it is installed. &#x20;

Reacting to such threats often falls outside the scope of what a technical system is capable of independently defending against.  Therefore data security policies and procedures must be developed and adhered to by implementing project teams and operational staff when setting up and using OpenCRVS.

We provide a "Data Security Framework" document explained further with a video in [this section](../setup/6.-go-live/3.3.4-set-up-an-smtp-server-for-opencrvs-monitoring-alerts.md).  The purpose of this document is to provide organisations with:

* An understanding of data security and privacy risks.&#x20;
* An understanding of the technical steps taken in OpenCRVS to mitigate against these risks.
* A guidance framework for the development of context-specific data security policies and procedures that should be designed and introduced by a government that has chosen to install OpenCRVS and digitise their civil registration system. &#x20;
* Security guidance for project managers and all staff involved on a temporary or continual basis in the following stages of an OpenCRVS project: a) design & implementation b) monitoring & maintenance and c) day-to-day usage of OpenCRVS.

Data security policies and procedures must be defined, implemented and updated by governments appropriate to their own contextual needs and should be informed by publicly available content specific to the subject of data security and not exclusively from this document.  Some example reference links are provided in the appendix, which may prove useful for developing such policies. &#x20;

\
