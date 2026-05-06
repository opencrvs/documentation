# MOSIP ID Integration

### 1. Introduction

MOSIP Integration Phase 3 establishes a configurable, event-driven integration framework between OpenCRVS (civil registration) and MOSIP (digital identity). All integration behaviour is driven by country-level configuration, the OpenCRVS core contains no country-specific logic.

| Capability               | Description                                                                                               |
| ------------------------ | --------------------------------------------------------------------------------------------------------- |
| UIN lifecycle management | Manages UIN creation, biographic correction, and life-status changes based on civil registration actions. |
| Identity authentication  | Authenticate individuals involved in civil registration events using MOSIP e-Signet services.             |

***

### 2. Feature Overview

Regardless of country configuration, the OpenCRVS core evaluates every civil registration action against the country’s configured MOSIP integration rules and triggers the appropriate operation.

For every civil registration event, OpenCRVS:

* Evaluates the (event\_type + action\_type) combination.
* Applies the business rules defined in the country’s configuration.
* Triggers the mapped MOSIP operation.
* Handles success and technical failure states.
* Logs resulting outcomes to the record audit history.

#### 2.1 Configuration Overview

| Event type                         | Action type        | Eligibility rule                                                                                                          | MOSIP operation        | Response handling                                    |
| ---------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------- | ---------------------- | ---------------------------------------------------- |
| Birth                              | Register           | Configurable per country (e.g. child at birth or foundling)                                                               | UIN Creation           | Record moves to ‘Awaiting external validation’       |
| Birth (UIN creation on correction) | Approve Correction | Configurable (e.g. informant identity authenticated on correction)                                                        | UIN Creation           | Record moves to ‘Awaiting external validation’       |
| Birth                              | Approve Correction | Corrected field is within MOSIP biographic schema and child has not yet enrolled for biometrics (e.g. under 10 years old) | Biographic Data Update | Send and continue: no response from MOSIP is tracked |
| Death                              | Register           | Individual has a MOSIP VID                                                                                                | Flag VID as deceased   | Send and continue: no response from MOSIP is tracked |

{% hint style="info" %}
Eligibility rules are evaluated at the point of action execution. If no rule is satisfied, no MOSIP operation is triggered and the record proceeds through the standard OpenCRVS workflow.
{% endhint %}

***

### 3. ID Lifecycle Management

#### 3.1 UIN Creation on Registration

The primary UIN creation trigger is confirmation of a birth registration by an authorised Registrar. Countries define configurable eligibility rules that determine whether and when a UIN is created.

| Parameter         | Value                                                                                      |
| ----------------- | ------------------------------------------------------------------------------------------ |
| Event type        | Birth                                                                                      |
| Action type       | Register                                                                                   |
| Eligibility       | Configurable per country (e.g. child at birth where MOSIP is enabled)                      |
| Data shared       | Configurable set of birth data fields (schema), sent via the MOSIP Packet Manager          |
| Response handling | Record moves to  ‘Awaiting external validation’ work queue                                 |
| On success        | On MOSIP confirmation: record moves to 'registered' and a VID is issued to the individual. |

{% hint style="warning" %}
MOSIP does not return failure responses. Records that stall in 'Awaiting external validation' must be investigated directly with MOSIP and manually removed from the work queue by the country implementation team or system integrator.
{% endhint %}

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=1479-4051&t=4kOcOC0uQvvvdVUn-1" %}

***

#### 3.2 UIN Creation on Correction

A UIN may not have been created at the time of original registration. For example, if eligibility conditions were not met. Phase 3 supports deferred UIN creation, triggered when an approved correction satisfies the eligibility rules.

| Parameter         | Value                                                                                      |
| ----------------- | ------------------------------------------------------------------------------------------ |
| Event type        | Birth                                                                                      |
| Action type       | Approve Correction                                                                         |
| Eligibility       | Configurable per country (e.g. parent identity authenticated as part of correction)        |
| Data shared       | Configurable schema of birth data fields                                                   |
| Response handling | Record moves to ‘Awaiting external validation’ work queue                                  |
| On success        | On MOSIP confirmation: record moves to 'registered' and a VID is issued to the individual. |

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=1479-4329&t=4kOcOC0uQvvvdVUn-1" %}

***

#### 3.3 UIN Biographic Corrections

When a correction approved in OpenCRVS updates biographic information (e.g. name, gender, date of birth) that was previously shared with MOSIP, an updated packet is sent to keep the MOSIP identity record in sync.

{% hint style="warning" %}
Biographic corrections for individuals already enrolled with biometrics may compromise identity integrity in MOSIP. Consult the MOSIP documentation and your implementation partner before enabling this for your country.
{% endhint %}

<table><thead><tr><th width="374">Parameter</th><th>Value</th></tr></thead><tbody><tr><td>Event type</td><td>Birth</td></tr><tr><td>Action type</td><td>Approve Correction</td></tr><tr><td>Eligibility</td><td>Corrected field is within the MOSIP biographic data set (country-configured schema)</td></tr><tr><td>Data shared</td><td>Updated biographic fields</td></tr><tr><td>Response handling</td><td>Correct and continue: no response from MOSIP is tracked</td></tr><tr><td>On success</td><td>MOSIP updates the biographic record and notifies the informant or subject via SMS or email</td></tr></tbody></table>

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=1479-4696&t=4kOcOC0uQvvvdVUn-1" %}

***

#### 3.4 Flag Individual as Deceased

When a death is registered for an individual with a MOSIP VID on record, OpenCRVS notifies MOSIP to flag the VID as deceased.

| Parameter         | Value                                                                          |
| ----------------- | ------------------------------------------------------------------------------ |
| Event type        | Death                                                                          |
| Action type       | Register                                                                       |
| Eligibility       | Individual has a MOSIP VID stored against the record                           |
| Data shared       | Individual’s VID and other country configurable data such as the date of death |
| Response handling | Register and continue: no response from MOSIP is tracked                       |
| On success        | MOSIP flags the VID as deceased and notifies the informant via SMS or email    |

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=1479-4907&t=4kOcOC0uQvvvdVUn-1" %}

***

### 4. Identity Authentication

OpenCRVS supports authentication of all individuals involved in civil registration events via MOSIP’s e-Signet service. Authentication is available for: Informant, Mother, Father, Spouse, Deceased, and Child, where applicable to the event type and country configuration.

{% hint style="info" %}
Authentication is currently available in all event declaration forms. Support for authentication in the print and correction flows is forthcoming.
{% endhint %}

***

#### 4.1 e-Signet Authentication Flow

Authentication is initiated from within the OpenCRVS declaration form. On success, a configurable set of form fields is pre-populated from the individual’s MOSIP ID schema data.

{% hint style="info" %}
The field mapping from MOSIP ID schema to OpenCRVS form fields is defined in country configuration.&#x20;
{% endhint %}

| UI State                    | Behaviour                                                                                           |
| --------------------------- | --------------------------------------------------------------------------------------------------- |
| Loading                     | Authentication request in progress.                                                                 |
| Authenticated               | Authentication confirmed. Configured fields are pre-populated from MOSIP ID schema data.            |
| CRVS system offline         | OpenCRVS cannot reach e-Signet. The e-Signet button is disabled.                                    |
| Timeout / technical failure | Request timed out or returned a technical error. Any data already entered in the form is preserved. |

When an individual authenticates via e-Signet, MOSIP issues a Partner-Specific User Token (PSUT). This token represents the individual in the context of OpenCRVS as a MOSIP partner, and is stored against the registration record. It allows OpenCRVS to reference the individual’s MOSIP identity in subsequent flows without storing or exposing the UIN.

***

#### 4.2 Identity Verification (Offline Ability)

Identity verification validates an individual's identity data entered manually or pre-populated via QR code scan against MOSIP records at the point of submission. This supports offline civil registration workflows where e-Signet is not available at the point of data entry.\
\
Verification requests are sent to MOSIP via the MOSIP Authentication SDK once the system is online, which confirms whether the captured data matches a record in the National ID system.

{% hint style="warning" %}
Offline verification validates that biographic data matches a National ID record but does not authenticate the informant and can cause downstream identity issues. e-Signet authentication is the preferred approach.
{% endhint %}

| UI State            | Behaviour                                                                                      |
| ------------------- | ---------------------------------------------------------------------------------------------- |
| Scan QR code        | QR code scanned and declaration form fields are pre-populated from encoded identity data.      |
| Pending validation  | Identity data is being validated against MOSIP records.                                        |
| ID verified         | Identity confirmed. Registration can proceed.                                                  |
| Verification failed | Identity could not be verified. The Registration Agent is prompted to review the entered data. |

{% embed url="https://www.figma.com/board/ouhT8BRAu7HASKkebrUkwu/MOSIP-Public-Documentation?node-id=1479-3372&t=4kOcOC0uQvvvdVUn-1" %}
