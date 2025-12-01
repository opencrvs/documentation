# Registration integration

In the OpenCRVS UI, when a registrar clicks the "Register" button on a fully complete and validated declaration, the legal authority has been given to create a birth registration.  It is then possible to integrate with a National ID system, both synchronously and asynchronously.



### Synchronous integration - birth & death

Once internal audit has taken place of that action in the "workflow" microservice, the following endpoint in the configurable countryconfig microservice is called while the registration is in a `WAITING_VALIDATION` status:

```
/trigger/events/${Event.id}/actions/${ActionType.REGISTER}`
```

The entire registration data payload is sent to an [onRegisterHandler](https://github.com/opencrvs/opencrvs-countryconfig/blob/6f3759980e8f18d1d25c2c7ed89e2f671928a255/src/api/registration/index.ts#L53)

{% hint style="warning" %}
The JWT token that is sent to this payload can be used in asynchronous operations explained below.
{% endhint %}

In our example we create a birth / death registration number at this point and return the amended payload to OpenCRVS.  Any synchronous interaction with a National ID system can take place here.

If a 200 is returned from this handler, the record will proceed to register, gaining a `REGISTERED` status, and appear in the Ready To Print work queue.

If any error occurs such as a 500, the record will be placed in a `REJECTED` status with the reason being equal to whatever error code or message is available.  &#x20;

The following library can return a graceful rejection message.

```typescript
@hapi/boom badImplementation
```

&#x20; &#x20;

### Aynchronous integration - birth & death

It is possible to use the same endpoint asynchronously.  But first, the following setting must be set to true in [application-config.ts](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/):

```typescript
EXTERNAL_VALIDATION_WORKQUEUE: true
```

This configuration setting enables a work-queue "In external validation" that can hold records in a `WAITING_VALIDATION` status until an asynchronous process completes.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-06-05 at 18.02.55.png" alt=""><figcaption></figcaption></figure>

{% hint style="danger" %}
The JWT token that is sent to the onRegisterHandelr, must be stored by your asynchronous process and used in the next operation.
{% endhint %}

Using the JWT, you can call the [acceptRequestedRegistration](https://github.com/opencrvs/opencrvs-countryconfig/blob/6f3759980e8f18d1d25c2c7ed89e2f671928a255/src/api/registration/index.ts#L102) or [rejectRequestedRegistration](https://github.com/opencrvs/opencrvs-countryconfig/blob/6f3759980e8f18d1d25c2c7ed89e2f671928a255/src/api/registration/index.ts#L129) handlers to respond to OpenCRVS asynchronously and progress the registration to a REGISTERED or REJECTED status accordingly.
