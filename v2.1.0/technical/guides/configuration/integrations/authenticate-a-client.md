---
description: >-
  Authenticating with your client details to retrieve an access token using
  OAuth 2.0
---

# Authenticate a client

Now that you have created a client, when you want to perform an API request you must first authenticate and receive an OpenCRVS access token. The token endpoint is OAuth 2.0 compliant.

Client access tokens are valid for 10 minutes by default (`CONFIG_SYSTEM_TOKEN_EXPIRY_SECONDS` on the auth service). After it expires you must authenticate again to retrieve a new access token.



**URL**

`POST https://gateway.<your_domain>/auth/token`

**Request payload**

| Parameter       | Type   | Description                                |
| --------------- | ------ | ------------------------------------------ |
| `client_id`     | string | The unique identifier for your client      |
| `client_secret` | string | The secret key associated with your client |
| `grant_type`    | string | Must be set to `client_credentials`        |

Send the parameters in the request body, either as `application/x-www-form-urlencoded` or as JSON.

{% hint style="warning" %}
Sending the parameters in the URL query string (`/auth/token?client_id=...&client_secret=...`) is deprecated and will stop working in a future release, because it exposes the client secret in gateway and proxy access logs. From OpenCRVS 2.1, such requests are rejected with `400 invalid_request` in every environment except production. In production they still work but log an error naming the parameters. If you have sent a secret this way, refresh it — it may still be in retained logs.
{% endhint %}

**Example request**

```sh
curl -X POST 'https://gateway.<your_domain>/auth/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'client_id=2fd153ab-86c8-45fb-990d-721140e46061&client_secret=8636abe2-affb-4238-8bff-200ed3652d1e&grant_type=client_credentials'
```

**Example JSON request body**

```json
{
    "client_id": "2fd153ab-86c8-45fb-990d-721140e46061",
    "client_secret": "8636abe2-affb-4238-8bff-200ed3652d1e",
    "grant_type": "client_credentials"
}
```

**Response**

```json
{
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6Ikp...",
    "token_type": "Bearer"
}
```

The token is a JWT and must be included as a header `Authorization: Bearer <token>` in all future API requests. The content of an OpenCRVS access token looks like this:

```json
{
  "scope": [
    "type=record.create&event=birth,death",
    "type=record.notify&event=birth,death"
  ],
  "userType": "system",
  "iat": 1778663757,
  "exp": 1778664357,
  "aud": [
    "opencrvs:auth-user",
    "opencrvs:user-mgnt-user",
    "opencrvs:gateway-user",
    "opencrvs:events-user",
    "opencrvs:countryconfig-user",
    "opencrvs:documents-user"
  ],
  "iss": "opencrvs:auth-service",
  "sub": "2fd153ab-86c8-45fb-990d-721140e46061"
}
```
