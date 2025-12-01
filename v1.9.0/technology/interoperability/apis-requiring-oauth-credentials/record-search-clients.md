---
description: >-
  Perform an advanced search of civil registration records from a trusted,
  external e-Gov service
---

# Record Search clients

The Record Search client can perform an advanced search of civil registration records. Use this to help support social protection systems, check the existence of civil registration records or check citizen demographics.

<figure><img src="../../../.gitbook/assets/Screenshot 2023-01-11 at 17.17.45 (1).png" alt=""><figcaption></figcaption></figure>

To stop abuse of such a powerful API, all results returned are audited as having been downloaded by the client. System Administrators should be careful to ensure that citizen data is not exposed to untrustworthy individuals by using this API.

{% hint style="danger" %}
All client behaviour is audited and is ultimately the personal responsibility of the National System Administrator of OpenCRVS that created the client. Protect citizen data and do not expose it unnecessarily as you may be in breach of local laws.
{% endhint %}

{% hint style="info" %}
A daily limit of 2000 Record Search requests per client, per day is hardcoded into OpenCRVS Core. Any subsequent requests will fail.
{% endhint %}

{% hint style="info" %}
You can use our [Postman collections](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/postman) to test Record Search API functionality. [Postman](https://www.postman.com/) is a tool you can download to test API access before building your integrations.
{% endhint %}

**Submitting a Record Search**

To submit an Record Search, your client must first request an [authorization token ](authenticate-a-client.md)using your `client_id` and `client_secret`.

#### Record Search Requests

With the token as an authorization header, the following example request will submit a record search in GraphQL. GraphQL is the chosen protocol as this API re-uses the same **Advanced Search** GraphQL queries that are used buy the OpenCRVS GUI.

{% hint style="info" %}
You can browse to the [GraphQL Playground](https://www.apollographql.com/docs/apollo-server/v2/testing/graphql-playground/) using an authorization header to view the full documentation for the searchEvents GraphQL query.

https://gateway.your\_domain/graphql
{% endhint %}

<figure><img src="../../../.gitbook/assets/Screenshot 2023-01-11 at 17.33.01 (1).png" alt=""><figcaption><p>The GraphQL Playground for OpenCRVS</p></figcaption></figure>

The API and parameters explained below. A full list of available Advanced Search GraphQL variables is also explained below.

{% openapi-operation spec="record-search" path="/graphql" method="post" %}
[OpenAPI record-search](https://4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/gitbook-x-prod-openapi/raw/e1db6b2ce67c739a754f530156c76a8d0197722d00a870f80115a5de4f5aac2f.yaml?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20251201%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20251201T181032Z&X-Amz-Expires=172800&X-Amz-Signature=462568582a198d4f8809be2c36b18cce96b110c18f30c4b6cd2da99781dc0033&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}

**GraphQL Parameters**

| Parameter                            | Description                                                                                                                                                                                  |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operationName`                      | Must be "searchEvents"                                                                                                                                                                       |
| `query`                              | Use the exhaustive GraphQL syntax supplied or remove individual return parameters if you do not require that citizen information. **Protect citizen's privacy! Only request what you need.** |
| `variables.advancedSearchParameters` | A JSON object of optional search parameters listed below                                                                                                                                     |
| `count`                              | The number of records to be returned per page                                                                                                                                                |
| `skip`                               | Pagination offset                                                                                                                                                                            |

**GraphQL variables.advancedSearchParameters object**

We recommend that you use the Advanced Search feature in the OpenCRVS application and monitor the GraphQL payload that is sent to the Gateway using the Chrome Developer Tools "Network" tab, in order to understand how these parameters are formatted. The table below lists all possible parameters with a description and example where we feel further explanation is helpful.

<table><thead><tr><th>Parameter</th><th>Description</th><th>Example</th></tr></thead><tbody><tr><td><code>event</code></td><td>An enum for the registration event. Can be "birth" or "death"</td><td><code>birth</code></td></tr><tr><td><code>name</code></td><td>A string that can be used to search ALL names.</td><td></td></tr><tr><td><code>registrationStatuses</code></td><td>An array of possible application status enums. <a href="https://github.com/opencrvs/opencrvs-core/blob/85887d640150b16f4e4e04dc772335b37dd6bc4f/packages/search/src/features/search/utils.ts#L79">Possible statuses</a> are listed here. Remove "_STATUS" when providing the value. Examples listed in the next cell.</td><td><code>["REGISTERED", "CERTIFIED", "ISSUED"]</code></td></tr><tr><td><code>dateOfEvent</code></td><td>The date of event. YYYY-MM-DD</td><td><pre class="language-json"><code class="lang-json">2022-12-31
</code></pre></td></tr><tr><td></td><td></td><td></td></tr><tr><td><code>recordId</code></td><td>A unique uuid for the registration that forms part of the QR code URL on the certificate. Use this to <strong>validate</strong> a certificate.</td><td></td></tr><tr><td><code>dateOfEventStart</code></td><td>If you dont know the date of event, you can enter a start and end date to search within a range. YYYY-MM-DD</td><td></td></tr><tr><td><code>dateOfEventEnd</code></td><td>As above</td><td></td></tr><tr><td><code>contactNumber</code></td><td>The informant's mobile phone number with country code</td><td></td></tr><tr><td><code>nationalId</code></td><td>Any national id associated with any individual who has been involved in a registration event as a string</td><td></td></tr><tr><td><code>registrationNumber</code></td><td>An event registration number as a string</td><td></td></tr><tr><td><code>trackingId</code></td><td>An application tracking id as a string</td><td></td></tr><tr><td><code>dateOfRegistration</code></td><td>The date of registration. YYYY-MM-DD</td><td></td></tr><tr><td><code>dateOfRegistrationStart</code></td><td>If you dont know the date of registration, you can enter a start and end date to search within a range. YYYY-MM-DD</td><td></td></tr><tr><td><code>dateOfRegistrationEnd</code></td><td>As above</td><td></td></tr><tr><td><code>declarationLocationId</code></td><td>A FHIR Location uuid for the <strong>a registration office.</strong> You can search all registrations that were made in an office. You retrieve these ids using our open <a href="../fhir-location-rest-api.md">Location API</a>. Your offices are customised for your country needs in <a href="https://github.com/opencrvs/documentation/blob/release-v1.3.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.3-set-up-cr-offices-and-health-facilities">this step.</a></td><td><code>031dc5a6-ea63-47e6-a818-191cc12a9b92</code></td></tr><tr><td><code>eventLocationId</code></td><td>When searching by the hospital location in which an event took place, this is a FHIR Location uuid for a <strong>facility that is already in the OpenCRVS database to track places of births or deaths in health institutions.</strong> You can retrieve these ids using our open <a href="../fhir-location-rest-api.md">Location API</a>. Your health facilities are customised for your country needs in <a href="https://github.com/opencrvs/documentation/blob/release-v1.3.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.3-set-up-cr-offices-and-health-facilities">this step.</a></td><td><code>031dc5a6-ea63-47e6-a818-191cc12a9b92</code></td></tr><tr><td><code>eventCountry</code></td><td>When searching for the administrative location in which an event took place e.g. place of birth, then this is an <a href="https://www.iban.com/country-codes">alpha 3 country code </a>for the country.</td><td></td></tr><tr><td>eventLocationLevel1</td><td>When searching for the administrative location in which an event took place e.g. place of birth, then this is a FHIR Location uuid for the <strong>locationLevel1 if applicable, technically expressed in FHIR as a "state".</strong> You can retrieve these ids using our open <a href="../fhir-location-rest-api.md">Location API</a>. Your location levels are customised for your country needs in <a href="https://github.com/opencrvs/documentation/blob/release-v1.3.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions">this step</a>.</td><td><code>031dc5a6-ea63-47e6-a818-191cc12a9b92</code></td></tr><tr><td>eventLocationLevel2</td><td>When searching for the administrative location in which an event took place e.g. place of birth, then this is a FHIR Location uuid for the <strong>locationLevel2 if applicable, technically expressed in FHIR as a "district".</strong> You can retrieve these ids using our open <a href="../fhir-location-rest-api.md">Location API</a>. Your location levels are customised for your country needs in <a href="https://github.com/opencrvs/documentation/blob/release-v1.3.0/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.2-set-up-administrative-address-divisions">this step</a>.</td><td><code>031dc5a6-ea63-47e6-a818-191cc12a9b92</code></td></tr><tr><td>eventLocationLevel3</td><td>As above</td><td></td></tr><tr><td>eventLocationLevel4</td><td>As above</td><td></td></tr><tr><td>eventLocationLevel5</td><td>As above</td><td></td></tr><tr><td>childFirstNames</td><td>As above</td><td></td></tr><tr><td>childLastName</td><td>As above</td><td></td></tr><tr><td>childDoB</td><td>As above</td><td></td></tr><tr><td>childDoBStart</td><td>As above</td><td></td></tr><tr><td>childDoBEnd</td><td>As above</td><td></td></tr><tr><td>childGender</td><td>A string. Can be "male", "female" or "unknown"</td><td></td></tr><tr><td>childIdentifier</td><td>A string used to search by National ID</td><td></td></tr><tr><td>deceasedFirstNames</td><td>As above</td><td></td></tr><tr><td>deceasedFamilyName</td><td>As above</td><td></td></tr><tr><td>deceasedGender</td><td>A string. Can be "male", "female" or "unknown"</td><td></td></tr><tr><td>deceasedDoB</td><td>As above</td><td></td></tr><tr><td>deceasedDoBStart</td><td>As above</td><td></td></tr><tr><td>deceasedDoBEnd</td><td>As above</td><td></td></tr><tr><td>deceasedIdentifier</td><td>A string used to search by National ID</td><td></td></tr><tr><td>motherFirstNames</td><td>As above</td><td></td></tr><tr><td>motherFamilyName</td><td>As above</td><td></td></tr><tr><td>motherDoB</td><td>As above</td><td></td></tr><tr><td>motherDoBStart</td><td>As above</td><td></td></tr><tr><td>motherDoBEnd</td><td>As above</td><td></td></tr><tr><td>motherIdentifier</td><td>As above</td><td></td></tr><tr><td>fatherFirstNames</td><td>As above</td><td></td></tr><tr><td>fatherFamilyName</td><td>As above</td><td></td></tr><tr><td>fatherDoB</td><td>As above</td><td></td></tr><tr><td>fatherDoBStart</td><td>As above</td><td></td></tr><tr><td>fatherDoBEnd</td><td>As above</td><td></td></tr><tr><td>fatherIdentifier</td><td>As above</td><td></td></tr><tr><td>informantFirstNames</td><td>As above</td><td></td></tr><tr><td>informantFamilyName</td><td>As above</td><td></td></tr><tr><td>informantDoB</td><td>As above</td><td></td></tr><tr><td>informantDoBStart</td><td>As above</td><td></td></tr><tr><td>informantDoBEnd</td><td>As above</td><td></td></tr><tr><td>informantIdentifier</td><td>As above</td><td></td></tr><tr><td>groomDoB</td><td>As above</td><td></td></tr><tr><td>groomDoBStart</td><td>As above</td><td></td></tr><tr><td>groomDoBEnd</td><td>As above</td><td></td></tr><tr><td>groomIdentifier</td><td>As above</td><td></td></tr><tr><td>groomFirstNames</td><td>As above</td><td></td></tr><tr><td>groomFamilyName</td><td>As above</td><td></td></tr><tr><td>brideDoB</td><td>As above</td><td></td></tr><tr><td>brideDoBStart</td><td>As above</td><td></td></tr><tr><td>brideDoBEnd</td><td>As above</td><td></td></tr><tr><td>brideIdentifier</td><td>As above</td><td></td></tr><tr><td>brideFirstNames</td><td>As above</td><td></td></tr><tr><td>brideFamilyName</td><td>As above</td><td></td></tr></tbody></table>

**Record Search Response**

The response from a record search is not FHIR, but an Elasticsearch response.&#x20;

After a search has completed and if you search for any record returned, you will see that in Record Audit, an entry shows that this client has accessed the personally identifiable citizen data on the record.
