---
description: >-
  Authenticating with your client details to retrieve an access token using
  OAuth 2.0
---

# Authenticate a client

Now that you have created a client, when you want to perform an API request you must first authenticate and receive an OpenCRVS access token. The token endpoint is OAuth 2.0 compliant.

Client access tokens are valid for a maximum of 10 minutes. After it expires you must authenticate again to retrieve a new access token.



**URL**

`POST https://auth.<your_domain>/token`

**Request payload**

| Parameter       | Type   | Description                                |
| --------------- | ------ | ------------------------------------------ |
| `client_id`     | string | The unique identifier for your client      |
| `client_secret` | string | The secret key associated with your client |
| `grant_type`    | string | Must be set to `client_credentials`        |

**Example request body**

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
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6Ikp..."
}
```

The token is a JWT and must be included as a header `Authorization: Bearer <token>` in all future API requests. The content of an OpenCRVS access token looks like this:
