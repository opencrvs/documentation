# 4.2.4 Set up employee users, and scopes, for testing or production

The next step is for you to set up some employees that have access to your development or production OpenCRVS instance with different authorization levels (access to functionality) depending on your require use cases.&#x20;

This was explained in detail in the section: [User roles & scopes](../../../../product-specifications/users/)

For demo and development purposes, we have created some example employees in our Farajaland repo.&#x20;

A test employee setup like this should allow you to perform all quality assurance activities you may wish to perform.

The setup includes all the user roles located in 3 separate offices. But you should never use this list of test employees in production.

In production, your employee setup should only contain a **single National System Administrator** that will independently need to configure production staff accounts.&#x20;

In production, it is these users who should login and use the Team section to create users.  They can delegate user management responsibility to technical staff per office if you configure roles and scopes in a creative way.
