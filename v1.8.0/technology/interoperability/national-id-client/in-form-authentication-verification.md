---
description: >-
  Authenticating and verifying the identity of informants and parents during the
  event application process both offline and online.
---

# In-form authentication / verification

It's possible to [configure](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/) 3 types of form component that can interact with methods of National ID authentication and verification. Choice of component depends on your business rules and availabilty of the relevant dependencies.

### Offline

If your user has no connectivity, and if your country issues a National ID card to users that contains a QR code, then a form field component of **ID\_READER** type can parse the contents of the QR code and pre-populate some fields in the form.



### Online

If your user has connectivity, then of course it is possible to query a National ID system in 1 of 2 ways.

**API integration within an event form**

A form field component of **HTTP** type can connect with an external API. Use it along with a **BUTTON** and any relevant form pre-population field types such as **TEXT** where you may wish to store a response.&#x20;

Alternatively, we supply many display UI components to show message responses, or simply to display if someone is authenticated or verified, such as **ID\_VERIFICATION\_BANNER**.  Just adopt the copy appropriately.

```
{
  name: 'queryNISystem',
  type: 'HTTP',
  hideInPreview: true,
  custom: true,
  label: { id: 'form.label.empty', defaultMessage: ' ' },
  validator: [],
  options: {
    url: '/api/v1/niSystem', // Containerised middleware with access to the NI System API
    method: 'GET'
  }
},
{
  name: 'responseNISystem',
  type: 'TEXT',
  label: {},
  required: true,
  custom: true,
  initialValue: {
    expression: '$form.queryNISystem?.data',
    dependsOn: ['queryNISystem'] // An input field that may display the result of the query
  },
  maxLength: 10,
  conditionals: [
    {
      action: 'hide',
      expression: '!$form.queryNISystem?.data'
    }
  ],
  validator: [],
  mapping: {
    template: { // mapping function related to return value in certificates
    },
    mutation: { // mapping function related to submission of value in declaration
    },
    query: { // mapping function related to querying of value in declaration download
    }
  }
},
{
  name: 'submitButton',
  type: 'BUTTON',
  custom: true,
  hideInPreview: true,
  validator: [],
  options: {
    trigger: 'queryNISystem',
    shouldHandleLoadingState: true
  },
  conditionals: [
    {
      action: 'hide',
      expression: '$form.queryNISystem?.data'
    },
    {
      action: 'disable',
      expression: '$form.queryNISystem?.error'
    }
  ],
  label: {},
  buttonLabel: {},
  icon: 'UserCircle',
  loadingLabel: {}
}
```



**Redirect to NID auth portal from within an event form**

A form field component of **LINK\_BUTTON** type can redirect the user to an external NID web interface for authentication.  An auuthorised token can then be returned to the form and used in a similar way to the API example above to retrieve further values from the NID system for form pre-population.

```
{
  name: 'redirectToIDSystemAuth',
  validator: [],
  icon: {
    desktop: "Globe",
    mobile: "Fingerprint",
  },
  type: "LINK_BUTTON",
  custom: true,
  label: {},
  hideInPreview: true,
  conditionals: [
    {
      action: "disable",
      expression: "!!$form.redirectCallbackFetch",
    },
  ],
  mapping: {
    mutation: {
      operation: "ignoreFieldTransformer",
    }
  },
  options: {
    url: 'https://your-id-system-auth.gov',
    callback: {
      params: {
        state: "fetch-on-mount",
      },
      trigger: '', // Can simulate a subsequent HTTP field click to retrieve authorised data in a subsequent request
    }
  }
}
```
