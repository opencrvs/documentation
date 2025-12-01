# User roles & scopes

OpenCRVS supports the creation of multiple custom users with specific permissions (scopes) to control what they can and cannot do in the system. This feature allows countries to define user roles and their corresponding scopes based on their specific needs.

### Key Features

**Unlimited user role configuration**: Administrators can create and configure any number of system user roles.

**Custom role naming**: Each user role can have a custom name (e.g., _Healthcare Worker, Mayor, Registrar_).

**Scope-based permissions**: The functionalities available to each user role can be controlled by assigning specific scopes

### User Role Scopes

The following are the key scope categories available for configuration:

| Scope                                    | Description                                                                                                                                                                                                                                                      |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| record.create                            | This scope adds a custom event as an option in the event declaration form select                                                                                                                                                                                 |
| record.notify                            | This scope allows a user to send incomplete declarations to an assinged office. Declarations have the status 'Notified'                                                                                                                                          |
| record.declare                           | This scope allows a user to send complete declarations to their assigned office. Declarations will have the status 'Declared'                                                                                                                                    |
| record.declared.validate                 | This scope allows a user to validate a declaration                                                                                                                                                                                                               |
| record.declared.reject                   | This scope allows a user to reject a declaration                                                                                                                                                                                                                 |
| record.declared.archive                  | This scope allows a user to archive a declaration. An archived declaration has the status 'Archived'                                                                                                                                                             |
| record.archived.reinstate                | This scope allows a user to reinstate an archived declaration. Declarations will revert to the previous status before it was archived                                                                                                                            |
| record.declared.edit                     | This scope allows a user to edit a declaration declared by another user                                                                                                                                                                                          |
| record.unassign-others                   | This scope is to allow a user to unassign another user who is current assigned to the record                                                                                                                                                                     |
| record.review-duplicates                 | This scope allows a user to review declarations that have been flagged as a potential duplicate                                                                                                                                                                  |
| record.register                          | This scope allows a user to register a record. Record will have the status 'Registered'                                                                                                                                                                          |
| record.registered.print-certified-copies | This scope allows a user to print a certified copy and issue                                                                                                                                                                                                     |
| record.registered.request-correction     | This scope allows a user to request a correction to a record                                                                                                                                                                                                     |
| record.registered.correct                | This scope allows a user to correct a record and review correction requests                                                                                                                                                                                      |
| record.read                              | This scopes allows a user to view a record data                                                                                                                                                                                                                  |
| search                                   | This scope allows a user to search for record and view summary information                                                                                                                                                                                       |
| workqueue                                | This scopes defines what workqueues they see                                                                                                                                                                                                                     |
| profile.electronic-signature             | This scopes allows a user to add and update their electronic signature                                                                                                                                                                                           |
| performance.read                         | This scope allows a user to view metabase peformance dashboards                                                                                                                                                                                                  |
| config.update:all                        | This scope allows the user access to configurations options                                                                                                                                                                                                      |
| organisation.read-locations              | <p>This scope allows a user to view the Organisation, My Team menu tabs and view all locations<br>:all  - view all office team pages<br>:my-jurisdiction - only view office teams pages in your jurisdiction<br>:my-office - only view your office team page</p> |
| user.create                              | <p>This scope allows a user to create a new user<br>- role - role typers the user can create<br>:all  - any user<br>:my-jurisdiction - only users in the users jurisdiction</p>                                                                                  |
| user.edit                                | <p>This scope defines what user roles you can edit<br>- role - role typers the user can create</p>                                                                                                                                                               |
| user.update                              | <p>This scopes defines what user a user can update<br>all  - any user<br>- :my-jurisdiction - only users in the users jurisdiction</p>                                                                                                                           |
| user.read                                | <p>This scope allows a user to view a user's profile<br>- :all - audit any user<br>- :my-office  - only audit users in their office<br>- :my-jurisdiction - only audit users in their jurisdiction<br>- :only-my-audit - user can only view their audit</p>      |

{% hint style="info" %}
**How to configure user roles & scopes?**\
Learn how to define and assign appropriate permissions to different user roles in your system. [3.2-mapping-offices-and-user-types.md](../../setup/2.-gather-requirements/3.2-mapping-offices-and-user-types.md "mention")
{% endhint %}

{% hint style="info" %}
**User roles & scopes in Farajaland?**\
Learn how we mapped user roles and scopes to support and improve service delivery in Farajaland [user-role-mapping.md](../../default-configuration/opencrvs-configuration-in-farajaland/user-role-mapping.md "mention")
{% endhint %}
