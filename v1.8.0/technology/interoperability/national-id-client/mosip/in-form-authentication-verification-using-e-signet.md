# In-form authentication / verification using E-Signet

{% hint style="info" %}
This section assumes that you have already read the general [National ID "in-form authentication" page](../in-form-authentication-verification.md).   If you have not read that page, read it first for a high level introduction to the concepts, and then return here.
{% endhint %}

### Routes required for integration with MOSP ID Auth SDK

In order for your countryconfig microservice to be able to handle the MOSIP ID Auth SDK checks for the  OpenCRVS validation, approval and registration status transitions, the following [routes](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/src/index.ts#L634) **must be added**:

These routes are critically important to ensure that the record moves through the process successfully.

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
