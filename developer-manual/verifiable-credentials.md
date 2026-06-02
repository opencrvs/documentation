# Verifiable credentials

## Verifiable Credentials

> **Current scope:** Birth events only.

OpenCRVS supports two distinct issuance paths: 1) a **digital** SD-JWT / OID4VC credential delivered via a QR code link for digital wallets, and a **paper** raw JWT credential embedded as a QR code on printed birth certificates.

The platform does **not** include a credential issuer. It delegates signing to external issuer endpoints and simply relays the response. This keeps the signing key material outside OpenCRVS deployment.

### 1. Architecture overview

Country-config routes in routes.ts:

* `POST /verifiable-credentials/credential-offer`
* `POST /verifiable-credentials/paper-credential`
* `POST /_demo-issuer/...` (example responses for dev only)

**Two separate external issuer URLs are configured**:

| Environment variable                      | Purpose                                               |
| ----------------------------------------- | ----------------------------------------------------- |
| `VERIFIABLE_CREDENTIALS_SDJWT_ISSUE_URL`  | SD-JWT / OID4VC credential offers for digital wallets |
| `VERIFIABLE_CREDENTIALS_RAW_JWT_SIGN_URL` | Raw JWT signing for paper certificate QR codes        |

### 2. Digital VC (SD-JWT / OID4VC) - issuance flow

This path produces an `openid-credential-offer://` URI that a citizen scans with a compliant digital wallet.

#### 2.1 Trigger

A registrar opens a **REGISTERED** birth record and selects **"Issue a verifiable credential"** from the action menu. The action is defined in `issue-birth-credential-action.ts` and uses `customActionType: 'ISSUE_VERIFIABLE_CREDENTIAL'`.

#### 2.2 Guard conditions

* The action is **enabled** only when the `vc-issued` flag is absent.
* The action is **visible** only when the record status is `REGISTERED` and `vc-issued` is absent.
* The `vc-issued` flag is added to the record when the action is submitted, preventing re-issuance.

#### 2.3 Form configuration

#### 2.4 SD-JWT payload template

### 3. Paper VC (raw JWT) - issuance flow

This path produces a signed JWT that is rendered as a QR code directly on the printed birth certificate for offline verification.

#### 3.1 Trigger

When a registrar initiates **"Print" → "Birth Certificate"**, the print form is opened. The `print-birth-credential-action.ts` module injects two hidden fields into the **Collect Payment** page of the print workflow.

#### 3.2 Hidden field sequence

1. **`verifiable-credential-creation-http-request`** (FieldType.HTTP) — Automatically fires a POST to `PAPER_CREDENTIAL_HANDLER_URL` → `POST /api/countryconfig/verifiable-credentials/paper-credential`.
2. **`verifiable-credential`** (FieldType.ALPHA\_HIDDEN) — Stores the result at `data.credential_qr` (a data URL of the QR code).

Both fields use `DISPLAY_ON_REVIEW` with `never()` to remain invisible throughout the UI.

#### 3.3 Certificate rendering

The birth certificate SVG template references the credential QR code via a handlebar expression:

```svg
<image xlink:href="{{ $lookup ($action "PRINT_CERTIFICATE") "annotation.verifiable-credential" }}" />
```

The `$lookup` helper retrieves the `verifiable-credential` annotation from the `PRINT_CERTIFICATE` action, which contains the QR code data URL.

#### 3.4 Form configuration

#### 3.5 Paper VC payload template

**Notable design choices:**

* The **subject DID** is deterministic (UUID v5 of the registration number) but pseudonymous - it does not leak internal database IDs. Prefix: `urn:farajaland:paper-birth-subject:` / namespace: `b8be09fa-a9b9-4b9f-8d15-40f4696e9f8e`.
* The **credential ID** (`id`) is a fresh UUID per issuance so that re-prints are independently traceable.
* **Expiry** is 365 days from issuance.

### 4. Role-based access

Scope definition in `roles.ts`:

```typescript
{ type: 'record.custom-action', options: { event: ['birth'], customActionTypes: ['ISSUE_VERIFIABLE_CREDENTIAL'] } }
```

### 5. Event flagging

A `vc-issued` flag is defined in the birth event configuration:

```typescript
flags: [{ id: 'vc-issued', label: 'Verifiable Credential issued' }]
```

The flag:

* Prevents the digital VC action from being shown again after issuance.
* Is set when the `ISSUE_VERIFIABLE_CREDENTIAL` action is submitted.

***

### 6. Farajaland deployment configuration

#### Environment variables

| Variable                                  | Default (dev)                                              | Production (Helm override)                                |
| ----------------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------- |
| `VERIFIABLE_CREDENTIALS_SDJWT_ISSUE_URL`  | `http://localhost:3040/_demo-issuer/openid4vc/sdjwt/issue` | `https://proxy.issuer.opencrvs.dev/openid4vc/sdjwt/issue` |
| `VERIFIABLE_CREDENTIALS_RAW_JWT_SIGN_URL` | `http://localhost:3040/_demo-issuer/raw/jwt/sign`          | `https://proxy.issuer.opencrvs.dev/raw/jwt/sign`          |

### 7. [Farajaland issuer deployment](https://github.com/opencrvs/verifiable-credential-issuer)

Farajaland uses Walt.id to issue VCs. The issuer service is not deployed within the Farajaland deployment - the infrastructure is not yet properly secured and the setup is maintained separately.

#### Proxy

The repository includes a Node.js & Bun proxy. It adds an `issuerKey` for the issuance calls. Walt.id then signs the VCs with this key. This key corresponds to the `did:web` (see **DID** below). The digital VC also includes an `x5c` chain. Inji does not support SD-JWT VCs with `did:web`, so the configuration was patched to use an `x5c` certificate instead. The certificate must match the one specified in `verifier2-api/config/verifier-service.conf` in the same repository and deployment. That file also documents how the certificate is generated.

```sh
provision@issuer-walt-id:/opt/waltid-identity/docker-compose/verifier-api2/config$ ls
dev-mode.conf  _features.conf  verifier-service.conf  web.conf
```

#### DID

Both credential types use `did:web:issuer.opencrvs.dev` as the issuer DID. This DID method relies on the domain `issuer.opencrvs.dev` serving a DID document at `/.well-known/did.json`. This is served via `Caddyfile` in the repository.

#### Walt.id

You can check Walt.id configuration in `infrastructure/waltid-identity`. It includes environment variable changes but also changes that make the wallet experience prettier.

To-do:

* Walt.id [now supports](https://github.com/walt-id/waltid-identity/issues/1591) expiration & other JWT attributes in raw JWT signing since v0.18.2. It is unclear whether the currently deployed version includes these attributes in the paper VC; the **demo portals** (see **Demo portals** below) do not validate for them either.
* Walt.id [now supports](https://github.com/walt-id/waltid-identity/issues/1693) top-level `display` in the issuer-api config. This should improve the wallet experience but has not yet been configured.

### 8. [Farajaland demo portals](https://github.com/opencrvs/farajaland-demo-portals)

A demo portal that can verify paper and digital VCs using **offline verification** (JavaScript JWT check with public key) and **online verification** (connects to `issuer.opencrvs.dev`).
