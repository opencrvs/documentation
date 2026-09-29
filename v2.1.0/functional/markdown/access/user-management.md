# User management

### 1. Introduction

OpenCRVS provides user-friendly tools for administering user accounts and access across the civil registration system.

System administrators can:

* Create and edit user profiles
* Assign offices and roles
* Support users with login issues
* Reset credentials
* Deactivate and reactivate accounts
* Review a full audit history of user actions

All administrative actions are automatically recorded in **User Audit**, supporting transparency, accountability, and compliance with governance requirements.

> **Note**
>
> Roles and permission scopes are not configured through the User Management interface.
>
> Role definitions and scope assignments are set by system developers or implementers during system configuration.

***

### 2. Feature Overview

User Management provides a **secure, controlled way to administer system access** across offices and jurisdictions, ensuring that only authorised personnel can view, create, and manage user accounts.

#### Core capabilities

With **OpenCRVS** User Management, the system supports:

* Creation of **role-based user accounts** aligned to organisational structure (eg. National Administrator, State Administrator).
* **Scoped access control** that limits which users an administrator can view or manage.
* Editing of **user profile information**, roles, and office assignments.
* **Credential support actions**, including username reminders and password resets.
* **Account lifecycle management**, including activation, deactivation, and reactivation.
* Automatic **audit logging** of all administrative actions for compliance and accountability.

User Management is:

* **Scope-driven** — permissions determine what each administrator can see and modify.
* **Organisation-aware** — access follows office and jurisdiction boundaries.
* **Security-focused** — credentials and access can be quickly recovered, restricted, or revoked.
* **Fully auditable** — every change to a user account is recorded in User Audit.

***

### 3. Configuration Overview

#### 3.1 Viewing organisations

These scopes grant users the ability to browse the administrative structure and view office team pages

| Scope                                                                          | Description                                      |
| ------------------------------------------------------------------------------ | ------------------------------------------------ |
| `{ type: 'organisation.read-locations' }`                                      | View all office locations                        |
| `{ type: 'organisation.read-locations', options: { accessLevel: 'administrativeArea' } }` | View offices within their administrative area |
| `{ type: 'organisation.read-locations', options: { accessLevel: 'location' } }` | View only their own office                      |

***

#### 3.2 Viewing user profiles and audit history

These scopes grant a user the ability to view a user’s profile and audit history.

| Scope                                                              | Description                                   |
| ------------------------------------------------------------------ | --------------------------------------------- |
| `{ type: 'user.read' }`                                            | View all users in the country                 |
| `{ type: 'user.read', options: { accessLevel: 'administrativeArea' } }` | View users within their administrative area |
| `{ type: 'user.read', options: { accessLevel: 'location' } }`      | View only users in the same office            |
| `{ type: 'user.read-only-my-audit' }`                              | View only their own audit history             |

`user.search` takes the same `accessLevel` option and controls which users appear in searches.

***

#### 3.3 Creating users

These scopes grant a user the ability to create users

| Scope                                                                    | Description                                                |
| ------------------------------------------------------------------------ | ---------------------------------------------------------- |
| `{ type: 'user.create' }`                                                | Create and assign users to any office                      |
| `{ type: 'user.create', options: { accessLevel: 'administrativeArea' } }` | Create users only within their administrative area         |
| `{ type: 'user.create', options: { role: ['REGISTRATION_AGENT'] } }`     | Limit the roles the administrator can assign               |

**Example**

An administrator in a State Office with `{ type: 'user.create', options: { accessLevel: 'administrativeArea' } }` can create users for any District office within that State, but not for other States.

***

#### 3.4 Updating users

These scopes grant a user the ability to update a user.

* Editing user details
* Sending username reminders
* Resetting passwords
* Deactivating/reactivating accounts

| Scope                                                                  | Description                                  |
| ---------------------------------------------------------------------- | -------------------------------------------- |
| `{ type: 'user.edit' }`                                                | Update any user                              |
| `{ type: 'user.edit', options: { accessLevel: 'administrativeArea' } }` | Update users within their administrative area |

Like `user.create`, `user.edit` also accepts a `role` option limiting which roles the administrator can manage. See [How "user scope" options map to user details](../../../technical/guides/configuration/users/how-user-scope-options-map-to-user-details.md).

***

### 4. User Management Actions

#### 4.1 Creating users

From the **Office view**, authorised administrators can create new user accounts for that location.

**Required details**

| Data              | Description                                                     |
| ----------------- | --------------------------------------------------------------- |
| First name(s)     | User’s given name(s)                                            |
| Last name         | User’s family name                                              |
| Phone number      | Used for SMS notifications and login support                    |
| Email address     | Used for email notifications (if enabled)                       |
| National ID (NID) | Unique identifier where required                                |
| Role              | e.g. Registration Agent, Registrar, National Registrar          |
| Digital signature | Required for Registrar or National Registrar roles              |
| Device            | Assigned mobile or web device (if device assignment is enabled) |

**Output**

* Username is generated automatically (e.g. Jane Smith → `j.smith`)
* Temporary credentials are sent via SMS or email
* User completes onboarding at first login
* Event is recorded in **User Audit**

***

#### 4.2 Updating users

Administrators can update user information from the **Office view** or **User Audit**.

**Steps**

1. Locate the user
2. Open the menu (⋯)
3. Select **Edit user**

**Editable fields**

* Assigned office
* Name
* Phone
* Email
* National ID
* Role
* Digital signature
* Device

All changes are logged.

***

#### 4.3 Sending a username reminder

Administrators can send a reminder if the user cannot retrieve their username.

#### Steps

1. Locate the user
2. Open the menu
3. Select **Send username reminder**

The username is sent via SMS or email.

***

#### 4.4 Resetting a password

Users can reset passwords themselves, but administrators can assist when necessary.

#### Steps

1. Locate the user
2. Open the menu
3. Select **Reset password**

The system:

* Sends a temporary password
* Requires password change at next login

***

#### 4.5 Deactivating a user

Deactivation removes access while preserving the account and history.

#### When to use

* User leaves employment
* Temporary suspension
* Suspected misuse
* Security concerns

#### Steps

1. Locate the user
2. Open the menu
3. Select **Deactivate**
4. Choose a reason and optionally add comments

Once deactivated, the user cannot log in.

***

#### 4.6 Reactivating a user

Administrators can restore access when appropriate.

#### Steps

1. Locate the deactivated user
2. Open the menu
3. Select **Reactivate**

Access is restored according to the user’s current:

* Role
* Office
* Scopes

***

### 5. User onboarding

New accounts are created in a **pending** state. The user activates their account by completing onboarding at first login.

**Steps**

1. Receive username and temporary password (via SMS or email)
2. Log in and create a new password
3. Set security questions
4. Confirm profile details, assigned office, and role

Once complete, the account becomes **active** and the user signs in with their new password.

***

### 6. Audit and Accountability

All user management actions are automatically recorded, including:

* Creation
* Edits
* Role changes
* Password resets
* Deactivation/reactivation

Audit logs provide:

* Timestamp
* Administrator performing the action
* Type of change
* Before/after values

This supports compliance, investigations, and operational transparency.

***

### 6. Summary

OpenCRVS User Management enables administrators to securely control system access through scoped permissions and organisational boundaries.

Key benefits include:

* Controlled access based on jurisdiction
* Secure onboarding and credential recovery
* Temporary or permanent access removal
* Full audit history of all administrative actions

Together, these features ensure a secure, accountable, and maintainable user administration model for civil registration operations.
