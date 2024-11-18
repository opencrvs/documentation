# 3.2.9 Countryconfig APIs explained

There are a number of further API endpoints in the countryconfig server that require explanation.

#### Content

URL:

```
/content/{application}
```

The content endpoint returns all visible text in all languages you require to display to users of the applications - the login application and the main client.  You configure the text content as JSON and this is explained in detail in the next section: step [3.2.9.1 Managing language content](3.2.9.1-managing-language-content.md) &#x20;

#### Event Registration

URL:

```
/event-registration
```

The event registration endpoint is a **synchronous** endpoint which is called by opencrvs-core at the point of registration.  You can make use of this endpoint to generate the registration number and up to 3 additional identifiers should you require this.  The logic which does this can be customised here: &#x20;

[event-registration/service.ts](https://github.com/opencrvs/opencrvs-countryconfig/blob/93a58dd80867e8613c12b9767ea7b4ca80953929/src/api/event-registration/service.ts#L27)

If the route returns a downstream error in any logic or 3rd party system you are integrating with, the registration will be rejected and appear in the registrar's "Requires updates" workqueue. In this way, when the system error is resolved, the registration can be re-submitted.

#### Notification

URL:

```
/notification
```

The notification endpoint is called by opencrvs-core whenever the main application wishes to send a message to staff or service recipients when OpenCRVS is deployed to a production server.  This is where you configure integration with your communications provider and is explained thoroughly in [step 3.3.3 Provision a comms gateway](../../3.3-set-up-a-server-hosted-environment/3.3.3-provision-a-comms-gateway.md)

#### Email&#x20;

URL:

```
/content/country-logo
```

The HTML emails that are sent to staff and beneficiaries include a government logo.  You can host this logo file here so that they render successfully.

#### Dashboard

URL:

```
/content/<your-country-map>.geojson
```

The analytics dashboards display an interactive map of your country as a visual aid. You can configure this map here as a [geojson](https://geojson.org/) file.
