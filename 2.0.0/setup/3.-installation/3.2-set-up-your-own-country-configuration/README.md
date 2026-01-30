---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/setup/3.-installation/3.2-set-up-your-own-country-configuration
---

# 4.2 Configure: Set-up your own, local, country configuration

This section explains how to set up your own **country configuration** of OpenCRVS.

You will learn how to:

#### 🏗️ 1. Create Your Configuration Repository

* Fork the fictional **Farajaland** configuration into your own **country configuration repository**.
* Rename it using the convention

#### 🗺️ 2. Set Up Locations and Statistics

* Define your **administrative divisions** (e.g., province, district, sub-district).
* Configure **performance metrics** and statistics for each location to enable localised monitoring and analytics.
* Ensure each location has unique codes or identifiers for consistency across systems.

***

#### 🏛️ 3. Set Up Registration Offices and Health Facilities

* Add **civil registration offices** where event registrations occur, aligning them with your administrative divisions.
* Add **health facilities** (hospitals, clinics, etc.) to record births and deaths that occur in these locations.
* Configure these facilities to allow separate tracking of **hospital vs home events**.
* If applicable, set up **API interoperability** with these facilities for event notifications.

***

#### 👥 4. Create User Accounts

* Set up **test users** for QA and development environments.
* Create a **National System Administrator** user for production.

> ⚠️ Note: All production users must be created through the OpenCRVS **National System Administrator interface** after deployment.

***

#### ⚙️ 5. Configure System Settings

Customise the behaviour and rules of your OpenCRVS instance.

* 🧩 **Application settings** — country name, time zone, languages, branding, and feature toggles.
* 👮 **User roles and permissions** — define each role’s access to modules, actions, and reports.
* 📋 **User work queues** — configure queues to manage pending registrations, corrections, and verifications.
* 🪪 **Certificates** — set up official certificate templates, logos, seals, and multilingual text.
* 🧾 **Event configurations** — customise declaration, search, certificate collection, and correction forms.
* 🔍 **De-duplication algorithms** — configure how the system detects and flags potential duplicate records.
* 📊 **Business Intelligence dashboards** — define key indicators and visualisations to monitor performance.

***

#### 🔗 6. Understand API Integrations

* Review the **available API endpoints** in the country configuration.
* Understand their **business use cases**, such as:
* Sending SMS or email notifications 📱
* Generating or formatting registration numbers 🔢
* Integrating with other national systems (e.g., identity, health, or statistics platforms) 🌐
* Document the endpoints your country will use and any required credentials.

***

#### 💾 7. Seed and Clear Local Databases

Use the provided commands to populate or reset your local environment with reference data for development and testing.

To learn how to deploy your configuration to a remote server, you must go to the next [section: 4.3](../../../../v1.9.0/setup/3.-installation/3.3-set-up-a-server-hosted-environment).
