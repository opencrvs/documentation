---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/technology/interoperability/national-id/registration-integration
---

# Registration integration

In the OpenCRVS UI, when a registrar clicks the "Register" button on a fully complete and validated declaration, the legal authority has been given to create a birth registration.  It is then possible to integrate with a National ID system, both synchronously and asynchronously.



### Synchronous integration - birth & death

Once internal audit has taken place of that action in the "workflow" microservice, the following endpoint in the configurable countryconfig microservice is called while the registration is in a `WAITING_VALIDATION` status:

```
/trigger/events/${Event.id}/actions/${ActionType.REGISTER}`
```

Refer to our [default](https://github.com/opencrvs/opencrvs-countryconfig/blob/ef1160edee76b4aa2f619d81f396c740346f6565/src/index.ts#L672) and [MOSIP](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/index.ts#L668) example.

{% hint style="warning" %}
The JWT token that is sent to this payload should be used to communicate back with OpenCRVS using a client from our toolkit: `import { createClient } from '@opencrvs/toolkit/api'`
{% endhint %}

In our example we create a birth / death registration number at this point and return the amended payload to OpenCRVS.  Any interaction with a National ID system can take place here.



Using the JWT, you can process your integration and respond to OpenCRVS as you wish, progressing the declaration to a [REGISTERED](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/registration/index.ts#L111) or [REJECTED](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/registration/index.ts#L172) status accordingly.

### Aynchronous integration - birth & death

It is possible to use the same endpoint asynchronously.  But first, you must configure an in-external-validation workqueue in your [worqueueConfig](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/workqueue/workqueueConfig.ts#L377C3-L399C5) and ensure that the correct users have permission to view the workqueue in [roles.ts](https://roles.tshttps/github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/data-seeding/roles/roles.ts#L162C7-L162C138).

**workqueueConfig.ts**

```
{
    slug: 'in-external-validation',
    icon: 'FileText',
    name: {
      id: 'workqueues.inExternalValidation.title',
      defaultMessage: 'In external validation',
      description: 'Title of in external validation workqueue'
    },
    query: {
      flags: {
        anyOf: [
          `${ActionType.REGISTER}:${ActionStatus.Requested}`.toLowerCase()
        ]
      },
      updatedAtLocation: { type: 'exact', term: user('primaryOfficeId') }
    },
    actions: [
      {
        type: 'DEFAULT',
        conditionals: []
      }
    ]
  },
```

**roles.ts**

```
'workqueue[id=in-external-validation...
```

This configuration setting enables a work-queue "In external validation" that can hold records in a `WAITING_VALIDATION` status until an asynchronous process completes.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-06-05 at 18.02.55.png" alt=""><figcaption></figcaption></figure>

{% hint style="danger" %}
The JWT token that is sent to countryconfig must be stored by your asynchronous process in order to communicate back with OpenCRVS.  In our MOSIP example, it is stored in an SQLite DB.
{% endhint %}
