---
description: >-
  Submitting full or partial event applications into OpenCRVS from an external
  service such as a health institution or public portal.
---

# Integration: Health notifications / Self-service portal

An **Event Notification client** can submit full or partial events to an OpenCRVS office.

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-06-30 at 09.42.48.png" alt=""><figcaption></figcaption></figure>

When Event Notifications are received in OpenCRVS, they receive the status "Notified", are audited and logged as being received from an automated client, and appear within the Notifications workqueue.

#### Submitting an Event Notification

With an authorised token, first [create an event](https://documentation.opencrvs.org/technical/apis/core-apis/events#post-events).

{% hint style="info" %}
This request will return a response containing the event ID in the `id` field. You must use this `eventId` in the subsequent request.
{% endhint %}

#### Event Notification Requests

Once the event is creaeted, you can submit the [notification](https://documentation.opencrvs.org/technical/apis/core-apis/events#post-events-eventid-notify).



#### Example API integration: DHIS2 Annual Conference 2026

During a demonstration at the [DHIS2](https://dhis2.org/) Annual Conference 2026, [OpenFN](https://www.openfn.org/) ran a cron job to monitor new "Tracked Entities" in DHIS2 every 24 hours, then transform the entities into an OpenCRVS Event Notification payload. &#x20;

The demonstration used hardcoded CRVS\_OFFICE and HEALTH\_FACILITY ids.  These can be dynamically retrieved via the OpenCRVS [Location](https://app.gitbook.com/s/SSLwN6XKBBaNBtMjawLL/technical/apis/core-apis/locations) API.

This [repository](https://github.com/opencrvs/event-notification-integration) contains example code to submit the notification to OpenCRVS.
