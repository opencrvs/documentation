# Birth form definition

### Section 1 — Forms in this document

<table><thead><tr><th width="284.6015625">Form</th><th width="193.18359375">Section</th><th>Invoked by action</th></tr></thead><tbody><tr><td>Declaration form</td><td>Section 2</td><td><code>DECLARE</code> / <code>NOTIFY</code> (same form — roles that can only notify see a subset of fields via role-scoped visibility conditions)</td></tr><tr><td>Correction form</td><td>Section 3</td><td><code>REQUEST_CORRECTION</code> / <code>APPROVE_CORRECTION</code></td></tr><tr><td>Action confirmation — Approve late registration</td><td>Section 5.1</td><td><code>APPROVE_LATE_REGISTRATION</code></td></tr><tr><td>Action confirmation — Escalate</td><td>Section 5.2</td><td><code>ESCALATE</code></td></tr><tr><td>Action confirmation — Respond to escalation</td><td>Section 5.3</td><td><code>RESPOND_TO_ESCALATION</code></td></tr><tr><td>Action confirmation — Revoke registration</td><td>Section 5.4</td><td><code>REVOKE_REGISTRATION</code></td></tr><tr><td>Action confirmation — Reinstate revoked registration</td><td>Section 5.5</td><td><code>REINSTATE_REVOKED_REGISTRATION</code></td></tr></tbody></table>

***

### Section 2 — Declaration form

#### Form structure overview

| Page      | Name                 | Field count | Notes                                                                                                 |
| --------- | -------------------- | ----------- | ----------------------------------------------------------------------------------------------------- |
| 0         | Introduction         | 1           | Informational text only                                                                               |
| 1         | Informant's details  | 16          | Hospital-clerk role sees only notifying official fields (3 DATA fields + contact fields)              |
| 2         | Child's details      | 15          | Hospital-clerk/embassy-officer restricted to Health Institution for place of birth                    |
| 3         | Mother's details     | 16          | Entirely hidden for hospital-official except mother\_details\_unavailable (flagged asymmetry — BS-22) |
| 4         | Father's details     | 15          | father\_details\_unavailable NOT hidden for hospital-official (flagged asymmetry — BS-22)             |
| 5         | Supporting documents | 6           | Entire page hidden for hospital-official                                                              |
| 6         | Review               | 2           | Print-in-advance button for Registrar/RG only; informant signature                                    |
| **Total** |                      | **71**      | Excludes intro text                                                                                   |

***

#### Page 0 — Introduction

**Field definitions**

| field\_id                  | type        | label        | hint | options / component | mandatory | analytics | secured |
| -------------------------- | ----------- | ------------ | ---- | ------------------- | --------- | --------- | ------- |
| `intro_birth_registration` | `PARAGRAPH` | Introduction | —    | —                   | —         | —         | —       |

**Field behaviour**

| field\_id                  | display\_condition | pre\_population | validation | notes                                                                                                                                                                                                                                                                                                                                                                                                                      |
| -------------------------- | ------------------ | --------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `intro_birth_registration` | —                  | —               | —          | Full informant briefing text: "I am going to help you make a declaration of birth. As the legal Informant it is important that all the information provided by you is accurate. Once the declaration is processed you will receive an SMS to tell you when to visit the office to collect the certificate — Take your ID with you. Make sure you collect the certificate. A birth certificate is critical for this child." |

***

#### Page 1 — Informant's details

**Field definitions**

| field\_id                                | type        | label              | hint | options / component                                                               | mandatory | analytics | secured |
| ---------------------------------------- | ----------- | ------------------ | ---- | --------------------------------------------------------------------------------- | --------- | --------- | ------- |
| `informant_type`                         | `SELECT`    | Informant type     | —    | Mother \| Father \| Grandfather \| Grandmother \| Legal Guardian \| Self \| Other | TRUE      | TRUE      | FALSE   |
| `informant_notifying_official`           | `DATA`      | Notifying Official | —    | —                                                                                 | FALSE     | FALSE     | FALSE   |
| `informant_notifying_official_firstname` | `DATA`      | First name(s)      | —    | —                                                                                 | FALSE     | FALSE     | FALSE   |
| `informant_notifying_official_lastname`  | `DATA`      | Last name          | —    | —                                                                                 | FALSE     | FALSE     | FALSE   |
| `informant_nationality`                  | `SELECT`    | Nationality        | —    | (country list — Farajaland default)                                               | TRUE      | FALSE     | FALSE   |
| `informant_id_type`                      | `SELECT`    | Form of ID         | —    | National ID \| Passport \| No ID                                                  | TRUE      | FALSE     | FALSE   |
| `informant_id_reader`                    | `ID_READER` | ID Reader          | —    | —                                                                                 | FALSE     | FALSE     | FALSE   |
| `informant_national_id_number`           | `ID`        | National ID no.    | —    | —                                                                                 | TRUE      | FALSE     | FALSE   |
| `informant_passport_number`              | `ID`        | Passport no.       | —    | —                                                                                 | TRUE      | FALSE     | FALSE   |
| `informant_firstname`                    | `NAME`      | First name(s)      | —    | —                                                                                 | TRUE      | FALSE     | FALSE   |
| `informant_lastname`                     | `NAME`      | Last name          | —    | —                                                                                 | TRUE      | FALSE     | FALSE   |
| `informant_date_of_birth`                | `DATE`      | Date of birth      | —    | —                                                                                 | TRUE      | TRUE      | FALSE   |
| `informant_place_of_residence`           | `TEXT`      | Place of residence | —    | —                                                                                 | TRUE      | TRUE      | FALSE   |
| `contact_phone_number`                   | `PHONE`     | Phone number       | —    | —                                                                                 | FALSE     | FALSE     | FALSE   |
| `contact_email_address`                  | `EMAIL`     | Email address      | —    | —                                                                                 | FALSE     | FALSE     | FALSE   |

**Field behaviour**

| field\_id                                | display\_condition                                                                                                  | pre\_population        | validation              | notes                                                                                                                                |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ---------------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `informant_type`                         | HIDE IF role = hospital-official                                                                                    | —                      | —                       | Informant hierarchy per birth-spec A2.3: Mother > Father > Legal Guardian > Other.                                                   |
| `informant_notifying_official`           | SHOW IF role = hospital-official                                                                                    | —                      | —                       | Display label only — indicates Hospital Official is the notifying official.                                                          |
| `informant_notifying_official_firstname` | SHOW IF role = hospital-official                                                                                    | LoggedInUser.firstname | —                       | Pre-populated from logged-in user profile.                                                                                           |
| `informant_notifying_official_lastname`  | SHOW IF role = hospital-official                                                                                    | LoggedInUser.lastname  | —                       | Pre-populated from logged-in user profile.                                                                                           |
| `informant_nationality`                  | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father \| Self)                         | —                      | —                       | Shown only for informant types that are not the parents.                                                                             |
| `informant_id_type`                      | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father \| Self)                         | —                      | —                       | —                                                                                                                                    |
| `informant_id_reader`                    | HIDE IF role = hospital-official; SHOW IF informant\_id\_type = National ID AND informant\_nationality = Farajaland | eSignet / QR scan      | —                       | eSignet widget for Farajaland National ID verification.                                                                              |
| `informant_national_id_number`           | HIDE IF role = hospital-official; SHOW IF informant\_id\_type = National ID AND informant\_nationality = Farajaland | —                      | —                       | —                                                                                                                                    |
| `informant_passport_number`              | HIDE IF role = hospital-official; SHOW IF informant\_id\_type = Passport                                            | —                      | —                       | —                                                                                                                                    |
| `informant_firstname`                    | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father \| Self)                         | —                      | —                       | —                                                                                                                                    |
| `informant_lastname`                     | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father \| Self)                         | —                      | —                       | —                                                                                                                                    |
| `informant_date_of_birth`                | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father \| Self)                         | —                      | —                       | —                                                                                                                                    |
| `informant_place_of_residence`           | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father \| Self)                         | —                      | —                       | Source CSV uses TEXT; Mother and Father use structured ADDRESS. Confirm whether this should use ADDRESS for consistency — see BFF-9. |
| `contact_phone_number`                   | —                                                                                                                   | —                      | —                       | Default country code: Farajaland. Used for SMS notifications.                                                                        |
| `contact_email_address`                  | —                                                                                                                   | —                      | Any valid email address | —                                                                                                                                    |

**Open questions**

> **BFF-1** Should informant date of birth allow age substitution when exact DOB is unknown? (BS-22). Owner: Country team. Status: Open.

> **BFF-2** Should informant place of residence use structured ADDRESS (province/district/village/street) consistent with mother and father sections? Owner: Country team. Status: Open.

***

#### Page 2 — Child's details

**Field definitions**

| field\_id                               | type      | label                           | hint | options / component                                        | mandatory | analytics | secured |
| --------------------------------------- | --------- | ------------------------------- | ---- | ---------------------------------------------------------- | --------- | --------- | ------- |
| `child_firstname`                       | `NAME`    | First name(s)                   | —    | —                                                          | TRUE      | FALSE     | FALSE   |
| `child_lastname`                        | `NAME`    | Last name                       | —    | —                                                          | TRUE      | FALSE     | FALSE   |
| `child_date_of_birth`                   | `DATE`    | Date of birth                   | —    | —                                                          | TRUE      | TRUE      | FALSE   |
| `child_reason_for_delayed_registration` | `TEXT`    | Reason for delayed registration | —    | —                                                          | TRUE      | TRUE      | FALSE   |
| `child_sex`                             | `SELECT`  | Sex                             | —    | Male \| Female                                             | TRUE      | TRUE      | FALSE   |
| `child_place_of_birth`                  | `SELECT`  | Place of birth                  | —    | Health Institution \| Residential address \| Other address | TRUE      | TRUE      | FALSE   |
| `child_health_institution`              | `SELECT`  | Health Institution              | —    | (facility picker)                                          | TRUE      | TRUE      | FALSE   |
| `child_birth_address_country`           | `ADDRESS` | Address — Country               | —    | country                                                    | TRUE      | TRUE      | FALSE   |
| `child_birth_address_province`          | `ADDRESS` | Address — Province              | —    | province                                                   | TRUE      | TRUE      | FALSE   |
| `child_birth_address_district`          | `ADDRESS` | Address — District              | —    | district                                                   | TRUE      | TRUE      | FALSE   |
| `child_birth_address_village`           | `ADDRESS` | Address — Village               | —    | village                                                    | TRUE      | TRUE      | FALSE   |
| `child_birth_address_street`            | `ADDRESS` | Address — Street                | —    | street                                                     | FALSE     | FALSE     | FALSE   |
| `child_attendant_at_birth`              | `SELECT`  | Attendant at birth              | —    | Nurse \| Midwife \| Traditional birth attendant \| None    | FALSE     | TRUE      | FALSE   |
| `child_type_of_birth`                   | `SELECT`  | Type of birth                   | —    | Single \| Twin \| Triplet \| Higher multiple delivery      | FALSE     | TRUE      | FALSE   |
| `child_weight_at_birth`                 | `NUMBER`  | Weight at birth                 | —    | —                                                          | FALSE     | TRUE      | FALSE   |

**Field behaviour**

| field\_id                               | display\_condition                                                        | pre\_population                                                                           | validation              | notes                                                                 |
| --------------------------------------- | ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------- |
| `child_firstname`                       | —                                                                         | —                                                                                         | —                       | NID attribute: child.firstName                                        |
| `child_lastname`                        | —                                                                         | —                                                                                         | —                       | NID attribute: child.familyName                                       |
| `child_date_of_birth`                   | —                                                                         | —                                                                                         | Cannot be a future date | —                                                                     |
| `child_reason_for_delayed_registration` | SHOW IF days\_since(child\_date\_of\_birth) > 365                         | —                                                                                         | —                       | Shown automatically when birth is over 365 days ago. Birth-spec A2.6. |
| `child_sex`                             | —                                                                         | —                                                                                         | —                       | NID attribute: child.gender                                           |
| `child_place_of_birth`                  | —                                                                         | IF role = hospital-official OR role = embassy-officer: only Health Institution selectable | —                       | Hospital-clerk and embassy-officer restricted to Health Institution.  |
| `child_health_institution`              | SHOW IF child\_place\_of\_birth = Health Institution                      | IF role = hospital-official THEN user.assignedFacility                                    | —                       | Facility picker. Pre-populated for hospital-official.                 |
| `child_birth_address_country`           | SHOW IF child\_place\_of\_birth IN (Residential address \| Other address) | Farajaland                                                                                | —                       | Defaults to Farajaland.                                               |
| `child_birth_address_province`          | SHOW IF child\_place\_of\_birth IN (Residential address \| Other address) | —                                                                                         | —                       | —                                                                     |
| `child_birth_address_district`          | SHOW IF child\_place\_of\_birth IN (Residential address \| Other address) | —                                                                                         | —                       | —                                                                     |
| `child_birth_address_village`           | SHOW IF child\_place\_of\_birth IN (Residential address \| Other address) | —                                                                                         | —                       | —                                                                     |
| `child_birth_address_street`            | SHOW IF child\_place\_of\_birth IN (Residential address \| Other address) | —                                                                                         | —                       | —                                                                     |
| `child_attendant_at_birth`              | —                                                                         | —                                                                                         | —                       | —                                                                     |
| `child_type_of_birth`                   | —                                                                         | —                                                                                         | —                       | —                                                                     |
| `child_weight_at_birth`                 | —                                                                         | —                                                                                         | 0–6 kg                  | Unit: kg.                                                             |

**Open questions**

> **BFF-3** Should Residential address and Other address options be hidden or only disabled for hospital-official and embassy-officer roles? (BS-22). Owner: Country team. Status: Open.

***

#### Page 3 — Mother's details

**Field definitions**

| field\_id                           | type        | label                        | hint | options / component                 | mandatory | analytics | secured |
| ----------------------------------- | ----------- | ---------------------------- | ---- | ----------------------------------- | --------- | --------- | ------- |
| `mother_details_unavailable`        | `CHECKBOX`  | Mother's details unavailable | —    | —                                   | FALSE     | TRUE      | FALSE   |
| `mother_details_unavailable_reason` | `TEXT`      | Reason                       | —    | —                                   | TRUE      | TRUE      | FALSE   |
| `mother_nationality`                | `SELECT`    | Nationality                  | —    | (country list — Farajaland default) | TRUE      | TRUE      | FALSE   |
| `mother_id_type`                    | `SELECT`    | Form of ID                   | —    | National ID \| Passport \| No ID    | TRUE      | FALSE     | FALSE   |
| `mother_id_reader`                  | `ID_READER` | ID Reader                    | —    | —                                   | FALSE     | FALSE     | FALSE   |
| `mother_national_id_number`         | `ID`        | National ID no.              | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `mother_passport_number`            | `ID`        | Passport no.                 | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `mother_firstname`                  | `NAME`      | First name(s)                | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `mother_lastname`                   | `NAME`      | Last name                    | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `mother_date_of_birth`              | `DATE`      | Date of birth                | —    | —                                   | TRUE      | TRUE      | FALSE   |
| `mother_address_country`            | `ADDRESS`   | Address — Country            | —    | country                             | TRUE      | TRUE      | FALSE   |
| `mother_address_province`           | `ADDRESS`   | Address — Province           | —    | province                            | TRUE      | TRUE      | FALSE   |
| `mother_address_district`           | `ADDRESS`   | Address — District           | —    | district                            | TRUE      | TRUE      | FALSE   |
| `mother_address_village`            | `ADDRESS`   | Address — Village            | —    | village                             | TRUE      | TRUE      | FALSE   |
| `mother_address_street`             | `ADDRESS`   | Address — Street             | —    | street                              | FALSE     | FALSE     | FALSE   |
| `mother_number_of_previous_births`  | `NUMBER`    | No. of previous births       | —    | —                                   | FALSE     | TRUE      | FALSE   |

**Field behaviour**

| field\_id                           | display\_condition                                                                                            | pre\_population   | validation | notes                                                                                                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------- | ---------- | -------------------------------------------------------------------------------------------------------------- |
| `mother_details_unavailable`        | HIDE IF role = hospital-official                                                                              | —                 | —          | When checked: hides all other mother fields and shows reason. Birth-spec A2.5.                                 |
| `mother_details_unavailable_reason` | SHOW IF mother\_details\_unavailable = TRUE                                                                   | —                 | —          | —                                                                                                              |
| `mother_nationality`                | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                              |
| `mother_id_type`                    | HIDE IF role = hospital-official                                                                              | —                 | —          | Controller: drives visibility of mother\_id\_reader and downstream ID fields.                                  |
| `mother_id_reader`                  | HIDE IF role = hospital-official; SHOW IF mother\_id\_type = National ID AND mother\_nationality = Farajaland | eSignet / QR scan | —          | eSignet widget. No role condition needed beyond controller — mother\_id\_type is hidden for hospital-official. |
| `mother_national_id_number`         | HIDE IF role = hospital-official; SHOW IF mother\_id\_type = National ID AND mother\_nationality = Farajaland | —                 | —          | —                                                                                                              |
| `mother_passport_number`            | SHOW IF mother\_id\_type = Passport                                                                           | —                 | —          | —                                                                                                              |
| `mother_firstname`                  | —                                                                                                             | —                 | —          | NID attribute: mother.firstName                                                                                |
| `mother_lastname`                   | —                                                                                                             | —                 | —          | NID attribute: mother.familyName                                                                               |
| `mother_date_of_birth`              | —                                                                                                             | —                 | —          | NID attribute: mother.dateOfBirth                                                                              |
| `mother_address_country`            | HIDE IF role = hospital-official                                                                              | Farajaland        | —          | Defaults to Farajaland.                                                                                        |
| `mother_address_province`           | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                              |
| `mother_address_district`           | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                              |
| `mother_address_village`            | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                              |
| `mother_address_street`             | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                              |
| `mother_number_of_previous_births`  | —                                                                                                             | —                 | —          | Optional — analytics capture only.                                                                             |

**Open questions**

> **BFF-4** mother\_details\_unavailable IS hidden for hospital-official but father\_details\_unavailable is NOT. Confirm whether this asymmetry is intentional. (BS-22). Owner: Country team. Status: Open.

***

#### Page 4 — Father's details

**Field definitions**

| field\_id                           | type        | label                        | hint | options / component                 | mandatory | analytics | secured |
| ----------------------------------- | ----------- | ---------------------------- | ---- | ----------------------------------- | --------- | --------- | ------- |
| `father_details_unavailable`        | `CHECKBOX`  | Father's details unavailable | —    | —                                   | FALSE     | TRUE      | FALSE   |
| `father_details_unavailable_reason` | `TEXT`      | Reason                       | —    | —                                   | TRUE      | TRUE      | FALSE   |
| `father_nationality`                | `SELECT`    | Nationality                  | —    | (country list — Farajaland default) | TRUE      | TRUE      | FALSE   |
| `father_id_type`                    | `SELECT`    | Form of ID                   | —    | National ID \| Passport \| No ID    | TRUE      | FALSE     | FALSE   |
| `father_id_reader`                  | `ID_READER` | ID Reader                    | —    | —                                   | FALSE     | FALSE     | FALSE   |
| `father_national_id_number`         | `ID`        | National ID no.              | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `father_passport_number`            | `ID`        | Passport no.                 | —    | —                                   | FALSE     | FALSE     | FALSE   |
| `father_firstname`                  | `NAME`      | First name(s)                | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `father_lastname`                   | `NAME`      | Last name                    | —    | —                                   | TRUE      | FALSE     | FALSE   |
| `father_date_of_birth`              | `DATE`      | Date of birth                | —    | —                                   | TRUE      | TRUE      | FALSE   |
| `father_address_same_as_mother`     | `CHECKBOX`  | Same as mother's address     | —    | —                                   | FALSE     | FALSE     | FALSE   |
| `father_address_country`            | `ADDRESS`   | Address — Country            | —    | country                             | TRUE      | TRUE      | FALSE   |
| `father_address_province`           | `ADDRESS`   | Address — Province           | —    | province                            | TRUE      | TRUE      | FALSE   |
| `father_address_district`           | `ADDRESS`   | Address — District           | —    | district                            | TRUE      | TRUE      | FALSE   |
| `father_address_village`            | `ADDRESS`   | Address — Village            | —    | village                             | TRUE      | TRUE      | FALSE   |
| `father_address_street`             | `ADDRESS`   | Address — Street             | —    | street                              | FALSE     | FALSE     | FALSE   |

**Field behaviour**

| field\_id                           | display\_condition                                                                                            | pre\_population   | validation | notes                                                                                                  |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------- | ---------- | ------------------------------------------------------------------------------------------------------ |
| `father_details_unavailable`        | —                                                                                                             | —                 | —          | Source CSV: NOT hidden for hospital-official (unlike mother\_details\_unavailable). Flagged asymmetry. |
| `father_details_unavailable_reason` | SHOW IF father\_details\_unavailable = TRUE                                                                   | —                 | —          | —                                                                                                      |
| `father_nationality`                | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                      |
| `father_id_type`                    | HIDE IF role = hospital-official                                                                              | —                 | —          | Controller: drives ID field visibility.                                                                |
| `father_id_reader`                  | HIDE IF role = hospital-official; SHOW IF father\_id\_type = National ID AND father\_nationality = Farajaland | eSignet / QR scan | —          | eSignet widget.                                                                                        |
| `father_national_id_number`         | HIDE IF role = hospital-official; SHOW IF father\_id\_type = National ID AND father\_nationality = Farajaland | —                 | —          | —                                                                                                      |
| `father_passport_number`            | SHOW IF father\_id\_type = Passport                                                                           | —                 | —          | Source CSV: mandatory = FALSE — differs from informant and mother versions (mandatory = TRUE).         |
| `father_firstname`                  | —                                                                                                             | —                 | —          | NID attribute: father.firstName                                                                        |
| `father_lastname`                   | —                                                                                                             | —                 | —          | NID attribute: father.familyName                                                                       |
| `father_date_of_birth`              | —                                                                                                             | —                 | —          | NID attribute: father.dateOfBirth                                                                      |
| `father_address_same_as_mother`     | HIDE IF role = hospital-official                                                                              | —                 | —          | When checked: pre-populate father's address from mother's address.                                     |
| `father_address_country`            | HIDE IF role = hospital-official                                                                              | Farajaland        | —          | Defaults to Farajaland.                                                                                |
| `father_address_province`           | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                      |
| `father_address_district`           | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                      |
| `father_address_village`            | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                      |
| `father_address_street`             | HIDE IF role = hospital-official                                                                              | —                 | —          | —                                                                                                      |

**Open questions**

> **BFF-5** Father's passport number is optional (mandatory = FALSE) but informant and mother versions are mandatory. Confirm whether intentionally optional. (BS-22). Owner: Country team. Status: Open.

> **BFF-6** Should father\_details\_unavailable also be hidden for hospital-official, for consistency with mother section? (BS-22). Owner: Country team. Status: Open.

***

#### Page 5 — Supporting documents

**Field definitions**

| field\_id                                    | type                | label                            | hint | options / component     | mandatory | analytics | secured |
| -------------------------------------------- | ------------------- | -------------------------------- | ---- | ----------------------- | --------- | --------- | ------- |
| `documents_proof_of_birth`                   | `FILE`              | Proof of birth                   | —    | —                       | TRUE      | TRUE      | FALSE   |
| `documents_proof_of_mother_id`               | `FILE_WITH_OPTIONS` | Proof of mother's ID             | —    | National ID \| Passport | FALSE     | TRUE      | FALSE   |
| `documents_proof_of_father_id`               | `FILE_WITH_OPTIONS` | Proof of father's ID             | —    | National ID \| Passport | FALSE     | TRUE      | FALSE   |
| `documents_proof_of_informant_id`            | `FILE_WITH_OPTIONS` | Proof of informant's ID          | —    | National ID \| Passport | FALSE     | TRUE      | FALSE   |
| `documents_proof_of_assigned_responsibility` | `FILE`              | Proof of assigned responsibility | —    | —                       | TRUE      | TRUE      | FALSE   |
| `documents_acquired_child_court_document`    | `FILE`              | Acquired child court document    | —    | —                       | TRUE      | TRUE      | FALSE   |

**Field behaviour**

| field\_id                                    | display\_condition                                                                                                                                                                                           | pre\_population | validation | notes                                             |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- | ---------- | ------------------------------------------------- |
| `documents_proof_of_birth`                   | HIDE IF role = hospital-official                                                                                                                                                                             | —               | —          | Entire Page 5 hidden for hospital-official.       |
| `documents_proof_of_mother_id`               | HIDE IF role = hospital-official; HIDE IF mother\_id\_type = No ID; HIDE IF eSignet\_verification\_state IN (pending-verification \| id-authenticated)                                                       | —               | —          | Upload type matches mother's selected ID form.    |
| `documents_proof_of_father_id`               | HIDE IF role = hospital-official; HIDE IF father\_id\_type = No ID; HIDE IF eSignet\_verification\_state IN (pending-verification \| id-authenticated)                                                       | —               | —          | Same eSignet state condition as mother's ID.      |
| `documents_proof_of_informant_id`            | HIDE IF role = hospital-official; SHOW IF informant\_type NOT IN (Mother \| Father); HIDE IF informant\_id\_type = No ID; HIDE IF eSignet\_verification\_state IN (pending-verification \| id-authenticated) | —               | —          | Shown when informant is not the mother or father. |
| `documents_proof_of_assigned_responsibility` | HIDE IF role = hospital-official; SHOW IF informant\_type = Legal Guardian                                                                                                                                   | —               | —          | —                                                 |
| `documents_acquired_child_court_document`    | HIDE IF role = hospital-official; SHOW IF informant\_type = Legal Guardian                                                                                                                                   | —               | —          | —                                                 |

**Open questions**

> **BFF-7** Confirm OpenCRVS flag or state names for eSignet pending-verification and id-authenticated states that control document upload visibility. (BS-22). Owner: Technical lead. Status: Open.

***

#### Page 6 — Review

**Field definitions**

| field\_id                          | type        | label                                        | hint | options / component | mandatory | analytics | secured |
| ---------------------------------- | ----------- | -------------------------------------------- | ---- | ------------------- | --------- | --------- | ------- |
| `review_print_certificate_advance` | `BUTTON`    | Print certificate in advance of registration | —    | —                   | FALSE     | FALSE     | FALSE   |
| `review_informant_signature`       | `SIGNATURE` | Informant signature                          | —    | Sign \| Upload      | TRUE      | FALSE     | FALSE   |

**Field behaviour**

| field\_id                          | display\_condition                                     | pre\_population | validation | notes                                                                                                              |
| ---------------------------------- | ------------------------------------------------------ | --------------- | ---------- | ------------------------------------------------------------------------------------------------------------------ |
| `review_print_certificate_advance` | SHOW IF role IN (local-registrar \| registrar-general) | —               | —          | Supports offline registration drive (birth-spec A4.4). Shown only when a Registrar/RG is creating the declaration. |
| `review_informant_signature`       | —                                                      | —               | —          | Required on all declarations. Does not need to be re-captured after edits (birth-spec A2.4).                       |

***

### Section 3 — Correction form

**Form ID:** `form:correction-birth`

#### Field definitions

| field\_id                          | type       | label                 | hint                                                              | options / component                                               | mandatory | analytics | secured |
| ---------------------------------- | ---------- | --------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------- | --------- | --------- | ------- |
| `correction_requester_id_verified` | `CHECKBOX` | ID verified           | —                                                                 | —                                                                 | TRUE      | FALSE     | FALSE   |
| `correction_reason`                | `SELECT`   | Reason for correction | —                                                                 | Clerical error \| Change in circumstances \| Court order \| Other | TRUE      | FALSE     | FALSE   |
| `correction_reason_other`          | `TEXT`     | Other reason          | Briefly describe the reason for the correction.                   | —                                                                 | FALSE     | FALSE     | FALSE   |
| `correction_supporting_doc`        | `FILE`     | Supporting document   | —                                                                 | —                                                                 | FALSE     | FALSE     | FALSE   |
| `correction_note`                  | `TEXT`     | Note to registrar     | Add any context that will help the registrar review this request. | —                                                                 | FALSE     | FALSE     | FALSE   |

#### Field behaviour

| field\_id                          | display\_condition                 | pre\_population | validation | notes                                                |
| ---------------------------------- | ---------------------------------- | --------------- | ---------- | ---------------------------------------------------- |
| `correction_requester_id_verified` | —                                  | —               | —          | Required confirmation before correction can proceed. |
| `correction_reason`                | —                                  | —               | —          | Options from birth-spec A8.2.                        |
| `correction_reason_other`          | SHOW IF correction\_reason = Other | —               | —          | —                                                    |
| `correction_supporting_doc`        | —                                  | —               | —          | —                                                    |
| `correction_note`                  | —                                  | —               | —          | Visible to the approving registrar.                  |

***

### Section 5.1 — Action confirmation — Approve late registration

**Form ID:** `form:action-confirmation-approve-late-registration`

#### Field definitions

| field\_id              | type   | label   | hint                                        | options / component | mandatory | analytics | secured |
| ---------------------- | ------ | ------- | ------------------------------------------- | ------------------- | --------- | --------- | ------- |
| `approve_late_comment` | `TEXT` | Comment | Provide any notes on the approval decision. | —                   | FALSE     | FALSE     | FALSE   |

#### Field behaviour

| field\_id              | display\_condition | pre\_population | validation | notes                  |
| ---------------------- | ------------------ | --------------- | ---------- | ---------------------- |
| `approve_late_comment` | —                  | —               | —          | Captured in audit log. |

***

### Section 5.2 — Action confirmation — Escalate

**Form ID:** `form:action-confirmation-escalate`

#### Field definitions

| field\_id         | type     | label                 | hint                              | options / component                                        | mandatory | analytics | secured |
| ----------------- | -------- | --------------------- | --------------------------------- | ---------------------------------------------------------- | --------- | --------- | ------- |
| `escalate_to`     | `SELECT` | Escalate to           | —                                 | Provincial Registrar \| Legal Officer \| Registrar General | TRUE      | FALSE     | FALSE   |
| `escalate_reason` | `TEXT`   | Reason for escalation | Describe the question or concern. | —                                                          | TRUE      | FALSE     | FALSE   |

#### Field behaviour

| field\_id         | display\_condition | pre\_population | validation | notes                                                            |
| ----------------- | ------------------ | --------------- | ---------- | ---------------------------------------------------------------- |
| `escalate_to`     | —                  | —               | —          | Drives branching flag effects in ESCALATE action postconditions. |
| `escalate_reason` | —                  | —               | —          | Visible to the escalation recipient.                             |

***

### Section 5.3 — Action confirmation — Respond to escalation

**Form ID:** `form:action-confirmation-respond-to-escalation`

#### Field definitions

| field\_id             | type   | label    | hint                               | options / component | mandatory | analytics | secured |
| --------------------- | ------ | -------- | ---------------------------------- | ------------------- | --------- | --------- | ------- |
| `escalation_response` | `TEXT` | Response | Provide your guidance or decision. | —                   | TRUE      | FALSE     | FALSE   |

#### Field behaviour

| field\_id             | display\_condition | pre\_population | validation | notes                                                  |
| --------------------- | ------------------ | --------------- | ---------- | ------------------------------------------------------ |
| `escalation_response` | —                  | —               | —          | Visible to the Registrar who initiated the escalation. |

***

### Section 5.4 — Action confirmation — Revoke registration

**Form ID:** `form:action-confirmation-revoke-registration`

#### Field definitions

| field\_id                | type     | label                    | hint                                                 | options / component                                                      | mandatory | analytics | secured |
| ------------------------ | -------- | ------------------------ | ---------------------------------------------------- | ------------------------------------------------------------------------ | --------- | --------- | ------- |
| `revoke_reason`          | `SELECT` | Reason for revocation    | —                                                    | Fraudulent registration \| Registration in error \| Court order \| Other | TRUE      | FALSE     | FALSE   |
| `revoke_reason_other`    | `TEXT`   | Other reason             | —                                                    | —                                                                        | FALSE     | FALSE     | FALSE   |
| `revoke_legal_reference` | `TEXT`   | Legal reference          | Provide the relevant legal reference or case number. | —                                                                        | FALSE     | FALSE     | FALSE   |
| `revoke_supporting_doc`  | `FILE`   | Supporting documentation | —                                                    | —                                                                        | FALSE     | FALSE     | FALSE   |

#### Field behaviour

| field\_id                | display\_condition             | pre\_population | validation | notes          |
| ------------------------ | ------------------------------ | --------------- | ---------- | -------------- |
| `revoke_reason`          | —                              | —               | —          | Birth-spec A9. |
| `revoke_reason_other`    | SHOW IF revoke\_reason = Other | —               | —          | —              |
| `revoke_legal_reference` | —                              | —               | —          | —              |
| `revoke_supporting_doc`  | —                              | —               | —          | —              |

***

### Section 5.5 — Action confirmation — Reinstate revoked registration

**Form ID:** `form:action-confirmation-reinstate-revoked-registration`

#### Field definitions

| field\_id          | type   | label                    | hint                                          | options / component | mandatory | analytics | secured |
| ------------------ | ------ | ------------------------ | --------------------------------------------- | ------------------- | --------- | --------- | ------- |
| `reinstate_reason` | `TEXT` | Reason for reinstatement | Explain why the revocation is being reversed. | —                   | TRUE      | FALSE     | FALSE   |

#### Field behaviour

| field\_id          | display\_condition | pre\_population | validation | notes            |
| ------------------ | ------------------ | --------------- | ---------- | ---------------- |
| `reinstate_reason` | —                  | —               | —          | Birth-spec A9.3. |

***

### NID attribute mapping

| field\_id              | NID attribute        | Trigger                                  | Notes                                                                                     |
| ---------------------- | -------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------- |
| `child_firstname`      | `child.firstName`    | REGISTER (creation); APPROVE\_CORRECTION | Corrections shared with NID — birth-spec A8.3                                             |
| `child_lastname`       | `child.familyName`   | REGISTER (creation); APPROVE\_CORRECTION | —                                                                                         |
| `child_date_of_birth`  | —                    | REGISTER (creation); APPROVE\_CORRECTION | Corrections to DOB require Provincial Registrar approval — A8.2                           |
| `child_sex`            | `child.gender`       | REGISTER (creation); APPROVE\_CORRECTION | —                                                                                         |
| `mother_firstname`     | `mother.firstName`   | REGISTER (creation)                      | —                                                                                         |
| `mother_lastname`      | `mother.familyName`  | REGISTER (creation)                      | —                                                                                         |
| `mother_date_of_birth` | `mother.dateOfBirth` | REGISTER (creation)                      | —                                                                                         |
| `father_firstname`     | `father.firstName`   | REGISTER (creation)                      | —                                                                                         |
| `father_lastname`      | `father.familyName`  | REGISTER (creation)                      | —                                                                                         |
| `father_date_of_birth` | `father.dateOfBirth` | REGISTER (creation)                      | —                                                                                         |
| `mother_nationality`   | —                    | UIN eligibility condition on REGISTER    | Not a direct attribute mapping — used to determine citizen parent for UIN creation. A4.3. |
| `father_nationality`   | —                    | UIN eligibility condition on REGISTER    | Same as above.                                                                            |
