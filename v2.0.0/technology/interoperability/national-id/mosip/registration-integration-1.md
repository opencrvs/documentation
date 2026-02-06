# Registration integration

{% hint style="info" %}
This section assumes that you have already read the general [National ID registration integration page](../) and are familiar with those concepts.  If you have not read that page, read it first for a high level introduction to the concepts, and then return here.
{% endhint %}

Our example shows integration with the [mosip-api](https://github.com/opencrvs/mosip/tree/main/packages/mosip-api) middleware at this point.

We perform [some business logic](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/registration/index.ts#L195) based on props in the `declaration` and `pendingAction` and continue to MOSIP or reject.

Then we create a `createMosipInteropClient` [client](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/registration/index.ts#L215) to register a [birth](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/registration/index.ts#L221) or [death](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/api/registration/index.ts#L297).

Asynchronous return of a MOSIP credential being issued is performed via websub.  The OpenCRVS JWT is retrieved from SQLite and [registered with OpenCRVS](https://github.com/opencrvs/mosip/blob/dfa03cd9ea9cc01b4ec257edee5c0dc9837b1bbc/packages/mosip-api/src/routes/websub-credential-issued.ts#L63).  All that code is abstracted away inside the middleware.  You can decide to fork and configure as appropriate.
