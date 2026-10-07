# Why VPN?

Even though OpenCRVS regularly undergoes hardening, and publicly hosted penetration testing, there are still strong architectural, operational and trust reasons to deploy it behind a VPN or private network wherever possible.&#x20;

Penetration testing demonstrates that the out-the-box system was secure against a defined set of tests at a point in time—it does not eliminate future vulnerabilities, configuration mistakes or supply chain risks.  Some key points are:



**A VPN protects sensitive personal data**

Civil registration systems contain some of the most sensitive government information:

* births
* deaths
* personal identities
* addresses
* family relationships

Minimising access aligns with the principle of least exposure.



**It reduces automated attacks**

Public services are constantly subjected to:

* credential stuffing
* password spraying
* bot traffic
* vulnerability scanning
* denial of service attempts

Private services simply do not receive the same volume of hostile traffic.



**It greatly reduces the attack surface**

* A VPN means only authenticated users and trusted systems can even reach the OpenCRVS endpoints.
* Anonymous internet scanning, reconnaissance and automated attacks never reach the application.



**Provides defence in depth**

* Security should never rely solely on application security.
* A VPN adds a network security layer in addition to authentication, authorisation, encryption and auditing.



**It protects against unknown vulnerabilities**

* New CVEs are discovered continuously in operating systems, Kubernetes, reverse proxies, databases and application frameworks.
* A VPN provides protection even before security patches are available or deployed.



**Limits exposure of authentication endpoints**

* Login and MFA endpoints are valuable attack targets.
* Keeping them private reduces opportunities for brute force, social engineering and enumeration attacks.



**It protects operational infrastructure**

* Internal APIs used by OpenCRVS components are less likely to be accidentally exposed.
* Administrative interfaces, monitoring endpoints and debugging services remain inaccessible from the internet.



**Reduces the impact of configuration mistakes**

* Even well-managed environments occasionally expose ports or misconfigure firewalls.
* A VPN makes accidental exposure significantly less damaging.



**It helps satisfy government security policies**

* Many ministries already require government systems handling identity data to operate only over government networks or approved VPNs.
* This often simplifies accreditation and security approval.



**Finally, it reduces internet dependency**

* Internal government traffic can continue operating even if public internet routing experiences issues or attacks.



***

### Effect on downstream integrations such as National ID, Education, Passports, Population Registries

This is arguably the strongest architectural reason.

Governments are understandably reluctant to allow their national identity, legal or other government systems to trust arbitrary data arriving from the public internet.

If OpenCRVS is deployed behind the same government VPN or private network:

* Other systems know requests originate from a trusted network.
* Traffic never traverses the public internet.
* Firewalls can restrict communication to specific IP ranges.
* Mutual TLS becomes easier to manage.
* The overall trust boundary is much clearer.

OpenCRVS effectively becomes another trusted government service.

If OpenCRVS is publicly accessible while other systems are private:

* Those systems must accept requests originating from the internet.
* Firewall rules must explicitly allow inbound traffic from outside the trusted network.
* Additional security controls and continuous monitoring become necessary.
* Security teams may question why a critical system is accepting data from a publicly reachable service.

Although the API requests are authenticated and cryptographically protected, the perceived trust level is lower because the source system is no longer entirely within the government's trusted network perimeter.

NID is ultimately making identity decisions based on civil registration data supplied by OpenCRVS. For example:

* creating a legal identity following birth registration
* updating a person's demographic details
* marking a person's identity following death registration

Government security teams therefore need confidence that:

* the source system is authentic
* the source system has not been compromised
* communications cannot be intercepted or spoofed
* only authorised systems can submit events

A private network helps establish this trust by ensuring the source itself resides within the government's controlled infrastructure.

***

### Public deployment is still possible

Hosting OpenCRVS publicly is not inherently insecure. With appropriate controls—including independent, and regular, penetration testing, continuous monitoring, rapid patching of updates and rigorous operational security—it can be operated safely.

If a country decides to expose OpenCRVS to the public internet, there are a number of compensating controls that can significantly reduce risk.

Some items in the checklist are covered by OpenCRVS infrastructure configuration scripts and documentation.

#### Put a WAF in front of OpenCRVS

OpenCRVS does not ship or configure a WAF. Choose a provider (for example Cloudflare, Azure Front Door or AWS WAF) that can:
* Allow traffic only from your country or from known IP ranges (government networks, embassies, partner organisations).
* Block common web attacks (OWASP Top 10) and bots with managed rule sets.
* Absorb DDoS attacks.

#### Restrict access in OpenCRVS

{% hint style="warning" %}
OpenCRVS deployment scripts provide basic protection and configuration options only. Use them together with a WAF, not instead of one.
{% endhint %}

* Limit the application to known IP ranges, and the Kibana, MinIO and Metabase consoles to administrator IPs only. See [IP Allowlisting](ip-allowlisting.md).
* Keep the default Kubernetes network policies and host firewall enabled. See [Kubernetes Network Policy](kubernetes-network-policy.md) and [Ubuntu Firewall configuration](ubuntu-firewall-configuration.md).
* Require a VPN or bastion host for SSH. See [SSH access](ssh-access.md).
* Never disable 2FA in production.
* Use mTLS for system-to-system integrations such as MOSIP. The SI terminates mTLS in front of OpenCRVS.

#### Operate it securely

* Patch OpenCRVS and the infrastructure under it promptly: OS, Kubernetes, container images, databases. See [Version upgrades](../../version-upgrades.md).
* Monitor logs and alert on failed logins and unusual API activity. See [Monitoring](../../monitoring/README.md).
* Run vulnerability scans and penetration tests regularly, not once.
* Keep encrypted, offline or immutable backups, and test restores. See [Backup & Restore](../opencrvs-maintenance-tasks/backup-and-restore/README.md).
* Have an incident response plan that names who responds and how.
