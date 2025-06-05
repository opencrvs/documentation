# National ID

Civil registration provides the source of truth for any vital event that occurs in a country.  Civil registration can inform a National ID system when a birth occurs and automatically generate a national ID for the child at birth.  At point of death, a civil registration system can inform the National ID system that the person is deceased, thus preventing fraudulent usage of a National ID of a deceased person.

The partnership of Civil Registration and National ID is what collectively constitutes the foundational identity infrastructure of a nation.   As a result is usual that an integration with a country's National ID system is requested when installing a civil registration system.



OpenCRVS is agnostic regarding which National ID system it integrates with.  This section is first organised agnostically around the main business use cases.  As of OpenCRVS v1.8.0, OpenCRVS has a production ready integration library dedicated to interoperating with MOSIP and E-Signet, fellow OpenSource Digital Public Goods.  A dedicated section exists that builds on the same agnostic integration points specifically for integrating with MOSIP.

### Default functionality

Currently OpenCRVS supports the following default National ID integration functionality:

#### Use cases:

OpenCRVS can let a National ID system know of any birth that occurs in the country so that operations can be put in place to provide a National ID number for the child. OpenCRVS can let a National ID system know of any death that occurs in the country so that operations can be put in place to mark the individual as deceased.

There are 3 points of integration possible.

1\) Configuration of a HTTP, FETCH\_BUTTON, ID\_READER (used when scanning QR codes on ID cards), or ID\_VERIFICATION\_BANNER (used to display authentication status to the user) components in your declaration forms to authenticate a parent or informant's National ID via the National ID portal's APIs.

2\) Intgegration to the National ID system at the point where backend processing is [poised to register the event](https://github.com/opencrvs/opencrvs-countryconfig/blob/a84fe1bb9499fd09dd957e2744261daeeb4ee87f/src/api/event-registration/handler.ts#L21) in OpenCRVS.

3\) Subscription to the REGISTERED webhook to perform an action once the civil registration is completed.

### Future National ID integration functionality

**Revocation**: Occasionally a birth or death may be wrongly registered either fraudulently or by mistake. Any revocation in OpenCRVS should be communicated to the National ID system.

**Correction**: Occasionally data may have been entered incorrectly to the registration and a legal correction is performed in OpenCRVS. Any correction in OpenCRVS should be communicated to the National ID system.

We are continually improving our National ID integration capabilities and look forward to addressing functionality such as this in future versions of OpenCRVS. For more information, please get in touch at: **team@opencrvs.org**

### MOSIP / E-Signet integration

Previous integrations with MOSIP & E-Signet are in a state of refactor to utilise the MOSIP Packet Manager API.

OpenCRVS 1.8.0 will introduce a MVP, production ready integration with MOSIP using Packet Manager API. A new [OpenCRVS > MOSIP NPM package](https://www.npmjs.com/package/@opencrvs/mosip) has been created to ease interoperability requirements.

This [country configuration repository](https://github.com/opencrvs/opencrvs-countryconfig-mosip) gives code examples regarding how to use the package and configure the flows.

Flows are currently in a design state and will be updated and finalised for a production ready integration covering all possible unhappy path eventualities in OpenCRVS v1.9.0

{% embed url="https://www.figma.com/board/DifOmLi6RpYidYy7p28zXy/MOSIP-Integration?node-id=940-1862&t=oOM7CgPvAr4ioy9P-1" %}
