---
description: >-
  Authenticating with your client details to retrieve an access token using
  OAuth 2.0
---

# Authenticate a client

Now that you have created a client when you want to perform an API request, you must first authenticate and receive an OpenCRVS **access token**. The token endpoint is OAuth 2.0 compliant.

{% hint style="warning" %}
**Client access tokens are valid for a maximum of 10 minutes. After it expires you must authenticate again to retrieve a new access token.**
{% endhint %}

{% hint style="info" %}
You can use our [Postman collections](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/postman) to test all client functionality. [Postman](https://www.postman.com/) is a tool you can download to test API access before building your integrations.
{% endhint %}

**URL**

```
POST https://auth.<your_domain>/token?client_id=<client_id>&client_secret=<client_secret>&grant_type=&grant_type=client_credentials
```

#### **Request payload**

Example URL

```
https://auth.<your_domain>/token?client_id=2fd153ab-86c8-45fb-990d-721140e46061&client_secret=8636abe2-affb-4238-8bff-200ed3652d1e&grant_type=&grant_type=client_credentials
```

| Query parameter | Sample value                           | Description                                                              |
| --------------- | -------------------------------------- | ------------------------------------------------------------------------ |
| `client_id`     | `2fd153ab-86c8-45fb-990d-721140e46061` | The client id used in the authentication process for system clients.     |
| `client_secret` | `8636abe2-affb-4238-8bff-200ed3652d1e` | The client secret used in the authentication process for system clients. |
| `grant_type`    | `client_credentials`                   | The only supported grant type is client\_credentials                     |

#### **Request Response**

```
{
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6Ikp...",
}
```

The token is a [JWT](https://jwt.io/) containing with the following structure and must be included as a header:**`Authorization: Bearer <token>`** in all future API requests. The content of an OpenCRVS access token looks like this:

#### **Token Header**

| Parameter | Sample value | Description                 |
| --------- | ------------ | --------------------------- |
| `alg`     | `RS256`      | Signing algorithm.          |
| `typ`     | `JWT`        | This value is always `JWT`. |

#### **Token Payload**

| Parameter | Sample value                 | Description                                                                                                                                                                                                                                |
| --------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `scope`   | `['recordsearch']`           | An array of OpenCRVS roles for authorization permissions to access. These are defined as a feature of the OpenCRVS core. Approved scopes are `health`, `nationalId`, `ageCheck`. If you require a new scope, please open a feature request |
| `iat`     | `1593712289`                 | When the JWT was created.                                                                                                                                                                                                                  |
| `exp`     | `1594317089`                 | When the JWT expires - For clients this is set to 10 minutes by default, but this is configurable in the resources package.                                                                                                                |
| `aud`     | `['opencrvs.auth']`          | An array of services that will respond to this JWT.                                                                                                                                                                                        |
| `iss`     | `'opencrvs.auth'`            | The issuing service of the JWT.                                                                                                                                                                                                            |
| `sub`     | `'5ee75eb2104ccf88d9ac0c3d'` | A unique client id in our database.                                                                                                                                                                                                        |
