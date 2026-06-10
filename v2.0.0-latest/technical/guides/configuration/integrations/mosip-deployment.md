# MOSIP Deployment

{% hint style="warning" %}
This section assumes that you are already thoroughly aware of how to deploy OpenCRVS. If you are not, complete a basic deployment first following [the deployment guide](../../installation/deploy-set-up-a-server-hosted-environment/).
{% endhint %}

#### Kubernetes / Helm deployment

In OpenCRVS v2.0.0, the MOSIP middleware is deployed as part of the Kubernetes cluster using Helm charts.

An example Helm chart is available in the OpenCRVS Core repository:

{% embed url="https://github.com/opencrvs/opencrvs-core/tree/develop/charts/opencrvs-mosip" %}

#### mosip-api middleware

The [mosip-api](https://github.com/opencrvs/mosip/tree/main/packages/mosip-api) middleware is a critical component that must be deployed. It handles communication with:

* **eSignet** — For OAuth token exchange and user info retrieval during form authentication.
* **MOSIP Packet Manager API** — For packet creation and processing during UIN lifecycle management.
* **MOSIP WebSub** — For asynchronous callback notifications on credential issuance.
* **MOSIP ID Auth SDK** — For identity verification requests.

All of the secrets and key files required are supplied by MOSIP for the different steps of the eSignet, IDA Auth SDK, and Packet Manager integration. Communicate with your MOSIP team for these values and an understanding of why they are needed.

#### Environment variables

**mosip-api middleware**

The following environment variables must be set for the mosip-api container:

| Variable                                | Description                                        |
| --------------------------------------- | -------------------------------------------------- |
| `NODE_ENV`                              | `production`                                       |
| `MOSIP_BIRTH_WEBHOOK_URL`               | Webhook URL for birth events                       |
| `MOSIP_DEATH_WEBHOOK_URL`               | Webhook URL for death events                       |
| `OPENCRVS_GATEWAY_URL`                  | OpenCRVS Gateway URL                               |
| `OPENCRVS_PUBLIC_KEY_URL`               | OpenCRVS Auth public key URL                       |
| `LOCALE`                                | Locale setting                                     |
| `CLIENT_APP_URL`                        | OpenCRVS client application URL                    |
| `MOSIP_WEBSUB_CALLBACK_URL`             | Public callback URL for MOSIP WebSub notifications |
| `ESIGNET_USERINFO_URL`                  | eSignet User Info API endpoint                     |
| `ESIGNET_TOKEN_URL`                     | eSignet token endpoint                             |
| `ESIGNET_REDIRECT_URL`                  | eSignet login redirect URL                         |
| `OIDP_CLIENT_PRIVATE_KEY_PATH`          | Path to eSignet JWK file                           |
| `OPENID_PROVIDER_CLAIMS`                | Comma-separated list of available eSignet claims   |
| `IDA_AUTH_DOMAIN_URI`                   | ID Auth SDK domain URI (supplied by MOSIP)         |
| `IDA_AUTH_URL`                          | ID Auth SDK URL (supplied by MOSIP)                |
| `PARTNER_APIKEY`                        | Partner API key (supplied by MOSIP)                |
| `PARTNER_ID`                            | Partner ID (supplied by MOSIP)                     |
| `PARTNER_MISP_LK`                       | Partner MISP LK (supplied by MOSIP)                |
| `DECRYPT_P12_FILE_PASSWORD`             | Password for decrypt keystore.p12                  |
| `SIGN_P12_FILE_PASSWORD`                | Password for sign keystore.p12                     |
| `MOSIP_PACKET_AUTH_CLIENT_ID`           | Credentials for MOSIP Packet Manager API           |
| `MOSIP_PACKET_AUTH_CLIENT_SECRET`       | Credentials for MOSIP Packet Manager API           |
| `MOSIP_WEBSUB_AUTH_CLIENT_ID`           | Credentials for MOSIP WebSub                       |
| `MOSIP_WEBSUB_AUTH_CLIENT_SECRET`       | Credentials for MOSIP WebSub                       |
| `MOSIP_AUTH_URL`                        | MOSIP authentication URL                           |
| `MOSIP_WEBSUB_HUB_URL`                  | MOSIP WebSub hub URL                               |
| `MOSIP_WEBSUB_SECRET`                   | WebSub hub secret                                  |
| `MOSIP_WEBSUB_TOPIC`                    | WebSub topic                                       |
| `MOSIP_CREATE_PACKET_URL`               | MOSIP Packet Manager create packet URL             |
| `MOSIP_PROCESS_PACKET_URL`              | MOSIP workflow manager URL                         |
| `MOSIP_VERIFIABLE_CREDENTIAL_ALLOWLIST` | Credential allowlist                               |
| `MOSIP_CENTER_ID`                       | MOSIP center ID                                    |
| `MOSIP_MACHINE_ID`                      | MOSIP machine ID                                   |
| `DECRYPT_P12_FILE_PATH`                 | Path to keystore.p12 (decrypt)                     |
| `ENCRYPT_CERT_PATH`                     | Path to ida-partner.crt                            |
| `SIGN_P12_FILE_PATH`                    | Path to keystore.p12 (sign)                        |

**Country configuration service**

The following variables must be set in the country configuration (countryconfig) service:

| Variable                    | Description                                                                                 |
| --------------------------- | ------------------------------------------------------------------------------------------- |
| `ESIGNET_REDIRECT_URL`      | The eSignet login URL that OpenCRVS redirects to                                            |
| `OPENID_PROVIDER_CLIENT_ID` | OIDP client ID for eSignet                                                                  |
| `OPENID_PROVIDER_CLAIMS`    | Comma-separated list of available eSignet claims for form pre-population                    |
| `MOSIP_API_USERINFO_URL`    | The mosip-api service URL for retrieving user info from eSignet                             |
| `MOSIP_INTEROP_URL`         | The mosip-api service URL for interoperability API calls (default: `http://mosip-api:2024`) |

These are configured in [opencrvs-integrationland/src/environment.ts](https://github.com/opencrvs/opencrvs-integrationland/blob/release-v2.0.0/src/environment.ts).

#### Static certificate key files

You will need to make a directory on your server for the shared volume that stores the static certificate key files used by the mosip-api. The files are supplied by MOSIP:

| File              | Purpose                                                      |
| ----------------- | ------------------------------------------------------------ |
| `keystore.p12`    | PKCS#12 keystore used for ID Auth SDK signing and decryption |
| `ida-partner.crt` | Partner certificate for ID Auth SDK encryption               |
| `esignet-jwk.txt` | JWK private key for eSignet OIDP client authentication       |

#### MOSIP\_INTEROP\_URL

The `MOSIP_INTEROP_URL` environment variable in the country configuration points to the mosip-api service and is used by `createMosipInteropClient` for all registration integration operations. The default value is:

```
http://mosip-api:2024
```

#### Setting environment secrets

You will need to manually add the environment variables used for the MOSIP and eSignet integration into your GitHub environment (or equivalent secrets management).

**Environment secrets** (sensitive values):

| Secret                         | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| `DECRYPT_P12_FILE_PASSWORD`    | Password supplied by MOSIP to decrypt `keystore.p12`           |
| `DECRYPT_P12_FILE_PATH`        | Path within the shared volume to the MOSIP `keystore.p12` file |
| `ENCRYPT_CERT_PATH`            | Path to the MOSIP `ida-partner.crt` file                       |
| `ESIGNET_USERINFO_URL`         | eSignet User Info API endpoint                                 |
| `IDA_AUTH_DOMAIN_URI`          | ID Auth SDK domain URI                                         |
| `IDA_AUTH_URL`                 | ID Auth SDK API URL                                            |
| `OIDP_CLIENT_PRIVATE_KEY_PATH` | Path to eSignet `esignet-jwk.txt`                              |
| `OPENID_PROVIDER_CLAIMS`       | Comma separated list of available eSignet claims               |
| `PARTNER_APIKEY`               | MOSIP partner API key                                          |
| `PARTNER_ID`                   | MOSIP partner ID                                               |
| `PARTNER_MISP_LK`              | MOSIP partner MISP LK                                          |
| `SIGN_P12_FILE_PASSWORD`       | Password supplied by MOSIP to sign with `keystore.p12`         |
| `SIGN_P12_FILE_PATH`           | Path to the MOSIP `keystore.p12` file for signing              |

**Environment variables** (non-sensitive):

| Variable                                | Description                                                                 |
| --------------------------------------- | --------------------------------------------------------------------------- |
| `ESIGNET_REDIRECT_URL`                  | The eSignet login URL that OpenCRVS redirects to                            |
| `ESIGNET_TOKEN_URL`                     | The authorized code from eSignet login is used to retrieve an OAuth token   |
| `MOSIP_API_USERINFO_URL`                | The mosip-api service URL configured in esignetConfig                       |
| `MOSIP_INTEROP_URL`                     | The mosip-api URL for interoperability API calls                            |
| `MOSIP_API_VERSION`                     | The released version tag of the mosip-api service                           |
| `MOSIP_CENTER_ID`                       | Used in the `refId` prop when submitting payloads to the Packet Manager API |
| `MOSIP_MACHINE_ID`                      | As above                                                                    |
| `MOSIP_AUTH_URL`                        | URL used to authenticate with MOSIP Packet Manager API and WebSub           |
| `MOSIP_PACKET_AUTH_CLIENT_ID`           | Credentials for MOSIP Packet Manager API                                    |
| `MOSIP_PACKET_AUTH_CLIENT_SECRET`       | Credentials for MOSIP Packet Manager API                                    |
| `MOSIP_CREATE_PACKET_URL`               | Create packet URL for the Packet Manager API                                |
| `MOSIP_PROCESS_PACKET_URL`              | Workflow manager URL called after packet creation                           |
| `MOSIP_VERIFIABLE_CREDENTIAL_ALLOWLIST` | Credential allowlist (usage depends on MOSIP direction)                     |
| `MOSIP_WEBSUB_AUTH_CLIENT_ID`           | Credentials for MOSIP WebSub                                                |
| `MOSIP_WEBSUB_AUTH_CLIENT_SECRET`       | Credentials for MOSIP WebSub                                                |
| `MOSIP_WEBSUB_HUB_URL`                  | URL to subscribe to MOSIP WebSub                                            |
| `MOSIP_WEBSUB_SECRET`                   | `hub.secret` value for MOSIP WebSub                                         |
| `MOSIP_WEBSUB_TOPIC`                    | `hub.topic` value for MOSIP WebSub                                          |
