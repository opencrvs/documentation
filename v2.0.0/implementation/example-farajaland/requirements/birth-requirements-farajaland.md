# Birth business requirements

### 1. Introduction

OpenCRVS ships with an example country configuration called **Farajaland**. Farajaland is not a real country; it is a teaching and demonstration example used to show how civil registration business rules can be translated into OpenCRVS configuration.

This page summarises the **key birth civil registration business rules** for Farajaland. These rules drive how birth events are declared, validated, registered, printed, corrected, and revoked.

### 2. Plain-Language Summary

Farajaland registers births through four channels: health facilities (hospital notification), community (Community Leader declaration), district registration offices (walk-in declaration), and embassies (overseas births).

When a birth occurs at a health facility, a Health Official captures a shortened notification form with key details. The notification is routed to the district Registration Officer, who completes the record into a full declaration with all required information, validates it, and presents it for registration. When a birth occurs in the community, a Community Leader captures a declaration using a shortened version of the declaration form (fields hidden by role). The Community Leader's declaration enters Declared status and must be validated by a Registration Officer before the Registrar can register it.

At a registration office, a Registration Officer captures the full declaration directly from the informant and either submits it for the Registrar's review or, if the officer is also a Registrar, registers it themselves.

Embassy Officials capture overseas birth declarations and submit them for registration by the Registrar General.

If a birth is registered more than 365 days after the date of birth, the declaration is automatically flagged as a late registration. A Provincial Registrar must approve the late registration before the Registrar can register it. The Provincial Registrar may also reject the late registration, returning it for updates.

Where a mother and/or father is authenticated via MOSIP eSignet during declaration, a UIN is created for the child at registration (provided at least one parent is a Farajaland citizen).

The first birth certificate is free. Certified copies cost $10. Certificates can be printed in advance of issuance for offline registration drives. Certified copies require the original certificate to have been issued first.

Corrections to registered records can be requested by a Registration Officer and approved by a Registrar. Corrections to the child's date of birth require Provincial Registrar approval. Corrections to the child's biographical data (name, date of birth, sex) trigger an update to the MOSIP National ID system. A correction that adds parent authentication (previously missing) triggers deferred UIN creation for the child.

The Registrar General can revoke a birth registration (deactivating the child's UIN in MOSIP) and reinstate a previously revoked registration.

Registrars can escalate records to the Provincial Registrar, to Legal, or to the Registrar General for guidance.

***

### 3. Channels in scope

| Channel             | Used for                      | Notes                                                                                                                                                                                                                               |
| ------------------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Registration office | Full declaration              | Walk-in declarations captured by Registration Officer. The primary channel for in-person registration.                                                                                                                              |
| Health facility     | Notification (shortened form) | Hospital Official captures a notification at point of birth using a shortened version of the declaration form (fields hidden by role). Must be completed into a full declaration by a Registration Officer before registration.     |
| Community           | Declaration (shortened form)  | Community Leader captures a declaration using a shortened version of the declaration form (fields hidden by role). Record enters Declared status. Must be validated by a Registration Officer before the Registrar can register it. |
| Embassy             | Full declaration              | Embassy Official captures overseas birth declarations. Restricted to births of Farajaland citizens occurring outside the country. Registered by the Registrar General.                                                              |

***

### 4.1 — Notification

* **Who can capture a notification?** Health Official (`health_official`).
* **Which channels?** Health facility.
* **Health facility channel:** The Health Official captures key birth details (child's name, sex, date and time of birth, place of birth, mother's details where available) using the declaration form with non-essential fields hidden by role. The Health Official's name is auto-populated from their user profile. Pre-populated data: none from external systems at notification stage (eSignet authentication is available but optional at this stage).
* **How long can a notification remain?** Open Question — the time limit for notifications before automatic archive or escalation is not stated.
* **Can the public see the notification?** Open Question — whether a citizen can look up a notification using a tracking ID is not stated.
* **Automatic messages on notification:** Open Question — whether SMS/email is sent to the informant on notification is not stated. See A12 for the full notification trigger list.

***

### 4.2 — Declaration

* **Who can submit a declaration?** Registration Officer (`registration_officer`), Registrar (`registrar`), Community Leader (`community_leader`), Embassy Official (`embassy_official`). Health Officials submit notifications, not declarations.
* **Registration office channel:** Registration Officer captures the full declaration directly from the informant. All mandatory fields are visible and required. Pre-populated data: eSignet authentication of mother and/or father can pre-populate their biographical details from MOSIP.
* **Health facility / Community channel (completion of notification):** Registration Officer opens the existing notification, completes all remaining mandatory fields, and submits as a full declaration.
* **Embassy channel:** Embassy Official captures the full declaration for overseas births. Registered by the Registrar General.
* **Informant hierarchy:** Open Question — the order of preference for informants (mother, father, other relative, legal guardian) and any conditions are not fully enumerated. Legal guardians must provide court documentation.
* **Is the informant required to sign?** Yes — informant signature is mandatory.
* **Are mother / father details mandatory or optional?** Mother and father details are optional.
* **Conditions requiring additional documentary evidence:** Legal guardians must provide court documentation. Other conditions: Open Question.
* **Late declaration rule:** At 365 days from the date of birth, the declaration becomes "late" and triggers a requirement for Provincial Registrar approval before registration can proceed. The system automatically adds a flag (`flag:late-registration-approval-required`) when `declarationDate − dateOfBirth > 365 days`. The Provincial Registrar reviews and either approves (clearing the flag, allowing registration) or rejects (returning for updates).

***

### 4.3 — Validation

* **Conditions requiring validation:** All records originating from a Community Leader (declarations using a shortened form) or a Health Official (notifications) must be validated by a Registration Officer before registration. Declarations submitted directly at a registration office by a Registration Officer do not require a separate validation step — the Registration Officer's act of completing the declaration serves as validation.
* **Who can validate?** Registration Officer (`registration_officer`).
* **Time limit for validation:** Open Question — not stated.
* **Can the validator amend the declaration during review?** Yes — Registration Officers can modify declarations without recapturing the informant's signature.
* **If amended, does the informant need to re-confirm or re-sign?** No.
* **If the validator decides the record cannot be validated:** The record is rejected — see A5.

***

### 4.4 — Registration

* **Conditions that must be met before registration:**
  * No outstanding duplicate concerns (potential-duplicate flag must be resolved)
  * If the record originated as a notification: validation by a Registration Officer must be complete
  * If the registration is late (over 365 days): Provincial Registrar approval must be obtained (flag:late-registration-approval-required must be absent)
  * All required supporting documents on file
  * No pending correction request
* **Conditions requiring elevated approval:** Late registration (over 365 days from date of birth) requires Provincial Registrar approval via `action:APPROVE_LATE_REGISTRATION` before the Registrar can register.
* **Does this event trigger NID integration at registration?** Yes — if at least one parent is a Farajaland citizen and has been authenticated via eSignet (PSUT stored on the record), UIN creation is triggered for the child via MOSIP Packet Manager. The record enters an _Awaiting external validation_ workqueue while MOSIP processes the identity creation. See A14 for full integration requirements.
* **Offline drive rule:** Yes — Registrars can print certificates before the record's registration has been synchronised to the central server, as part of registration drives to register and issue certificates offline. Acknowledged risk: the certificate is not "legally final" until the registration has synced.
* **Who can register?** Registrar (`registrar`), Registrar General (`registrar_general` — for embassy declarations).
* **Per-channel registration rules:**
  * Office: Registrar registers after reviewing the declaration submitted by the Registration Officer. Alternatively, a Registrar who holds `record.edit` + `record.register` scopes can review, edit, and register in one flow.
  * Health facility / Community: Registrar registers after the Registration Officer has validated and completed the declaration.
  * Embassy: Registrar General registers embassy declarations.
  * Offline drive: Registrar declares and registers directly (BIRTH-REG-5), printing the certificate immediately.

***

### 4.5 — Rejection and re-declaration

* **Conditions under which a record may be rejected:**
  * Missing or incorrect data
  * Incomplete supporting documents
  * Policy non-compliance
  * Failed document or identity checks
* **Who can reject?** Registration Officer (`registration_officer`), Registrar (`registrar`), Provincial Registrar (`provincial_registrar` — for late registration rejections), Registrar General (`registrar_general` — for embassy declaration rejections).
* **What information is captured on rejection?** A reason for rejection and a free-text comment.
* **Who can re-submit after rejection?** The original declarer
* **When a rejected record is corrected and re-submitted:** The act of re-declaration (action:DECLARE) clears the `flag:rejected` and returns the record to the standard workflow. Alternatively, a Registrar with `record.edit` + `record.register` scopes can edit and register directly, clearing the `flag:rejected` without requiring re-declaration.

***

### 4.6 — Archive and reinstate

* **Conditions under which a record is archived:**
  * Confirmed duplicate (marked as duplicate during review)
  * Abandoned notification (no follow-up declaration)
  * Withdrawn by informant
* **Who can archive?** Registration Officer (`registration_officer`).
* **Conditions under which an archived record may be reinstated:** Open Question — `record.reinstate` does not exist in v2.0. If reinstatement of archived records is required, it must be modelled as a custom action or the platform mechanism must be verified. Note: the user-provided workflows include BIRTH-ARCHIVE-1 (archive by Registration Officer) but do not describe a reinstate flow for archived (pre-registration) records. Reinstatement of _revoked registrations_ is covered in A9.
* **Who can reinstate (archived records)?** Registration Officer (`registration_officer`).
* **What information is captured on archive?** A reason and a comment.

***

### 4.7 — Certificate and certified copy

#### Template 1: Birth Certificate (primary)

* **Template name:** Birth Certificate
* **Output type:** Full certificate
* **Fee:** Free (first certificate)
* **Must the original certificate be issued before a certified copy can be requested?** N/A — this is the primary certificate.
* **Can certificates be printed in advance of collection?** Yes — BIRTH-ISSUE-1 describes printing in advance of issuance.
* **If advance-printed, must they be formally recorded at issuance?** Yes — Open Question on exact recording mechanism.
* **Who can print?** Registrar (`registrar`), Embassy Official (`embassy_official` — for embassy declarations after registration by Registrar General), Registrar General (`registrar_general`).
* **Conditions before printing:** Record must be Registered. No correction request in progress (`flag:correction-requested` must be absent).

#### Template 2: Certified Copy

* **Template name:** Certified Copy
* **Output type:** Certified copy
* **Fee:** $10 (or equivalent local currency)
* **Must the original certificate be issued before a certified copy can be requested?** Yes — the primary certificate must have been printed first.
* **Can certified copies be printed in advance?** Yes — with formal recording at issuance.
* **Who can print?** Registrar (`registrar`), Embassy Official (`embassy_official`), Registrar General (`registrar_general`).
* **Conditions before printing:** Record must be Registered. Primary certificate must have been issued (journal check — no flag needed). No correction request in progress.

***

### 4.8 — Correction

* **Fields that cannot be corrected after registration:** Open Question — "all fields correctable through configured workflows" per source material, but practical restrictions may apply.
* **Fields requiring elevated approval:** Corrections to the child's date of birth require Provincial Registrar approval.
* **Does correction require the informant to re-confirm or re-sign?** Open Question — not stated.
* **Must corrections be shared with the NID system?** Yes — corrections to the child's biographical data (name, date of birth, sex) must be shared with the Farajaland National ID system. See A14.
* **Correction fee:** Open Question — not stated.
* **Who can request a correction?** Registration Officer (`registration_officer`).
* **Who can approve a correction?** Registrar (`registrar`).

#### Correction to add parent authentication and trigger UIN creation

When a correction adds eSignet authentication of the mother or father to a record where it was previously absent, and this now satisfies the eligibility rules for UIN creation (at least one citizen parent authenticated), the correction triggers deferred UIN creation for the child via MOSIP. This uses the same UIN creation flow as at-registration creation.

***

### 4.9 — Revocation / deactivation

* **Who can revoke?** Registrar General (`registrar_general`).
* **Conditions under which revocation is permitted:** When a registration is later found to have been made in error or fraudulently.
* **What information is captured on revocation?** A reason, a legal reference, and supporting documentation. Open Question — exact fields not specified.
* **Must revocation be shared with the NID system?** Yes — birth revocation triggers UIN deactivation in the MOSIP National ID system.
* **Can a revocation be reversed?** Yes — the Registrar General can reinstate a previously revoked registration&#x20;
* **After revocation, can certificates still be printed?** No. A `flag:revoked` on the Registered record would gate Print (absent required).

***

### 4.10 — Escalation

#### 4.10.1 — Escalation to Provincial Registrar&#x20;

* **How triggered:** Manually by the Registrar.
* **When:** When the Registrar has a question or concern about a declaration that requires provincial-level guidance.
* **Escalating from:** Registrar (`registrar`).
* **Escalating to:** Provincial Registrar (`provincial_registrar`).
* **Response action:** The Provincial Registrar reviews the record and provides a response (via a custom action). The record is returned to the Registrar's queue for further processing.

#### 4.10.2 — Escalation to Registrar General

* **How triggered:** Manually by the Registrar.
* **When:** When the Registrar has a question requiring national-level authority.
* **Escalating from:** Registrar (`registrar`).
* **Escalating to:** Registrar General (`registrar_general`).
* **Response action:** The Registrar General reviews and provides a response. The record is returned to the Registrar.

***

### 4.11 — Duplicate detection

* **Working definition of a duplicate for birth:** Same child name (exact or near-exact match using fuzzy matching), same date of birth, same mother's details (name and/or National ID). Age plausibility rules applied.
* **Who reviews potential duplicates?** Registrar (`registrar`).
* **What happens to a record marked as a duplicate?** The new declaration is archived; the original record is unchanged.
* **What happens to a record marked as not a duplicate?** The record continues through the lifecycle as if no duplicate had been flagged (the `flag:potential-duplicate` is removed).

***

### 4.12 — Informant notifications

* **Channels:** Open Question — SMS, email, both, or neither not explicitly confirmed. The source material mentions informant notification capability but does not enumerate specific triggers.
* **Moments that should trigger a message:**

| Ref              | Action                          | Recipient | Purpose                                                                               |
| ---------------- | ------------------------------- | --------- | ------------------------------------------------------------------------------------- |
| birth-declared   | When a declaration is submitted | Informant | Confirm receipt of declaration with tracking ID                                       |
| birth-rejected   | When a record is rejected       | Informant | Notify of rejection with reason and next steps                                        |
| birth-registered | When a birth is registered      | Informant | Confirm registration with registration number and certificate collection instructions |

* **What contact details do we need to capture?** Informant's phone number (for SMS) and/or email address (for email). These fields must be present in the declaration form.

***

### 4.13 — Search and record discovery

* **Who can search?** Registration Officer (`registration_officer`), Registrar (`registrar`), Provincial Registrar (`provincial_registrar`), Registrar General (`registrar_general`), Embassy Official (`embassy_official`).
* **Geographic scope of search results:** Varies by role:
  * Registration Officer / Registrar: records within their district (`placeOfBirth = my-administrative-area`)
  * Provincial Registrar: Records within their province (`placeOfBirth = my-administrative-area` at province level)
  * Registrar General: nationwide (`any`)
  * Embassy Official: Records they declared (`declared_by = user`) or nationwide?
* **Can staff search using PII?** Yes — name, date of birth, National ID.

***

### 4.14 — Interoperability (event-specific)

#### National ID system (MOSIP)

**Actions triggering NID calls:**

| Action                                    | Purpose                        | Data shared (OpenCRVS → MOSIP)                     | Data received                       | Failure handling                                                                                                                                |
| ----------------------------------------- | ------------------------------ | -------------------------------------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Registration (when eligible)              | Create UIN for child           | Child's biographical data (configurable field set) | VID returned on successful creation | Record enters _Awaiting external validation_ workqueue. MOSIP does not return failure responses — stalled records require manual investigation. |
| Correction (biographical fields)          | Update child's identity record | Updated name, date of birth, and/or sex            | None (send and continue)            | System-wide default                                                                                                                             |
| Correction (adding parent authentication) | Deferred UIN creation          | Child's biographical data                          | VID returned                        | Same as registration                                                                                                                            |
| Revocation                                | Deactivate child's identity    | VID and revocation data                            | None (register and continue)        | System-wide default                                                                                                                             |

**Event-specific NID policy:**

* UIN creation is restricted to children where at least one parent is a Farajaland citizen.
* Corrections to the child's biographical data (name, date of birth, sex) trigger propagation to MOSIP.
* Birth revocation triggers UIN deactivation.

**eSignet authentication during declaration:**

* Mother and/or father can authenticate via eSignet during declaration
* On successful authentication: form fields pre-populated from MOSIP ID schema; PSUT stored against the record.
* Offline alternative: CBOR-based QR code scanning of MOSIP credentials, with subsequent online verification.
* Authentication of at least one citizen parent is a prerequisite for UIN creation at registration.

#### Health information system

* Health facilities submit birth notifications via the MoU with the Ministry of Health.
* Pre-population: hospital official name auto-populated from user profile.



***



### 5. Using Farajaland as a reference

These Farajaland rules are **illustrative**, not prescriptive. They show how:

* Legal and policy decisions (for example, who can declare, how late registrations are handled, how many free certificates are allowed) map onto OpenCRVS configuration.
* Business requirements around identity systems and fees can be integrated with registration workflows.

When configuring OpenCRVS for a real country, use Farajaland as a starting point and adapt each rule to match national legislation, policy, and operational practice.
