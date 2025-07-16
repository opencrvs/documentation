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



Note how we customise the event-registration endpoint in order to follow whatever configuration requirements exist for the country and prepare the payload for the MOSIP Packet Manager API at [this](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/index.ts#L445) point in the code:

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
