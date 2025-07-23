# National ID

### Why integrate OpenCRVS with National ID?

Civil registration provides the source of truth for any vital event that occurs in a country.  Civil registration can inform a National ID system when a birth occurs and therefore instigate the generation of a National ID for the child at birth.  At the point of death, a civil registration system can inform the National ID system that the person is deceased, thus preventing fraudulent usage of a National ID of a deceased person.

The partnership of Civil Registration and National ID is what collectively constitutes the foundational identity infrastructure of a nation.  &#x20;

[Bridging the Identity Gap: Integrating Civil Registration and National Identity Systems](http://prod-website-903390823.ap-south-1.elb.amazonaws.com/mosip16.9/bridging-the-identity-gap-integrating-civil-registration-and-national-identity-systems)



### Which National ID systems can OpenCRVS interoperate with?

OpenCRVS is agnostic regarding which National ID system it integrates with.  This section is first organised around the main business use cases. &#x20;

As of OpenCRVS v1.8.0, OpenCRVS has a production ready integration library dedicated to interoperating with [MOSIP](https://www.mosip.io/) and [E-Signet](https://docs.esignet.io/), fellow OpenSource Digital Public Goods.  A dedicated section exists that builds on the same agnostic integration points specifically for integrating with MOSIP.

In the past, OpenCRVS has delivered proof-of-concept (not production ready) integrations with [INGroupe](https://ingroupe.com/) and [OSIA standard](https://secureidentityalliance.org/osia) National ID systems



### Existing National ID integration functionality

Currently OpenCRVS supports the following default National ID integration functionality:

* Authenticating and verifying the identity of informants and parents during the event application process both offline and online.
* Configurable rules to determine whether or not a civil registration event should or should not integrate with a National ID system at the point of registration.
* Integration with a National ID system at the point of registration synchronously and asynchronously



### Roadmapped National ID integration functionality

The following business functionality is not currently supported but is in our roadmap

* Notifying a National ID system of any legal correction to a previously registered record
* Notifying a National ID system of any legal revocation of a previously registered record
* Notifying a National ID system of any legal name change
* Authenticating and verifying the identity of an individual who is collecting an issued certificate

