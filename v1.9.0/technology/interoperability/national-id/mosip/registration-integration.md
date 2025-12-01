# Registration integration

{% hint style="info" %}
This section assumes that you have already read the general [National ID registration integration page](../).   If you have not read that page, read it first for a high level introduction to the concepts, and then return here.
{% endhint %}

Documentation for the form fields required for MOSIP Registration Integration in OpenCRVS 1.9 is a work in progress

### Asynchronous integration

MOSIP integration can only work asynchronously, so ensure that you have enabled the external validation workqueue and prepare to configure the endpoints we described in the link above.

Note how we customise the [onRegisterHandler](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/aa338d2974699e56db574f7df046ca8e8638f35d/src/index.ts#L670) in order to follow whatever configuration requirements exist for the country and prepare the payload for the **mosip-api** middleware that will authenticate with MOSIP, and submit data using. the MOSIP Packet Manager API.





