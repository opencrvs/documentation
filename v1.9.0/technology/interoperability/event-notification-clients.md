---
description: >-
  Submitting full or partial event applications into OpenCRVS from an external
  service such as a health institution or public portal.
---

# Event Notification clients

An Event Notification client can submit full or partial events into an OpenCRVS' office. The technical documentation for the Event Notification API's are found in our [Swagger-documentation](https://api.opencrvs.org/develop/events/).

{% hint style="info" %}
You can use our [Postman collections](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/postman) to test Event Notification API functionality. Specifically, use the **Event Notification - v1.9.0 -collection**.

[Postman](https://www.postman.com/) is a tool you can download to test API access before building your integrations.
{% endhint %}

The following images and examples use our fictional country's, [Farajaland's](../../default-configuration/intro-to-farajaland.md), birth registration configuration. However, the actual events and workflows will depend on your own country's configuration.

<figure><img src="../../.gitbook/assets/Screenshot 2023-01-11 at 15.39.53.png" alt=""><figcaption><p>An Event Notification in the Farajaland 'In Progress' view</p></figcaption></figure>

When Event Notifications are received in OpenCRVS, they are audited accordingly as being received from one of your automated clients. **Events notified via the Event Notification API are saved with status `NOTIFIED`.**

<figure><img src="../../.gitbook/assets/Screenshot 2023-01-11 at 15.40.23.png" alt=""><figcaption><p>Record Audit view for an Event Notification</p></figcaption></figure>

**Submitting an Event Notification**

To submit an Event Notification, your client must first request an [authorization token](authenticate-a-client.md) using your `client_id` and `client_secret`.

#### Event Notification Requests

With the token as an authorization header, events are notified with two subsequent API requests:

1. `POST /api/events/events` to initialize an event
2. `POST /api/events/events/notifications` to send full or partial event values and notify an event

With the token as an authorization header, the following requests will submit a minimal birth declaration on the [Farajaland](../../default-configuration/intro-to-farajaland.md) configuration.

```http
POST /api/events/events
content-type: application/json
Authorization: Bearer {{token}}

{
    "type": "v2.birth",
    "transactionId": "{{uuid}}",
    "dateOfEvent": {
        "fieldId": "child.dob"
    }
}
```

{% hint style="info" %}
This request will respond with a payload containing the event id, in the `id` field. This event id must be used in the following request.
{% endhint %}

After the request above is sent, the event will be initialized and ready for receiving the notification:

```http
POST /api/events/events/notifications
content-type: application/json
Authorization: Bearer {{token}}

{
    "eventId": "{{eventId}}",
    "transactionId": "{{uuid}}",
    "declaration": {
        "child.firstname": "Jane",
        "child.surname": "Doe",
        "child.dob": "{{yyyy-MM-dd}}"
    },
    "annotation": {}
}
```

See the detailed documentation for the API's in [Swagger](https://api.opencrvs.org/develop/events/).
