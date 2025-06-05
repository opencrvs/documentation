---
description: >-
  Interoperating with a National ID system at the point of registration, both
  synchronously and asynchronously.
---

# Registration integration

In the OpenCRVS UI, when a registrar clicks the "Register" button on a fully complete and validated declaration, the legal authority has been given to create a birth registration.  It is then possible to integrate with a National ID system, both synchronously and asynchronously.



### Synchronous integration

Once internal audit has taken place of that action in the "workflow" microservice, the following endpoint in the configurable countryconfig microservice is called while the registration is in a `WAITING_VALIDATION` status:

```
/event-registration
```

The entire registration data payload is sent to [this endpoint](https://github.com/opencrvs/opencrvs-countryconfig/blob/4d9b0081e38f11325ff47cecc3a51df85b50cffb/src/index.ts#L431) as a FHIR Bundle.

{% hint style="warning" %}
The JWT token that is sent to this payload can be used in asynchronous operations explained below.
{% endhint %}

In our example we create a birth registration number at this point and return the amended payload to OpenCRVS.  Any synchronous interaction with a National ID system can take place here.

If a 200 is returned from this handler, the record will proceed to register, gaining a `REGISTERED` status, and appear in the Ready To Print work queue.

If any error occurs such as a 500, the record will be placed in a `REJECTED` status with the reason being equal to whatever error code or message is available.  &#x20;

The following library can return a graceful rejection message.

```typescript
@hapi/boom badImplementation
```

&#x20; &#x20;

### Aynchronous integration

It is possible to use the same endpoint asynchronously.  But first, the following setting must be set to true in application-config.ts:

```typescript
EXTERNAL_VALIDATION_WORKQUEUE: true
```

This configuration setting enables a work-queue "In external validation" that can hold records in a `WAITING_VALIDATION` status until an asynchronous process completes.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-06-05 at 18.02.55.png" alt=""><figcaption></figcaption></figure>

{% hint style="danger" %}
The JWT token that is sent to the /event-registration endpoint must be stored by your asynchronous process and used in the next operation.
{% endhint %}

Using the JWT, you can call the gateway microservice GraphQL endpoint `confirmRegistration` resolver.

You can decode the JWT and retrieve the internal record uuid - the variable `id` used in the payload.

```
POST https://gateway.<your_domain>/graphql
Content-Type: application/json
Authorization: Bearer {{token}}

{
  "operationName": "confirmRegistration",
  "query": "mutation confirmRegistration(
        $id: ID!
        $details: ConfirmRegistrationInput!
      ) {
        confirmRegistration(id: $id, details: $details)
      }",  
  "variables": {
      "id":"<record uuid from JWT>",
      "details": {
        "identifiers": [{
          "type": "",
          "value": ""
        }],
        "registrationNumber": "",
        "comment": "",
      }
  }
}
```
