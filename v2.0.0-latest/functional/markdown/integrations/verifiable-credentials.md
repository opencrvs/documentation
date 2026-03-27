# Verifiable Credentials

**AI dump - based on ed briefing document and github tickets.**

### 1. Introduction

A **verifiable credential (VC)** is a digital credential that asserts claims about a civil event (for example, a birth or death) and can be **cryptographically verified** by others.

In OpenCRVS, a VC:

* Is derived from a **registered event record**.
* Is **digitally signed** on behalf of the issuing authority so that tampering can be detected.
* Can be designed to reveal only the **minimum necessary data** for a given use case (selective disclosure, where supported by the chosen VC stack).

OpenCRVS is responsible only for **issuing** verifiable credentials, not for holding or verifying them.

The record action **Issue verifiable credential**:

* Is available on **registered** records.
* Derives a VC payload from the registered event record.
* Signs it on behalf of the issuing authority.
* Creates a **VC offer** that the requester can consume with their own VC app or wallet (for example, by scanning a QR code or opening a link).

Once the VC offer has been consumed by the requester’s VC app, they control how and where the credential is presented. Verifiable credentials complement, rather than replace, paper certificates: they provide a reusable, digital way to prove that a vital event has been registered across multiple services.

***

### 2. Feature overview

Verifiable credentials provide a **portable, digital proof** of registration that can be reused across many services and channels, without sharing the full underlying record.

#### Core capabilities

With verifiable credentials, OpenCRVS supports:

* **Issuing digital proofs** of registered events (for example, birth, death, marriage) from the authoritative record.
* **Strong authenticity guarantees** using digital signatures and recognised issuers.
* **Selective data sharing** by including only the attributes needed for a given use case (where supported by the chosen VC stack).
* **Reusable verification** across multiple relying parties (for example, schools, health facilities, social protection programmes).
* **Integration with national digital identity and wallet ecosystems**, where they exist.
* **Auditability and lifecycle management** of VC issuance via the Issue verifiable credential action.

Verifiable credentials are:

* **Digital-by-design** — intended for use in apps, wallets, and online services.
* **Complementary** to certificates — they do not replace paper, but offer a more convenient digital option.
* **Policy-driven** — configuration determines what data is exposed, who can issue, and how revocation is handled.

***

### 3. What a verifiable credential represents

A VC issued from OpenCRVS typically encodes:

* **Event information**
  * Event type (for example, birth, death, marriage).
  * Key event attributes (for example, date and place of event).
* **Subject information**
  * Person(s) to whom the event relates (for example, child, deceased, spouses).
* **Registration information**
  * Registration number and date of registration.
  * Issuing authority (for example, civil registration office / registrar general).
* **Issuer information**
  * The organisation that issued the VC (for example, Ministry / CRVS authority).
  * Cryptographic material used to sign the VC.

The exact set of attributes is configurable so that countries can:

* Align with **national legal requirements**.
* Respect **privacy and data minimisation** principles.
* Support **interoperability** with other systems (for example, National ID, social protection, education).

***

### 4. When verifiable credentials are issued

Verifiable credentials are issued only for **registered** records.

Currently OpenCRVS supports the following triggers:

* **On demand after registration**
  * Authorised users can issue or reissue a VC from a registered record, similar to issuing a certified copy.

Planned triggers are:

* **On registration**
  * When a record first reaches **Registered** status, a VC can be issued automatically via email to the informant
* ~~**As part of a service flow**~~
  * ~~For example, when a parent applies for a digital benefit, the system may request or verify a VC for a child’s birth.~~

***

### 5. Issuance and verification

#### 5.1 Issuance (CRVS side)

From the perspective of registration staff, issuing a verifiable credential is similar to printing a certificate:

* An authorised user selects the **Issue verifiable credential** action on a **Registered** record.
* A configured **VC template** determines:
  * Which data fields are included.
  * How the credential is structured.
* OpenCRVS:
  * Derives the credential payload from the record.
  * Signs it with the configured issuer keys.
  * Produces one or more **presentation options**, such as:
    * A **QR code** that can be scanned into a wallet or verifier app.
    * A **VC file** or link that can be shared electronically.

Issuance events are written to the **audit trail**, just like certificates and other actions.

#### 5.2 Verification (relying party side)

Relying parties (for example, schools, health facilities, social protection agencies) can verify a VC by:

* Scanning a **QR code** on a printed or digital document.
* Loading the VC into a **wallet** or web-based verifier.

The verifier checks that:

* The credential’s **signature** is valid.
* It was issued by a **trusted authority** (key recognised in the trust list).
* The credential has not been **revoked** or expired, according to configured rules.

This allows services to trust the event registration without:

* Calling OpenCRVS directly in every case.
* Storing full copies of the civil registration record.

***

### 6. Relationship to certificates and UINs

Verifiable credentials sit alongside existing outputs and identifiers:

* **Certificates / certified copies**
  * Provide a **paper** or PDF representation endorsed by the civil registration authority.
  * Are still important for many legal and operational processes.
* **UINs (Tracking ID, Registration number, National ID)**
  * Identify the **record** and, where integrated, the **person**.
  * Can be included in a verifiable credential to link digital proofs back to the underlying registration.

A VC can include:

* The **registration number** as a core identifier.
* Optionally, a **National ID** (if appropriate and allowed by policy).

This makes it possible to cross-check between:

* The VC,
* The paper certificate, and
* The underlying digital record in OpenCRVS.

***

### 7. Configuration overview

Configuration for verifiable credentials includes:

* **Issuers and keys**
  * Which authority (organisation) issues VCs.
  * Cryptographic keys used for signing.
  * Trust framework (how verifiers know which issuers to trust).
* **Credential schemas / templates**
  * Which data fields are included for each event type (for example, Birth VC vs Death VC).
  * How data is mapped from the OpenCRVS record to the VC payload.
* **Issuance rules**
  * When a VC can be issued (for example, only when status = Registered).
  * Which users/roles can issue or reissue credentials.
  * Whether issuance is automatic or via an explicit action.
* **Revocation / status checks**
  * How to mark a VC as no longer valid (for example, after revocation of the underlying registration or a serious correction).
  * How verifiers can check the VC’s status (for example, via a status list or API).

These settings should be aligned with:

* National **digital identity** strategy.
* Applicable **data protection and privacy** laws.
* Cross-government **interoperability** standards, where they exist.

***

### 8. Example use cases

Potential use cases for verifiable credentials issued from OpenCRVS include:

* **Proving birth for education enrolment**
  * Parent presents a Birth VC to a school, which verifies authenticity without needing a paper certificate.
* **Accessing health and nutrition services**
  * Health provider verifies a child’s birth and age via a VC to determine eligibility.
* **Social protection enrolment**
  * Social protection agencies verify birth or death events digitally to establish or update benefit eligibility.
* **Cross-border services**
  * With appropriate agreements, a VC could be used to prove an event in another country’s systems, reducing manual document exchange.

These examples illustrate how digital proofs from OpenCRVS can reduce fraud, simplify verification, and improve access to services, while the underlying civil registration record remains authoritative and under the control of the CRVS authority.
