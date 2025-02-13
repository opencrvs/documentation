# User roles & scope

OpenCRVS supports the creation of multiple custom users with specific permissions (scopes) to control what they can and cannot do in the system. This feature allows countries to define user roles and their corresponding scopes based on their specific needs.

#### Key Features

• **Unlimited user role configuration**: Administrators can create and configure any number of system user roles.

• **Custom role naming**: Each user role can have a custom name (e.g., _Healthcare Worker, Mayor, Registrar_).

• **Scope-based permissions**: The functionalities available to each user role can be controlled by assigning specific scopes

### User Role Scopes

The following are the key scope categories available for configuration:

#### 1. Declare

• record.declare-birth – Allows a user to declare a birth.

• record.declare-death – Allows a user to declare a death.

• record.declare-marriage – Allows a user to declare a marriage.

• record.declaration-submit-incomplete – Allows a user to send incomplete declarations to an assigned office.

• record.declaration-submit-for-review – Allows a user to send complete declarations for review.

• record.declaration-submit-for-approval – Allows a user to send a declaration for approval.

#### 2. Validate

• record.declaration-submit-for-updates – Allows a user to send a declaration for updates (status: _Requires Updates_).

• record.declaration-archive – Allows a user to archive a declaration (status: _Archived_).

• record.declaration-reinstate – Allows a user to reinstate an archived declaration (reverting to the previous status).

• record.unassign-others – Allows a user to unassign another user currently assigned to the record.

#### 3. Register

• record.register – Allows a user to register a record.

#### 4. Certify

• record.registration-print\&issue-certified-copies – Allows a user to print and issue a certified copy.

#### 5. Correct

• record.registration-request-correction – Allows a user to request a correction to a record.

• record.registration-correct – Allows a user to correct a record and review correction requests.

#### 6. Performance

• performance.read – Allows a user to view performance reports.

• performance.read-dashboards – Allows a user to view Metabase performance dashboards.

• performance.vital-statistics-export – Allows a user to export vital statistics to CSV.

#### 7. Search

• search.birth – Allows a user to search for all birth records.

• search.death – Allows a user to search for all death records.

• search.marriage – Allows a user to search for all marriage records.

• search.birth:my-jurisdiction – Allows a user to search for birth records in their jurisdiction.

• search.death:my-jurisdiction – Allows a user to search for death records in their jurisdiction.

• search.marriage:my-jurisdiction – Allows a user to search for marriage records in their jurisdiction.

#### 8. Config

• config.update:all – Allows a user to update configuration settings.

#### 9. Organisation

• organisation.read-locations:all – Allows a user to view all locations in the organisation.

• organisation.read-locations:my-jurisdiction – Allows a user to view only locations in their jurisdiction.

• organisation.read-locations:my-office – Allows a user to only view their office’s information.

#### 10. User Management

• user.create:all – Allows a user to create a user in any location.

• user.create:my-jurisdiction – Allows a user to create a user only in their jurisdiction.

• user.update:all – Allows a user to update user details in any location.

• user.update:my-jurisdiction – Allows a user to update user details only in their jurisdiction.

• user.read:all – Allows a user to view any user’s audit page.

• user.read:my-jurisdiction – Allows a user to view audit pages only in their jurisdiction.

• user.read:my-office – Allows a user to view user audit pages in their office.

• user.read:only-my-audit – Allows a user to view only their own audit page.\


{% hint style="info" %}
**How to configure user roles & scopes?**\
Learn how to define and assign appropriate permissions to different user roles in your system. [3.2-mapping-offices-and-user-types.md](../../setup/2.-gather-requirements/3.2-mapping-offices-and-user-types.md "mention")
{% endhint %}

{% hint style="info" %}
**User roles & scopes in Farajaland?**\
Learn how we mapped user roles and scopes to support and improve service delivery in Farajaland [user-role-mapping.md](../../default-configuration/opencrvs-configuration-in-farajaland/user-role-mapping.md "mention")
{% endhint %}



<table><thead><tr><th width="228.08182370999793">System roles</th><th>Responsibilities</th><th>Farajaland user roles</th></tr></thead><tbody><tr><td>Field Agent</td><td><ul><li>Create vital event notifications / declarations</li></ul></td><td><p>Hospital Clerk</p><p>Community Leader</p></td></tr><tr><td>Registration Agent</td><td><ul><li>Create vital event declarations</li><li>Validate and send declarations for approval</li><li>Issue certificates</li><li>Search for records</li><li>View performance statistics</li></ul></td><td>Registration Officer</td></tr><tr><td>Registrar</td><td><ul><li>Create vital event declarations</li><li>Approve and register declarations</li><li>Issue certificates</li><li>Search for records</li><li>View performance statistics (default local)</li></ul></td><td>Registrar<br>Provincial Registrar</td></tr><tr><td>National Registrar</td><td><ul><li>Create vital event declarations</li><li>Approve and register declarations</li><li>Issue certificates</li><li>Search for records</li><li>View performance statistics (default Nationally)</li></ul></td><td>Registrar General</td></tr><tr><td>Local System Admin</td><td><ul><li>Create users</li><li>Edit users</li></ul></td><td>Administrator</td></tr><tr><td>National System Admin</td><td><ul><li>Config management</li><li>Create users</li><li>Edit users</li></ul></td><td>National Administrator</td></tr><tr><td>Performance Manager</td><td><ul><li>View performance statistics (default local)</li></ul></td><td>Operations Manager</td></tr></tbody></table>
