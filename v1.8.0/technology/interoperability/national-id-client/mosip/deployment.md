---
description: >-
  Deployment process for the technical components and modules required to
  integrate with MOSIP & E-Signet
---

# Deployment

{% hint style="warning" %}
This section assumes that you are already thoroughly aware of how to deploy OpenCRVS.  If you are not, then first complete a basic deployment following the documentation [here](../../../../setup/3.-installation/3.3-set-up-a-server-hosted-environment/).
{% endhint %}

### Docker Compose configuration

Take a look at the docker-compose.deploy.yml file in our example configuration.&#x20;

The mosip-api middleware is configured like [this](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/infrastructure/docker-compose.deploy.yml#L1030):

```
mosip-api:
    volumes:
      - '/data/sqlite:/data/sqlite'
    image: ghcr.io/opencrvs/mosip-api:${MOSIP_API_VERSION}
    environment:
      - NODE_ENV=production
      - MOSIP_BIRTH_WEBHOOK_URL=http://mosip-mock:20240/webhooks/opencrvs/birth
      - MOSIP_DEATH_WEBHOOK_URL=http://mosip-mock:20240/webhooks/opencrvs/death
      - OPENCRVS_GRAPHQL_GATEWAY_URL=http://gateway:7070/graphql
      - OPENCRVS_PUBLIC_KEY_URL=http://auth:4040/.well-known
      - LOCALE=en
      - ESIGNET_USERINFO_URL=${ESIGNET_USERINFO_URL}
      - ESIGNET_TOKEN_URL=${ESIGNET_TOKEN_URL}
      - ESIGNET_REDIRECT_URL=${ESIGNET_REDIRECT_URL}
      - OIDP_CLIENT_PRIVATE_KEY_PATH=${OIDP_CLIENT_PRIVATE_KEY_PATH}
      - OPENID_PROVIDER_CLAIMS=${OPENID_PROVIDER_CLAIMS}
      - DECRYPT_P12_FILE_PATH=${DECRYPT_P12_FILE_PATH}
      - DECRYPT_P12_FILE_PASSWORD=${DECRYPT_P12_FILE_PASSWORD}
      - ENCRYPT_CERT_PATH=${ENCRYPT_CERT_PATH}
      - IDA_AUTH_DOMAIN_URI=${IDA_AUTH_DOMAIN_URI}
      - IDA_AUTH_URL=${IDA_AUTH_URL}
      - PARTNER_APIKEY=${PARTNER_APIKEY}
      - PARTNER_ID=${PARTNER_ID}
      - PARTNER_MISP_LK=${PARTNER_MISP_LK}
      - SIGN_P12_FILE_PATH=${SIGN_P12_FILE_PATH}
      - SIGN_P12_FILE_PASSWORD=${SIGN_P12_FILE_PASSWORD}
      - CLIENT_APP_URL=https://register.{{hostname}}
      - SQLITE_DATABASE_PATH=/data/sqlite/mosip-api.db
      - MOSIP_PACKET_AUTH_CLIENT_ID=${MOSIP_PACKET_AUTH_CLIENT_ID}
      - MOSIP_PACKET_AUTH_CLIENT_SECRET=${MOSIP_PACKET_AUTH_CLIENT_SECRET}
      - MOSIP_WEBSUB_AUTH_CLIENT_ID=${MOSIP_WEBSUB_AUTH_CLIENT_ID}
      - MOSIP_WEBSUB_AUTH_CLIENT_SECRET=${MOSIP_WEBSUB_AUTH_CLIENT_SECRET}
      - MOSIP_AUTH_URL=${MOSIP_AUTH_URL}
      - MOSIP_WEBSUB_CALLBACK_URL=http://mosip-api:2024/websub/callback
      - MOSIP_WEBSUB_HUB_URL=${MOSIP_WEBSUB_HUB_URL}
      - MOSIP_WEBSUB_SECRET=${MOSIP_WEBSUB_SECRET}
      - MOSIP_WEBSUB_TOPIC=${MOSIP_WEBSUB_TOPIC}
      - MOSIP_CREATE_PACKET_URL=${MOSIP_CREATE_PACKET_URL}
      - MOSIP_PROCESS_PACKET_URL=${MOSIP_PROCESS_PACKET_URL}
      - MOSIP_VERIFIABLE_CREDENTIAL_ALLOWLIST=${MOSIP_VERIFIABLE_CREDENTIAL_ALLOWLIST}
      - MOSIP_CENTER_ID=${MOSIP_CENTER_ID}
      - MOSIP_MACHINE_ID=${MOSIP_MACHINE_ID}
    deploy:
      replicas: 1
      labels:
        - 'traefik.enable=true'
        - 'traefik.http.routers.mosip-api.rule=Host(`mosip-api.{{hostname}}`)'
        - 'traefik.http.services.mosip-api.loadbalancer.server.port=2024'
        - 'traefik.http.routers.mosip-api.tls=true'
        - 'traefik.http.routers.mosip-api.tls.certresolver=certResolver'
        - 'traefik.http.routers.mosip-api.entrypoints=web,websecure'
        - 'traefik.http.routers.mosip-api.middlewares=gzip-compression'
        - 'traefik.docker.network=opencrvs_overlay_net'
        - 'traefik.http.middlewares.mosip-api.headers.customresponseheaders.Pragma=no-cache'
        - 'traefik.http.middlewares.mosip-api.headers.customresponseheaders.Cache-control=no-store'
        - 'traefik.http.middlewares.mosip-api.headers.customresponseheaders.X-Robots-Tag=none'
        - 'traefik.http.middlewares.mosip-api.headers.stsseconds=31536000'
        - 'traefik.http.middlewares.mosip-api.headers.stsincludesubdomains=true'
        - 'traefik.http.middlewares.mosip-api.headers.stspreload=true'
    networks:
      - overlay_net
    logging:
      driver: gelf
      options:
        gelf-address: 'udp://127.0.0.1:12201'
        tag: 'mosip-api'
```

Take a look at the docker-compose.qa-deploy.yml file in our example configuration.  This configuration is deployed to a QA server.

For the countryconfig microservice, the following [environment](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/infrastructure/docker-compose.qa-deploy.yml#L60C7-L63C57) variables are set:

```
- ESIGNET_REDIRECT_URL=${ESIGNET_REDIRECT_URL}
- OPENID_PROVIDER_CLIENT_ID=${OPENID_PROVIDER_CLIENT_ID:-}
- OPENID_PROVIDER_CLAIMS=${OPENID_PROVIDER_CLAIMS:-}
- MOSIP_API_USERINFO_URL=${MOSIP_API_USERINFO_URL}
```

A [volume](https://github.com/opencrvs/opencrvs-countryconfig-mosip/blob/4fa62771a1faea01f87c2fb0db80824e8f594fe7/infrastructure/docker-compose.qa-deploy.yml#L136) is shared with the mosip-api Docker container containing the static certificate key files that MOSIP will be required to share with you.

```
 mosip-api:
    volumes:
      - /certs:/certs:ro 
```

### Environment secrets (variables)

You will need to manually add the environment variables used for the MOSIP and E-Signet integration into the Gthub environment of choice.  In our example, it is a QA environment.

<figure><img src="../../../../.gitbook/assets/Screenshot 2025-07-16 at 11.10.39.png" alt=""><figcaption></figcaption></figure>

Click "Add environment secret" and enter the following variables:

#### **Environment secrets** <a href="#environment-secrets" id="environment-secrets"></a>

|                                |                                                                                                                                                                                                       |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BACKUP\_ENCRYPTION\_PASSPHRASE | This is the password that is used to encrypt all the backups that OpenCRVS creates from a production server and that are stored on the **backup** server. Use this passphrase to decrypt the backups. |

### Static certificate key files
