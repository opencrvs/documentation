# 4.2.5 Set up application settings

The next step is to configure some functional application settings. Some of these settings can be changed later, others must be configured now during installation and cannot be changed in production.

You will be referring to the **5. config: Applications Settings Excel** sheet that would have been prepared in [section 2: Gather requirements](../../../2.-gather-requirements/).

## 1. Prepare global functional settings

Prepare your _**src/api/applcation/application-config.ts**_ source file. This is a Typescript file that is loaded in the application via an API explained in section [3.2.9 Countryconfig APIs explained](../3.2.9-countryconfig-apis-explained.md).

Using our [application-config.ts](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/application/application-config.ts) file as an example, update the settings according to your needs.&#x20;

| Parameter                                                                                                                                                                                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <pre><code><strong>APPLICATION_NAME
</strong></code></pre>                                                                                                                                              | You can call your instance of OpenCRVS anything you like, such as "Farajaland CR"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| <pre><code>BIRTH: {
    REGISTRATION_TARGET: 30,
    LATE_REGISTRATION_TARGET: 365,
    FEE: {
      ON_TIME: 0,
      LATE: 5.5,
      DELAYED: 15
    },
    PRINT_IN_ADVANCE: true
  }
</code></pre> | <p>These are your registration time periods in days and fees for <strong>birth</strong>, explained in more detail <a href="../../../../product-specifications/core-functions/5.-print-certificate.md">here</a>.  PRINT_IN_ADVANCE allows you to print  certificates in advance for collection.  You can disable this by setting it to false, if you operationally want to enforce an ID check from a recipient before printing a copy.  </p><p></p><p>The FEE object sets default fees for certification as a fallback if you havent configured individual fees for specific certificate templates.  Explained in section <a href="../3.2.6-configure-certificate-templates.md">Configure certificate templates</a></p> |
| <pre><code>DEATH: {
    REGISTRATION_TARGET: 45,
    FEE: {
      ON_TIME: 0,
      DELAYED: 0
    },
    PRINT_IN_ADVANCE: true
  }
</code></pre>                                                      | These are your registration time periods and fees for **death.**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| <pre><code>MARRIAGE: {
    REGISTRATION_TARGET: 45,
    FEE: {
      ON_TIME: 10,
      DELAYED: 45
    },
    PRINT_IN_ADVANCE: true
  }
</code></pre>                                                 | <p>These are your registration time periods and fees for <strong>marriage.</strong>  </p><p></p><p><strong>Marriage registration only exists in beta in OpenCRVS v1.7.0.  All events are  covered in v1.9.0</strong></p>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| <pre><code>CURRENCY: {
    languagesAndCountry: ['en-US'],
    isoCode: 'USD'
  }

</code></pre>                                                                                                        | Fees due for collection and correction of certificates are calculated and displayed according to this value.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| <pre><code>PHONE_NUMBER_PATTERN
</code></pre>                                                                                                                                                           | This is a regular expression to evaluate if a supplied phone number minus country code is valid.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| <pre><code>NID_NUMBER_PATTERN
</code></pre>                                                                                                                                                             | If you configure your form to include a field to capture a user's National ID number, then this regular expression can evaluate if the string is valid.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| <pre><code>COUNTRY_LOGO
</code></pre>                                                                                                                                                                   | You can always use our Farajaland logo by default and then upload this in the UI later, but if you look at the top of the file, you can see that this refers to a property that imports a copy of your country logo as a base64 image.  Do not change this property but instead, locate your official logo/crest, convert it to base64 and you can replace our logo \[here]\([https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/application/country-logo.ts](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/application/country-logo.ts)).                                                                                                                               |
| <pre><code>LOGIN_BACKGROUND: {
    backgroundColor: '36304E'
  }
</code></pre>                                                                                                                          | <p>You can set the background of the login page to be a color of choice.  You can always use the UI to change this color later, or use a tiled or full screen image.  </p><p></p><p>Other available properties are:</p><pre class="language-typescript"><code class="lang-typescript">backgroundImage `data:image/jpg;base64,${fs
      .readFileSync(join(__dirname, 'login-bg.jpg'))
      .toString('base64')}`,
imageFit: 'FILL'
</code></pre>                                                                                                                                                                                                                                                                      |
| <pre><code>FIELD_AGENT_AUDIT_LOCATIONS
</code></pre>                                                                                                                                                    | **This cannot be amended later in the UI and must be configured here.** In application performance analytics, you can set the administrative level that you wish to aggregate field agent performance.  We recommend that you leave this as DISTRICT as it refers to the FHIR "district" location level as opposed to your internal country name for location level 2.  If your country is very small and has only 1 location level, set this to STATE.                                                                                                                                                                                                                                                                 |
| <pre><code>DECLARATION_AUDIT_LOCATIONS
</code></pre>                                                                                                                                                    | **This cannot be amended later in the UI and must be configured here.** In application performance analytics, you can set the administrative level that you wish to aggregate field agent declaration completeness performance.  We recommend that you leave this as DISTRICT as it refers to the FHIR "district" location level as opposed to your internal country name for location level 2.  If your country is very small and has only 1 location level, set this to STATE.                                                                                                                                                                                                                                        |
| <pre><code>USER_NOTIFICATION_DELIVERY_METHOD
</code></pre>                                                                                                                                              | **This cannot be amended later in the UI and must be configured here.** If you are using SMS or WhatsApp to send notifications to **staff**, set this to "sms".  If you are using email, set this to "email"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| <pre><code>INFORMANT_NOTIFICATION_DELIVERY_METHOD
</code></pre>                                                                                                                                         | **This cannot be amended later in the UI and must be configured here.** If you are using SMS or WhatsApp to send notifications to **informants**, set this to "sms".  If you are using email, set this to "email"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| <pre><code>export const COUNTRY_WIDE_CRUDE_DEATH_RATE = 10
</code></pre>                                                                                                                                | **This cannot be amended later in the UI and must be configured here.** You will notice this separate property used by an API handler called by our analytics services.  Whereas countries generally have crude birth rate ratios per area in their stastics, they tend to have a country-wide crude death rate.  You can set this here in order to correctly calculate death registration completeness rates.                                                                                                                                                                                                                                                                                                          |
| <p></p><pre class="language-typescript"><code class="lang-typescript">SIGNATURE_REQUIRED_FOR_ROLES
</code></pre>                                                                                        | The National System Administrator can create new employees.  In the create user forms, the requirement to add a transparent PNG signature for certain employee roles, so that the signature can appear on the certificate can be configured here.                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| <pre><code>FEATURES: { ... }
</code></pre>                                                                                                                                                              | **The following features can be enabled on and off in this block.  We refer to this block as "Feature flags**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| <pre><code>DATE_OF_BIRTH_UNKNOWN
</code></pre>                                                                                                                                                          | **This cannot be amended later in the UI and must be configured here.**  In some countries, individuals do not know their date of birth.  If you wish to enable that individuals are allowed to submit their ages in your declaration forms rather than a date of birth, set this to true.  **Please note that those individuals will have their days and months of birth automatically set to the 1st January in the system in that case.**                                                                                                                                                                                                                                                                            |
| <pre><code>DEATH_REGISTRATION
</code></pre>                                                                                                                                                             | Whether to enable the registration of death events in your OpenCRVS installation.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| <pre><code>MARRIAGE_REGISTRATION
</code></pre>                                                                                                                                                          | Whether to enable the registration of marriage events in your OpenCRVS installation. In OpenCRVS v1.3 we have released marriage registration in BETA.  Set this property to true in order to demonstrate marriage registration as a proof of concept.  Get in touch with us at [team@opencrvs.org](mailto:team@opencrvs.org) if you wish to use marriage registration in production.  We require to complete marriage performance analytics and searching in order to release this feature in a future version.  **It is not yet production ready.**                                                                                                                                                                    |
| <pre><code>PRINT_DECLARATION
</code></pre>                                                                                                                                                              | If enabled, you are able to print the review page of any declaration form including all the data entered by the applicant in an easy to read fashion.  This can be a useful tool.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| <pre><code>INFORMANT_SIGNATURE
INFORMANT_SIGNATURE_REQUIRED
</code></pre>                                                                                                                               | These props enable the informant signature component on the review page.  Signatures are now configurable also in the form config so it is likely that this prop will be deprecated in future versions.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| <pre><code>EXTERNAL_VALIDATION_WORKQUEUE
</code></pre>                                                                                                                                                  | This prop controls the visibility of a workqueue that you can use for asynchronous integration with an external system at the point of registration via APIs.  As an example, we use this for MOSIP asynchronous generation of a National ID.                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

## 2. Prepare javascript initialisation settings



{% embed url="https://youtu.be/j1mTlrL5Gy8" %}

The OpenCRVS Core Login application loads the following config js files before connecting to the OpenCRVS backend to serve all the content.  The Login app has not communicated with the backend yet and needs to know how to access it

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

As you can see, the React Login application uses the URL values to understand how to connect to backend services such as the login authentication API and the country configuration API.   **Do not edit the URLs.**&#x20;

**You must set some values**:

**COUNTRY**: Set the [Alpha 3 country code](https://www.iban.com/country-codes) to be the same as the value you used when importing the set up files in step 3.2.5. The Login app needs to convert users phone numbers into MSISDN numbers using an Alpha 3 country code in case the user forgets their login details and requires an SMS reset.

**LANGUAGES:** This property allows you to customise the global language options. This value is a comma separated string of [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language codes for every translation you wish to set up in step [3.2.5.1 Managing language content](3.2.9.1-managing-language-content/).

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

You may notice that localhost is replaced by your domain name dynamically in handlebars. **Do not edit the URLs.** We have taken care of this substitution for you in step [3.3.5 Deploy](../../3.3-set-up-a-server-hosted-environment/3.3.6-deploy-automated-and-manual/)

You must set the **COUNTRY & LANGUAGES** values only.

**Client app - localhost development:** [**client-config.js**](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/client-config.js)

```
window.config = {
  API_GATEWAY_URL: 'http://localhost:7070/',
  CONFIG_API_URL: 'http://localhost:2021',
  LOGIN_URL: 'http://localhost:3020',
  AUTH_URL: 'http://localhost:4040',
  MINIO_BUCKET: 'ocrvs',
  COUNTRY_CONFIG_URL: 'http://localhost:3040',
  // Country code in uppercase ALPHA-3 format
  COUNTRY: 'FAR',
  LANGUAGES: 'en,fr',
  SENTRY: '',
  // Use the values in comments when Metabase is running locally
  // http://localhost:4444/public/dashboard/acae0527-74be-4804-a3ee-f8b3c9c8784c#bordered=false&titled=false&refresh=300
  LEADERBOARDS_DASHBOARD_URL: '',
  // http://localhost:4444/public/dashboard/fec78656-e4f9-4b51-b540-0fed81dbd821#bordered=false&titled=false&refresh=300
  REGISTRATIONS_DASHBOARD_URL: '',
  // http://localhost:4444/public/dashboard/a17e9bc0-15a2-4bd1-92fa-ab0f346227ca#bordered=false&titled=false&refresh=300
  STATISTICS_DASHBOARD_URL: ''
}
```

Following the same process as you did for the local development Login app config file, you must set the **COUNTRY & LANGUAGES** values, and can optionally uncomment **LEADERBOARDS\_DASHBOARD\_URL, REGISTRATIONS\_DASHBOARD\_URL** and **STATISTICS\_DASHBOARD\_URL** if you wish to run metabase dashboards locally.  Refer to[ this step](4.2.5.2-configuring-metabase-dashboards.md) for more instructions.

**Client app - server:** [**client-config.prod.js**](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/client-config.prod.js)

```
window.config = {
  API_GATEWAY_URL: 'https://gateway.{{hostname}}/',
  CONFIG_API_URL: 'https://config.{{hostname}}',
  LOGIN_URL: 'https://login.{{hostname}}',
  AUTH_URL: 'https://auth.{{hostname}}',
  MINIO_BUCKET: 'ocrvs',
  COUNTRY_CONFIG_URL: 'https://countryconfig.{{hostname}}',
  // Country code in uppercase ALPHA-3 format
  COUNTRY: 'FAR',
  LANGUAGES: 'en,fr',
  SENTRY: '{{sentry}}',
  LEADERBOARDS_DASHBOARD_URL:
    'https://metabase.{{hostname}}/public/dashboard/acae0527-74be-4804-a3ee-f8b3c9c8784c#bordered=false&titled=false&refresh=300',
  REGISTRATIONS_DASHBOARD_URL:
    'https://metabase.{{hostname}}/public/dashboard/fec78656-e4f9-4b51-b540-0fed81dbd821#bordered=false&titled=false&refresh=300',
  STATISTICS_DASHBOARD_URL:
    'https://metabase.{{hostname}}/public/dashboard/a17e9bc0-15a2-4bd1-92fa-ab0f346227ca#bordered=false&titled=false&refresh=300'
}
```

Following the same process as you did for the production Login app config file, you must set the **COUNTRY & LANGUAGES** values.

