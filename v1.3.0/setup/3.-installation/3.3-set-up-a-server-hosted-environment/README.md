# 3.3 Set-up a server-hosted environment

This section outlines the process to setup and deploy OpenCRVS on a remote server environment for Staging (developer testing), Quality Assurance or live Production use.\
\
First you need to provision 1, 3 or 5 Ubuntu servers, with an additional, optional backup server that have internet connectivity, in a secure location with cooling and uninterrupted power supply. &#x20;

{% hint style="danger" %}
**OpenCRVS in production must be deployed in a minimum of a** [**Tier 2**](https://en.wikipedia.org/wiki/Data\_center#Data\_center\_levels\_and\_tiers) **data centre with the strongest possible internet connection.**
{% endhint %}

#### Decide on the size of your deployment

OpenCRVS supports deployments to 1 server, but this is only recommended for a testing (staging), development or a quality assurance environment.

Alternatively, OpenCRVS supports deployments to 3 servers in a load balanced cluster.  This approach also provisions Mongo replica sets for managing a production database at a normal scale.

Finally, OpenCRVS supports deployments to 5 servers in a load balanced cluster.  This approach also provisions Mongo replica sets for managing a production database at a large scale.

If you wish to enable an automated backup from production onto another server, you will need an additional backup server.

This section instructs you how to provision your servers and deploy your OpenCRVS instance.

