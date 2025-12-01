# In-form authentication / verification with E-Signet

{% hint style="info" %}
This section assumes that you have already read the general [National ID "in-form authentication" page](/broken/pages/3yx3OjwfiAd2MTvsz2xS).   If you have not read that page, read it first for a high level introduction to the concepts, and then return here.
{% endhint %}

Take a look at our example configuration.  Helper form field functions are imported from our NPM library to make it easy to configure offline and online (with E-Signet) plus manual entry fields if you pay close attention to the code.

Look at how these functions are used:

### idReaderFields

This [function](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/form/birth/index.ts#L240) will apply all the UI fields in your forms on the relevant pages for both QR Code reader and E-Signet redirect.

### getInitialValueFromIDReader

This [function](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/form/birth/index.ts#L259C15-L259C42) will set the initialValue (pre-population) of a form field and disable it from being edited on succesful scanning of an authentic QR code from an NID card, or successful authentication from E-Signet.

### Offline

Observe the [qrCodeConfig](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/form/common/id-reader-configurations.ts#L37) property to configure the values that will be available for form initialValues (pre-population) from the QRCode supplied by MOSIP on their National ID cards.

### Online

Observe the [esignetConfig](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/form/common/id-reader-configurations.ts#L54) property to see the environment variables that will need to be configured to enable the redirect to E-Signet.  The available E-Signet data that can be used as initialValues (pre-population) is configurable in the OPENID\_PROVIDER\_CLAIMS value.

The mosip-api package handles all communication to/from E-Signet and more environment variables are required to be set there.  All of these variables are explained in the next section on [Deployment](/broken/pages/u2lbWVVouLFlE6wriuXf).

### Routes required for integration with MOSP ID Auth SDK

In OpenCRVS, some event actions require additional confirmation from the Country Configuration API before they can be accepted. This process is known as **action confirmation**.

The MOSIP integration uses the [Action Confirmation API ](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/develop/src/api/action-confirmation.md)to communicate with the MOSIP ID Auth SDK when using the **offline** or **manual** form field options.  This is for a secondary online authentication check once the application is submitted and passes through the OpenCRVS validation, approval and registration status transitions. &#x20;

The following [routes](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/index.ts#L634) **must be added.** These routes are critically important to ensure that the record moves through the process successfully.

```
server.route({
  method: 'POST',
  path: '/events/{event}/actions/sent-notification',
  handler: mosipRegistrationForReviewHandler({
    url: env.isProd ? 'http://mosip-api:2024' : 'http://localhost:2024'
  }),
  options: {
    tags: ['api', 'custom-event'],
    description: 'Receives notifications on sent-notification action'
  }
})

server.route({
  method: 'POST',
  path: '/events/{event}/actions/sent-notification-for-review',
  handler: mosipRegistrationForReviewHandler({
    url: env.isProd ? 'http://mosip-api:2024' : 'http://localhost:2024'
  }),
  options: {
    tags: ['api', 'custom-event'],
    description:
      'Receives notifications on sent-notification-for-review action'
  }
})

server.route({
  method: 'POST',
  path: '/events/{event}/actions/sent-for-approval',
  handler: mosipRegistrationForApprovalHandler({
    url: env.isProd ? 'http://mosip-api:2024' : 'http://localhost:2024'
  }),
  options: {
    tags: ['api', 'custom-event'],
    description: 'Receives notifications on sent-for-approval action'
  }
})
```
