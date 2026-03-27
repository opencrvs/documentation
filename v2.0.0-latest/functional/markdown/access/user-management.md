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

| Scope          | Description                   |
| -------------- | ----------------------------- |
| `organisation` | View all office locations     |
| `organisation` | View only their team location |

\<aside> 🚨

Please note that searching for an office and searching for a user are backlog features.

\</aside>

***

#### 3.2 Viewing user profiles and audit history

These scopes grant a user the ability to view a user’s profile and audit history.

| Scope                       | Description                             |
| --------------------------- | --------------------------------------- |
| `user.read:all`             | View all users in the country           |
| `user.read:my-jurisdiction` | View users within the same jurisdiction |
| `user.read:my-office`       | View only users in the same office      |

***

#### 3.3 Creating users

These scopes grant a user the ability to create users

| Scope                         | Description                                    |
| ----------------------------- | ---------------------------------------------- |
| `user.create:all`             | Create and assign users to any office          |
| `user.create:my-jurisdiction` | Create users only within the same jurisdiction |

**Example**

An administrator in a State Office with `user.create:my-jurisdiction` can create users for any District office within that State, but not for other States.

***

#### 3.4 Updating users

These scopes grant a user the ability to update a user.

* Editing user details
* Sending username reminders
* Resetting passwords
* Deactivating/reactivating accounts

| Scope                         | Description                               |
| ----------------------------- | ----------------------------------------- |
| `user.update:all`             | Update any user                           |
| `user.update:my-jurisdiction` | Update users within the same jurisdiction |

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

\<aside> 🚨

User creation form is not currently configurable …!

\</aside>

**Output**

* Username is generated automatically (e.g. Jane Smith → `j.smith`)
* Temporary credentials are sent via SMS or email
* User completes onboarding at first login
* Event is recorded in **User Audit**

***

#### 4.2 Editing users

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

…



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
