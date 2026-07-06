# Security

### 1. Introduction

OpenCRVS includes several built-in features to protect access to the system and reduce the risk of unauthorised use:

* Username and password-based authentication.
* Two-factor authentication (2FA) using SMS or email.
* A PIN to quickly lock and unlock the application on a device.

These features work together to ensure that only authorised users can sign in, and that sessions remain protected even when devices are shared or temporarily unattended.

***

### 2. Feature overview

Authentication and session security provide a **multi-layered approach to protecting user access**, ensuring that identities are verified at login and that active sessions remain protected throughout daily work.

#### Core capabilities

With authentication and session security, OpenCRVS supports:

* **Unique username and password credentials** for every user account.
* **Temporary passwords and mandatory first-login password change** during onboarding.
* Optional **two-factor authentication (2FA)** using SMS or email verification codes.
* **Time-limited one-time codes** to prevent replay or reuse during login.
* A **screen lock PIN** for quickly securing active sessions without full re-authentication.
* **Administrative password reset and recovery workflows** through User Management.
* Automatic **audit logging** of authentication events, credential changes, and security actions.

Authentication and session security are:

* **Identity-based** — every action is tied to a unique named user.
* **Layered** — multiple controls protect both login and active sessions.
* **Configurable** — deployments can enable or require 2FA based on policy.
* **Auditable** — all authentication and recovery events are recorded in User Audit.

***

### 3. Username and password

Each OpenCRVS user is issued a **unique username and password**.

#### Username

* Automatically generated when the account is created
* Serves as a stable identifier across the system
* Appears in audit logs and activity records

#### Password

* Initially issued as a **temporary password**
* Must be changed on first login
* Can be reset through self-service or by an administrator
* Never displayed in clear text to administrators

***

### 4. Two-factor authentication (2FA)

OpenCRVS can require **two-factor authentication (2FA)** to strengthen login security.

#### Behaviour

1. User enters username and password
2. System prompts for a one-time verification code
3. Code is delivered via SMS or email
4. User enters the code to complete login

The 2FA code is:

* Time-limited to 10 minutes
* Codes can only be used once
* Invalid or expired codes result in login failure
* All challenges and outcomes are logged

***

### 5. Screen lock PIN

OpenCRVS supports a **screen lock PIN** to protect active sessions on a device.

This allows users to quickly secure their session without fully signing out.

#### Behaviour

* After inactivity, the lock screen is shown
* User enters their PIN to continue
* Multiple incorrect attempts may require full re-authentication

The PIN is:

* Device- and session-specific
* Faster than full login
* Logged as part of session activity

This feature is particularly useful in shared offices or mobile field environments.

***

### 6. How these features work together

These controls operate together to provide layered protection:

* **Username + password** verify the user’s identity
* **2FA** confirms control of a trusted communication channel
* **Screen lock PIN** protects an authenticated session

Combined with scoped permissions and role-based access control, these mechanisms help maintain a secure, accountable environment for civil registration operations.
