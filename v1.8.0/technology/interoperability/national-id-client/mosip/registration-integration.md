---
description: >-
  Using MOSIP's Packet Manager API for asynchronous integration at the point of
  registration
---

# Registration integration

{% hint style="info" %}
This section assumes that you have already read the general [National ID registration integration page](../registration-integration.md).   If you have not read that page, read it first for a high level introduction to the concepts, and then return here.
{% endhint %}

### Asynchronous integration

MOSIP integration can only work asynchronously, so ensure that you have enabled the external validation workqueue and prepare to configure the endpoints we described in the link above.

Note how we customise the event-registration endpoint in order to follow whatever configuration requirements exist for the country and prepare the payload for the **mosip-api** middleware that will authenticate with MOSIP, and submit data using. the MOSIP Packet Manager API at [this](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/index.ts#L445) point in the code:

```
handler: async (request, h) => {
  const url = env.isProd ? 'http://mosip-api:2024' : 'http://localhost:2024'
  const result = await verify({ url, request })
  const bundle = request.payload as fhir3.Bundle

  if (shouldForwardToIDSystem(request.payload as fhir3.Bundle, result)) {
    const payload =
      getEventType(bundle) === 'BIRTH'
        ? fhirBirthToMosip(bundle)
        : fhirDeathToMosip(bundle)

    logger.info(
      'Passed country specified custom logic check for id creation. Forwarding to MOSIP...'
    )

    return mosipRegistrationHandler({
      url,
      headers: request.headers,
      payload
    })(request, h)
  } else {
    logger.info(
      'Failed country specified custom logic check for id creation. Bypassing id system...'
    )
    return eventRegistrationHandler(request, h)
  }
}
```

Lets delve into the example functions we have written to explain the logic.

### shouldForwardToIDSystem

There will be edge cases in your civil registration and foundational identity business processes where you do not always want to create a MOSIP National ID at the point of birth, or inform MOSIP at death,  depending on the demographic data completed by the informant.  This function examines the payload according to these **purely example rules**.  You should configure these according to the laws and processes relevant to your country:

* In this example, we are only creating a National ID at birth if any of the parents or informant have successfully completed "in-form authentication", using QR Code or E-Signet
* At death, we are only informing MOSIP that the deceased has passed if the spouse has successfully completed "in-form authentication", using QR Code or E-Signet
* We are only creating a National ID at birth automatically from the cvil registration if the child is under 10 years of age.  If the child is over 10, then to create a National ID, they will be required to do so directly in MOSIP and submit their biometrics.

### fhirBirthToMosip / fhirDeathToMosip

Every country has a different form configuration with different questions and sections and different requirements regarding the demographic data points that are required by MOSIP. &#x20;

The configurability of the systems are key selling points of both MOSIP & OpenCRVS. &#x20;

The OpenCRVS form data is expressed in the FHIR standard and therefore must be converted into a format that is understandable by the MOSIP Packet Manager API.  That is the purpose of these mapping functions.  You should customise them to suit the form that you have configured and the MOSIP data requirements that your country has decided to configure.

### mosipRegistrationHandler

This function is imported from our NPM library into your countryconfig repo and calls the mosip-api middleware.  The mosip-api middleware creates and stores an Application ID (AID) along with the Birth Registration Number and sends the full payload with this metadata to MOSIP. &#x20;

For reference, this logic is here: [https://github.com/opencrvs/mosip/blob/9c43d0f902416935b04a95344819fc43b5b44d62/packages/mosip-api/src/routes/event-registration.ts#L89](https://github.com/opencrvs/mosip/blob/9c43d0f902416935b04a95344819fc43b5b44d62/packages/mosip-api/src/routes/event-registration.ts#L89)

The metadata is stored in an SQLLite database.  MOSIP processes asynchronously, so the mosip-api has to subscribe to MOSIP WebSub status updates which will contain the metadata so OpenCRVS can identify status updates with the correct application. &#x20;

In the case of birth for example, when the status of the MOSIP application is successful, the mosip-api can retrieve the record from the SQLLite database, append the VID and inform OpenCRVS Core that MOSIP registration is completed.



### Running the mosip-api and mocks in development

Checkout this repo and follow the README to run the middleware and mocks alongside your local instance of OpenCRVS:

{% embed url="https://github.com/opencrvs/mosip/tree/main" %}
