---
layout:
  width: default
  title:
    visible: true
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
---

# Communications

### 1. Introduction

Communications in OpenCRVS keep both system users and informants informed about key steps in the civil registration process. Notifications can be triggered by record actions (for example, Notify, Declare, Register) or by system events (for example, onboarding a new user), and can be delivered via SMS and/or email.



***

### 2. Feature overview

Communications supports a range of notification scenarios for both internal users and external informants.

#### Core capabilities

With Communications, OpenCRVS supports:

* SMS and email notifications triggered by **record actions** (for example, Notify, Declare, Validate, Reject, Register).
* System notifications for **user account events** (for example, onboarding, password reset, username reminder).
* Per–event-type and per–action configuration of message templates.
* Use of **template variables** (for example, `name`, `trackingId`, `registrationNumber`) to personalise messages.
* Integration with external SMS gateways (for example, Infobip, Twilio) and email services (for example, SMTP providers).
* Optional bulk communications to system users (for example, platform updates).

Notifications are designed to:

* Guide informants through the registration process.
* Reduce missed appointments and uncollected certificates.
* Keep staff informed of account-related activity.

***

### 3. System users notifications

User notifications are messages sent to **system users** (for example, Registrars, Field Agents, System Administrators).

#### 3.1 Core user notifications

The following notifications are sent to a user:

* **Onboarding invite** — invite a new user to activate their account and set a password.
* **Two-factor authentication codes** — send one-time codes for secure login
* **Username reminder** — send the username to a user who has forgotten it.
* **Password reset** — notify a user that a password reset has been initiated.

#### 3.2 Bulk email to system users

A user with the scope `config.update:all` can send **mass email** to all system users. Typical use cases include:

* Informing users about upcoming system maintenance.
* Announcing new functionality or workflow changes.
* Providing guidance on updated policies.

***

### 4. Informant notifications

Informant notifications are messages sent to the **informant** or other contact person linked to a record (for example, parent, relative, or informant).

Any **record action** can be configured to send an informant notification. Configuration is specific to each event type (for example, birth, death) and each action.

#### Example record-action notifications

* **Record Action – Notify**
  * Purpose: Inform the informant that an incomplete declaration (notification) has been received and explain next steps.
  * Example content: Include the tracking ID and instructions on what information or documents are still required.
* **Record Action – Declare**
  * Purpose: Confirm receipt of a completed declaration and set expectations for review time.
  * Example content: Inform the informant of the expected wait time for validation and registration.
* **Record Action – Validate**
  * Purpose: Update the informant that the declaration has passed validation and is awaiting final approval and registration.
* **Record Action – Reject**
  * Purpose: Inform the informant that the declaration has been rejected.
  * Example content: Include the reason for rejection and any next steps.
* **Record Action – Register**
  * Purpose: Confirm that the event has been registered.
  * Example content: Share the registration number and next steps for certificate collection.

Each notification can be configured separately for SMS and email, and can be enabled or disabled per action.

***

### 5. Configuring notifications overview

Notification behaviour is controlled through configuration that links **events and actions** to **channels and templates**.

#### 5.1 Configuration elements

* **Event type** — for example, Birth, Death.
* **Trigger** — record action or system event (for example, Notify, Declare, Register, UserCreated).
* **Recipient** — informant, user, specific role, or all users.
* **Channel(s)** — SMS, email, or both.
* **Template** — message content with placeholders.
* **Language** — message variants per supported language.

#### 5.2 SMS configuration

SMS notifications require integration with one or more SMS gateway providers (for example, Infobip, Twilio). The exact provider and connection details are set during deployment.

**Example SMS (Record Action: Register)**

> Congratulations, the birth of \{{name\}} has been registered. Visit your local registration office in 5 days with your ID to collect the certificate. Your tracking ID is \{{trackingId\}}.

Key characteristics:

* Short, clear language suitable for SMS length constraints.
* Use of placeholders (for example, `name`, `trackingId`).
* Country-specific guidance on timeframes and required documents.

To learn more ..>

#### 5.3 Email configuration

Email notifications require integration with an email service (for example, SMTP server or cloud email provider).

Email templates can:

* Use richer formatting than SMS (for example, headings, bullet points, links).
* Include more detailed instructions, supporting documents, or links to external resources.
* Be localised per language and tailored per event type.

For example, the email version of a “Registered” notification might include:

* A summary of the registered event.
* The registration number and tracking ID.
* A link to information about office locations and opening hours.
* A reminder of documents required for certificate collection.

To learn more ..>

***

### 6. Worked example

Here we illustrates how a real-world business rule is translated into a comms **configuration** and then into **code in the country configuration package**

#### **Business requirement:**

When a birth is successfully registered, automatically notify the informant so they:

* Know registration is co
*
* mplete
* Receive the registration number
* Understand what to do next (certificate collection)
* Have a tracking ID for follow-up

#### Configuration input

Email template: Link to design

| Action   | Channel | Content                      |
| -------- | ------- | ---------------------------- |
| Register | Email   | Birth registration completed |

Hello \{{informantName\}},

Congratulations, the birth of \{{childName\}} has been registered. Registration number: \{{registrationNumber\}}

Please visit \{{crvsOffice\}} with your ID to collect the birth certificate. Your tracking ID is \{{trackingId\}}.

Best regards, \{{applicationName\}}

_This is an automated message. Please do not reply._ |



> insrt html/svg code
