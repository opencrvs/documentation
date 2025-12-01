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
      - OPENCRVS_GRAPHQL_GATEWAY_URL=http://gateway:7070/graphql
      - OPENCRVS_PUBLIC_KEY_URL=http://auth:4040/.well-known
      - LOCALE=en
      - ESIGNET_USERINFO_URL=${ESIGNET_USERINFO_URL}
      - ESIGNET_TOKEN_URL=${ESIGNET_TOKEN_URL}
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

#### **Environment secrets** <a href="#environment-secrets" id="environment-secrets"></a>

Click "Add environment secret" and enter the following secrets:

| secret                           | description                                                                                                                                                                                                                                                                                                                                                            |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DECRYPT\_P12\_FILE\_PASSWORD     | A password that is supplied by MOSIP to decrypt the file below.                                                                                                                                                                                                                                                                                                        |
| DECRYPT\_P12\_FILE\_PATH         | The same path within the shared volume of the mosip-api service to the MOSIP "keystore.p12" file supplied by MOSIP used when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk) and when validating the returned credential.  It is configurable that these can be 2 different files, hence the duplication with SIGN\_P12\_FILE\_PATH    |
| ENCRYPT\_CERT\_PATH              | The path within the shared volume of the mosip-api service to the MOSIP "ida-partner.crt" file supplied by MOSIP used when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk)                                                                                                                                                             |
| ESIGNET\_USERINFO\_URL           | The E-Signet User Info API endpoint used by the mosip-api service to retrieve details of the individual from E-Signet using an authorised E-Signet token that is returned from the authentication process.                                                                                                                                                             |
| IDA\_AUTH\_DOMAIN\_URI           | API endpoint variables supplied by MOSIP  when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk)                                                                                                                                                                                                                                         |
| IDA\_AUTH\_URL                   | API endpoint variables supplied by MOSIP  when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk)                                                                                                                                                                                                                                         |
| OIDP\_CLIENT\_PRIVATE\_KEY\_PATH | The path within the shared volume of the mosip-api service to the E-Signet "esignet-jwk.txt" file supplied by MOSIP                                                                                                                                                                                                                                                    |
| OPENID\_PROVIDER\_CLAIMS         | A comment separated list of available E-Signet data that can be used as initialValues (pre-population) for form fields.  E.G. `name,family_name,given_name,middle_name,birthdate,address`                                                                                                                                                                              |
| PARTNER\_APIKEY                  | A variable supplied by MOSIP  when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk)                                                                                                                                                                                                                                                     |
| PARTNER\_ID                      | A variable supplied by MOSIP  when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk)                                                                                                                                                                                                                                                     |
| PARTNER\_MISP\_LK                | A variable supplied by MOSIP  when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk)                                                                                                                                                                                                                                                     |
| SIGN\_P12\_FILE\_PASSWORD        | A password that is supplied by MOSIP to decrypt the file below.                                                                                                                                                                                                                                                                                                        |
| SIGN\_P12\_FILE\_PATH            | The same path within the shared volume of the mosip-api service to the MOSIP "keystore.p12" file supplied by MOSIP used when interacting with the [MOSIP ID Auth SDK](https://github.com/mosip/ida-auth-sdk) and when validating the returned credential.  It is configurable that these can be 2 different files, hence the duplication with DECRYPT\_P12\_FILE\_PATH |



**Environment variables**

Click "Add environment variable" and enter the following variables:

<table><thead><tr><th>variable</th><th>description</th></tr></thead><tbody><tr><td>ESIGNET_REDIRECT_URL</td><td>The E-Signet login URL that OpenCRVS redirects to.</td></tr><tr><td>ESIGNET_TOKEN_URL</td><td>​The authorized "code" from an E-Signet login is used to retrieve an API OAuth token from this API endpoint in order to interact with the E-Signet User Info API. </td></tr><tr><td>MOSIP_API_USERINFO_URL</td><td>The mosip-api service URL configured in the form esignetConfig that is triggered by the callback to retrieve details of the individual from E-Signet's ESIGNET_USERINFO_URL.</td></tr><tr><td>MOSIP_API_VERSION</td><td>The released version <a href="https://github.com/opencrvs/mosip/releases/tag/v1.8.0">tag</a> of the mosip-api service</td></tr><tr><td>MOSIP_CENTER_ID</td><td><p>Used in the following prop when submitting the payloads to the MOSIP Packet Manager API</p><pre class="language-typescript"><code class="lang-typescript">refId: `${env.MOSIP_CENTER_ID}_${env.MOSIP_MACHINE_ID}`
</code></pre></td></tr><tr><td>MOSIP_MACHINE_ID</td><td>As above</td></tr><tr><td>MOSIP_AUTH_URL</td><td>URL used to authenticate with MOSIP Packet Manager API and WebSub</td></tr><tr><td>MOSIP_PACKET_AUTH_CLIENT_ID</td><td>Credentials used to authenticate with MOSIP Packet Manager API</td></tr><tr><td>MOSIP_PACKET_AUTH_CLIENT_SECRET</td><td>Credentials used to authenticate with MOSIP Packet Manager API</td></tr><tr><td>MOSIP_CREATE_PACKET_URL</td><td>Create packet URL for the MOSIP Packet Manager API</td></tr><tr><td>MOSIP_PROCESS_PACKET_URL</td><td>MOSIP workflow manager, workflow instance URL to be called immediately after the packet is created.</td></tr><tr><td>MOSIP_VERIFIABLE_CREDENTIAL_ALLOWLIST</td><td>Not currently in use in this phase.  Awaiting MOSIP direction on it's use in future releases.</td></tr><tr><td>MOSIP_WEBSUB_AUTH_CLIENT_ID</td><td>Credentials used to authenticate with MOSIP WebSub</td></tr><tr><td>MOSIP_WEBSUB_AUTH_CLIENT_SECRET</td><td>Credentials used to authenticate with MOSIP WebSub</td></tr><tr><td>MOSIP_WEBSUB_HUB_URL</td><td>URL to subscribe to MOSIP WebSub</td></tr><tr><td>MOSIP_WEBSUB_SECRET</td><td><code>hub.secret</code> value for MOSIP WebSub</td></tr><tr><td>MOSIP_WEBSUB_TOPIC</td><td><code>hub.topic</code> value for MOSIP WebSub</td></tr></tbody></table>

### Static certificate key files

You will need to make a directory on your server for the shared volume that stores the static certificate key files used by the mosip-api.  In our example, the path to this drectory is:

```
/certs
```

You will be given static files from MOSIP.  The files are:

* keystore.p12
* ida-partner.crt
* esignet-jwk.txt
