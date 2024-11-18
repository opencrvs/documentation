# 3.2 Set-up your own country configuration

This section instructs you how to set-up and provision your own, local, country configuration of OpenCRVS.

{% hint style="info" %}
OpenCRVS must be configured for your country locally, before deploying to a server in the next section: [3.3 Set-up a server-hosted environment](../3.3-set-up-a-server-hosted-environment/)
{% endhint %}

The instructions should be conducted sequentially as laid out in each step, and will include:

1. Forking our fictional country configuration "Farajaland" into your own country configuration repository.
2. Set up administrative divisions and statistics for location specific performance metrics.
3. Set up civil registration offices (the locations where civil registrations occur - relative to the administrative divisions), and set up health facilities (the locations where some births and deaths occur - relative to the administrative divisions - in order to track hospital births and deaths separately from home births and deaths & in order to interoperate with these facilities va APIs.)
4. Set up an list of test civil registration employee users who can access the system. (Users can be created using the OpenCRVS user interface at any time). Set up of a single National System Administrator user for production.
5. Set up application settings
6. Configure certificates
7. Configure declarion forms
8. Commands to seed & clear your local databases with the above reference data for development purposes.
9. Understanding of the API endpoints available in the country configuration and their business use-cases.
