# Birth Journeys  — Farajaland

| Ref | Journey                                                                         | Starting point                         | Key actors                                            |
| --- | ------------------------------------------------------------------------------- | -------------------------------------- | ----------------------------------------------------- |
| J1  | Health facility notification to registration (BIRTH-REG-1)                      | New record                             | Health Official, Registration Officer, Registrar      |
| J2  | Community declaration to registration (BIRTH-REG-2)                             | New record                             | Community Leader, Registration Officer, Registrar     |
| J3  | Office declaration and registration (BIRTH-REG-3)                               | New record                             | Registration Officer, Registrar                       |
| J4  | Late registration with Provincial Registrar approval (BIRTH-REG-4)              | New record                             | Registration Officer, Provincial Registrar, Registrar |
| J5  | Offline registration drive (BIRTH-REG-5)                                        | New record                             | Registrar                                             |
| J6  | Embassy declaration and registration (BIRTH-REG-9)                              | New record                             | Embassy Official, Registrar General                   |
| J7  | Birth with MOSIP parent authentication and UIN creation (BIRTH-REG-11)          | New record                             | Registration Officer / Registrar, MOSIP               |
| N1  | Late registration rejected by Provincial Registrar (BIRTH-REG-6)                | Existing record — Declared             | Registration Officer, Provincial Registrar            |
| N2  | Rejection by Registration Officer, redeclared by Community Leader (BIRTH-REG-7) | Existing record — Declared             | Registration Officer, Community Leader                |
| N3  | Rejection by Registrar, redeclared by Registration Officer (BIRTH-REG-8)        | Existing record — Declared             | Registrar, Registration Officer                       |
| N4  | Embassy rejection and redeclaration (BIRTH-REG-10)                              | Existing record — Declared             | Registrar General, Embassy Official                   |
| N5  | Certificate printing in advance of issuance (BIRTH-ISSUE-1)                     | Existing record — Registered           | Registrar                                             |
| N6  | Escalation to Provincial Registrar (BIRTH-ESCALATE-1)                           | Existing record — Declared             | Registrar, Provincial Registrar                       |
| N7  | Escalation to Legal (BIRTH-ESCALATE-2)                                          | Existing record — Declared             | Registrar, Legal Officer                              |
| N8  | Escalation to Registrar General (BIRTH-ESCALATE-3)                              | Existing record — Declared             | Registrar, Registrar General                          |
| N9  | Archive declaration (BIRTH-ARCHIVE-1)                                           | Existing record — Declared or Notified | Registration Officer                                  |
| N10 | Simple correction (BIRTH-CORRECT-1)                                             | Existing record — Registered           | Registration Officer, Registrar                       |
| N11 | Correction to add MOSIP authentication for UIN creation (BIRTH-CORRECT-2-MOSIP) | Existing record — Registered           | Registration Officer, Registrar, MOSIP                |
| N12 | Revoke a registration (BIRTH-REVOKE-1)                                          | Existing record — Registered           | Registrar General                                     |
| N13 | Reinstate revoked registration (BIRTH-REINSTATE\_REVOKED\_REGISTRATION-1)       | Existing record — Registered (revoked) | Registrar General                                     |

***

### The journeys

Journeys J1–J7 begin with a new record — an informant initiates and the record progresses through the registration lifecycle. Journeys N1–N13 begin from a record already in the system, triggered by an exception, an error, or a post-registration need.

***

#### J1 — Health facility notification to registration (BIRTH-REG-1)

> **When this applies:** A birth occurs at a health facility. The Health Official captures a notification with partial details, which must be completed and validated by a Registration Officer before being registered by a Registrar.

**In plain terms:** A baby is born in a hospital. The hospital clerk captures the basic birth details using a shortened form. This notification is sent to the district registration office, where a Registration Officer reviews the notification, contacts the family if needed, completes all required fields, and validates the record. The Registrar then reviews the completed declaration and formally registers the birth. The family receives a birth certificate.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                                                 |
| -------------------- | -------------------- | -------------------------------------------------------------- |
| Health Official      | Hospital Official    | Captures the initial birth notification at the health facility |
| Registration Officer | Registration Officer | Completes, validates, and submits the full declaration         |
| Registrar            | Local Registrar      | Reviews the declaration and registers the birth                |
| Informant            | Parent / Guardian    | Provides birth details and identity documents                  |

**Step by step:**

| # | Who                  | What happens                                                                                                                                                                       | Where                        | Typical timeframe        | Output / handoff                                                                                                          |
| - | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| 1 | Health Official      | Captures birth notification using shortened form (child's name, sex, date/time of birth, place of birth, mother's details where available). Hospital official name auto-populated. | Health facility              | Day 0 (at birth)         | Notification submitted → record in Notified status, routed to district Registration Officer's workqueue                   |
| 2 | Registration Officer | Reviews notification, contacts family if needed, completes all remaining mandatory fields, validates the record                                                                    | District registration office | Within 30 days           | Full declaration submitted → record in Declared status                                                                    |
| 3 | System               | Runs duplicate detection against existing records                                                                                                                                  | Automated                    | Immediate                | If potential duplicate found → flag added, routed to Registrar for review (see duplicate detection). Otherwise continues. |
| 4 | Registrar            | Reviews the completed declaration and registers the birth                                                                                                                          | District registration office | Within 30 days           | Record in Registered status. Registration number assigned.                                                                |
| 5 | Registrar            | Prints birth certificate                                                                                                                                                           | District registration office | At registration or later | Certificate issued to informant/family                                                                                    |

**Key decisions:**

* If the birth is more than 365 days ago → late registration rules apply; see J4
* If a potential duplicate is detected → the Registrar must review the existing record before proceeding
* If supporting documents are incomplete → the Registration Officer rejects the notification or holds it for follow-up

**What the informant / family receives:** Birth certificate (first copy free). Tracking ID provided at notification for status tracking.

***

#### J2 — Community declaration to registration (BIRTH-REG-2)

> **When this applies:** A birth occurs in a rural community. A Community Leader captures the declaration using a shortened form, which must be validated by a Registration Officer and then registered by a Registrar.

**In plain terms:** A baby is born in a rural area. The Community Leader visits the family and captures the basic birth details using a shortened form on their device. The declaration is submitted (online or synced later if offline) to the district registration office. A Registration Officer reviews the Community Leader's submission, completes any missing details with the family, and validates it as a full declaration. The Registrar then registers the birth. The family receives a certificate.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                                                        |
| -------------------- | -------------------- | --------------------------------------------------------------------- |
| Community Leader     | Community Leader     | Captures birth declaration in the community using shortened form      |
| Registration Officer | Registration Officer | Validates, completes missing fields, and submits the full declaration |
| Registrar            | Local Registrar      | Registers the birth                                                   |
| Informant            | Parent / Guardian    | Provides birth details and identity documents                         |

**Step by step:**

| # | Who                  | What happens                                                                                             | Where                        | Typical timeframe        | Output / handoff                                                                                          |
| - | -------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------- | ------------------------ | --------------------------------------------------------------------------------------------------------- |
| 1 | Community Leader     | Captures birth declaration using shortened form. May work offline; data syncs when connectivity returns. | Community / home visit       | Within days of birth     | Declaration submitted → record in Declared status, routed to district Registration Officer for validation |
| 2 | Registration Officer | Reviews declaration, contacts family, completes any missing fields, validates the record                 | District registration office | Within 30 days           | Validated declaration → record ready for registration                                                     |
| 3 | System               | Runs duplicate detection                                                                                 | Automated                    | Immediate                | If duplicate found → flagged for review                                                                   |
| 4 | Registrar            | Reviews and registers the birth                                                                          | District registration office | Within 30 days           | Record in Registered status                                                                               |
| 5 | Registrar            | Prints birth certificate                                                                                 | District registration office | At registration or later | Certificate issued                                                                                        |

**Key decisions:**

* If the Community Leader is offline → data queued in the device Outbox until connectivity returns
* If the birth is more than 365 days ago → late registration rules apply; see J4
* If a potential duplicate is detected → Registrar reviews before proceeding

**What the informant / family receives:** Birth certificate (first copy free). Tracking ID provided at declaration.

***

#### J3 — Office declaration and registration (BIRTH-REG-3)

> **When this applies:** A parent or guardian walks into a district registration office to declare a birth directly.

**In plain terms:** The informant visits the registration office in person. A Registration Officer captures the full declaration, including all mandatory fields and supporting documents. The Registration Officer validates the declaration and submits it. The Registrar reviews and registers the birth. The family receives a certificate the same day or shortly after.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                                                |
| -------------------- | -------------------- | ------------------------------------------------------------- |
| Registration Officer | Registration Officer | Captures and validates the full declaration                   |
| Registrar            | Local Registrar      | Registers the birth                                           |
| Informant            | Parent / Guardian    | Provides all birth details and supporting documents in person |

**Step by step:**

| # | Who                  | What happens                                                                                                                                          | Where                        | Typical timeframe    | Output / handoff                                  |
| - | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | -------------------- | ------------------------------------------------- |
| 1 | Registration Officer | Captures the full declaration from the informant, including all mandatory fields. Informant signs. eSignet authentication of mother/father available. | District registration office | Day of visit         | Declaration submitted → record in Declared status |
| 2 | System               | Runs duplicate detection                                                                                                                              | Automated                    | Immediate            | If duplicate found → flagged                      |
| 3 | Registrar            | Reviews the declaration and registers the birth                                                                                                       | District registration office | Same day or next day | Record in Registered status                       |
| 4 | Registrar            | Prints birth certificate                                                                                                                              | District registration office | At registration      | Certificate issued                                |

**Key decisions:**

* If the birth is more than 365 days ago → late registration; see J4
* If a potential duplicate is detected → Registrar reviews
* If the informant is a legal guardian → court documentation required

**What the informant / family receives:** Birth certificate (first copy free), typically same-day.

***

#### J4 — Late registration with Provincial Registrar approval (BIRTH-REG-4)

> **When this applies:** The birth occurred more than 365 days ago. The declaration is automatically flagged as a late registration requiring Provincial Registrar approval before the Registrar can register it.

**In plain terms:** When a birth is declared more than a year after it occurred, the system automatically flags it as a late registration. The declaration follows the normal path (notification or office declaration) but before the Registrar can register it, a Provincial Registrar must review and approve the late registration. Once approved, the Registrar registers the birth. If the Provincial Registrar rejects it, the record is returned for updates (see N1).

**Who's involved:**

| Role in this journey | Country title        | Responsibility                                          |
| -------------------- | -------------------- | ------------------------------------------------------- |
| Registration Officer | Registration Officer | Captures or completes the declaration                   |
| Provincial Registrar | Provincial Registrar | Reviews and approves (or rejects) the late registration |
| Registrar            | Local Registrar      | Registers the birth after provincial approval           |
| Informant            | Parent / Guardian    | Provides birth details and supporting documents         |

**Step by step:**

| # | Who                  | What happens                                                                                        | Where                        | Typical timeframe         | Output / handoff                                                                           |
| - | -------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------- | ------------------------- | ------------------------------------------------------------------------------------------ |
| 1 | Registration Officer | Captures or completes the declaration as in J1/J2/J3                                                | District registration office | —                         | Declaration submitted → record in Declared status                                          |
| 2 | System               | Detects that `declarationDate − dateOfBirth > 365 days`. Automatically adds late-registration flag. | Automated                    | Immediate                 | Record flagged for late-registration approval → routed to Provincial Registrar's workqueue |
| 3 | Provincial Registrar | Reviews the late registration. Checks supporting documentation and circumstances.                   | Provincial office            | —                         | Approves → flag cleared, record routed to Registrar for registration. Or rejects → see N1. |
| 4 | Registrar            | Registers the birth                                                                                 | District registration office | After provincial approval | Record in Registered status                                                                |
| 5 | Registrar            | Prints birth certificate                                                                            | District registration office | At registration           | Certificate issued                                                                         |

**Key decisions:**

* If the Provincial Registrar rejects → see N1 (BIRTH-REG-6)
* Open Question: whether a further "delayed" tier (beyond 365 days, e.g. requiring court order) applies

**What the informant / family receives:** Birth certificate (first copy free), after provincial approval and registration.

***

#### J5 — Offline registration drive (BIRTH-REG-5)

> **When this applies:** A Registrar conducts a registration drive in a remote area. The Registrar declares and registers births directly, printing certificates on-site without waiting for server synchronisation.

**In plain terms:** During a registration drive in an area with poor or no connectivity, the Registrar captures the full declaration directly from the informant, registers the birth, and prints the certificate — all in one session, offline. The data syncs to the central server when the Registrar's device reconnects.

**Who's involved:**

| Role in this journey | Country title     | Responsibility                                          |
| -------------------- | ----------------- | ------------------------------------------------------- |
| Registrar            | Local Registrar   | Captures declaration, registers, and prints certificate |
| Informant            | Parent / Guardian | Provides all birth details                              |

**Step by step:**

| # | Who       | What happens                                                                                    | Where                               | Typical timeframe | Output / handoff                                                                                               |
| - | --------- | ----------------------------------------------------------------------------------------------- | ----------------------------------- | ----------------- | -------------------------------------------------------------------------------------------------------------- |
| 1 | Registrar | Captures full declaration directly from informant. Informant signs.                             | Field location (registration drive) | Day of drive      | Declaration submitted → record in Declared status (local)                                                      |
| 2 | Registrar | Registers the birth                                                                             | Field location                      | Immediate         | Record in Registered status (local)                                                                            |
| 3 | Registrar | Prints birth certificate                                                                        | Field location                      | Immediate         | Certificate issued on-site                                                                                     |
| 4 | System    | When connectivity returns, data syncs to central server. Duplicate detection runs at sync time. | Automated                           | When online       | Registration confirmed centrally. Audit timestamped at the time the Registrar performed each action on-device. |

**Key decisions:**

* If a duplicate is detected at sync time → flagged for review; certificate has already been issued
* Certificate is not "legally final" until sync completes — acknowledged risk

**What the informant / family receives:** Birth certificate printed on-site during the drive.

***

#### J6 — Embassy declaration and registration (BIRTH-REG-9)

> **When this applies:** A Farajaland citizen gives birth overseas. The Embassy Official captures the declaration at the embassy, and the Registrar General registers it.

**In plain terms:** A Farajaland citizen has a baby abroad. They visit the nearest Farajaland embassy, where an Embassy Official captures the full declaration. The declaration is submitted to the Registrar General, who reviews and registers the birth. The Embassy Official then prints the certificate for the family.

**Who's involved:**

| Role in this journey | Country title               | Responsibility                                                         |
| -------------------- | --------------------------- | ---------------------------------------------------------------------- |
| Embassy Official     | Embassy Official            | Captures the declaration and prints the certificate after registration |
| Registrar General    | Registrar General           | Reviews and registers the embassy declaration                          |
| Informant            | Parent / Guardian (citizen) | Provides birth details and identity documents                          |

**Step by step:**

| # | Who               | What happens                                     | Where           | Typical timeframe  | Output / handoff                                                               |
| - | ----------------- | ------------------------------------------------ | --------------- | ------------------ | ------------------------------------------------------------------------------ |
| 1 | Embassy Official  | Captures the full declaration from the informant | Embassy         | —                  | Declaration submitted → record in Declared status, routed to Registrar General |
| 2 | Registrar General | Reviews the declaration and registers the birth  | CRA National HQ | —                  | Record in Registered status                                                    |
| 3 | Embassy Official  | Prints birth certificate                         | Embassy         | After registration | Certificate issued to family                                                   |

**Key decisions:**

* If the Registrar General rejects the declaration → see N4 (BIRTH-REG-10)
* Open Question: whether late registration rules apply to embassy declarations

**What the informant / family receives:** Birth certificate printed at the embassy.

***

#### J7 — Birth with MOSIP parent authentication and UIN creation (BIRTH-REG-11)

> **When this applies:** During the declaration, the mother and/or father authenticates via MOSIP eSignet. At registration, this triggers UIN creation for the child (provided at least one parent is a Farajaland citizen).

**In plain terms:** This journey overlays any of J1–J6. During the declaration, the parent authenticates their identity using the national ID system (MOSIP eSignet). Their details are pre-populated from the ID system. When the birth is registered, the system automatically sends the child's details to MOSIP for creation of a Unique Identification Number (UIN). The record is held briefly while the identity system processes the request. Once confirmed, a VID (Virtual ID) is stored on the record.

**Who's involved:**

| Role in this journey             | Country title               | Responsibility                                   |
| -------------------------------- | --------------------------- | ------------------------------------------------ |
| Registration Officer / Registrar | As per base journey         | Captures declaration with eSignet authentication |
| MOSIP system                     | National ID system          | Authenticates parent identity; creates child UIN |
| Informant                        | Parent / Guardian (citizen) | Authenticates via eSignet                        |

**Step by step:**

| # | Who                              | What happens                                                                                                                    | Where                         | Typical timeframe        | Output / handoff                                                              |
| - | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------ | ----------------------------------------------------------------------------- |
| 1 | Registration Officer / Registrar | During declaration, initiates eSignet authentication for mother and/or father                                                   | Registration office / Embassy | During declaration       | Parent's identity verified; form fields pre-populated from MOSIP; PSUT stored |
| 2 | —                                | Base journey continues (declaration, validation, registration)                                                                  | As per base journey           | —                        | —                                                                             |
| 3 | System                           | At registration, evaluates eligibility (at least one citizen parent authenticated). Sends child data to MOSIP for UIN creation. | Automated                     | At registration          | Record enters _Awaiting external validation_ workqueue                        |
| 4 | MOSIP system                     | Processes identity creation                                                                                                     | External                      | Variable                 | VID returned to OpenCRVS and stored on record                                 |
| 5 | —                                | Registration completes. Certificate can be printed.                                                                             | —                             | After MOSIP confirmation | Record fully registered                                                       |

**Key decisions:**

* If neither parent is a Farajaland citizen → UIN creation does not trigger; registration proceeds normally
* If the device is offline during eSignet → QR code scanning of MOSIP credential as fallback (verification, not authentication)
* If MOSIP does not respond → record stalls in _Awaiting external validation_ queue; requires manual investigation

**What the informant / family receives:** Birth certificate. Child's UIN is created in the national ID system.

***

#### Other journeys

The journeys below begin from a record that already exists in the system. Each entry shows the status the record is in when the journey starts and what triggers it.

***

#### N1 — Late registration rejected by Provincial Registrar (BIRTH-REG-6)

**Triggered when:** A Provincial Registrar reviews a late registration (flagged at declaration) and determines it cannot be approved — due to insufficient evidence, documentation gaps, or policy non-compliance. **Record at the start:** Declared (with `flag:late-registration-approval-required`)

**In plain terms:** The Provincial Registrar reviews the late registration request and rejects it, providing a reason. The record is returned to the Registration Officer who submitted it, who contacts the family, gathers additional evidence, and re-submits the declaration. The Provincial Registrar reviews again.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                                                  |
| -------------------- | -------------------- | --------------------------------------------------------------- |
| Provincial Registrar | Provincial Registrar | Reviews and rejects the late registration                       |
| Registration Officer | Registration Officer | Receives the rejection, gathers additional evidence, re-submits |

**Step by step:**

| # | Who                  | What happens                                                                                               | Where                        | Output / handoff                                                         |
| - | -------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------ |
| 1 | Provincial Registrar | Reviews the late registration and rejects it with a reason and comment                                     | Provincial office            | Record flagged as rejected; routed back to Registration Officer          |
| 2 | Registration Officer | Reviews the rejection reason, contacts the family, gathers additional evidence or corrects the declaration | District registration office | Updated declaration re-submitted                                         |
| 3 | Provincial Registrar | Reviews the re-submitted late registration                                                                 | Provincial office            | Approves → registration proceeds (J4 step 4). Or rejects again → repeat. |

**Key decisions:**

* If the informant cannot provide the required evidence → record may be archived (see N9)

**What the informant / family receives:** Notification of rejection (if informant notifications are configured — see BQ-7).

***

#### N2 — Rejection by Registration Officer, redeclared by Community Leader (BIRTH-REG-7)

**Triggered when:** A Registration Officer reviews a community notification and determines the data is too incomplete or incorrect to proceed. **Record at the start:** Declared (after completion from Notified) or Notified

**In plain terms:** The Registration Officer rejects the community submission with a reason. The Community Leader receives the rejected record, visits the family to gather the missing or corrected information, and re-submits. The Registration Officer then reviews the updated submission.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                        |
| -------------------- | -------------------- | ------------------------------------- |
| Registration Officer | Registration Officer | Rejects the declaration with a reason |
| Community Leader     | Community Leader     | Edits the record and re-submits       |

**Step by step:**

| # | Who                  | What happens                                                                                        | Where                        | Output / handoff                                          |
| - | -------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------- | --------------------------------------------------------- |
| 1 | Registration Officer | Rejects the declaration with a reason and comment                                                   | District registration office | Record flagged as rejected; routed to Community Leader    |
| 2 | Community Leader     | Reviews rejection reason, visits the family, edits the record with corrected/additional information | Community                    | Updated record re-declared → rejection flag cleared       |
| 3 | Registration Officer | Reviews the re-submitted declaration                                                                | District registration office | Proceeds to registration (via Registrar) or rejects again |

**Key decisions:**

* If the Community Leader cannot resolve the issue → record may be archived

**What the informant / family receives:** Updated record re-submitted by Community Leader on their behalf.

***

#### N3 — Rejection by Registrar, redeclared by Registration Officer (BIRTH-REG-8)

**Triggered when:** A Registrar reviews a declaration submitted by a Registration Officer and determines it cannot be registered as submitted. **Record at the start:** Declared

**In plain terms:** The Registrar rejects the declaration with a reason. The Registration Officer who submitted it reviews the rejection, contacts the informant if needed, edits the record, and re-declares it. The Registrar reviews the updated declaration.

**Who's involved:**

| Role in this journey | Country title        | Responsibility          |
| -------------------- | -------------------- | ----------------------- |
| Registrar            | Local Registrar      | Rejects the declaration |
| Registration Officer | Registration Officer | Edits and re-declares   |

**Step by step:**

| # | Who                  | What happens                                            | Where                        | Output / handoff                                           |
| - | -------------------- | ------------------------------------------------------- | ---------------------------- | ---------------------------------------------------------- |
| 1 | Registrar            | Rejects the declaration with a reason and comment       | District registration office | Record flagged as rejected; routed to Registration Officer |
| 2 | Registration Officer | Reviews rejection reason, edits the record, re-declares | District registration office | Rejection flag cleared; record back in Declared status     |
| 3 | Registrar            | Reviews the updated declaration                         | District registration office | Registers or rejects again                                 |

**Key decisions:**

* The Registrar may alternatively edit and register directly if they hold `record.edit` + `record.register` scopes (Open Question BQ-20)

**What the informant / family receives:** Certificate after successful re-declaration and registration.

***

#### N4 — Embassy rejection and redeclaration (BIRTH-REG-10)

**Triggered when:** The Registrar General reviews an embassy declaration and rejects it. **Record at the start:** Declared

**In plain terms:** The Registrar General rejects the embassy declaration with a reason. The Embassy Official receives the rejection, contacts the informant, edits the record, and re-declares. The Registrar General reviews again.

**Who's involved:**

| Role in this journey | Country title     | Responsibility          |
| -------------------- | ----------------- | ----------------------- |
| Registrar General    | Registrar General | Rejects the declaration |
| Embassy Official     | Embassy Official  | Edits and re-declares   |

**Step by step:**

| # | Who               | What happens                                                      | Where           | Output / handoff                                       |
| - | ----------------- | ----------------------------------------------------------------- | --------------- | ------------------------------------------------------ |
| 1 | Registrar General | Rejects the embassy declaration with a reason                     | CRA National HQ | Record flagged as rejected; routed to Embassy Official |
| 2 | Embassy Official  | Reviews rejection, contacts family, edits the record, re-declares | Embassy         | Rejection flag cleared                                 |
| 3 | Registrar General | Reviews the updated declaration                                   | CRA National HQ | Registers or rejects again                             |

**What the informant / family receives:** Certificate after successful redeclaration and registration at the embassy.

***

#### N5 — Certificate printing in advance of issuance (BIRTH-ISSUE-1)

**Triggered when:** A Registrar prints a certificate in advance of the informant's collection visit. **Record at the start:** Registered

**In plain terms:** After registering a birth, the Registrar prints the certificate in advance so it is ready when the family comes to collect it. The certificate must be formally recorded at issuance.

**Who's involved:**

| Role in this journey | Country title   | Responsibility                    |
| -------------------- | --------------- | --------------------------------- |
| Registrar            | Local Registrar | Prints the certificate in advance |

**Step by step:**

| # | Who       | What happens                                         | Where                        | Output / handoff                              |
| - | --------- | ---------------------------------------------------- | ---------------------------- | --------------------------------------------- |
| 1 | Registrar | Prints the birth certificate for a registered record | District registration office | Certificate printed and stored for collection |
| 2 | Registrar | When the family collects, records the issuance       | District registration office | Issuance recorded in the system               |

**What the informant / family receives:** Pre-printed birth certificate collected at a later date.

***

#### N6 — Escalation to Provincial Registrar (BIRTH-ESCALATE-1)

**Triggered when:** A Registrar has a question or concern about a declaration that requires provincial-level guidance. **Record at the start:** Declared

**In plain terms:** The Registrar escalates the record to the Provincial Registrar with a question or comment. The Provincial Registrar reviews the record, provides guidance, and returns it. The Registrar then proceeds with registration or takes other action based on the guidance.

**Who's involved:**

| Role in this journey | Country title        | Responsibility       |
| -------------------- | -------------------- | -------------------- |
| Registrar            | Local Registrar      | Escalates the record |
| Provincial Registrar | Provincial Registrar | Reviews and responds |

**Step by step:**

| # | Who                  | What happens                                                            | Where                        | Output / handoff                                                        |
| - | -------------------- | ----------------------------------------------------------------------- | ---------------------------- | ----------------------------------------------------------------------- |
| 1 | Registrar            | Escalates the record to the Provincial Registrar with a reason/question | District registration office | Record flagged as escalated; routed to Provincial Registrar's workqueue |
| 2 | Provincial Registrar | Reviews the record and provides a response                              | Provincial office            | Escalation resolved; record returned to Registrar's workqueue           |
| 3 | Registrar            | Acts on the Provincial Registrar's guidance                             | District registration office | Registration proceeds, or other action taken                            |

**What the informant / family receives:** No direct output — internal workflow step.

***

#### N7 — Escalation to Legal (BIRTH-ESCALATE-2)

**Triggered when:** A Registrar has a legal question about a declaration. **Record at the start:** Declared

**In plain terms:** The Registrar escalates the record to the Legal Officer for legal guidance. The Legal Officer reviews and responds. The Registrar proceeds based on the guidance.

**Who's involved:**

| Role in this journey | Country title   | Responsibility       |
| -------------------- | --------------- | -------------------- |
| Registrar            | Local Registrar | Escalates the record |
| Legal Officer        | Legal Officer   | Reviews and responds |

**Step by step:**

| # | Who           | What happens                                         | Where                        | Output / handoff                                  |
| - | ------------- | ---------------------------------------------------- | ---------------------------- | ------------------------------------------------- |
| 1 | Registrar     | Escalates the record to Legal with a reason/question | District registration office | Record flagged; routed to Legal Officer           |
| 2 | Legal Officer | Reviews and provides legal guidance                  | CRA National HQ              | Escalation resolved; record returned to Registrar |
| 3 | Registrar     | Acts on the legal guidance                           | District registration office | Proceeds accordingly                              |

**What the informant / family receives:** No direct output — internal workflow step.

***

#### N8 — Escalation to Registrar General (BIRTH-ESCALATE-3)

**Triggered when:** A Registrar has a question requiring national-level authority. **Record at the start:** Declared

**In plain terms:** The Registrar escalates the record to the Registrar General. The Registrar General reviews and responds. The Registrar acts on the guidance.

**Who's involved:**

| Role in this journey | Country title     | Responsibility       |
| -------------------- | ----------------- | -------------------- |
| Registrar            | Local Registrar   | Escalates the record |
| Registrar General    | Registrar General | Reviews and responds |

**Step by step:**

| # | Who               | What happens                                          | Where                        | Output / handoff                            |
| - | ----------------- | ----------------------------------------------------- | ---------------------------- | ------------------------------------------- |
| 1 | Registrar         | Escalates to Registrar General with a reason/question | District registration office | Record flagged; routed to Registrar General |
| 2 | Registrar General | Reviews and provides guidance                         | CRA National HQ              | Escalation resolved; record returned        |
| 3 | Registrar         | Acts on guidance                                      | District registration office | Proceeds accordingly                        |

**What the informant / family receives:** No direct output — internal workflow step.

***

#### N9 — Archive declaration (BIRTH-ARCHIVE-1)

**Triggered when:** A Registration Officer determines that a notified or declared record cannot progress — confirmed duplicate, abandoned notification, or withdrawn by the informant. **Record at the start:** Notified or Declared

**In plain terms:** The Registration Officer archives the record with a reason. The record is removed from active processing. It remains in the system as a historical record.

**Who's involved:**

| Role in this journey | Country title        | Responsibility      |
| -------------------- | -------------------- | ------------------- |
| Registration Officer | Registration Officer | Archives the record |

**Step by step:**

| # | Who                  | What happens                                  | Where                        | Output / handoff                                           |
| - | -------------------- | --------------------------------------------- | ---------------------------- | ---------------------------------------------------------- |
| 1 | Registration Officer | Archives the record with a reason and comment | District registration office | Record in Archived status. Removed from active workqueues. |

**Key decisions:**

* Open Question: can an archived record be reinstated? (Not supported in v2.0 — see BQ-9)

**What the informant / family receives:** No certificate. Record preserved but inactive.

***

#### N10 — Simple correction (BIRTH-CORRECT-1)

**Triggered when:** An error is discovered in a registered birth record — a misspelling, incorrect date, or other data issue. **Record at the start:** Registered

**In plain terms:** A Registration Officer requests a correction on the registered record, specifying the field(s) to change and providing supporting documentation. The correction request is reviewed and approved (or rejected) by a Registrar. While the correction is pending, the certificate cannot be reprinted. Once approved, the record is updated and a corrected certificate can be issued.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                     |
| -------------------- | -------------------- | ---------------------------------- |
| Registration Officer | Registration Officer | Requests the correction            |
| Registrar            | Local Registrar      | Approves or rejects the correction |

**Step by step:**

| # | Who                  | What happens                                                                                        | Where                        | Output / handoff                                                                                                   |
| - | -------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| 1 | Registration Officer | Requests a correction on the registered record, specifying fields and providing supporting evidence | District registration office | Correction request submitted → `flag:correction-requested` added. Print disabled.                                  |
| 2 | Registrar            | Reviews the correction request. Approves or rejects.                                                | District registration office | If approved: record updated, flag cleared, Print re-enabled. If rejected: flag cleared, original record unchanged. |
| 3 | Registrar            | Prints corrected certificate (if approved)                                                          | District registration office | Corrected certificate issued                                                                                       |

**Key decisions:**

* If the correction involves the child's date of birth → Provincial Registrar approval required (elevated approval)
* If the correction involves biographical data (name, DOB, sex) → MOSIP update triggered (see N11 for MOSIP-related corrections)

**What the informant / family receives:** Corrected birth certificate (if approved).

***

#### N11 — Correction to add MOSIP authentication for UIN creation (BIRTH-CORRECT-2-MOSIP)

**Triggered when:** A correction adds eSignet authentication of a parent to a record where it was previously absent, satisfying the eligibility rules for UIN creation. **Record at the start:** Registered (without child UIN)

**In plain terms:** A registered birth record did not trigger UIN creation at registration because no parent was authenticated. A correction is submitted that adds mother or father authentication via eSignet. Once the correction is approved, the system triggers deferred UIN creation for the child through MOSIP.

**Who's involved:**

| Role in this journey | Country title        | Responsibility                                       |
| -------------------- | -------------------- | ---------------------------------------------------- |
| Registration Officer | Registration Officer | Requests the correction to add parent authentication |
| Registrar            | Local Registrar      | Approves the correction                              |
| MOSIP system         | National ID system   | Creates the child's UIN                              |

**Step by step:**

| # | Who                  | What happens                                                                                            | Where                        | Output / handoff                                                       |
| - | -------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------- | ---------------------------------------------------------------------- |
| 1 | Registration Officer | Requests correction to add eSignet authentication of mother or father                                   | District registration office | Correction request submitted                                           |
| 2 | Registrar            | Approves the correction                                                                                 | District registration office | Record updated with parent authentication                              |
| 3 | System               | Evaluates eligibility — at least one citizen parent now authenticated. Triggers UIN creation via MOSIP. | Automated                    | Record enters _Awaiting external validation_. VID returned and stored. |

**What the informant / family receives:** Child's UIN created in the national ID system. Updated certificate if needed.

***

#### N12 — Revoke a registration (BIRTH-REVOKE-1)

**Triggered when:** A registration is found to have been made in error or fraudulently. **Record at the start:** Registered

**In plain terms:** The Registrar General revokes the birth registration, providing a legal reason and supporting documentation. The record is marked as revoked. The child's UIN in MOSIP is deactivated. Certificates can no longer be printed.

**Who's involved:**

| Role in this journey | Country title     | Responsibility           |
| -------------------- | ----------------- | ------------------------ |
| Registrar General    | Registrar General | Revokes the registration |

**Step by step:**

| # | Who               | What happens                                                                          | Where           | Output / handoff                                               |
| - | ----------------- | ------------------------------------------------------------------------------------- | --------------- | -------------------------------------------------------------- |
| 1 | Registrar General | Revokes the registration with a reason, legal reference, and supporting documentation | CRA National HQ | `flag:revoked` added to the Registered record. Print disabled. |
| 2 | System            | Sends revocation to MOSIP — child's UIN deactivated                                   | Automated       | MOSIP identity flagged as inactive                             |

**Key decisions:**

* Can the revocation be reversed? Yes — see N13

**What the informant / family receives:** No further certificates can be issued. Notification to the family: Open Question.

***

#### N13 — Reinstate revoked registration (BIRTH-REINSTATE\_REVOKED\_REGISTRATION-1)

**Triggered when:** A previously revoked registration is determined to be valid after further investigation. **Record at the start:** Registered (with `flag:revoked`)

**In plain terms:** The Registrar General reinstates a previously revoked birth registration, clearing the revocation flag. Certificates can be printed again. Open Question on whether MOSIP UIN is reactivated.

**Who's involved:**

| Role in this journey | Country title     | Responsibility                      |
| -------------------- | ----------------- | ----------------------------------- |
| Registrar General    | Registrar General | Reinstates the revoked registration |

**Step by step:**

| # | Who               | What happens                                    | Where           | Output / handoff                          |
| - | ----------------- | ----------------------------------------------- | --------------- | ----------------------------------------- |
| 1 | Registrar General | Reinstates the registration with a reason       | CRA National HQ | `flag:revoked` cleared. Print re-enabled. |
| 2 | System            | Open Question: whether MOSIP UIN is reactivated | —               | —                                         |

**What the informant / family receives:** Certificates can be printed again. Registration restored.

***

### Open Questions

| ID   | Question                                                                                                                     | Domain       | Decision-maker                | Target date | Status |
| ---- | ---------------------------------------------------------------------------------------------------------------------------- | ------------ | ----------------------------- | ----------- | ------ |
| JQ-1 | Does the Registrar have `record.edit` + `record.register` to register-with-edits after rejection (bypassing re-declaration)? | registration | Country team                  | —           | Open   |
| JQ-2 | Do late registration rules apply to embassy declarations?                                                                    | declaration  | Country team                  | —           | Open   |
| JQ-3 | Is there a further "delayed" tier beyond 365 days?                                                                           | declaration  | Country team                  | —           | Open   |
| JQ-4 | Can archived records be reinstated? (Not supported in v2.0)                                                                  | archive      | Country team / OpenCRVS Core  | —           | Open   |
| JQ-5 | Is MOSIP UIN reactivated when a revoked registration is reinstated?                                                          | integration  | Country team                  | —           | Open   |
| JQ-6 | Is notification of rejection sent to the informant? Via what channel?                                                        | notification | Country team                  | —           | Open   |
| JQ-7 | Escalation response time expectations?                                                                                       | escalation   | Country team                  | —           | Open   |
| JQ-8 | Does the escalation use a single branching action (Recipe 2) or separate actions per destination?                            | escalation   | Country team / Technical lead | —           | Open   |

***

### Version History

| Version | Date       | Status | Sections changed | Summary                                                                                        |
| ------- | ---------- | ------ | ---------------- | ---------------------------------------------------------------------------------------------- |
| 0.1     | 2026-05-07 | Draft  | All              | Initial draft — all journeys from BIRTH-REG-1 through BIRTH-REINSTATE\_REVOKED\_REGISTRATION-1 |
