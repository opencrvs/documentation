# Access proxy example: Cloudflare Access with Google

This page shows how to put an access proxy in front of an OpenCRVS web application. The access proxy authenticates users with an external identity provider (IdP) before their requests reach OpenCRVS. This is one of the controls described in [Why VPN?](why-vpn.md) for deployments that are reachable from the public internet.

The example uses Cloudflare Access as the access proxy and Google as the IdP. Cloudflare Access lets only authenticated users with an allowed email address reach the application.

This setup protects the network path to the application. It does not change how users sign in to OpenCRVS. Users still sign in to OpenCRVS with their OpenCRVS account after they pass the access proxy.

## Why this example uses Cloudflare and Google

Cloudflare Access and Google are used here because they are popular, widely used services. Many large organisations, including government ministries, already have a Google Workspace or Cloudflare account. They can follow this example without buying or installing new software. Cloudflare also offers a Free plan for up to 50 users, which makes the example easy to try.

The pattern does not depend on these products. OpenCRVS does not require them, and the OpenCRVS deployment scripts do not configure them.

{% hint style="info" %}
**Vendor neutrality.** The OpenCRVS team does not recommend any third-party product. We stay agnostic to the choice of identity provider, access proxy and WAF. The products named on this page are examples, not endorsements or supported options. Choose the products that meet your country's security, procurement and data-residency requirements.
{% endhint %}

## Open source alternatives

An access proxy and an IdP are two separate roles. You can replace each of them with an open source product, and you can self-host both inside your own infrastructure.

| Role | Cloudflare example | Open source alternatives |
| --- | --- | --- |
| Identity provider (IdP). Authenticates users. | Google | [Keycloak](https://www.keycloak.org/), [Authentik](https://goauthentik.io/), [Dex](https://dexidp.io/) |
| Access proxy. Allows or denies requests based on the IdP result. | Cloudflare Access | Authentik with its proxy outpost, [OAuth2 Proxy](https://oauth2-proxy.github.io/oauth2-proxy/) or [Pomerium](https://www.pomerium.com/), in front of Traefik or as a Traefik `forwardAuth` middleware |

For example:

* **Authentik** can act as both the IdP and the access proxy. Its proxy outpost enforces authentication in front of the application.
* **Keycloak** is an IdP. Pair it with an access proxy such as OAuth2 Proxy to protect the application.

The steps on this page are specific to Cloudflare Access and Google. If you use open source products, the flow and the checks stay the same: authenticate the user, check an allow policy, and make sure the origin cannot be reached without going through the proxy. Follow the documentation of your chosen products for the configuration.

{% hint style="info" %}
Self-hosted products do not hide your origin IP address and do not absorb DDoS attacks as a cloud service does. You also operate and patch them yourself. Combine them with the controls in [IP Allowlisting](ip-allowlisting.md), [Kubernetes Network Policy](kubernetes-network-policy.md) and [Ubuntu Firewall configuration](ubuntu-firewall-configuration.md).
{% endhint %}

## How it works

1. A user opens `https://<application-hostname>`. Cloudflare looks for a valid `CF_Authorization` cookie. The cookie is not present.
2. Cloudflare sends the user to `https://<team>.cloudflareaccess.com`. Cloudflare then sends the user to the Google sign-in page.
3. The user signs in with Google.
4. Google sends the user to `https://<team>.cloudflareaccess.com/cdn-cgi/access/callback`.
5. Cloudflare checks the Access policy. If the policy allows the user, Cloudflare sets the `CF_Authorization` cookie and sends the user to the application.
6. For each next request, Cloudflare validates the cookie. Cloudflare adds the `Cf-Access-Jwt-Assertion` header and sends the request to the origin.

## Prerequisites

* A Cloudflare account with Zero Trust enabled. The Free plan is sufficient for up to 50 users.
* The DNS record of the application is **Proxied** (orange cloud) in Cloudflare.
* A Google Cloud project.

## Step 1: Get the Cloudflare team domain

1. Open the Cloudflare dashboard. Go to **Zero Trust**.
2. Create an organization if none exists. The team name becomes `<team>.cloudflareaccess.com`.
3. Write down the team domain. You need it in the next step.

## Step 2: Create the Google OAuth client

1. Open the [Google Cloud Console](https://console.cloud.google.com/). Select your project.
2. Go to **Google Auth Platform → Branding**. Set:
   * **App name**
   * **User support email**
   * **Authorized domains**: `cloudflareaccess.com`
3. Go to **Data Access**. Add these scopes:
   * `openid`
   * `.../auth/userinfo.email`
   * `.../auth/userinfo.profile`
4. Go to **Audience**. Select the user type:
   * **Internal**: Only accounts of your Google Workspace organization can sign in.
   * **External**: Any Google account can sign in. In the **Testing** status, only accounts on the **Test users** list can sign in.
5. Go to **Clients → Create client**. Set:
   * **Application type**: `Web application`
   * **Authorized redirect URI**: `https://<team>.cloudflareaccess.com/cdn-cgi/access/callback`
6. Save the **Client ID** and the **Client secret**. Do not put the secret in documents, chat, or Git.

## Step 3: Add Google as an identity provider in Cloudflare

Use the generic **OpenID Connect** provider type. Do not use the built-in **Google** type (see [Troubleshooting](access-proxy-example-cloudflare-access.md#troubleshooting)).

1. In Zero Trust, go to **Settings → Authentication → Login methods → Add new**.
2. Select **OpenID Connect**.
3. Set:

| Field | Value |
| --- | --- |
| Name | `Google OIDC` |
| App ID | Google Client ID |
| Client secret | Google Client secret |
| Auth URL | `https://accounts.google.com/o/oauth2/v2/auth` |
| Token URL | `https://oauth2.googleapis.com/token` |
| Certificate URL | `https://www.googleapis.com/oauth2/v3/certs` |
| PKCE | On |
| Email claim | `email` |
| Scopes | `openid`, `email`, `profile` |

4. Click **Save**. Click **Test**.
5. Sign in with Google. The result page must show your email address.

## Step 4: Create the Access application and policy

1. Go to **Access controls → Applications → Add an application → Self-hosted**.
2. Set:
   * **Application name**: a name of your choice
   * **Public hostname**: the hostname of the application
   * **Accepted identity providers**: `Google OIDC` only
3. Create a policy:
   * **Action**: `Allow`
   * **Include**: selector **Emails ending in**, value `@example.org`
4. Make sure the policy is attached to the application.
5. Save the application.

{% hint style="warning" %}
Use the `@` character in the **Emails ending in** value. Without it, the rule does not match.
{% endhint %}

## Step 5: Enable instant authentication

1. Open the application settings.
2. Turn on **Instant Auth**. This option is available when only one identity provider is selected.
3. Save the application.

Users now go directly to the Google sign-in page. They do not see the Cloudflare login page.

## Step 6: Test

1. Open a **new private window**.
2. Go to `https://<application-hostname>`.
3. Sign in with an allowed account. The application opens. The `CF_Authorization` cookie is set.
4. Open another new private window. Sign in with an account that is not allowed. Cloudflare shows **That account does not have access**.

## Step 7: Restrict access to the origin

Cloudflare Access protects only requests that go through Cloudflare. If the origin IP address is reachable directly, users can bypass Access.

* Allow only [Cloudflare IP ranges](https://www.cloudflare.com/ips/) on the origin firewall. See [IP Allowlisting](ip-allowlisting.md).
* Optional: Validate the `Cf-Access-Jwt-Assertion` header in the application. Use the public keys from `https://<team>.cloudflareaccess.com/cdn-cgi/access/certs`.

## Troubleshooting

| Symptom | Cause | Solution |
| --- | --- | --- |
| Cloudflare shows `Unable to find the requested identity provider`. | The test ran before the provider was saved, or from a stale page. | Save the provider. Reload the page. Click **Test** in the list. |
| Cloudflare shows `User email was not returned. API permissions are likely incorrect.` The Google consent screen asks for the email address. | The built-in **Google** provider type does not get the email address in this setup. | Delete it. Use the **OpenID Connect** provider type (Step 3). |
| A user cannot sign in with Google. The OAuth app is **External** in **Testing** status. | The user is not on the **Test users** list. | Add the user to **Test users**. Or publish the app. |
| Google does not let you publish the app. | Branding data is missing. | Set the app name, support email, home page, privacy policy link, and authorized domains in **Branding**. |
| Cloudflare shows `That account does not have access`, but the policy is correct. | The private window keeps an old denied session. | Close all private windows. Open a new one. |
