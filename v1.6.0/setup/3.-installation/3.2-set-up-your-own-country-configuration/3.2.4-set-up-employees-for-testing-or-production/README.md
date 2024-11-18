# 4.2.4 Set up employees & roles for testing or production

{% embed url="https://youtu.be/FGrox2hQh90" %}

The next step is for you to set up some employees that have access to your development or production OpenCRVS instance.

You can also configure custom role titles to match each of the built-in OpenCRVS system roles.

For demo and development purposes, we have created some example employees in our Farajaland repo. A test employee setup like this allows you to perform all quality assurance activities you may wish to perform. The setup includes all the user roles located in 3 separate offices and are documented in the main README of our opencrvs-core Git repository. But you should never use this list of test employees in production.

In production, your employee setup should only contain a single National System Administrator that will independently need to configure production staff accounts. In production, it is these users who should login and use the Team section to create users.  They can create Local System Administrators to delegate user management responsibility to technical staff per office.
