# 4.2 Configure: Set-up your own, local, country configuration

This section instructs you how to configure your own, country configuration of OpenCRVS.

The instructions guide you to:

1. Fork our fictional country configuration "Farajaland" into your own country configuration repository.
2. Set up administrative divisions and statistics for location specific performance metrics.
3. Set up civil registration offices (the locations where civil registrations occur - relative to the administrative divisions), and set up health facilities (the locations where some births and deaths occur, in order to track hospital births and deaths separately from home births and deaths & in order to interoperate with these facilities va APIs.)
4. Set up a list of test civil registration employee users who can access the system in QA. Set up of a single National System Administrator user for use in production.   (Production users must be created using the OpenCRVS National System Administrator user interface after deployment)
5. Configure application settings and copy
6. Configure user roles and permissions
7. Configure user "work-queues" to manage their backlog of registrations requiring processing
8. Configure certificates
9. Configure events, event declaration, search, certificate collection & correction forms.
10. Configure de-duplication algorithms
11. Configure BI analytics dashboards
12. Understand the API endpoints available in the country configuration and their business use-cases for aspects such as SMS notifications, event registration number configuration & integration with other systems.&#x20;
13. Commands to seed & clear your local databases with the above reference data for development purposes.

To learn how to deploy your configuration to a remote server, you must go to the next [section: 4.3](../3.3-set-up-a-server-hosted-environment/).
