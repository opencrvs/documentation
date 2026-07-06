# Use case inventory

### 1. Introduction

This page provides a comprehensive inventory of all use cases supported by OpenCRVS, organised by functional area. Each use case documents:

* **Actor:** Who performs the action (admin, user, system, citizen)
* **Use case:** What functionality is provided
* **Version:** When the feature was released (version number or "Backlog" for planned features)
* **Notes:** Additional context or implementation details

{% hint style="info" %}
**For Business Analysts and Systems Integrators:** Use this inventory to understand OpenCRVS capabilities, plan implementations, and map country-specific requirements to supported features.
{% endhint %}

***

### 2. Use case categories

<details>

<summary>1. Vital Events</summary>

| **Actor** | **Use Case**                             | **Version** | **Notes**                                                               |
| --------- | ---------------------------------------- | ----------- | ----------------------------------------------------------------------- |
| admin     | Configure Birth event                    | 1.7         | Registration of a live birth                                            |
| admin     | Configure Death event                    | 1.7         | Registration of a death                                                 |
| admin     | Configure Fetal death (Stillbirth) event | 1.7         | Registration of fetal deaths (stillbirths)                              |
| admin     | Configure Marriage event                 | 1.7         | Registration of a legally recognized union between two persons          |
| admin     | Configure Divorce event                  | 1.9         | Registration of legal dissolution of marriage                           |
| admin     | Configure Judicial separation event      | 1.9         | Registration of formal separation without divorce                       |
| admin     | Configure Adoption event                 | 1.9         | Registration of a legal adoption                                        |
| admin     | Configure Recognition of Paternity event | 1.9         | Registration of voluntary or legal recognition of paternity for a child |
| admin     | Configure Change of Name event           | 1.9         | Registration of legal change of name for a person                       |
| admin     | Configure Change of Sex event            | 1.9         | Registration of legal change of gender marker                           |
| admin     | Configure Legal guardianship event       | 1.9         | Registration of a new or reassigned guardian                            |
| admin     | Configure Annulment of Marriage event    | 1.9         | Registration of the annulment of a previously registered marriage       |
| admin     | Configure Foundling event                | 1.9         | Registration of an abandoned or unidentified child                      |
| admin     | Configure Legal Emancipation event       | 1.9         | Registration of legal emancipation of a minor                           |
| admin     | Configure Change of Civil Status event   | 1.9         | Registration of change/correction to civil status                       |



</details>

#### 2. Workflows

| **Actor** | **Use Case**                                                        | **Version** | **Notes**                                                                                                                                    |
| --------- | ------------------------------------------------------------------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| admin     | Configure birth event workflow                                      | 1.7         | Business rules achieved through managing user roles and their scopes                                                                         |
| admin     | Configure death event workflow                                      | 1.7         | Business rules achieved through managing user roles and their scopes                                                                         |
| admin     | Configure marriage event workflow                                   | 1.7         | Business rules achieved through managing user roles and their scopes                                                                         |
| admin     | Configure business process rules to register an event               | 2           | Support for conditional rules that trigger approvals, attestation based on event characteristics (e.g., late registration requires approval) |
| admin     | Configure business process rules to correct a registration          | 2           |                                                                                                                                              |
| admin     | Configure business process rules to print a certified copy          | 2           |                                                                                                                                              |
| admin     | Configure filtered lists of records (workqueues) for each user role | 1.9         |                                                                                                                                              |

#### 3. Forms

| **Actor** | **Use Case**                                             | **Version** | **Notes**                                                                                                      |
| --------- | -------------------------------------------------------- | ----------- | -------------------------------------------------------------------------------------------------------------- |
| admin     | Configure an Event Notification form                     | Backlog     | Optional form completed at health facilities as input into the registration process                            |
| admin     | Configure an Event Declaration form                      | 1.7         |                                                                                                                |
| admin     | Configure Edit Declaration forms                         | Backlog     |                                                                                                                |
| admin     | Configure Deduplication Review form                      | Backlog     |                                                                                                                |
| admin     | Configure Archive declaration form                       | 2           |                                                                                                                |
| admin     | Configure Reinstate declaration form                     | 2           |                                                                                                                |
| admin     | Configure Correction form                                | 1.9         |                                                                                                                |
| admin     | Configure Print Certified Copies form                    | 1.9         |                                                                                                                |
| admin     | Configure Bulk Certified Copies form                     | Backlog     |                                                                                                                |
| admin     | Configure Digitisation of legacy record form             | Backlog     |                                                                                                                |
| admin     | Configure Issue Certified Copy form                      | 1.9         |                                                                                                                |
| admin     | Configure Revocation form                                | Backlog     |                                                                                                                |
| admin     | Configure Protected Record form                          | Backlog     |                                                                                                                |
| admin     | Configure Search Collection form                         | Backlog     |                                                                                                                |
| admin     | Configure custom action forms                            | 1.10        | As custom actions are added (e.g., attestation, escalation), forms are configurable to capture further details |
| admin     | Configure form validation rules                          | 1.7         | Define logic and constraints in forms                                                                          |
| admin     | Configure override logic for validation rules            | Backlog     |                                                                                                                |
| admin     | Configure what form fields contain PII data              | 1.9         | PII data not included in VS Export                                                                             |
| admin     | Manage forms over time                                   | Backlog     | Forms are versioned so they can change over time. Required for digitisation of legacy records                  |
| admin     | Configure event certificate and certified copy templates | 1.7         | Create templates for printed certificates (multiple)                                                           |
| admin     | Configure payment receipt templates                      | Backlog     |                                                                                                                |

#### 4. Administrative Structure

| **Actor** | **Use Case**                                               | **Version** | **Notes**                                                                                  |
| --------- | ---------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------ |
| admin     | Configure administrative structure                         | 1.7         | Address structure in declaration form, performance data views, one-time only (for go-live) |
| admin     | Configure registration offices                             | 1.7         |                                                                                            |
| admin     | Configure health facilities                                | 1.7         | Reference data for the health facility dropdown in declaration form                        |
| admin     | Configure hierarchy of locations and users                 | 1.10        | Reflect national, provincial, municipal units                                              |
| admin     | Configure the type of location                             | 1.10        | e.g., registration office, health facility, court, embassy                                 |
| admin     | Configure versioning of administrative structure over time | Backlog     | Supports digitisation of legacy records                                                    |
| admin     | Manage administrative structure over time                  | 1.7         | Rename, add. Deactivate not supported                                                      |
| admin     | Manage health facilities over time                         | 1.7         | Rename, deactivate, add                                                                    |

#### 5. User Management

| **Actor** | **Use Case**                                                      | **Version** | **Notes**                                             |
| --------- | ----------------------------------------------------------------- | ----------- | ----------------------------------------------------- |
| admin     | Configure user roles and scopes                                   | 1.7         | Role based access control                             |
| admin     | Configure which user roles can manage users                       | 1.7         | Create, edit, deactivate                              |
| admin     | Configure which user roles can manage users in their jurisdiction | 1.7         |                                                       |
| admin     | Configure which user roles can create a digital signature         | 1.7         |                                                       |
| admin     | Configure user creation form                                      | Backlog     |                                                       |
| admin     | Configure role name to appear in audit logs                       | Backlog     | e.g., Registrar shown in logs for multiple role types |
| admin     | Update scopes of a user role type                                 | 1.7         | Add, remove scopes                                    |
| admin     | Deactivate a user role type                                       | Backlog     | Remove a role type while maintaining audit logs       |
| admin     | Create a new user                                                 | 1.7         |                                                       |
| admin     | Deactivate a user                                                 | 1.7         |                                                       |
| admin     | Bulk create users                                                 | 1.7         | Assign role and office                                |
| admin     | Bulk manage users                                                 | Backlog     |                                                       |
| admin     | Configure 2FA authentication method                               | Backlog     | Current supported: SMS or Email                       |
| admin     | Configure alternative login method                                | Backlog     |                                                       |
| admin     | Configure lockscreen / pin duration time                          | Backlog     |                                                       |
| user      | View organisation structure                                       | 1.7         |                                                       |
| user      | View assigned users to a location                                 | 1.7         |                                                       |
| user      | View list of all system users                                     | Backlog     |                                                       |
| user      | View user profile                                                 | 1.7         |                                                       |
| user      | View user audit history logs                                      | 1.7         |                                                       |
| user      | Search for a location                                             | Backlog     |                                                       |
| user      | Search for a user                                                 | Backlog     |                                                       |
| user      | Create a user                                                     | 1.7         | Assign a role and office                              |
| user      | Upload digital signature for a user                               | 1.7         |                                                       |
| user      | Complete new user onboarding                                      | 1.7         | Setting password and security questions               |
| user      | New user can authenticate with ID system                          | Backlog     |                                                       |
| user      | Resend onboarding invite                                          | 1.7         |                                                       |
| user      | Login                                                             | 1.7         |                                                       |
| user      | Get username reminder                                             | 1.7         |                                                       |
| user      | Reset password                                                    | 1.7         |                                                       |
| user      | Complete 2FA                                                      | 1.7         |                                                       |
| user      | Resend 2FA code                                                   | 1.7         |                                                       |
| user      | Create lockscreen PIN                                             | 1.7         |                                                       |
| user      | Enter lockscreen PIN                                              | 1.7         |                                                       |
| user      | Reset lockscreen PIN                                              | 1.7         |                                                       |
| user      | Edit a user's details                                             | 1.7         |                                                       |
| user      | Move user to a new location                                       | 1.7         |                                                       |
| user      | Assign user to another role type                                  | 1.7         |                                                       |
| user      | Reset user's password                                             | 1.7         |                                                       |
| user      | Deactivate a user                                                 | 1.7         |                                                       |
| user      | Reinstate a user                                                  | 1.7         |                                                       |
| user      | Mass send email to all users                                      | 1.7         |                                                       |
| user      | Mass send email to specific role types                            | Backlog     |                                                       |
| user      | Mass send email to users in a location                            | Backlog     |                                                       |
| user      | Change my full name                                               | Backlog     |                                                       |
| user      | Change system language                                            | 1.7         |                                                       |
| user      | Change my password                                                | 1.7         |                                                       |
| user      | Change my phone number                                            | 1.7         |                                                       |
| user      | Change my email                                                   | 1.7         |                                                       |
| user      | Change my profile image                                           | 1.7         |                                                       |
| user      | Create/replace my digital signature                               | Backlog     |                                                       |

#### 6. Create Notification

| **Actor** | **Use Case**                                           | **Version** | **Notes** |
| --------- | ------------------------------------------------------ | ----------- | --------- |
| admin     | Configure which user roles can notify an event         | Backlog     |           |
| user      | Notify vital event                                     | Backlog     |           |
| user      | Create event notifications offline                     | Backlog     |           |
| user      | Save a notification form                               | Backlog     |           |
| user      | Update a saved notification form                       | Backlog     |           |
| user      | Submit an event notification                           | Backlog     |           |
| system    | Process submitted notifications on connectivity        | Backlog     |           |
| system    | Submit notification from health facility (e.g., DHIS2) | Backlog     |           |

#### 7. Create Declaration

| **Actor** | **Use Case**                                                 | **Version** | **Notes**                                                      |
| --------- | ------------------------------------------------------------ | ----------- | -------------------------------------------------------------- |
| admin     | Configure which user roles can declare an event              | 1.7         |                                                                |
| admin     | Configure which user roles can submit declaration incomplete | 1.7         |                                                                |
| admin     | Configure tracking ID number logic                           | 1.7         |                                                                |
| user      | Create an event declaration                                  | 1.7         |                                                                |
| user      | Create declaration only in my jurisdiction                   | 2           |                                                                |
| user      | Create event declarations offline                            | 1.7         |                                                                |
| user      | Save a draft declaration                                     | 1.7         |                                                                |
| user      | Update a draft declaration                                   | 1.7         |                                                                |
| user      | Delete a draft declaration                                   | 1.7         |                                                                |
| user      | Create declaration from a notification                       | Backlog     | Currently notification is considered an incomplete declaration |
| user      | Populate form with user details                              | Backlog     | Name, Role, Location                                           |
| user      | Populate form from ID card QR code scan                      | 1.8         |                                                                |
| system    | Authenticate identity with ID system and populate form       | 1.8         |                                                                |
| user      | Link existing record to declaration                          | Backlog     | e.g., marriage record linked to divorce declaration            |
| user      | Upload supporting documents                                  | 1.7         |                                                                |
| user      | Capture electronic signature of individuals                  | 1.7         | e.g., informant, witnesses                                     |
| user      | Upload image of signatures                                   | 1.7         |                                                                |
| user      | Capture biometrics of individuals                            | Backlog     |                                                                |
| user      | Submit declaration for review                                | 1.7         |                                                                |
| user      | Submit declaration for review (incomplete)                   | 1.7         |                                                                |
| system    | Submit declaration from health facility (e.g., DHIS2)        | 1.7         |                                                                |
| system    | Validate form fields on data entry                           | 1.7         |                                                                |
| system    | Enforce completion of mandatory fields                       | 1.7         |                                                                |
| system    | Process submitted declarations on connectivity               | 1.7         |                                                                |
| system    | Generate a tracking ID                                       | 1.7         |                                                                |

#### 8. Review Declaration

| **Actor** | **Use Case**                                                | **Version** | **Notes**                                            |
| --------- | ----------------------------------------------------------- | ----------- | ---------------------------------------------------- |
| admin     | Configure which user roles can review declarations          | 1.7         |                                                      |
| admin     | Configure review permissions based on role and jurisdiction | 2           |                                                      |
| system    | Validate identity with ID system                            | 1.8         |                                                      |
| user      | Review declaration                                          | 1.7         | Declaration data viewed against supporting documents |
| user      | View business process status to register                    | 2           |                                                      |
| user      | Print declaration                                           | 1.7         |                                                      |
| user      | View ID system validation response                          | 1.8         | Valid / Invalid                                      |
| user      | View authentication status of individuals                   | 1.8         |                                                      |
| user      | Validate a declaration                                      | 1.7         |                                                      |
| user      | Request updates to a declaration                            | 1.7         |                                                      |
| user      | Escalate a declaration (Custom action)                      | 2           |                                                      |
| user      | Attest a declaration (Custom action)                        | 2           |                                                      |
| user      | Approve declaration (Custom action)                         | 2           |                                                      |
| user      | Give feedback on declaration (Custom action)                | 2           |                                                      |

#### 9. Edit Declaration

| **Actor** | **Use Case**                                              | **Version** | **Notes**                                                 |
| --------- | --------------------------------------------------------- | ----------- | --------------------------------------------------------- |
| admin     | Configure which user roles can edit a declaration         | 1.7         | For declarations submitted for review/approval            |
| admin     | Configure which declarations a user can edit              | 2           | For records that were submitted, rejected, requiring edit |
| admin     | Configure conditions for informant's signature after edit | 1.9         | Does informant need to resign after edit?                 |
| user      | Edit a declaration                                        | 1.7         |                                                           |

#### 10. Archive & Reinstate Declaration

| **Actor** | **Use Case**                                                     | **Version** | **Notes**                      |
| --------- | ---------------------------------------------------------------- | ----------- | ------------------------------ |
| admin     | Configure which user roles can archive a declaration             | 1.7         |                                |
| admin     | Configure which user roles can reinstate an archived declaration | 1.7         |                                |
| user      | Archive a declaration                                            | 1.7         | Sets record status to Archived |
| user      | Reinstate an archived declaration                                | 1.7         | Sets record status to Declared |

#### 11. Deduplication

| **Actor** | **Use Case**                                               | **Version** | **Notes**                                |
| --------- | ---------------------------------------------------------- | ----------- | ---------------------------------------- |
| admin     | Configure which user roles can review potential duplicates | 1.7         |                                          |
| admin     | Configure logic for flagging potential duplicates          | 1.9         |                                          |
| system    | Real-time detection of potential duplicates                | 1.7         | Rules are hard-coded for birth and death |
| user      | Review a potential duplicate declaration                   | 1.7         |                                          |
| user      | Mark a flagged declaration as not a duplicate              | 1.7         |                                          |
| user      | Mark a flagged declaration as a duplicate                  | 1.7         |                                          |

#### 12. Registration

| **Actor** | **Use Case**                                             | **Version** | **Notes**                                  |
| --------- | -------------------------------------------------------- | ----------- | ------------------------------------------ |
| admin     | Configure which user roles can register an event         | 1.7         |                                            |
| admin     | Configure registration permissions based on jurisdiction | 2           | Based on event location, declared location |
| admin     | Configure registration number generation logic           | 1.7         |                                            |
| admin     | Configure UIN creation / deactivation business logic     | 1.8         | Creation (birth) / deactivate (death)      |
| user      | Register an event                                        | 1.7         |                                            |
| user      | Register, print and issue certified copy offline         | 1.9         |                                            |
| system    | Generate registration number                             | 1.7         |                                            |
| system    | Generate application ID to track UIN                     | 1.8         |                                            |
| system    | Request a UIN from the ID system                         | 1.8         |                                            |
| system    | Request deactivation of UIN from ID system               | 1.8         |                                            |

#### 13. Search

| **Actor** | **Use Case**                                       | **Version** | **Notes**                                                     |
| --------- | -------------------------------------------------- | ----------- | ------------------------------------------------------------- |
| admin     | Configure which user roles can search for records  | 1.7         |                                                               |
| admin     | Configure search permissions based on jurisdiction | 2           | Based on event, declared, or registered location              |
| admin     | Configure fields for basic search                  | 1.9         | e.g., tracking ID, phone, registration number                 |
| admin     | Configure fields for advanced search               | 1.9         |                                                               |
| admin     | Configure which user roles can use advanced search | Backlog     |                                                               |
| user      | Search for a record using basic search             | 1.7         |                                                               |
| user      | Search for a record using advanced search          | 1.7         |                                                               |
| user      | View search results                                | 1.7         |                                                               |
| user      | Save an advanced search query                      | 1.7         | Not prioritised for 1.9. Configurable workqueues used instead |

#### 14. Certificates & Certified Copies

| **Actor** | **Use Case**                                             | **Version** | **Notes**                                                |
| --------- | -------------------------------------------------------- | ----------- | -------------------------------------------------------- |
| admin     | Configure which roles can print and issue certified copy | 1.7         |                                                          |
| admin     | Configure which roles can print certified copy           | 2           |                                                          |
| admin     | Configure which roles can issue certified copy           | 2           |                                                          |
| admin     | Configure business rules for printing and issuing        | 1.9         |                                                          |
| admin     | Configure business rules for printing in advance         | Backlog     |                                                          |
| admin     | Configure electronic signatures on certified copy        | 1.7         |                                                          |
| user      | Preview certified copy before printing                   | 1.7         |                                                          |
| user      | Print and issue a certified copy                         | 1.7         |                                                          |
| user      | Print certified copy in advance of issuance              | 1.7         |                                                          |
| user      | Issue certified copy                                     | 1.7         |                                                          |
| user      | Reissue certificate after correction                     | 1.9         |                                                          |
| user      | Reissue certificate after loss or damage                 | 1.9         |                                                          |
| user      | Print and reissue "original" certificate                 | Backlog     | Based on earlier template                                |
| user      | Issue multi-language certificate                         | 1.7         | Label data only                                          |
| user      | Validate requester's ID                                  | 1.7         |                                                          |
| system    | Authenticate requester identity and populate form        | Backlog     |                                                          |
| user      | View certificate issuance history                        | Backlog     | Track all issued versions and reprints                   |
| user      | Legalize a certified copy                                | Backlog     | Apply special seals for international use                |
| user      | Bulk print certified copies                              | Backlog     |                                                          |
| user      | Verify a certified copy                                  | 1.7         | QR code links to partial record view (deprecated in 1.9) |
| system    | Third party verification of certificate authenticity     | Backlog     | Enable non-system users to verify certificates           |
| system    | Create a verifiable credential                           | Backlog     |                                                          |
| system    | Issue a digital verifiable credential                    | Backlog     | QR code / digital wallet                                 |
| system    | Verify a verifiable credential (relying party)           | Backlog     |                                                          |

#### 15. Correct Registrations

| **Actor** | **Use Case**                                           | **Version** | **Notes**                                       |
| --------- | ------------------------------------------------------ | ----------- | ----------------------------------------------- |
| admin     | Configure who can request correction                   | 1.7         |                                                 |
| admin     | Configure who can review correction request            | 1.7         |                                                 |
| admin     | Configure who can correct a record                     | 1.7         |                                                 |
| admin     | Configure correction permissions based on jurisdiction | 2           |                                                 |
| admin     | Configure correction summary display                   | 1.9         |                                                 |
| user      | Correct a vital event registration                     | 1.7         | Registrar/supervisor directly corrects          |
| user      | Request correction to vital event registration         | 1.7         | Citizen submits correction request              |
| system    | Authenticate requester identity and populate form      | Backlog     |                                                 |
| user      | View business process status to correct                | 2           |                                                 |
| user      | Review a correction request                            | 1.7         | Registrar/supervisor evaluates and approves     |
| user      | Change name                                            | Backlog     | Changes name on birth record (not a correction) |
| user      | Change sex/gender marker                               | Backlog     | Changes sex on birth record (not a correction)  |
| user      | Record legal adoption on original birth record         | 2           |                                                 |
| user      | Record legal separation/divorce on marriage record     | 2           |                                                 |
| user      | Add/remove declaration supporting documents            | Backlog     | Edit documents after registration               |
| system    | Send corrected biographic data to ID system            | Backlog     |                                                 |

#### 16. Revoke & Reinstate Registration

| **Actor** | **Use Case**                                      | **Version** | **Notes**       |
| --------- | ------------------------------------------------- | ----------- | --------------- |
| admin     | Configure permissions to request revoke/reinstate | Backlog     |                 |
| admin     | Configure permissions to review revoke/reinstate  | Backlog     |                 |
| admin     | Configure permissions to revoke/reinstate         | Backlog     |                 |
| admin     | Configure UIN revoke/reinstate logic              | Backlog     |                 |
| user      | Request revocation of vital event registration    | Backlog     |                 |
| user      | Request reinstatement of vital event registration | Backlog     |                 |
| system    | Authenticate requester identity and populate form | Backlog     |                 |
| user      | Review revocation request                         | Backlog     | Approve, Reject |
| user      | Review reinstatement request                      | Backlog     |                 |
| user      | Revoke a vital event registration                 | Backlog     |                 |
| user      | Reinstate a vital event registration              | Backlog     |                 |
| system    | Request revocation of UIN (birth) in ID system    | Backlog     |                 |
| system    | Request reinstatement of UIN (death) in ID system | Backlog     |                 |

#### 17. Record Audit

| **Actor** | **Use Case**                                       | **Version** | **Notes**                                  |
| --------- | -------------------------------------------------- | ----------- | ------------------------------------------ |
| admin     | Configure which users can view a record            | 1.7         |                                            |
| admin     | Configure record permissions based on jurisdiction | 2           |                                            |
| admin     | Configure record summary display                   | 1.9         |                                            |
| user      | View record summary                                | 1.7         |                                            |
| user      | View audit history logs                            | 1.7         |                                            |
| user      | View record                                        | 1.7         |                                            |
| user      | View previous record versions                      | Backlog     | Prior corrections and original declaration |
| user      | View outstanding requests on record                | Backlog     | Approvals, corrections, revocations        |
| user      | View all supporting documents                      | Backlog     | Uploaded as part of various actions        |
| user      | Add comment                                        | Backlog     |                                            |
| user      | View comments                                      | Backlog     |                                            |
| user      | View linked vital event records                    | Backlog     |                                            |
| system    | Log all system actions on records                  | 1.7         |                                            |
| system    | Automatically flag suspected fraudulent activity   | Backlog     |                                            |

#### 18. Performance Management

| **Actor** | **Use Case**                                      | **Version** | **Notes**                                  |
| --------- | ------------------------------------------------- | ----------- | ------------------------------------------ |
| admin     | Configure who can view performance reports        | 1.7         |                                            |
| admin     | Configure who can export vital statistics         | 1.7         |                                            |
| admin     | Configure performance data access by jurisdiction | 2           |                                            |
| admin     | Configure vital statistics export by jurisdiction | 2           |                                            |
| admin     | Customize data visualisations                     | 1.7         | Metabase only                              |
| admin     | Configure data for external visualisation tool    | 1.9         |                                            |
| admin     | Configure performance management report           | 1.9         |                                            |
| admin     | Manage statistical data                           | 1.7         | e.g., population, crude birth/death rates  |
| user      | View data visualisations                          | 1.7         | Metabase only                              |
| user      | Monitor registration completeness                 | 1.7         | Across time and geography                  |
| user      | Monitor certification rates                       | 1.7         | Across time and geography                  |
| user      | Monitor data quality                              | Backlog     | Across time and geography                  |
| user      | Monitor corrections                               | 1.7         | Across time and geography                  |
| user      | Monitor collection of fees                        | 1.7         | Across time and geography                  |
| user      | Monitor service timeliness                        | 1.7         | Time between notification and registration |
| user      | Monitor user productivity metrics                 | 1.7         | Outputs by registrar or office             |
| user      | Export vital statistics to CSV                    | 1.7         | Monthly reports                            |
| user      | Generate reports                                  | Backlog     | Based on registered events                 |

#### 19. Payments

| **Actor** | **Use Case**                                         | **Version** | **Notes**                           |
| --------- | ---------------------------------------------------- | ----------- | ----------------------------------- |
| admin     | Configure fees for certificates and certified copies | 1.7         |                                     |
| admin     | Configure fees for corrections                       | 1.7         |                                     |
| admin     | Configure fees for registrations                     | 1.7         | Can be done within declaration form |
| user      | Collect confirmation that payment has been collected | 1.7         |                                     |
| user      | Enter receipt number for manual payment              | 1.9         |                                     |
| user      | Initiate payment collection to citizen               | Backlog     |                                     |
| user      | Print payment receipt                                | Backlog     |                                     |
| citizen   | Pay for service using payment integration            | Backlog     |                                     |

#### 20. Protected Records

| **Actor** | **Use Case**                                          | **Version** | **Notes**       |
| --------- | ----------------------------------------------------- | ----------- | --------------- |
| admin     | Configure permissions to request protection status    | Backlog     |                 |
| admin     | Configure permissions to review protection request    | Backlog     |                 |
| admin     | Configure permissions to add/remove protection status | Backlog     |                 |
| admin     | Configure who can search for protected record         | Backlog     |                 |
| admin     | Configure if record is hidden from search             | Backlog     |                 |
| admin     | Configure what data is hidden if protected            | Backlog     |                 |
| user      | Request adding protected status to registration       | Backlog     |                 |
| user      | Review request to add protected status                | Backlog     | Approve, Reject |
| user      | Add protected status to registration                  | Backlog     |                 |
| user      | Request removing protected status                     | Backlog     |                 |
| user      | Review request to remove protected status             | Backlog     | Approve, Reject |
| user      | Remove protected status from registration             | Backlog     |                 |

#### 21. Person Centricity

| **Actor** | **Use Case**                                        | **Version** | **Notes**                                        |
| --------- | --------------------------------------------------- | ----------- | ------------------------------------------------ |
| system    | Link all event records to person unique identifier  | Backlog     |                                                  |
| system    | Link event records by role                          | Backlog     | Informant, child, parent, deceased, spouse, etc. |
| user      | View summary of individual's latest biographic info | Backlog     |                                                  |
| user      | View vital event registrations linked to individual | Backlog     |                                                  |
| user      | Declare vital event from individual's overview      | Backlog     |                                                  |
| user      | Link existing event record to individual            | Backlog     |                                                  |
| user      | Search for an individual                            | Backlog     |                                                  |

#### 22. Digitise Legacy Records

| **Actor** | **Use Case**                                              | **Version** | **Notes** |
| --------- | --------------------------------------------------------- | ----------- | --------- |
| admin     | Configure which roles can digitise legacy record          | Backlog     |           |
| admin     | Configure which roles can approve digitised legacy record | Backlog     |           |
| user      | Create a digitised legacy record                          | Backlog     |           |
| user      | Approve a digitised legacy record                         | Backlog     |           |
| user      | Reject a digitised legacy record                          | Backlog     |           |

#### 23. Informant Notifications

| **Actor** | **Use Case**                                          | **Version** | **Notes** |
| --------- | ----------------------------------------------------- | ----------- | --------- |
| admin     | Configure actions that trigger informant notification | 1.7         |           |
| admin     | Configure email as notification method                | 1.7         |           |
| admin     | Configure SMS as notification method                  | 1.7         |           |
| admin     | Configure WhatsApp as notification method             | Backlog     |           |
| admin     | Configure Facebook Messenger as notification method   | Backlog     |           |
| citizen   | Receive declaration submitted incomplete notification | 1.7         |           |
| citizen   | Receive declaration submitted for review notification | 1.7         |           |
| citizen   | Receive declaration rejected notification             | 1.7         |           |
| citizen   | Receive registration confirmation notification        | 1.7         |           |
| citizen   | Receive notifications based on custom actions         | Backlog     |           |

#### 24. User Notifications

| **Actor** | **Use Case**                                   | **Version** | **Notes** |
| --------- | ---------------------------------------------- | ----------- | --------- |
| admin     | Configure email as notification method         | 1.7         |           |
| admin     | Configure SMS as notification method           | 1.7         |           |
| user      | Receive onboarding notification                | 1.7         |           |
| user      | Receive 2FA notification                       | 1.7         |           |
| user      | Receive password reset notification            | 1.7         |           |
| user      | Receive username reminder notification         | 1.7         |           |
| user      | Receive username updated notification          | 1.7         |           |
| user      | Receive change phone number confirmation       | 1.7         |           |
| user      | Receive mandatory password change notification | 1.7         |           |
| user      | Receive notification from system admin         | 1.7         | All users |

#### 25. Customisation

| **Actor** | **Use Case**                                      | **Version** | **Notes**                              |
| --------- | ------------------------------------------------- | ----------- | -------------------------------------- |
| admin     | Configure system languages                        | 1.7         |                                        |
| admin     | Configure application name                        | 1.7         |                                        |
| admin     | Configure logo                                    | 1.7         |                                        |
| admin     | Configure login background (image or colour)      | 1.7         |                                        |
| admin     | Configure currency                                | 1.7         |                                        |
| admin     | Configure administrative time periods             | 1.7         | On time, late and delayed registration |
| admin     | Configure date format                             | Backlog     |                                        |
| admin     | Configure name format                             | Backlog     |                                        |
| admin     | Configure custom application styling (Custom CSS) | Backlog     |                                        |
| admin     | Configure Right to Left text                      | Backlog     |                                        |

#### 26. Legacy Data Import

| **Actor** | **Use Case**                                   | **Version** | **Notes**                                            |
| --------- | ---------------------------------------------- | ----------- | ---------------------------------------------------- |
| admin     | Import birth and death records using APIs      | 1.7         |                                                      |
| admin     | Import any civil registration event using APIs | Backlog     | Associate with legacy event form. Enables correction |
| user      | Search based on legacy registration number     | Backlog     |                                                      |
| system    | Run deduplication check on legacy records      | Backlog     |                                                      |
| user      | Review potential duplicates of legacy records  | Backlog     |                                                      |
|           |                                                |             |                                                      |

MOSIP — Specific list of mosip use cases define here

Citizen → Authenticate themselves via e-sginet Citizen → …

system → submit birth to mosip for uin generation system → submit biographics updates to MOSIP

#### 27. Integration & Platform APIs (System-to-System)

| **Actor**                            | **Use Case**                                               | **Version** | **Notes**                                     |
| ------------------------------------ | ---------------------------------------------------------- | ----------- | --------------------------------------------- |
| **Integration Management**           |                                                            |             |                                               |
| admin                                | Create and manage system integration clients               |             |                                               |
| **Authentication & Security**        |                                                            |             |                                               |
| system                               | Authenticate system users via single sign-on (SSO)         |             |                                               |
| system                               | Authorise external systems to access CRS APIs              |             |                                               |
| system                               | Authenticate individuals against National ID system        |             |                                               |
| **Outbound Event & Data Sharing**    |                                                            |             |                                               |
| system                               | Publish registered event records                           |             |                                               |
| system                               | Publish corrections to registered records                  |             |                                               |
| system                               | Publish revocations or reinstatements                      |             |                                               |
| system                               | Share registrations (birth & death) with ID system (MOSIP) |             |                                               |
| system                               | Share corrections (birth & death) with ID system (MOSIP)   |             |                                               |
| system                               | Share revocations (birth & death) with ID system (MOSIP)   |             |                                               |
| **Inbound Requests & Data Exchange** |                                                            |             |                                               |
| system                               | Receive event notifications, declarations, registrations   |             |                                               |
| system                               | Receive request to edit notification or declaration        |             |                                               |
| system                               | Receive request to archive notification or declaration     |             |                                               |
| system                               | Receive request to correct registration                    |             |                                               |
| system                               | Receive request to revoke or reinstate record              |             |                                               |
| system                               | Receive requests to trigger custom workflow action         |             |                                               |
| system                               | Receive record search requests                             |             |                                               |
| system                               | Receive location and reference data requests               |             |                                               |
| **Payments & Financial Integration** |                                                            |             |                                               |
| system                               | Request payment initiation                                 |             |                                               |
| system                               | Receive payment confirmation or status updates             |             |                                               |
| system                               | Link payments to record workflow actions                   |             | e.g., registrations or issuing certified copy |

#### 28. Public Portal APIs (Citizen-Facing)

| **Actor**                          | **Use Case**                                                      | **Version** | **Notes**                                            |   |   |
| ---------------------------------- | ----------------------------------------------------------------- | ----------- | ---------------------------------------------------- | - | - |
| **Authentication & Profile**       |                                                                   |             |                                                      |   |   |
| citizen                            | Authenticate to access public portal                              |             |                                                      |   |   |
| citizen                            | Update personal profile information                               |             |                                                      |   |   |
| citizen                            | Manage notification subscription preferences                      |             |                                                      |   |   |
| **Event Notification**             |                                                                   |             |                                                      |   |   |
| citizen                            | Submit new civil event notification                               |             |                                                      |   |   |
| citizen                            | Edit existing civil event notification                            |             |                                                      |   |   |
| citizen                            | Archive (delete) civil event notification                         |             |                                                      |   |   |
| **Event Declaration**              |                                                                   |             |                                                      |   |   |
| citizen                            | Submit civil event declaration                                    |             |                                                      |   |   |
| citizen                            | Edit existing civil event declaration                             |             |                                                      |   |   |
| citizen                            | Archive (delete) civil event declaration                          |             |                                                      |   |   |
| **Record Access & Viewing**        |                                                                   |             |                                                      |   |   |
| citizen                            | View record status and flags                                      |             |                                                      |   |   |
| citizen                            | View own civil registration records                               |             |                                                      |   |   |
| citizen                            | Search and view civil registration records                        |             |                                                      |   |   |
| citizen                            | View supporting documents linked to record                        |             |                                                      |   |   |
| **Certified Copies**               |                                                                   |             |                                                      |   |   |
| citizen                            | Request certified copy (with template and language preference)    |             |                                                      |   |   |
| citizen                            | Download digitally signed certified copy (PDF)                    |             |                                                      |   |   |
| citizen                            | Request preview of draft certificate                              |             |                                                      |   |   |
| citizen                            | Approve or reject draft certificate preview (custom action)       |             |                                                      |   |   |
| **Corrections, Appeals & Actions** |                                                                   |             |                                                      |   |   |
| citizen                            | Request correction to registered civil record                     |             |                                                      |   |   |
| citizen                            | Request revocation to registered civil record                     |             |                                                      |   |   |
| citizen                            | Track status of a request                                         |             |                                                      |   |   |
| citizen                            | Submit appeal against civil registration decision (custom action) |             |                                                      |   |   |
| citizen                            | Track status of an appeal                                         |             |                                                      |   |   |
| **Notifications**                  |                                                                   |             |                                                      |   |   |
| citizen                            | Receive request confirmations via SMS or email                    |             | e.g., declaration received with tracking ID          |   |   |
| citizen                            | Receive status updates via SMS or email                           |             | e.g., declaration rejected                           |   |   |
| citizen                            | Receive confirmation of requests via SMS or email                 |             | e.g., registration approved with registration number |   |   |
| **Verifiable Credentials**         |                                                                   |             |                                                      |   |   |
| citizen                            | Request verifiable credential for civil registration record       |             |                                                      |   |   |
| citizen                            | Receive verifiable credential offer                               |             |                                                      |   |   |
| **Payments & Appointments**        |                                                                   |             |                                                      |   |   |
| citizen                            | Make payments for civil registration services                     |             |                                                      |   |   |
| citizen                            | View payment status and receipts                                  |             |                                                      |   |   |
| citizen                            | Request appointment for in-person services                        |             |                                                      |   |   |
| citizen                            | View or manage appointment bookings                               |             |                                                      |   |   |
