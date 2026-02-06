---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/technology/interoperability/national-id/mosip/in-form-authentication-verification-with-e-signet
---

# In-form authentication / verification with E-Signet

{% hint style="info" %}
This section assumes that you have already read the general [National ID - In-form authentication /verification](../in-form-authentication-verification.md) section and understand the basic concepts of the fields which will render in your form when using these helper functions.   If you have not read that page, read it first for a high level introduction to the concepts, and then return here.
{% endhint %}

In the countryconfig-mosip repo, observe helper functions on the [mother.ts](https://mother.tshttps/github.com/opencrvs/opencrvs-countryconfig-mosip/blob/develop/src/form/v2/birth/forms/pages/mother.ts) page ...

[A helper function that uses](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/form/v2/birth/forms/pages/mother.ts#L112) the **ID\_READER** component to render a **QR\_READER** and **LINK\_BUTTON** to redirect users to E-Signet.  **QUERY\_PARAM\_READER**, **LOADER** & **HTTP**  components are built in to control the subsequent _OIDP\_USERINFO_ requests that E-Signet requires.  **VERIFICATION\_STATUS** components broadcast the correct user experience both for E-Signet and offline QR validation.

{% hint style="success" %}
This helper function means that you do not need to code and configure any of the above components individually.
{% endhint %}

```
...getMOSIPIntegrationFields('mother', {
  existingConditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: requireMotherDetails
    }
  ]
})
```

[A helper function that ensures](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/a02aad6e0d8a8a6bfbfd31f35b77e63b409615f6/src/form/v2/birth/forms/pages/mother.ts#L120C5-L144C7) returned values from the requests pre-populate and disable input fields on the form.

```
connectToMOSIPIdReader(
  {
    id: 'mother.name',
    type: FieldType.NAME,
    required: true,
    configuration: farajalandNameConfig,
    hideLabel: true,
    label: {
      defaultMessage: "Mother's name",
      description: 'This is the label for the field',
      id: 'event.birth.action.declare.form.section.mother.field.name.label'
    },
    conditionals: [
      {
        type: ConditionalType.SHOW,
        conditional: and(requireMotherDetails)
      }
    ],
    validation: [invalidNameValidator('mother.name')]
  },
  {
    valuePath: 'data.name',
    disableIf: ['pending', 'verified', 'authenticated']
  }
),
```
