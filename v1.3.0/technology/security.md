# Security

{% hint style="info" %}
We treat the security of OpenCRVS and the personally identifiable citizen data it stores with utmost care.
{% endhint %}

Every release of the OpenCRVS application and infrastructure has been security penetration tested by an independent, [CREST](https://www.crest-approved.org/) and [CyberEssentials](https://www.ncsc.gov.uk/cyberessentials/overview) certified 3rd party to UK government standards. &#x20;

The latest penetration test of OpenCRVS was performed by [GoFore](https://gofore.com/) - [NORAD's](https://www.norad.no/) preferred security testing provider. [GoFore](https://gofore.com/) Plc conducts security assessments for public and private organisations in the form of white hat penetration testing (aka ethical hacking) to simulate an adversary attacking the system and identifying vulnerabilities that may be exploited to compromise data confidentiality, integrity and availability.

Gofore pentesters utilise proven pentesting methods of code review, automated enumeration scans via the public internet, fuzzing with diverse input, and manual tests. The security assessment was conducted in two rounds, first to identify and report vulnerabilities, and then reassessed to ensure reported vulnerabilities were resolved.

> _"Already from the results of the first assessment, it was evident that the OpenCRVS web application had a good security posture. The web application security fundamentals were sound."_&#x20;
>
> GoFore Cyber Security Consultant

### **Key security points**

All servers must be protected behind a government virtual private network or VPN.  It should not be possible to browse to OpenCRVS on the open internet without successful configuration and access through a VPN client

OpenCRVS Core team can provision a basic [Wireguard VPN](https://www.wireguard.com/) where an existing gov VPN does not exist but OpenCRVS Core team cannot advise on how to manage and maintain the VPN.

Please note that despite the fact that OpenCRVS software is regularly penetration tested on every official release, every installation of OpenCRVS infrastructure and every country configuration of the VPN, servers and OpenCRVS software should be independently penetration tested by a 3rd party cyber security organisation.&#x20;

{% hint style="danger" %}
&#x20;OpenCRVS Core team accepts no liability for the security of your installation of OpenCRVS.
{% endhint %}

#### **Two factor authentication**

Our mobile application and microservices are secure, protected by [2-Factor Authentication](https://en.wikipedia.org/wiki/Multi-factor\_authentication) utilising [OAuth JWT best practices](https://tools.ietf.org/id/draft-ietf-oauth-jwt-bcp-02.html).  2FA codes are sent to the user's mobile device in order log in.  These codes time out after 5 minutes preventing brute force attack and ensuring only authenticated users with access to authenticated hardware can access OpenCRVS.

#### Access controls

User types and access controls are managed in order to segregate personally identifiable data to only to the users who need it. These user types can be set up in the Team GUI accessible by National and Local System Administrators.  Every access to a specific declaration or registration is audited in order to track who viewed the data thus protecting citizen rights.

#### Ansible firewalls

All OpenCRVS data is encrypted in transit and at rest. OpenCRVS includes daily, automated, external back up as a configurable option in our [Ansible](https://www.ansible.com/) script.  The Ansible script automatically provisions a secure firewall to OpenCRVS on each node.

#### SSL certificate

OpenCRVS SSL certificate is automatically provisioned by [Traefik](https://traefik.io/) signed by [LetsEncrypt](https://letsencrypt.org/), and automatically rotates

#### Database encryption

Encryption keys to the databases, API keys and sensitive environment secrets are never stored in .env files but instead are stored in RAM in inaccessible [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/) and provided to deployment by inaccessible [Github Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

All access to OpenCRVS servers and infrastructure health is logged and monitored in [Kibana](https://www.elastic.co/observability/infrastructure-monitoring).
