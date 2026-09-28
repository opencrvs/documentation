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



*   **Geofence & restrict access to known IP addresses wherever possible**

    * Whitelist government IP ranges.
    * If the system is intended for use only within a single country, consider allowing access only from IP addresses geolocated to that country.
    * Whitelist static IP addresses used by embassies, overseas missions and trusted partner organisations.
    * Avoid exposing the service to the entire internet if only a subset of users require access.


*   **Use a Web Application Firewall (WAF)**

    * Protect against common web attacks (OWASP Top 10).
    * Block known malicious traffic before it reaches OpenCRVS.
    * Enable managed rule sets and bot protection.


*   **Implement DDoS protection**

    * Use services such as Cloudflare, Azure DDoS Protection or AWS Shield.
    * Prevent the system becoming unavailable during attacks.


*   **Continue enforcing multi-factor authentication**

    * Do not disable OpenCRVS 2FA on any circumstance.


*   **Restrict administrative interfaces**

    * Restrict access to Kibana, MinIO and Metabase administrative consoles to trusted system administrator IP addresses or a private network/VPN only.
    * SSH Administration should always require VPN or bastion-host access.


*   **Apply security patches rapidly**

    * Maintain a process for monitoring security advisories.
    * Patch not only OpenCRVS, but also Kubernetes, container images, operating systems, ingress controllers, databases and other infrastructure components.


*   **Implement continuous security monitoring**

    * Centralise logs.
    * Detect unusual login patterns.
    * Alert on repeated failed authentication attempts and suspicious API activity.


*   **Perform regular vulnerability scanning**

    * Scan both infrastructure and applications.
    * Schedule periodic penetration testing rather than treating it as a one-off exercise.


*   **Use mutual TLS (mTLS) for system-to-system integrations**

    * Especially for integrations with systems such as MOSIP.
    * Ensure APIs authenticate both the client and the server.


*   **Maintain tested backup and disaster recovery procedures**

    * Ensure backups are encrypted and offline or immutable.
    * Regularly test restoration.


*   **Develop and rehearse an incident response plan**

    * Know who responds to security incidents.
    * Define communication, containment and recovery procedures in advance.





