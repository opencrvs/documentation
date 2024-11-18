# CDPI Living Lab environment

> SSH ubuntu@13.234.152.15
>
> Pyry / Euan / Vijay has the SSH key (email re: "Credentials of OpenCRVS server details")

[https://github.com/opencrvs/opencrvs-cdpi-living-lab](https://github.com/opencrvs/opencrvs-cdpi-living-lab)

[https://register.opencrvs.lab.cdpi.dev/](https://register.opencrvs.lab.cdpi.dev/)\
(the DNS is set by Vijay)\
\
Deployment happens via GitHub actions "Deploy(production)". The environment only has one prod/dev/qa etc. environment, so you can always deploy to production.

The only way it works differently to Farajaland, is that deploy.sh has also docker-compose.dci.yml attached. This also deploys the DCI-CRVS-API to the Docker swarm.
