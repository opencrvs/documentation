---
description: >-
  Authenticating and verifying the identity of informants and parents during the
  event application process both offline and online.
---

# In-form authentication / verification

It's possible to [configure](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/) 3 types of form component that can interact with methods of National ID authentication and verification. Choice of component depends on your business rules and availabilty of the relevant dependencies.



### Online

If your user has connectivity, then of course it is possible to query a National ID system in 1 of 2 ways.



**API integration within an event form**

A form field component type of **HTTP** type can connect with an external API. Use it along with a **BUTTON** and any relevent field type such as **TEXT** where you may wish to store a response. Or, we also have many display UI components to show message responses, or simply to display if someone is authenticated or verified, such as **ID\_VERIFICATION\_BANNER**.  Just adopt the copy appropriately.

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
