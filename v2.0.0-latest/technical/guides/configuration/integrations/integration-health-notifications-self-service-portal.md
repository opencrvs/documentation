---
description: >-
  Submitting full or partial event applications into OpenCRVS from an external
  service such as a health institution or public portal.
---

# Integration: Health notifications / Self-service portal

An **Event Notification client** can submit full or partial events to an OpenCRVS office.&#x20;

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-06-30 at 09.42.48.png" alt=""><figcaption></figcaption></figure>

When Event Notifications are received in OpenCRVS, they receive the status "Notified", are audited and logged as being received from an automated client, and appear within the Notifications workqueue.

#### Submitting an Event Notification

With an authorised token, first [create an event](https://documentation.opencrvs.org/technical/apis/core-apis/events#post-events).

{% hint style="info" %}
This request will return a response containing the event ID in the `id` field. You must use this `eventId` in the subsequent request.
{% endhint %}

#### Event Notification Requests

Once the event is creaeted, you can submit the [notification](https://documentation.opencrvs.org/technical/apis/core-apis/events#post-events-eventid-notify).
