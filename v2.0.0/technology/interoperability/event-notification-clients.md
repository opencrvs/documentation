---
description: >-
  Submitting full or partial event applications into OpenCRVS from an external
  service such as a health institution or public portal.
---

# Event Notification clients

An **Event Notification client** can submit full or partial events to an OpenCRVS office. You can find the technical documentation for the Event Notification APIs in our [Swagger documentation](https://api.opencrvs.org/develop/events/).

{% hint style="info" %}
You can use our [Postman collections](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/postman) to test the Event Notification API functionality. Specifically, use the **Event Notification - v1.9.0** collection.

[Postman](https://www.postman.com/) is a tool you can download to test API access before building your integrations.
{% endhint %}

The following images and examples use the fictional country [Farajaland](../../default-configuration/intro-to-farajaland.md) and its birth registration configuration. Your actual events and workflows may vary depending on your country’s configuration.

<figure><img src="../../.gitbook/assets/Screenshot 2023-01-11 at 15.39.53.png" alt=""><figcaption><p>An Event Notification in the Farajaland 'In Progress' view</p></figcaption></figure>

When Event Notifications are received in OpenCRVS, they are audited and logged as being received from an automated client. **Events submitted via the Event Notification API are saved with the status `NOTIFIED`.**

<figure><img src="../../.gitbook/assets/Screenshot 2023-01-11 at 15.40.23.png" alt=""><figcaption><p>Record audit view for an Event Notification</p></figcaption></figure>

## Submitting an Event Notification

To submit an Event Notification, your client must first request an [authorization token](authenticate-a-client.md) using your `client_id` and `client_secret`.

### Event Notification Requests

Using the token in the Authorization header, an event is notified via two sequential API requests:

1. `POST /api/events/events` to initialize the event
2. `POST /api/events/events/notifications` to submit full or partial event data and trigger the notification

The example below demonstrates how to submit a simple birth declaration based on the [Farajaland](../../default-configuration/intro-to-farajaland.md) configuration. This example will contain the child's name and date of birth details.

```http
POST /api/events/events
Content-Type: application/json
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
This request will return a response containing the event ID in the `id` field. You must use this `eventId` in the subsequent request.
{% endhint %}

Once the event is initialized, you can submit the notification:

```http
POST /api/events/events/notifications
Content-Type: application/json
Authorization: Bearer {{token}}

{
  "eventId": "{{eventId}}",
  "transactionId": "{{uuid}}",
  "createdAtLocation": "{{uuid}}"
  "declaration": {
    "child.firstname": "Jane",
    "child.surname": "Doe",
    "child.dob": "{{yyyy-MM-dd}}"
  },
  "annotation": {}
}
```

{% hint style="info" %}
The request must contain a valid facility id in the `createdAtLocation` field. For finding the correct id's, refer to the [FHIR Location REST API -documentation](fhir-location-rest-api.md)
{% endhint %}

For full API details, refer to the [Swagger documentation](https://api.opencrvs.org/develop/events/).
