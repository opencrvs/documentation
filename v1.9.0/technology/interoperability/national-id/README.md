# National ID

### Why integrate OpenCRVS with National ID?

Civil registration provides the source of truth for any vital event that occurs in a country.  Civil registration can inform a National ID system when a birth occurs and therefore instigate the generation of a National ID for the child at birth.  At the point of death, a civil registration system can inform the National ID system that the person is deceased, thus preventing fraudulent usage of a National ID of a deceased person.

The partnership of Civil Registration and National ID is what collectively constitutes the foundational identity infrastructure of a nation.  &#x20;

[Bridging the Identity Gap: Integrating Civil Registration and National Identity Systems](http://prod-website-903390823.ap-south-1.elb.amazonaws.com/mosip16.9/bridging-the-identity-gap-integrating-civil-registration-and-national-identity-systems)



### Which National ID systems can OpenCRVS interoperate with?

OpenCRVS is agnostic regarding which National ID system it integrates with.  This section is first organised around the main business use cases. &#x20;

As of OpenCRVS v1.8.0, OpenCRVS has a production ready integration library dedicated to interoperating with [MOSIP](https://www.mosip.io/) and [E-Signet](https://docs.esignet.io/), fellow OpenSource Digital Public Goods.  A dedicated section exists that builds on the same agnostic integration points specifically for integrating with MOSIP.

In the past, OpenCRVS has delivered proof-of-concept (not production ready) integrations with [INGroupe](https://ingroupe.com/) and [OSIA standard](https://secureidentityalliance.org/osia) National ID systems



### Existing National ID integration functionality

Currently OpenCRVS supports the following default National ID integration functionality:

* Authenticating and verifying the identity of informants and parents during the event application process both offline and online.
* Configurable rules to determine whether or not a civil registration event should or should not integrate with a National ID system at the point of registration.
* Integration with a National ID system at the point of registration synchronously and asynchronously



## 📌 Recommendations on Key Scenarios

***

### 1. ⚰️ Death Registration & ID Deactivation

#### 🧩 Scenario / Issue

A death is registered in OpenCRVS and triggers interaction with the national ID system regarding the individual’s identifier.

#### ⚠️ Risks

* Immediate ID deactivation may disrupt access to essential services for surviving family members (🏦 banking, 💰 benefits, 🏥 healthcare).
* Downstream systems may act automatically without context or grace periods.
* Loss of trust if families experience sudden service denial following death registration.

#### ✅ Recommendations

* ❌ **Do not automatically deactivate IDs** upon death registration.
* 🚩 Use a **death flag or status indicator** shared with the ID system.
* ⏳ Leave final action (timing and service impact) to relying parties, with **clearly defined grace periods and policies**.
* 📢 Treat death registration as a **notification**, not an automatic enforcement trigger.

***

### 2. 👶➡️🧑 Updates to Registered Data (Infant vs Adult)

#### 🧩 Scenario / Issue

Civil registration data changes are requested after initial registration (e.g. name corrections, parent details).

#### ⚠️ Risks

* Silent updates to adult identity records can cause mismatches with banks and other relying parties.
* Updates propagated without strong authentication undermine identity assurance.
* Loss of traceability of changes over time.

#### ✅ Recommendations

* 🔍 **Clearly distinguish** between:
  * 👶 _Infant updates_ (pre-biometric)
  * 🧑 _Adult updates_ (post-biometric)
* ✅ Allow OpenCRVS-driven updates **only for infants** where biometrics are not yet captured.
* 🔐 Route adult updates through the **national ID system** using higher-assurance authentication.
* 📝 Maintain **full audit trails** for all updates.

***

### 3. 🔓 Fetching Demographic Data Without Authentication

#### 🧩 Scenario / Issue

A civil registration office or system requests demographic (biographic) data from the ID system using only an ID number, without authenticating the individual.

#### ⚠️ Risks

* No assurance that the person present is the individual whose data is being fetched.
* Risk of fraud or misattribution (e.g. incorrect parents linked to a child).
* Normalisation of data sharing without consent or verification.

#### ✅ Recommendations

* 🚫 **Do not allow demographic data retrieval** without prior authentication and consent.
* 🔑 Authenticate first (e.g. via **eSignet**), then return approved attributes for pre-population if needed.
* 🏛️ Restrict unauthenticated access to **exceptional, high-assurance government use cases only**, with strong governance.
* 🧭 Make the authentication step **explicit** in both system design and user messaging.

***

### 4. 🧱 Size & Purpose of the ID Schema

#### 🧩 Scenario / Issue

Countries decide how many attributes are stored in the ID system, ranging from minimal identifiers to extensive personal profiles.

#### ⚠️ Risks

* Large schemas blur the line between an **ID system** and a **population register**.
* Increased privacy and data-protection risk due to data concentration.
* Greater complexity and tighter coupling with downstream systems, making future change harder.

#### ✅ Recommendations

* 🎯 Keep the ID schema **as minimal as possible**, aligned with identification and authentication needs.
* 📚 Treat **civil registration systems as the source of truth** for life events.
* 🔁 Avoid duplicating detailed civil registration data inside the ID platform.
* 🏗️ Be explicit about architectural intent:\
  **Identification service** vs **population register**.

***

### 5. 🍼📄 Printing a National ID on Birth Certificates

#### 🧩 Scenario / Issue

Countries request that a national identifier (UIN or VID) be printed on birth certificates.

#### ⚠️ Risks

* Over-exposure of foundational identifiers, increasing privacy and misuse risk.
* Confusion between the purpose of a birth certificate (proof of birth) and an ID credential.
* Long-term rigidity if identifiers or policies evolve.

#### ✅ Recommendations

* ❌ **Do not print a national ID by default** on birth certificates.
* 🤔 Only consider printing an identifier where a **clearly defined use case** cannot be met otherwise (e.g. health or social protection).
* 🔗 Prefer **indirect linkage** (e.g. Birth Registration Number linked internally to the ID system).
* 🛡️ If printing is unavoidable, prefer **revocable or masked identifiers** over permanent UINs.

***

### 6. 🌐🚫 Offline Operation & Authentication Limitations

#### 🧩 Scenario / Issue

Civil registration is conducted offline (especially in remote settings), without real-time authentication or biometric verification.

#### ⚠️ Risks

* Lower assurance of identity at the point of registration.
* Inconsistent handling between offline and online registrations.
* Misaligned expectations of what offline workflows can safely support.

#### ✅ Recommendations

* 📣 Be explicit about **assurance limitations** in offline workflows.
* 🔄 Treat offline operation as **temporary or contextual**, with reconciliation once connectivity is restored.
* 🚧 Avoid extending offline workflows to **high-risk identity actions** (e.g. adult updates).
* 🛣️ Clearly communicate roadmap limitations and future enhancements.

