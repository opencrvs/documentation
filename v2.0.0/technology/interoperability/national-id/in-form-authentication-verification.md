---
description: >-
  Authenticating and verifying the identity of informants and parents during the
  event application process both offline and online.
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/technology/interoperability/national-id/in-form-authentication-verification
---

# In-form authentication / verification

It's possible to [configure](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/) 3 types of form component that can interact with methods of National ID authentication and verification. Choice of component depends on your business rules and availabilty of the relevant dependencies.

### Offline

If your user has no connectivity, and if your country issues a National ID card to users that contains a QR code, then a form field component of **QR\_READER** type can parse the contents of the QR code and pre-populate some fields in the form.

```
{
  type: FieldType.QR_READER,
  label: {
    id: `event.birth.action.declare.form.section.${page}.field.qr.label`,
    defaultMessage: 'Scan QR code',
    description: 'This is the label for the field'
  },
  id: `${page}.id-reader`
}
```

### Online

If your user has connectivity, then of course it is possible to query a National ID system in 1 of 2 ways.

**API integration within an event form**

A form field component of **HTTP** type can connect with an external API. Use it along with a **BUTTON** allowing you to trigger the request and display progress indication to a user. where you may wish to store a response.  Use it with a component like **TEXT** to display returned results.

In this example, observe how conditionals are used to control the process, exposing it only to a certain user type and disabling when offline.  These are optional but introduce a better user experience.

```
{
  id: 'child.createNID',
  type: FieldType.HTTP,
  label: {
    defaultMessage: 'iD',
    description: 'This is the label for the field',
    id: 'event.birth.action.declare.form.section.child.field.iD.label'
  },
  configuration: {
    method: 'POST',
    url: '/api/countryconfig/nid',
    body: {
      office: '$user.primaryOffice.name'
    },
    trigger: field('child.nidGenerator'),
    timeout: 5000,
    headers: {
      'Content-Type': 'application/json'
    }
  },
  conditionals: [
    {
      type: ConditionalType.DISPLAY_ON_REVIEW,
      conditional: never()
    }
  ]
},
{
  id: 'child.nidGenerator',
  type: FieldType.BUTTON,
  label: {
    defaultMessage: 'NID',
    description: 'NID',
    id: 'event.birth.child.nid.label'
  },
  conditionals: [
    {
      type: ConditionalType.ENABLE,
      conditional: and(
        field('child.createNID').isUndefined(),
        user.isOnline()
      )
    },
    {
      type: ConditionalType.SHOW,
      conditional: and(
        user.hasRole('LOCAL_REGISTRAR'),
        field('child.createNID').get('loading').isFalsy(),
        field('child.createNID').get('data').isFalsy()
      )
    },
    {
      type: ConditionalType.DISPLAY_ON_REVIEW,
      conditional: never()
    }
  ],
  configuration: {
    icon: 'IdentificationCard',
    text: {
      defaultMessage: 'Generate NID',
      description: 'Generate NID',
      id: 'event.birth.child.nid.label'
    }
  }
},
{
  id: 'child.nidGeneratorLoading',
  type: FieldType.BUTTON,
  label: {
    defaultMessage: 'NID',
    description: 'NID',
    id: 'event.birth.child.nid.label'
  },
  conditionals: [
    {
      type: ConditionalType.ENABLE,
      conditional: never()
    },
    {
      type: ConditionalType.SHOW,
      conditional: field('child.createNID').get('loading').isEqualTo(true)
    }
  ],
  configuration: {
    loading: true,
    text: {
      defaultMessage: 'Generating NID...',
      description: 'Generating NID...',
      id: 'event.birth.child.nid-generation.label'
    }
  }
},
{
  id: 'child.nidGeneratorSuccess',
  type: FieldType.BUTTON,
  label: {
    defaultMessage: 'NID',
    description: 'NID',
    id: 'event.birth.child.nid.label'
  },
  conditionals: [
    {
      type: ConditionalType.ENABLE,
      conditional: never()
    },
    {
      type: ConditionalType.SHOW,
      conditional: not(field('child.http-text').isFalsy())
    }
  ],
  configuration: {
    icon: 'Check',
    text: {
      defaultMessage: 'NID generated',
      description: 'NID generated',
      id: 'event.birth.child.nid-generated.label'
    }
  }
},
{
  id: 'child.iD',
  type: FieldType.TEXT,
  parent: field('child.createNID'),
  required: true,
  label: {
    defaultMessage: 'NID',
    description: 'This is the label for the field',
    id: 'event.birth.child.nid.label'
  },
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: and(
        field('child.createNID').get('error').isFalsy(),
        user.isOnline(),
        user.hasRole('LOCAL_REGISTRAR')
      )
    },
    {
      type: ConditionalType.ENABLE,
      conditional: never()
    }
  ],
  value: field('child.createNID').get('data')
},
```



**Redirect to NID auth portal from within an event form**

A form field component of **LINK\_BUTTON** type can redirect the user to an external NID web interface for authentication.  An auuthorised token can then be returned to the form and used in a similar way to the API example above to retrieve further values from the NID system for form pre-population. &#x20;

Look at this example for an E-Signet redirect.  The param `&state=fetch-on-mount` must be returned in order to re-load the form page at the correct point.

```
{
  id: `${page}.verify`,
  type: FieldType.LINK_BUTTON,
  label: {
    id: 'verify.label',
    defaultMessage: 'Authenticate',
    description: 'The title for the E-Signet verification button'
  },
  configuration: {
    icon: 'Globe',
    url: `${ESIGNET_REDIRECT_URL}?client_id=${OPENID_PROVIDER_CLIENT_ID}&response_type=code&scope=openid%20profile&acr_values=mosip:idp:acr:static-code&claims=name,family_name,given_name,middle_name,birthdate,address&state=fetch-on-mount`,
    text: {
      id: 'verify.label',
      defaultMessage: 'e-Signet',
      description: 'The title for the E-Signet verification button'
    }
  }
}
```

To collect paramters from a redirect URL for use within fields in the form after redirect use **QUERY\_PARAM\_READER**.

```
{
  id: `${page}.query-params`,
  type: FieldType.QUERY_PARAM_READER,
  conditionals: [
    {
      type: ConditionalType.DISPLAY_ON_REVIEW,
      conditional: never()
    }
  ],
  label: {
    id: 'form.query-params.label',
    defaultMessage: 'Query param reader',
    description:
      'This is the label for the query param reader field - usually this is hidden'
  },
  configuration: {
    pickParams: ['code', 'state']
  }
},
```

A LOADER component can render a spinner in the page:

```
{
    id: `${page}.fetch-loader`,
    type: FieldType.LOADER,
    parent: field(`${page}.verify-nid-http-fetch`),
    conditionals: [
      {
        type: ConditionalType.SHOW,
        conditional: not(
          field(`${page}.verify-nid-http-fetch`).get('loading').isFalsy()
        )
      },
      {
        type: ConditionalType.DISPLAY_ON_REVIEW,
        conditional: never()
      }
    ],
    label: {
      id: 'form.fetch-loader.label',
      defaultMessage: "Fetching the person's data from E-Signet",
      description:
        'This is the label for the fetch individual information loader'
    },
    configuration: {
      text: {
        id: 'form.fetch-loader.label',
        defaultMessage: "Fetching the person's data from E-Signet",
        description:
          'This is the label for the fetch individual information loader'
      }
    }
  }
```

An **ID\_READER** that wraps components in a visually appealing way, and **VERIFICATION\_STATUS** component can provide valuable visual indicators to users and improve overall user experience.

```
{
  id: `${page}.id-reader`,
  type: FieldType.ID_READER,
  required: false,
  label: {
    defaultMessage: 'QR Code',
    description: 'This is the label for the field',
    id: `event.birth.action.declare.form.section.${page}.field.qr.label`
  },
  conditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: existingShowConditional?.conditional
        ? and(
            existingShowConditional?.conditional,
            not(
              or(
                field(`${page}.verified`).isEqualTo('pending'),
                field(`${page}.verified`).isEqualTo('verified'),
                field(`${page}.verified`).isEqualTo('authenticated'),
                field(`${page}.verified`).isEqualTo('failed')
              )
            )
          )
        : not(
            or(
              field(`${page}.verified`).isEqualTo('pending'),
              field(`${page}.verified`).isEqualTo('verified'),
              field(`${page}.verified`).isEqualTo('authenticated'),
              field(`${page}.verified`).isEqualTo('failed')
            )
          )
    },
    {
      type: ConditionalType.DISPLAY_ON_REVIEW,
      conditional: never()
    }
  ],
  methods: [
    {
      type: FieldType.QR_READER,
      ...
    },
    {
      id: `${page}.verify`,
      type: FieldType.LINK_BUTTON,
      ...
    }
  ]
}

...

{
  id: `${page}.verified`,
  type: FieldType.VERIFICATION_STATUS,
  parent: [
    field(`${page}.verify-nid-http-fetch`),
    field(`${page}.id-reader`)
  ],
  label: {
    id: `${page}.verified.status`,
    defaultMessage: 'Verification status',
    description: 'The title for the status field label'
  },
  configuration: {
    status: {
      id: 'verified.status.text',
      defaultMessage:
        '{value, select, authenticated {ID Authenticated} verified {ID Verified} failed {Unverified ID} pending {Pending verification} other {Invalid value}}',
      description:
        'Status text shown on the pill on both form declaration and review page'
    },
    description: {
      id: 'verified.status.description',
      defaultMessage:
        "{value, select, authenticated {This identity has been successfully authenticated with the Farajaland’s National ID System. To make edits, please remove the authentication first.} verified {This identity data has been successfully verified with the Farajaland’s National ID System. Please note that their identity has not been authenticated using the individual's biometrics. To make edits, please remove the verification first.} pending {Identity pending verification with Farajaland’s National ID system} failed {The identity data does not match an entry in Farajaland’s National ID System} other {Invalid value}}",
      description: 'Description text of the status'
    }
  },
  conditionals: existingConditionals,
  value: [
    field(`${page}.verify-nid-http-fetch`).get('data.verificationStatus'),
    field(`${page}.id-reader`).get('data.verificationStatus')
  ]
}
```
