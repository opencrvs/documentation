# 4.3.1 Preparation steps

#### Before you begin

Before running any scripts, you must complete prepation steps. Please carefully check information on this page.

This section describes the environments, servers and network requirements that countries are required to prepare in order to install OpenCRVS. This section also explains how to configure, provision, deploy and maintain OpenCRVS server deployments technically.

We have an automated script to generate [Github environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) for you along with all the application secrets that Github needs to run the continuous provisioning and deployment scripts.

Environment naming is not limited, but we recommend to use following environment names: **qa, staging, production** and for training purposes a **development** (optional) server.

Github Actions use environment secrets and variables when installing software on servers and deploying OpenCRVS.

