# MOSIP Form Authentication

{% hint style="info" %}
This section assumes that you are familiar with the [MOSIP identity authentication flow](../../../functional/markdown/interoperability/mosip-id-integration.md) at the functional level. If you have not read that section, read it first for a high-level introduction, and then return here.
{% endhint %}

#### Overview

The MOSIP form integration provides helper functions that render eSignet authentication and QR code identity verification components directly in OpenCRVS declaration forms. These helpers are defined in [`src/events/mosip.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/mosip.ts) in the [opencrvs-integrationland](https://github.com/opencrvs/opencrvs-integrationland) repository.

Three main helper functions are available:

| Function                           | Purpose                                                                                    |
| ---------------------------------- | ------------------------------------------------------------------------------------------ |
| `getMOSIPIntegrationFields`        | Generates the full set of form fields for E-Signet authentication and QR verification      |
| `connectToMOSIPIdReader`           | Wraps individual form fields to receive values from the ID reader or E-Signet response     |
| `connectToMOSIPVerificationStatus` | Lower-level helper to add conditional show/hide/disable logic based on verification status |

#### getMOSIPIntegrationFields

This function generates the form fields required for MOSIP identity authentication on any form page. It is used for Informant, Mother, Father, Spouse, and Deceased roles across birth and death events.

Example from [`src/events/birth/forms/pages/mother.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/birth/forms/pages/mother.ts):

```typescript
import {
  getMOSIPIntegrationFields,
  connectToMOSIPIdReader,
  connectToMOSIPVerificationStatus
} from '@countryconfig/events/mosip'

// In the form page configuration:
...getMOSIPIntegrationFields('mother', {
  existingConditionals: [
    {
      type: ConditionalType.SHOW,
      conditional: requireMotherDetails
    }
  ]
})
```

The fields generated include:

1. **VERIFICATION\_STATUS** — Displays the current identity status (authenticated, verified, pending, failed).
2. **QUERY\_PARAM\_READER** (when `esignet: true`) — Reads OAuth callback parameters (`code`, `state`) from the URL.
3. **HTTP** (when `esignet: true`) — Fetches user info from the MOSIP API user info endpoint using the OAuth code.
4. **LOADER** (when `esignet: true`) — Shows a loading indicator while the HTTP request is in flight.
5. **ID\_READER** — Renders the authentication method chooser:
   * A **LINK\_BUTTON** for eSignet authentication (when `esignet: true`)
   * A **QR\_READER** for offline QR code scanning

#### connectToMOSIPIdReader

This function wraps a form field to receive its value from the MOSIP identity system. It connects the field to both the eSignet response (`verify-nid-http-fetch`) and the QR code reader (`id-reader`).

Example:

```typescript
connectToMOSIPIdReader(
  {
    id: "mother.name",
    type: FieldType.NAME,
    required: true,
    configuration: farajalandNameConfig,
    hideLabel: true,
    label: {
      defaultMessage: "Mother's name",
      description: "This is the label for the field",
      id: "event.birth.action.declare.form.section.mother.field.name.label",
    },
    conditionals: [
      {
        type: ConditionalType.SHOW,
        conditional: and(requireMotherDetails),
      },
    ],
    validation: [invalidNameValidator("mother.name")],
  },
  {
    valuePath: "data.name",
    disableIf: ["pending", "verified", "authenticated"],
  },
);
```

The second parameter configures:

* `valuePath` — The path within the HTTP response or QR data where the field value is found.
* `disableIf` — Statuses at which the field should be disabled (preventing edits after authentication/verification).
* `hideIf` — Statuses at which the field should be hidden.

#### connectToMOSIPVerificationStatus

A lower-level helper that adds conditional logic to any form field based on the current verification status. It upserts `SHOW` and `ENABLE` conditionals:

```typescript
export const connectToMOSIPVerificationStatus = (
  fieldInput: FieldConfigInput,
  { hideIf, disableIf },
): FieldConfigInput => {
  // Adds SHOW conditional: hide field when status matches hideIf
  // Adds ENABLE conditional: disable field when status matches disableIf
};
```

#### eSignet authentication URL

The eSignet redirect URL is constructed in the `LINK_BUTTON` configuration within `getMOSIPIntegrationFields`:

```typescript
url: `${ESIGNET_REDIRECT_URL}?client_id=${OPENID_PROVIDER_CLIENT_ID}&response_type=code&scope=openid%20profile&acr_values=mosip%3Aidp%3Aacr%3Agenerated-code&claims=%7B%22userinfo%22%3A%7B%22name%22%3A%7B%22essential%22%3Atrue%7D%2C%22birthdate%22%3A%7B%22essential%22%3Atrue%7D%2C%22address%22%3A%7B%22essential%22%3Atrue%7D%2C%22individual_id%22%3A%7B%22essential%22%3Atrue%7D%7D%2C%22id_token%22%3A%7B%7D%7D&state=noop`;
```

The `ESIGNET_REDIRECT_URL` and `OPENID_PROVIDER_CLIENT_ID` environment variables are configured in [`src/environment.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/environment.ts).

#### Offline identity verification via ID Auth

When eSignet is unavailable (offline registration), identity data can be captured via QR code scan or manual entry using the **QR\_READER** component. Once the system is back online, the submitted data is verified against the MOSIP ID Auth SDK through the `mosipInteropClient.verifyNid()` call in the action handler.

This verification happens in the `onBirthActionHandler` and `onDeathActionHandler` in [`src/api/events/handler.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/api/events/handler.ts).

{% hint style="warning" %}
MOSIP does not recommend offline ID Auth verification as a substitute for strong authentication — see [Identity verification on action (ID Auth)](https://app.gitbook.com/o/zub8C4BetmW3a9Bj4Cd4/s/TIJguU5Pzi7HeHrkXa4I/~/edit/~/changes/227/technical/guides/integration/mosip-registration-integration#identity-verification-on-action-id-auth) for the rationale.
{% endhint %}

#### Form pages using MOSIP integration

The helpers are used across the following form pages:

**Birth:**

* [`src/events/birth/forms/pages/informant.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/birth/forms/pages/informant.ts)
* [`src/events/birth/forms/pages/mother.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/birth/forms/pages/mother.ts)
* [`src/events/birth/forms/pages/father.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/birth/forms/pages/father.ts)

**Death:**

* [`src/events/death/forms/pages/informant.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/death/forms/pages/informant.ts)
* [`src/events/death/forms/pages/deceased.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/death/forms/pages/deceased.ts)
* [`src/events/death/forms/pages/spouse.ts`](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/events/death/forms/pages/spouse.ts)
