# Action triggers

### 1. Introduction

**OpenCRVS** provides a flexible, event-driven way for countries to extend and customise system behaviour through **action triggers.**

Action triggers allow country implementations to react to important actions performed on civil registration records — such as declarations, registrations, approvals, certificate printing, or user management events. Instead of embedding integrations and notifications inside the core system, OpenCRVS delegates control to the country configuration, enabling safer upgrades, greater flexibility, and full ownership of business logic.

This approach replaces the earlier single notification endpoint used in v1.x and introduces a generalised, extensible mechanism that works across all life events and workflows.

***

### 2. Feature overview

Action triggers enable country configuration packages to:

#### Listen to actions across all life events

Triggers can be attached to actions such as:

* declare
* register
* approve/reject
* print certificate
* view
* notify
* custom actions

These apply to **all configured events**, including:

* births
* deaths
* marriages
* adoptions
* any custom event type

***

#### Access the complete record

When a trigger fires, the configuration service receives:

* the full record document
* all form data
* metadata
* the complete change history

This supports:

* statistical reporting
* audit trails
* compliance checks
* downstream integrations

***

#### Send fully customised notifications

Countries control:

* SMS templates
* Email templates
* Language logic
* Message timing

Notifications can use any field from the record payload, enabling personalised, branded communication.

***

#### Integrate with external systems

Triggers provide a clean integration point for:

* national ID databases
* population registers
* health systems
* payment gateways
* document management systems
* analytics pipelines

Typical use cases:

* validating identity numbers
* generating national IDs
* syncing data to other ministries
* exporting statistics

***

#### Pause or intercept workflows

Triggers can temporarily **hold the workflow** while processing:

* return `202 Accepted` to pause
* perform async validation or external calls
* confirm completion later

This ensures data integrity before registration is finalised.

***

#### Handle user lifecycle events

Triggers are also available for system users.

| Endpoint                             | Purpose                                      |
| ------------------------------------ | -------------------------------------------- |
| `POST /triggers/user/user-created`   | Send welcome or onboarding messages          |
| `POST /triggers/user/reset-password` | Send customised password reset notifications |

***

### 4. Worked example

#### Business requirement: Send confirmation SMS on marriage registration

When a marriage is registered:

1. Send confirmation SMS
2. Include name of bride and groom
3. Include registration number
4. Include the next steps to collect marriage certificate

#### Configuration Code:

Register trigger endpoint

```
POST /triggers/events/marriage/actions/register
```

Implement logic

```jsx
server.route({
  method: 'POST',
  path: '/triggers/events/marriage/actions/register',
  handler: async (request, h) => {
    const record = request.payload

    // Send SMS
    await sendSMS(record.contact.phone,
      `Marriage registered. Certificate No: ${number}`)

    return h.response().code(200)
  }
})
```

All logic remains outside core, in country-configuration making upgrades safe and maintenance simpler.

***

### 5. Summary

Action triggers in OpenCRVS provide a powerful, event-driven extension mechanism that:

* works across all life events
* supports full record access
* enables complete notification control
* integrates cleanly with third-party systems
* allows workflow interception
* replaces legacy single-endpoint notifications

By moving custom behaviour into country configuration, implementations gain flexibility while keeping the core platform stable and upgradeable.

**In short:** action triggers turn OpenCRVS into a highly adaptable platform that can meet each country’s legal, operational, and technical requirements without modifying core code.

Examples:

MOSIP Email notifications
