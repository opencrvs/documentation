# Verifiable Credentials

{% hint style="warning" %}
This guide covers the **country-configuration side** of issuing Verifiable Credentials (VCs). Setting up a credential issuer, managing signing keys, hosting DID documents, and operating verification infrastructure are **out of scope** and the responsibility of the implementer. OpenCRVS does **not** include a credential issuer; it delegates signing to external endpoints and simply relays the response. Signing key material never enters the OpenCRVS deployment.
{% endhint %}

OpenCRVS supports two issuance paths for **birth events**:

* **Digital VC (SD-JWT / OID4VC)** — delivered as an `openid-credential-offer://` URI that a citizen scans with a compliant digital wallet.
* **Paper VC (raw JWT)** — a signed JWT rendered as a QR code on printed birth certificates for offline verification.

***

#### 1. Architecture overview

Country-config routes (defined in `routes.ts`):

| Endpoint                                        | Purpose                                                |
| ----------------------------------------------- | ------------------------------------------------------ |
| `POST /verifiable-credentials/credential-offer` | SD-JWT / OID4VC credential offer for digital wallets   |
| `POST /verifiable-credentials/paper-credential` | Raw JWT signing for paper certificate QR codes         |
| `POST /_demo-issuer/...`                        | Example responses for development (not for production) |

Two separate external issuer URLs must be configured:

| Environment variable                      | Purpose                                               |
| ----------------------------------------- | ----------------------------------------------------- |
| `VERIFIABLE_CREDENTIALS_SDJWT_ISSUE_URL`  | SD-JWT / OID4VC credential offers for digital wallets |
| `VERIFIABLE_CREDENTIALS_RAW_JWT_SIGN_URL` | Raw JWT signing for paper certificate QR codes        |

The platform forwards the request payload to the configured issuer URL and relays the signed response back. No signing or key material is handled within OpenCRVS.

***

#### 2. Digital VC (SD-JWT / OID4VC) — issuance flow

This path produces an `openid-credential-offer://` URI that a citizen scans with a compliant digital wallet.

**2.1 Trigger**

A registrar opens a **REGISTERED** birth record and selects **"Issue a verifiable credential"** from the action menu. The action is defined with `customActionType: 'ISSUE_VERIFIABLE_CREDENTIAL'`.

**2.2 Guard conditions**

* The action is **enabled** only when the `vc-issued` flag is absent.
* The action is **visible** only when the record status is `REGISTERED` and `vc-issued` is absent.
* The `vc-issued` flag is added to the record when the action is submitted, preventing re-issuance.

**2.3 Form configuration**

[issue-birth-credential-action.ts](https://github.com/opencrvs/opencrvs-farajaland/blob/release-v2.0.0/src/verifiable-credentials/issue-birth-credential-action.ts)

The form follows a step-by-step flow controlled by conditionals — most fields are hidden until the previous step completes.

The registrar first selects who is requesting the VC (Mother / Father / Informant). Their details from the record are shown in a read-only DATA field. The registrar then clicks **Generate**, which triggers an HTTP request to the country-config endpoint. The endpoint delegates signing to the external issuer and returns a QR code. Once the QR code is displayed, the registrar must check a confirmation box to acknowledge the citizen accepted the offer before the action can be submitted.

Note that the `flags` array in the reference implementation is commented out. The `vc-issued` flag is defined in the event configuration (see section 5) — how it gets set when the action is submitted depends on your implementation.

**2.4 SD-JWT payload template**

[birth-credential-template.ts](https://github.com/opencrvs/opencrvs-farajaland/blob/release-v2.0.0/src/verifiable-credentials/birth-credential-template.ts)

The template maps declaration data into the SD-JWT claim set that gets sent to `VERIFIABLE_CREDENTIALS_SDJWT_ISSUE_URL`.

`credentialConfigurationId` must match an OID4VC configuration registered on the issuer side (the reference uses `crvs_birth_v1`). The `authenticationMethod` is `PRE_AUTHORIZED` — the QR code contains a pre-authorisation token so the wallet can redeem the credential without additional login.

The `selectiveDisclosure` block controls which fields are SD-JWT disclosable. Fields marked with `sd: true` can be selectively revealed or withheld by the holder when presenting the credential.

Hardcoded values in the template (such as `place_of_birth.name: 'Chamakubi Health Post, Ibombo, Central'`) are Farajaland examples and must be replaced with your country's data mapping.

***

#### 3. Paper VC (raw JWT) — issuance flow

This path produces a signed JWT that is rendered as a QR code directly on the printed birth certificate for offline verification.

**3.1 Trigger**

When a registrar initiates **"Print" → "Birth Certificate"**, the print form opens. The `print-birth-credential-action.ts` module injects two hidden fields into the **Collect Payment** page of the print workflow.

**3.2 Hidden field sequence**

1. **`verifiable-credential-creation-http-request`** (`FieldType.HTTP`) — automatically fires a POST to `PAPER_CREDENTIAL_HANDLER_URL` → `POST /api/countryconfig/verifiable-credentials/paper-credential`.
2. **`verifiable-credential`** (`FieldType.ALPHA_HIDDEN`) — stores the result at `data.credential_qr` (a data URL of the QR code).

Both fields use `DISPLAY_ON_REVIEW` with `never()` to remain invisible throughout the UI.

**3.3 Certificate rendering**

The birth certificate SVG template references the credential QR code via a handlebars expression:

```svg
<image xlink:href="{{ $lookup ($action "PRINT_CERTIFICATE") "annotation.verifiable-credential" }}" />
```

The `$lookup` helper retrieves the `verifiable-credential` annotation from the `PRINT_CERTIFICATE` action, which contains the QR code data URL.

**3.4 Form configuration**

[print-birth-credential-action.ts](https://github.com/opencrvs/opencrvs-farajaland/blob/release-v2.0.0/src/verifiable-credentials/print-birth-credential-action.ts)

This module exports two hidden fields that are injected into the **Collect Payment** page of the print workflow. The field chaining is straightforward: the HTTP field fires automatically on page load, and the ALPHA\_HIDDEN field reads the QR code data URL from the response. Both use `DISPLAY_ON_REVIEW` with `never()` to stay invisible.

**3.5 Paper VC payload template**

[paper-birth-credential-template.ts](https://github.com/opencrvs/opencrvs-farajaland/blob/release-v2.0.0/src/verifiable-credentials/paper-birth-credential-template.ts)

Three constants at the top of the file must be customised per country:

* `PAPER_BIRTH_SUBJECT_DID_PREFIX` — the DID prefix for the credential subject (e.g. `urn:farajaland:paper-birth-subject:`).
* `PAPER_BIRTH_SUBJECT_DID_NAMESPACE` — a UUID v5 namespace used to derive a deterministic, pseudonymous subject DID from the registration number.
* `PAPER_BIRTH_ISSUER_DID` — must match the issuer's DID (e.g. `did:web:issuer.opencrvs.dev`).

The `mapping` object uses placeholder strings (`'<uuid>'`, `'<timestamp-seconds>'`, `'<timestamp-in-seconds:365d>'`) that the country-config route replaces with real values at issuance time. The `credentialSubject` fields (`rn`, `gn`, `fn`, `dob`) map the registration number, child names, and date of event — adjust these to match your event declaration schema and legal requirements.

**3.6 Notable design choices**

* The **subject DID** is deterministic (UUID v5 of the registration number) but pseudonymous — it does not leak internal database IDs. The prefix and namespace are configurable in the template.
* The **credential ID** is a fresh UUID per issuance so that re-prints are independently traceable.
* **Expiry** is set in the payload template (reference implementation uses 365 days from issuance).

***

#### 4. Role-based access

The `ISSUE_VERIFIABLE_CREDENTIAL` custom action requires the following scope in your `roles.ts`:

```typescript
{ type: 'record.custom-action', options: { event: ['birth'], customActionTypes: ['ISSUE_VERIFIABLE_CREDENTIAL'] } }
```

***

#### 5. Event flagging

Define a `vc-issued` flag in the birth event configuration:

```typescript
flags: [{ id: 'vc-issued', label: 'Verifiable Credential issued' }]
```

The flag:

* Prevents the digital VC action from being shown again after issuance.
* Is set when the `ISSUE_VERIFIABLE_CREDENTIAL` action is submitted.

***

#### 6. Environment variables

Configure the following environment variables for your country config deployment:

| Variable                                  | Development (example)                                      | Production                                           |
| ----------------------------------------- | ---------------------------------------------------------- | ---------------------------------------------------- |
| `VERIFIABLE_CREDENTIALS_SDJWT_ISSUE_URL`  | `http://localhost:3040/_demo-issuer/openid4vc/sdjwt/issue` | `https://<your-issuer-domain>/openid4vc/sdjwt/issue` |
| `VERIFIABLE_CREDENTIALS_RAW_JWT_SIGN_URL` | `http://localhost:3040/_demo-issuer/raw/jwt/sign`          | `https://<your-issuer-domain>/raw/jwt/sign`          |

{% hint style="info" %}
The issuer URLs must point to infrastructure that **you** operate. OpenCRVS does not provide, host, or manage credential issuers. Key generation, certificate management, DID document hosting (`/.well-known/did.json`), and overall issuer security are the implementer's responsibility.
{% endhint %}

***

#### 7. Reference files

All files referenced above live in the [Farajaland reference country configuration repository](https://github.com/opencrvs/opencrvs-farajaland/tree/release-v2.0.0/src/verifiable-credentials). Use them as a starting point for your own implementation:

| File                                                            | Purpose                       |
| --------------------------------------------------------------- | ----------------------------- |
| `src/verifiable-credentials/routes.ts`                          | Endpoint registration         |
| `src/verifiable-credentials/issue-birth-credential-action.ts`   | Digital VC form configuration |
| `src/verifiable-credentials/birth-credential-template.ts`       | SD-JWT payload template       |
| `src/verifiable-credentials/print-birth-credential-action.ts`   | Paper VC form configuration   |
| `src/verifiable-credentials/paper-birth-credential-template.ts` | Raw JWT payload template      |
