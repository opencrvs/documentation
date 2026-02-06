# Registration integration

{% hint style="info" %}
Based on your own business rules based on submitted bio/demographics, such as age of child / parents IDs authenticated, you need to decide whether or not to interoperate with National ID, continue to register or reject the declaration.&#x20;
{% endhint %}

You can access properties of the `declaration` and the submitting user (via `pendingAction`) to perform logical decision making like so:

```
export async function onBirthActionHandler(
  request: ActionConfirmationRequest,
  h: Hapi.ResponseToolkit
) {
  const token = request.auth.artifacts.token as string
  const event = request.payload

  const pendingAction = getPendingAction(event.actions)
  const declaration = deepMerge(
    aggregateActionDeclarations(event),
    pendingAction.declaration
  )

  /*
    declaration['child.dob'] 
    declaration['mother.nid'] 
    declaration['mother.verified'] !== 'authenticated'
  */
```

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
