# 4.2 Configure: Set-up your own, local, country configuration

This section explains how to set up your own **country configuration** of OpenCRVS.

You will learn how to:

1. **Create your configuration repository**
   * Fork the fictional country configuration, **Farajaland**, into your own country configuration repository.
2. **Set up locations and statistics**
   * Define your **administrative divisions**.
   * Configure **performance metrics** for each location.
3. **Set up registration offices and health facilities**
   * Add **civil registration offices** where registrations are processed (aligned with your administrative divisions).
   * Add **health facilities** to track hospital births and deaths separately from home events.
4. **Create user accounts**
   * Set up **test users** for QA environments.
   * Create a **National System Administrator** user for production use.\
     &#xNAN;_(Note: All production users must be created through the OpenCRVS National System Administrator interface after deployment.)_
5. **Configure system settings**
   * Application settings
   * User roles and permissions
   * User work queues for managing registration backlogs
   * Certificates
   * Event configurations (declaration, search, certificate collection, and correction forms)
   * De-duplication algorithms
   * Business Intelligence (BI) dashboards
6. **Understand API integrations**
   * Learn about available **API endpoints** and their business use cases (e.g., SMS notifications, event registration numbers, and integration with external systems).
7. **Seed and clear local databases**
   * Use provided commands to populate or reset your local databases with reference data for development.

To learn how to deploy your configuration to a remote server, you must go to the next [section: 4.3](../3.3-set-up-a-server-hosted-environment/).
