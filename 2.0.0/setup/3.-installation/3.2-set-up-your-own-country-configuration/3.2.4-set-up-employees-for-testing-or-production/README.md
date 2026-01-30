---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.4-set-up-employees-for-testing-or-production
---

# 4.2.4 Set up employees & roles for testing or production

#### 👥 Setting Up Employees and Access Levels

The next step is to create the **employees** who will access your development or production OpenCRVS instance. Each user must be assigned the appropriate **authorization level** (roles and scopes) depending on your country’s business processes.

User roles and permissions are described in detail in the section **User Roles & Scopes**.

***

#### 🧪 Test Users for Development & QA

For demonstration and development purposes, the Farajaland example configuration includes several **sample employee accounts**.

This test setup is designed to:

* Represent all major user roles
* Cover multiple civil registration offices
* Enable full end-to-end QA and workflow testing

You may create a similar set of demo users in your country configuration to support development and testing.

> ⚠️ **Important:**\
> These test users must **never** be used in production.

***

#### 🏛️ Users in Production

In a production environment, your configuration should contain **only one** pre-defined user:

* **The National System Administrator**

This user is responsible for:

* Logging into the production instance
* Using the **Team** section to create real user accounts
* Assigning roles to staff in each office

With well-designed roles and scopes, the National System Administrator can also **delegate user-management responsibilities** to trusted technical staff at regional or office level.

This ensures production user management remains:

* Secure
* Audited
* Controlled by authorised personnel in the National CRVS organisation
