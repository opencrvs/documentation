# Verifiable Credentials

### 1. Introduction

A verifiable credential (VC) is a digital credential that asserts claims about a civil registration event — currently a **birth** — and can be cryptographically verified by a third party without contacting OpenCRVS.

In OpenCRVS, a VC:

* Is derived from a **registered** event record.
* Is digitally signed on behalf of the issuing authority, so that any tampering can be detected.
* Can be designed to reveal only the minimum data needed for a given use case (selective disclosure), where the chosen credential format supports it.

**OpenCRVS issues verifiable credentials. It does not hold or verify them.** Once a credential has been issued, the holder (the requester and their wallet or app) controls how and where it is presented, and relying parties verify it against the issuer's published keys. OpenCRVS is not in the loop at presentation or verification time.

Verifiable credentials **complement** paper certificates rather than replacing them. They provide a reusable, digital way to prove that a vital event has been registered, usable across multiple services.

#### What the reference implementation supports

The reference implementation supports issuance of birth credentials, from a registered birth record, in two forms:

* **Digital credential** — a credential offer the requester consumes into their own wallet or VC app, for example by scanning a QR code or opening a link. This form can support selective disclosure (sharing only selected attributes).
* **Paper credential** — a signed credential rendered onto a printed or PDF document the requester can carry, and verify offline.

Both forms are issued on demand by an authorised user, in the same way they would issue a certified copy, and both derive their data from the same authoritative registered record.

***

### 2. Feature overview

Verifiable credentials give a country a portable, digital proof of registration that can be reused across many services and channels, without sharing the full underlying record.

The feature lets you:

* Issue a **digital** proof of a registered birth that the requester loads into their own wallet or VC app.
* Issue a **paper** proof of a registered birth, signed and renderable onto a document.
* Guarantee authenticity through digital signatures tied to an issuer you operate.
* Share only selected attributes, where the credential form supports selective disclosure (the digital form does; the paper form carries a fixed set of attributes).
* Support reuse across multiple relying parties — schools, health facilities, social protection programmes — each verifying independently.
* Record issuance in the audit trail, alongside certificates and other record actions.

Verifiable credentials are:

* **Digital-by-design** — intended for wallets, apps, and online services (with the paper form bridging to offline use).
* **Complementary to certificates** — they do not replace paper, but offer a more convenient, machine-verifiable option.
* **Policy-driven** — your configuration decides which data is exposed, who may issue, and (for the wider vision) how status is handled.

***

### 3. What a birth verifiable credential contains

A credential issued from OpenCRVS encodes a small, deliberately minimal set of claims drawn from the registered record. In the reference implementation a birth credential carries the **registration number**, the child's **given and family names**, and the **date of birth**.

The credential also carries issuer and lifecycle information:

* **Subject identifier.** The subject is identified by an identifier that is consistent for a given record but **pseudonymous** — it does not expose OpenCRVS's internal database identifiers.
* **Credential identifier.** Each issuance gets its own unique identifier, so re-prints and re-issues are independently traceable in the audit trail.
* **Expiry.** A credential expires **365 days** after issuance by default. This window is configurable.
* **Issuer.** The credential is signed by the issuer **you** operate (see §7).

> **Adapt the claim set to your context.** The fields above match the reference birth schema. Adjust them to match your own event declaration schema, your national legal requirements, and your data-minimisation policy before going to production.

***

### 4. When a verifiable credential is issued

Verifiable credentials are issued only for **registered** records.

#### On demand after registration

An authorised user opens a registered birth record and chooses to issue a credential, much as they would issue a certified copy. They can issue the digital form, the paper form, or both. This is the only trigger in the reference implementation.

#### Planned triggers

The following are part of the feature vision but are **not** in the reference implementation:

* _Planned —_ **On registration.** When a record first reaches _Registered_ status, a credential could be issued automatically (for example, emailed to the informant).
* _Planned —_ **As part of a service flow.** For example, when a parent applies for a digital benefit, the system could request or verify a child's birth credential as part of that flow.

***

### 5. Issuance and verification

#### 5.1 Issuance — the registration-office view

From the perspective of registration staff, issuing a credential is similar to printing a certificate:

1. An authorised user opens a **Registered** birth record.
2. They select the credential action — the **digital** VC action or the **paper** VC action.
3. A configured **template** determines which fields are included and how the credential is structured.
4. OpenCRVS derives the credential from the record and signs it through the issuer you operate:
   * The **digital** form produces a credential **offer** the requester consumes — for example, a QR code scanned into a wallet, or a link.
   * The **paper** form produces a signed credential that can be rendered onto a printed or PDF document.
5. The issuance is written to the **audit trail**, just like certificates and other actions.

Once a digital credential has been issued for a record, the record is marked accordingly (see §6), which prevents the digital credential action from being offered again for the same record.

#### 5.2 Verification — the relying-party view

Relying parties (schools, health facilities, social protection agencies) verify a credential without contacting OpenCRVS, by:

* Scanning a QR code on a printed or digital document, or
* Loading the credential into a wallet or web-based verifier.

The verifier checks that:

* The credential's **signature** is valid.
* It was issued by a **trusted issuer** — one whose keys the verifier recognises, published by you.
* The credential has **not expired**.

This lets a service trust the registration without calling OpenCRVS for every check or storing a full copy of the civil registration record.

> **Status and revocation are not provided out of the box.** The reference implementation enforces **expiry**, but does **not** include a revocation or status-list mechanism. If your policy requires the ability to invalidate a credential before it expires — for example after a correction or revocation of the underlying registration — that status infrastructure is part of the issuer environment **you** design and operate. Treat revocation as _Configurable / implementer-provided_, not as a built-in feature.

***

### 6. What you can configure

The feature is policy-driven: configuration decides who can issue credentials, what they contain, and where they are signed. The points below describe _what_ is configurable and why it matters; the [technical guide](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/integrations/verifiable-credentials) covers exactly how to set each one.

* **Who can issue.** Issuing the digital credential is a permissioned action, so you decide which roles can see and submit it, and for which events. In the reference implementation that is limited to birth.
* **Issue-once behaviour.** A record is marked once a digital credential has been issued, which stops the action being offered again and prevents accidental duplicate issuance. Deliberate re-issues are still possible and remain individually traceable in the audit trail, because each issuance mints a fresh credential identifier.
* **What the credential contains.** The claim set, the subject identifier, and the 365-day expiry are all defined in editable templates — one for the digital (selective-disclosure) form and one for the paper form. This is where you align the credential with your event schema, legal requirements, and data-minimisation policy.
* **Where signing happens.** OpenCRVS calls out to an issuer **you operate** to sign each credential. You point it at your own signing endpoints via configuration.

> **OpenCRVS does not provide, host, or manage credential issuers.** Key generation, certificate management, DID-document hosting, status/revocation infrastructure, and the overall security of the issuer are the implementer's responsibility. The demo issuer referenced in the technical guide exists only for local development and must not be used in production.

***

### 7. Relationship to certificates and identifiers

Verifiable credentials sit **alongside** existing OpenCRVS outputs and identifiers rather than replacing them:

* **Certificates / certified copies** remain the paper or PDF representation endorsed by the registration authority, and remain important for many legal and operational processes.
* **Identifiers** — the tracking ID, registration number, and (where integrated) national ID — identify the record and, where appropriate, the person. The reference birth credential carries the **registration number** as its core identifier, which lets a credential be cross-checked against both the paper certificate and the underlying digital record in OpenCRVS.

A credential **may** also carry a national ID where policy permits, to link the digital proof back to a person — but this is a policy decision for the implementer, governed by data-protection law.

***

### 8. Example use cases

Representative uses for birth credentials issued from OpenCRVS:

* **Proving birth for school enrolment.** A parent presents a birth credential to a school, which verifies authenticity without needing the paper certificate.
* **Accessing health and nutrition services.** A health provider verifies a child's birth and age to determine eligibility.
* **Social protection enrolment.** An agency verifies a registered birth digitally to establish or update benefit eligibility.
* **Cross-border services.** With appropriate agreements, a credential could help prove an event to another country's systems, reducing manual document exchange.

***

### 9. Setting it up

The functional behaviour described here is delivered through country configuration. The step-by-step setup — roles and scopes, the issue-once flag, the credential templates, the issuer environment variables, and the Farajaland reference files to start from — is documented in the technical guide:

[Verifiable credentials integration →](https://documentation.opencrvs.org/v2.0/technical/guides/configuration/integrations/verifiable-credentials)
