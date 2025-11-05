# 4.2.2 Set up administrative address divisions

{% embed url="https://youtu.be/WU6nYHgHk2I" %}

Now that you have a repository ready for your country configuration code, you can begin the configuration process. [Administrative division](https://en.wikipedia.org/wiki/Administrative\_division) structure must be standardised and configured in the application in order to accurately geo-locate registrations and provide accurate registration performance analytics and vital statistics exports.

OpenCRVS fully appreciates that within many countries, addresses are not standardised in some urban and rural areas. We believe passionately that this should not be a hindrance to registration, so we have gone out of our way to enable optional and un-standardised urban and rural address levels. However, we must ensure at least some administrative structure standardisation in order to calculate key metrics.

You can configure how many standardised levels you need between 1 and 5 administrative subdivisions. These must map into the FHIR Location standard. Therefore, internally we use the terms "state" for Location Level 1 and "district" ( "district" being a sub-level and therefore part of a "state") as Location Level 2. As of OpenCRVS v1.3, subsequent Location Levels 3-4 will populate the Address lines Array in the FHIR Location object at hard-coded indices.

You can present these location levels to the user labelled in any way that you want, such as "Province" for "state", and "County" for "district", as we have done in our demo country Farajaland.

This labelling process is simply achieved in [content management](../3.2.5-set-up-application-settings/3.2.9.1-managing-language-content/) by [editing the JSON directly](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/api/content/client/client.json), such as [here](https://github.com/opencrvs/opencrvs-countryconfig/blob/08bf134af4e7ab0624b94f74756caf5f4f263bf6/src/api/content/client/client.json#L1181), and [here](https://github.com/opencrvs/opencrvs-countryconfig/blob/08bf134af4e7ab0624b94f74756caf5f4f263bf6/src/api/content/client/client.json#L968). _**Replace all occurrences of the fictional country name "Farajaland", with your country name in the content of this file.**_

Regarding the analytical dependency, one of the key performance metrics for a good civil registration system is to be able to present what is referred to as the "Completeness rate" for a state or district. Completeness rates are the primary measure of performance of a CRVS system. They are used as a form of international comparison and the indicator selected to measure [SDG target 16.9](https://unstats.un.org/sdgs/metadata/?Text=\&Goal=16\&Target=16.9). In order to calculate the completeness rate, we use the following formula:

* Total: ((crude birth or death rate \* total population) / 1000) \* (target estimated days / 365))
* Male: ((crude birth or death rate \* population of males) / 1000) \* (target estimated days / 365))
* Female: ((crude birth or death rate \* population of females) / 1000) \* (target estimated days / 365))

Therefore in order to calculate completeness rate, you are required to have available from your country's statistical department, the value for the crude birth rate and total population divided by gender for all the administrative areas.

In our experience it is unrealistic to expect that countries have accurate data for each level, so these are automatically calculated by the system where they have not been explicitly supplied.

The rest of the address fields that can be completed by a user are all optional and should be left blank if not required. The form question labels can be renamed to suit your needs in content management. The address fields support all urban standardisations such as "zipcode", international addresses and additionally custom address lines for rural areas that can be used for un-standardised data such as "village elder".

We begin by creating source files for importing your standardised administrative subdivisions into the OpenCRVS database. Each one of these locations will be converted into a [FHIR Location](https://build.fhir.org/location.html) object. All subdivisions can be retrieved and edited in the future by using the [FHIR Location API](../../../../technology/interoperability/fhir-location-rest-api.md).
