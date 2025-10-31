---
description: >-
  Create, read, update or archive administrative areas, civil registration
  offices or health facilities using FHIR.
---

# APIs for system administrators

### FHIR Location REST API

You need access to the FHIR Location API for 3 important reasons...

#### 1. In order to get FHIR IDs for locations required in Event Notification or deciphering location information from FHIR IDs returned from a Record Search or Webhook response

This API will help you configure integrating clients to understand the relationship to places referenced by [FHIR Location](https://build.fhir.org/location.html) ids in payloads such as "Place of birth", "Place of registration", or "Jurisdiction" such as [Webhooks](create-a-client/webhook-clients.md) and [National ID](national-id-client.md) clients.

For an [Event Notification](create-a-client/event-notification-clients.md) client, you must submit the correct FHIR Location id for the health facility that OpenCRVS understands in order to correctly track the place of birth.

For a [Record Search](create-a-client/record-search-clients.md) client, you need the correct FHIR Location id when performing advanced searches depending on your parameters.

{% hint style="info" %}
All FHIR objects such as Location are ["FHIR Resources"](https://hl7.org/fhir/resource.html) and have a unique uuid: [**"id"**](https://hl7.org/fhir/resource-definitions.html#Resource.id) property that never changes.
{% endhint %}

**2. Changing administrative areas, civil registration offices or facilities**

During the configuration step of OpenCRVS you import all administrative areas, civil registration offices and health facilities in CSV files. But over the years of operation, changes occur to your infrastructure and jurisdictional operations.

Sometimes you may wish to add a new office or health facility.

Sometimes you may wish to change the name of an area or health facility.

Sometimes a location may no longer be in use and you want it to not appear as a valid place of birth or death, or a valid area in an address in new event declaration forms.

{% hint style="warning" %}
Note, in OpenCRVS a FHIR Location cannot be deleted entirely, only archived. This is to protect the integrity of any older event registrations where the historical name of the facility or administrative area must be always remembered. That can only be changed via the [correct record](../../product-specifications/core-functions/8.-correct-record.md) procedure.
{% endhint %}

**3. Updating population and crude-birth-rate statistics to power the registration "completion rate" performance**

During the configuration step of OpenCRVS you import all administrative areas with [statistics](../../product-specifications/core-functions/11.-vital-statistics-export.md) that are used to calculate changing [**completeness rates**](https://www.vitalstrategies.org/wp-content/uploads/Estimating-Completeness-of-Birth-and-Death-Registration.pdf) over time. This calculation depends upon the yearly population of that area and its associated, and ever changing, "crude birth rate". These values are collected by statistical departments in government. To provide accurate performance analytics, the previous year's statistics should be added via this API on a yearly basis.

### Using the FHIR Location REST API

{% hint style="info" %}
You can use our [Postman collections](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/postman) to test FHIR Location API functionality. [Postman](https://www.postman.com/) is a tool you can download to test API access before building your integrations.
{% endhint %}

{% hint style="warning" %}
Getting all FHIR Locations or getting a single FHIR Location by its id, can be performed by any client, publicly on the internet with no authorization headers necessary. If you wish to whitelist access for whatever reason, you can do so via Traefik in Docker compose files.
{% endhint %}

{% hint style="danger" %}
Only a National System Administrator's JWT token can be used to perform these actions as they are potentially destructive and can affect business operations. **An Interoperability client does not have permission.**
{% endhint %}

You can also use the FHIR API URL parameters to search using [**FHIR identifiers**](https://build.fhir.org/datatypes.html#Identifier) or other FHIR properties such as [**type**](https://build.fhir.org/datatypes-definitions.html#Identifier.type).

By adding the FHIR **status=active** property, you can filter out any deactivated locations that are no longer in use.

{% openapi-operation spec="fhir-location-api" path="/locations" method="get" %}
[OpenAPI fhir-location-api](https://gitbook-x-prod-openapi.4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/raw/c4baca207f68f6a1509d9ae3c6c9aae5f68483bef52d8f2a4f2eee69b6e72197.yaml?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20250716%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20250716T105626Z&X-Amz-Expires=172800&X-Amz-Signature=3c0be4a90599402a796aa76850c20261729aee6796f6bdff1b707f2119caa60e&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}

{% openapi-operation spec="fhir-location-api" path="/locations/{locationId}" method="get" %}
[OpenAPI fhir-location-api](https://gitbook-x-prod-openapi.4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/raw/c4baca207f68f6a1509d9ae3c6c9aae5f68483bef52d8f2a4f2eee69b6e72197.yaml?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20250716%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20250716T105626Z&X-Amz-Expires=172800&X-Amz-Signature=3c0be4a90599402a796aa76850c20261729aee6796f6bdff1b707f2119caa60e&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}

When creating a new location, **statisticalID** is the **adminPCode** or **custom id** you set when importing administrative areas or facility CSVs respectively. We call that a statisticalID because it is generally used by statistics departments in government as opposed to a FHIR id.

{% openapi-operation spec="fhir-location-api" path="/locations" method="post" %}
[OpenAPI fhir-location-api](https://gitbook-x-prod-openapi.4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/raw/c4baca207f68f6a1509d9ae3c6c9aae5f68483bef52d8f2a4f2eee69b6e72197.yaml?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20250716%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20250716T105626Z&X-Amz-Expires=172800&X-Amz-Signature=3c0be4a90599402a796aa76850c20261729aee6796f6bdff1b707f2119caa60e&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}

{% openapi-operation spec="fhir-location-api" path="/locations/{locationId}" method="put" %}
[OpenAPI fhir-location-api](https://gitbook-x-prod-openapi.4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/raw/c4baca207f68f6a1509d9ae3c6c9aae5f68483bef52d8f2a4f2eee69b6e72197.yaml?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20250716%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20250716T105626Z&X-Amz-Expires=172800&X-Amz-Signature=3c0be4a90599402a796aa76850c20261729aee6796f6bdff1b707f2119caa60e&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}

{% hint style="info" %}
To reinstate a location, set the status prop to **"active"**
{% endhint %}

{% hint style="info" %}
To archive a location, set the status prop to **"inactive"**
{% endhint %}

### Authorization to create, update and archive a FHIR Location

To retrieve a National System Administrators JWT token, login as the national system administrator. In our example, this is the user **j.campbell**.

In **Chrome**, right click anywhere on the page, choose **"Inspect"**, and open **"Chrome Developer Tools."**

Open the **"Application"** tab and expand **"Local Storage"**.

The JWT is the value for the key **"opencrvs"**

**Double click inside the value** and type **Ctrl+A** to select all, then **Ctrl+C** to copy the JWT into your clipboard.

<figure><img src="../../.gitbook/assets/Screenshot 2023-01-19 at 17.41.39.png" alt=""><figcaption></figcaption></figure>

**Update or Archive a FHIR Location**

