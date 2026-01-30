---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings
---

# 4.2.5 Set up application settings

The next step is to configure some functional application settings. Some of these settings can be changed later, others must be configured now during installation and cannot be changed in production.

You will be referring to the **5. config: Applications Settings Excel** sheet that would have been prepared in [section 2: Gather requirements](../../../../../v1.9.0/setup/2.-gather-requirements).

## 1. Prepare global functional settings

Prepare your _**src/api/applcation/application-config.ts**_ source file. This is a Typescript file that is loaded in the application via an API explained in section [4.2.9 Countryconfig APIs explained](../../../../../v1.9.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.9-countryconfig-apis-explained).

Using our [application-config.ts](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/application/application-config.ts) file as an example, update the settings according to your needs.

<table><thead><tr><th>Parameter</th><th>Description</th></tr></thead><tbody><tr><td><pre><code><strong>APPLICATION_NAME
</strong></code></pre></td><td>You can call your instance of OpenCRVS anything you like, such as "Farajaland CR"</td></tr><tr><td><pre><code>BIRTH: {
    REGISTRATION_TARGET: 30,
    LATE_REGISTRATION_TARGET: 365,
    FEE: {
      ON_TIME: 0,
      LATE: 5.5,
      DELAYED: 15
    },
    PRINT_IN_ADVANCE: true
  }
</code></pre></td><td><strong>DEPRECATED</strong>: The code remains to support the transition of existing countries still using previous versions. Fees and certificates are now customisable in a dedicated endpoint.</td></tr><tr><td><pre><code>DEATH: {
    REGISTRATION_TARGET: 45,
    FEE: {
      ON_TIME: 0,
      DELAYED: 0
    },
    PRINT_IN_ADVANCE: true
  }
</code></pre></td><td><strong>DEPRECATED</strong>: The code remains to support the transition of existing countries still using previous versions. Fees and certificates are now customisable in a dedicated endpoint.</td></tr><tr><td><pre><code>SYSTEM_IANA_TIMEZONE
</code></pre></td><td>Default timezone for the country. Basis for date and time calculations during searches: <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">https://en.wikipedia.org/wiki/List_of_tz_database_time_zones</a></td></tr><tr><td><pre><code>ADMIN_STRUCTURE: [
    {
      id: 'province',
      label: {
        id: 'field.address.province.label',
        defaultMessage: 'Province',
        description: 'Label for province in address'
      }
    },
    {
      id: 'district',
      label: {
        id: 'field.address.district.label',
        defaultMessage: 'District',
        description: 'Label for district in address'
      }
    }
  ]
</code></pre></td><td><strong>🏛️</strong> In section <a href="../../../../../v1.9.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions">4.2.2</a> you had to configure admin levels for our standardised address <strong>Hierarchy Levels.</strong> This property must be completed with the ids and labels to be used in a form FieldType.ADDRESS component below. They are required fields. Optional fields will appear below these selects. The label prop, and further details around localisation are explained in the next section: <a href="../../../../../v1.9.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/3.2.9.1-managing-language-content">4.2.5.1 Managing language content</a></td></tr><tr><td>Related to the above, here is an example screenshot of standardised address <strong>Hierarchy Level selects</strong>:</td><td><div><figure><img src="../../../../.gitbook/assets/Screenshot 2025-11-26 at 17.24.05.png" alt=""><figcaption></figcaption></figure></div></td></tr><tr><td><pre><code>MARRIAGE: {
    REGISTRATION_TARGET: 45,
    FEE: {
      ON_TIME: 10,
      DELAYED: 45
    },
    PRINT_IN_ADVANCE: true
  }
</code></pre></td><td><strong>DEPRECATED</strong>: The code remains to support the transition of existing countries still using previous versions. Fees and certificates are now customisable in a dedicated endpoint.</td></tr><tr><td><pre><code>CURRENCY: {
    languagesAndCountry: ['en-US'],
    isoCode: 'USD'
  }
</code></pre></td><td>Fees due for collection and correction of certificates are calculated and displayed according to this value.</td></tr><tr><td><pre><code>PHONE_NUMBER_PATTERN
</code></pre></td><td>This is a regular expression to evaluate if a supplied phone number minus country code is valid.</td></tr><tr><td><pre><code>NID_NUMBER_PATTERN
</code></pre></td><td>If you configure your form to include a field to capture a user's National ID number, then this regular expression can evaluate if the string is valid.</td></tr><tr><td><pre><code>COUNTRY_LOGO
</code></pre></td><td>If you look at the top of the file, you can see that this refers to a property that imports a copy of your country logo as a base64 image. Do not change this property but instead, locate your official logo/crest, convert it to base64 and you can replace our logo [here](<a href="https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/application/country-logo.ts">https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/application/country-logo.ts</a>).</td></tr><tr><td><pre><code>LOGIN_BACKGROUND: {
backgroundColor: '36304E'
}
</code></pre></td><td><p>You can set the background of the login page to be a color of choice. You can always use the UI to change this color later, or use a tiled or full screen image.</p><p>Other available properties are:</p><pre class="language-typescript"><code class="lang-typescript">backgroundImage data:image/jpg;base64,${fs       .readFileSync(join(__dirname, 'login-bg.jpg'))       .toString('base64')},
imageFit: 'FILL'
</code></pre></td></tr><tr><td><pre><code>FIELD_AGENT_AUDIT_LOCATIONS
</code></pre></td><td><strong>DEPRECATED:</strong> The code remains to support the transition of existing countries still using previous versions. Performance ahanlytics are now entirely configurable in Metabase.</td></tr><tr><td><pre><code>DECLARATION_AUDIT_LOCATIONS
</code></pre></td><td><strong>DEPRECATED:</strong> The code remains to support the transition of existing countries still using previous versions. Performance ahanlytics are now entirely configurable in Metabase.</td></tr><tr><td><pre><code>USER_NOTIFICATION_DELIVERY_METHOD
</code></pre></td><td><strong>DEPRECATED:</strong> The code remains to support the transition of existing countries still using previous versions. User notifications will use email as a delivery method by default but this can be configured. There does not have to be a universal method of delivery in practice.</td></tr><tr><td><pre><code>INFORMANT_NOTIFICATION_DELIVERY_METHOD
</code></pre></td><td><strong>DEPRECATED:</strong> The code remains to support the transition of existing countries still using previous versions. Informant notifications will use email as a delivery method by default but this can be configured. There does not have to be a universal method of delivery in practice.</td></tr><tr><td><pre><code>export const COUNTRY_WIDE_CRUDE_DEATH_RATE = 10
</code></pre></td><td><strong>This cannot be amended later in the UI and must be configured here.</strong> You will notice this separate property used by an API handler called by our analytics services. Whereas countries generally have crude birth rate ratios per area in their stastics, they tend to have a country-wide crude death rate. You can set this here in order to correctly calculate death registration completeness rates.</td></tr><tr><td><pre class="language-typescript"><code class="lang-typescript">SIGNATURE_REQUIRED_FOR_ROLES
</code></pre></td><td>The National System Administrator can create new employees. In the create user forms, the requirement to add a transparent PNG signature for certain employee roles, so that the signature can appear on the certificate can be configured here.</td></tr><tr><td><pre><code>SEARCH_DEFAULT_CRITERIA
</code></pre></td><td><p>This relates to the "Quick search" feature in the search bar. Availbale options for the default value in the select are:</p><pre class="language-typescriptreact"><code class="lang-typescriptreact">TRACKING_ID
REGISTRATION_NUMBER
NATIONAL_ID
NAME
PHONE_NUMBER
EMAIL
</code></pre></td></tr><tr><td>Example screenshot for above:</td><td><div><figure><img src="../../../../.gitbook/assets/Screenshot 2025-11-26 at 17.42.47.png" alt=""><figcaption></figcaption></figure></div></td></tr><tr><td><pre><code>FEATURES: { ... }
</code></pre></td><td><strong>The following features can be enabled on and off in this block. We refer to this block as "Feature flags</strong></td></tr><tr><td><pre><code>DATE_OF_BIRTH_UNKNOWN
</code></pre></td><td><strong>This cannot be amended later in the UI and must be configured here.</strong> In some countries, individuals do not know their date of birth. If you wish to enable that individuals are allowed to submit their ages in your declaration forms rather than a date of birth, set this to true. <strong>Please note that those individuals will have their days and months of birth automatically set to the 1st January in the system in that case.</strong></td></tr><tr><td><pre><code>DEATH_REGISTRATION
</code></pre></td><td><strong>DEPRECATED:</strong> Any event, and its associated availability, is now configurable.</td></tr><tr><td><pre><code>MARRIAGE_REGISTRATION
</code></pre></td><td><strong>DEPRECATED:</strong> Any event, and its associated availability, is now configurable.</td></tr><tr><td><pre><code>PRINT_DECLARATION
</code></pre></td><td><strong>DEPRECATED:</strong> A Field.Type.ALPHA_PRINT_BUTTON can now be added to enable printing any SVG "template" from any page of the form.</td></tr><tr><td><pre><code>INFORMANT_SIGNATURE
INFORMANT_SIGNATURE_REQUIRED
</code></pre></td><td><strong>DEPRECATED:</strong> Signatures are now entierly configurable on any field on the form.</td></tr><tr><td><pre><code>EXTERNAL_VALIDATION_WORKQUEUE
</code></pre></td><td>This prop controls the visibility of a workqueue that you can use for asynchronous integration with an external system at the point of registration via APIs. As an example, we use this for MOSIP asynchronous generation of a National ID.</td></tr></tbody></table>

## 2. Prepare javascript initialisation settings

{% embed url="https://youtu.be/j1mTlrL5Gy8" %}

The OpenCRVS Core Login application loads the following config js files before connecting to the OpenCRVS backend to serve all the content. The Login app has not communicated with the backend yet and needs to know how to access it

**Login app - localhost development:** [**login-config.js**](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/login-config.js)

```
window.config = {
  AUTH_API_URL: 'http://localhost:7070/auth/',
  CONFIG_API_URL: 'http://localhost:2021',
  // Country code in uppercase ALPHA-3 format
  COUNTRY: 'FAR',
  LANGUAGES: 'en,fr',
  CLIENT_APP_URL: 'http://localhost:3000/',
  COUNTRY_CONFIG_URL: 'http://localhost:3040',
  SENTRY: ''
}
```

As you can see, the React Login application uses the URL values to understand how to connect to backend services such as the login authentication API and the country configuration API. **Do not edit the URLs.**

**You must set some values**:

**COUNTRY**: Set the [Alpha 3 country code](https://www.iban.com/country-codes) to be the same as the value you used when importing the set up files in step 3.2.5. The Login app needs to convert users phone numbers into MSISDN numbers using an Alpha 3 country code in case the user forgets their login details and requires an SMS reset.

**LANGUAGES:** This property allows you to customise the global language options. This value is a comma separated string of [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language codes for every translation you wish to set up in step [3.2.5.1 Managing language content](../../../../../v1.9.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/broken-reference/).

For example, if you wanted to support Spanish and English, with Spanish being the default this string should be:

```
es,en
```

**Login app - server:** [**login-config.prod.js**](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/login-config.prod.js)

```
window.config = {
  AUTH_API_URL: 'https://gateway.{{hostname}}/auth/',
  CONFIG_API_URL: 'https://config.{{hostname}}',
  // Country code in uppercase ALPHA-3 format
  COUNTRY: 'FAR',
  LANGUAGES: 'en,fr',
  CLIENT_APP_URL: 'https://register.{{hostname}}/',
  COUNTRY_CONFIG_URL: 'https://countryconfig.{{hostname}}',
  SENTRY: '{{sentry}}'
}
```

As you ca**n see, the server config file contains the same settings.**

You may notice that localhost is replaced by your domain name dynamically in handlebars. **Do not edit the URLs.** We have taken care of this substitution for you in step [3.3.5 Deploy](../../../../../v1.9.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/broken-reference/)

You must set the **COUNTRY & LANGUAGES** values only.

**Client app - localhost development:** [**client-config.js**](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/client-config.js)

```
window.config = {
  API_GATEWAY_URL: 'http://localhost:7070/',
  CONFIG_API_URL: 'http://localhost:2021',
  LOGIN_URL: 'http://localhost:3020',
  AUTH_URL: 'http://localhost:4040',
  MINIO_BUCKET: 'ocrvs',
  MINIO_URL: 'http://localhost:3535/ocrvs/',
  MINIO_BASE_URL: 'http://localhost:3535', 
  COUNTRY_CONFIG_URL: 'http://localhost:3040',
  // Country code in uppercase ALPHA-3 format
  COUNTRY: 'FAR',
  LANGUAGES: 'en,fr',
  SENTRY: '',
  DASHBOARDS: [
    {
      id: 'registrations',
      title: {
        id: 'dashboard.registrationsTitle',
        defaultMessage: 'Registrations Dashboard',
        description: 'Menu item for registrations dashboard'
      },
      url: `http://localhost:4444/public/dashboard/03be04d6-bde0-4fa7-9141-21cea2a7518b#bordered=false&titled=false&refresh=300` // Filled in below
    },
    {
      id: 'completeness',
      title: {
        id: 'dashboard.completenessTitle',
        defaultMessage: 'Completeness Dashboard',
        description: 'Menu item for completeness dashboard'
      },
      url: `http://localhost:4444/public/dashboard/41940907-8542-4e18-a05d-2408e7e9838a#bordered=false&titled=false&refresh=300`
    },
    {
      id: 'registry',
      title: {
        id: 'dashboard.registryTitle',
        defaultMessage: 'Registry',
        description: 'Menu item for registry dashboard'
      },
      url: `http://localhost:4444/public/dashboard/dc66b77a-79df-4f68-8fc8-5e5d5a2d7a35#bordered=false&titled=false&refresh=300`
    }
  ],
  FEATURES: {}
}
```

Following the same process as you did for the local development Login app config file, you must set the **COUNTRY & LANGUAGES** values, and can optionally change the menu item titles for each of the available analytics dashboards configurable via Metabase.

**Client app - server:** [**client-config.prod.js**](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/client-config.prod.js)

```
;(function initClientConfig() {
  const scheme = window.location.protocol // "http:" or "https:"
  const hostname = '{{hostname}}' // Replaced dynamically
  const sentry = '{{sentry}}' // Replaced dynamically

  window.config = {
    API_GATEWAY_URL: `${scheme}//gateway.${hostname}/`,
    CONFIG_API_URL: `${scheme}//config.${hostname}`,
    LOGIN_URL: `${scheme}//login.${hostname}`,
    AUTH_URL: `${scheme}//gateway.${hostname}/auth/`,
    MINIO_URL: `${scheme}//minio.${hostname}/ocrvs/`,
    MINIO_BASE_URL: `${scheme}//minio.${hostname}`, // URL without path/bucket information, used for file uploads, v2
    MINIO_BUCKET: 'ocrvs',
    COUNTRY_CONFIG_URL: `${scheme}//countryconfig.${hostname}`,
    // Country code in uppercase ALPHA-3 format
    COUNTRY: 'FAR',
    LANGUAGES: 'en,fr',
    SENTRY: sentry,
    DASHBOARDS: [
      {
        id: 'registrations',
        title: {
          id: 'dashboard.registrationsTitle',
          defaultMessage: 'Registrations Dashboard',
          description: 'Menu item for registrations dashboard'
        },
        url: `${scheme}//metabase.${hostname}/public/dashboard/03be04d6-bde0-4fa7-9141-21cea2a7518b#bordered=false&titled=false&refresh=300`
      },
      {
        id: 'completeness',
        title: {
          id: 'dashboard.completenessTitle',
          defaultMessage: 'Completeness Dashboard',
          description: 'Menu item for completeness dashboard'
        },
        url: `${scheme}//metabase.${hostname}/public/dashboard/41940907-8542-4e18-a05d-2408e7e9838a#bordered=false&titled=false&refresh=300`
      },
      {
        id: 'registry',
        title: {
          id: 'dashboard.registryTitle',
          defaultMessage: 'Registry',
          description: 'Menu item for registry dashboard'
        },
        url: `${scheme}//metabase.${hostname}/public/dashboard/dc66b77a-79df-4f68-8fc8-5e5d5a2d7a35#bordered=false&titled=false&refresh=300`
      }
    ],
    FEATURES: {}
  }
})()
```

Following the same process as you did for the production Login app config file, you must set the **COUNTRY & LANGUAGES** values.
