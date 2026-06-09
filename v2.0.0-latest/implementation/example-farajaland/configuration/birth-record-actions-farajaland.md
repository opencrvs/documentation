# Birth record actions - Farajaland

### Flags

#### Flag: `late-registration-approval-required`

* **Label:** Late registration — approval required
* **Description:** Indicates a birth declared more than 365 days after date of birth. Provincial Registrar must approve before registration can proceed.
* **Set by:** `DECLARE` @ `record.dateOfDeclaration - record.dateOfBirth > 365 days`
* **Cleared by:** `APPROVE_LATE_REGISTRATION` (always)
* **Gates:**
  * Present required: `APPROVE_LATE_REGISTRATION`
  * Absent required: `REGISTER`
* **Drives:**
  * Present: `wq:pending-late-approval`
  * Absent: —
* **Traceability:** A2.6, A4.1

***

#### Flag: `potential-duplicate`

* **Label:** Potential duplicate
* **Description:** System-generated flag when deduplication detects a possible match against existing records. Registrar must review before registration.
* **Set by:** System (deduplication engine — not an explicit action postcondition; set automatically at DECLARE/NOTIFY)
* **Cleared by:** `REVIEW_DUPLICATES` (always — Registrar marks as not-a-duplicate) or `ARCHIVE` (record confirmed as duplicate and archived)
* **Gates:**
  * Present required: —
  * Absent required: `REGISTER`
* **Drives:**
  * Present: `wq:ready-for-registration` (shown with duplicate indicator)
  * Absent: —
* **Traceability:** A11.1

***

#### Flag: `rejected`

* **Label:** Rejected
* **Description:** Record rejected by a reviewing officer. Requires re-declaration to clear.
* **Set by:** `REJECT` (always)
* **Cleared by:** `DECLARE` (always — re-declaration clears rejection)
* **Gates:**
  * Present required: —
  * Absent required: —
* **Drives:**
  * Present: `wq:requires-updates`
  * Absent: —
* **Traceability:** A5.1, A5.2

***

#### Flag: `correction-requested`

* **Label:** Correction requested
* **Description:** A correction has been requested on a registered record. Print is blocked until the correction is approved or rejected.
* **Set by:** `REQUEST_CORRECTION` (always)
* **Cleared by:** `APPROVE_CORRECTION` (always), `REJECT_CORRECTION` (always)
* **Gates:**
  * Present required: `APPROVE_CORRECTION`, `REJECT_CORRECTION`
  * Absent required: `PRINT`
* **Drives:**
  * Present: `wq:pending-correction`
  * Absent: —
* **Traceability:** A8.1, A7.3

***

#### Flag: `revoked`

* **Label:** Revoked
* **Description:** Registration has been revoked by the Registrar General. Certificates cannot be printed.
* **Set by:** `REVOKE_REGISTRATION` (always)
* **Cleared by:** `REINSTATE_REVOKED_REGISTRATION` (always)
* **Gates:**
  * Present required: `REINSTATE_REVOKED_REGISTRATION`
  * Absent required: `PRINT`, `REQUEST_CORRECTION`
* **Drives:**
  * Present: `wq:revoked-records`
  * Absent: —
* **Traceability:** A9.1, A9.3

***

#### Flag: `escalated-to-provincial`

* **Label:** Escalated to Provincial Registrar
* **Description:** Record escalated to Provincial Registrar for guidance. Record is held until response.
* **Set by:** `ESCALATE` @ `actionForm.escalate_to = 'provincial-registrar'`
* **Cleared by:** `RESPOND_TO_ESCALATION` (always — when escalation target is provincial)
* **Gates:**
  * Present required: —
  * Absent required: `REGISTER`
* **Drives:**
  * Present: `wq:escalated-to-provincial`
  * Absent: —
* **Traceability:** A10.1

***

#### Flag: `escalated-to-legal`

* **Label:** Escalated to Legal
* **Description:** Record escalated to Legal Officer for legal guidance.
* **Set by:** `ESCALATE` @ `actionForm.escalate_to = 'legal-officer'`
* **Cleared by:** `RESPOND_TO_ESCALATION` (always — when escalation target is legal)
* **Gates:**
  * Present required: —
  * Absent required: `REGISTER`
* **Drives:**
  * Present: `wq:escalated-to-legal`
  * Absent: —
* **Traceability:** A10.2

***

#### Flag: `escalated-to-rg`

* **Label:** Escalated to Registrar General
* **Description:** Record escalated to Registrar General for national-level guidance.
* **Set by:** `ESCALATE` @ `actionForm.escalate_to = 'registrar-general'`
* **Cleared by:** `RESPOND_TO_ESCALATION` (always — when escalation target is RG)
* **Gates:**
  * Present required: —
  * Absent required: `REGISTER`
* **Drives:**
  * Present: `wq:escalated-to-rg`
  * Absent: —
* **Traceability:** A10.3

***

### Actions

#### Action: `CREATE`

**Identity**

* **Kind:** core
* **Action ID:** `CREATE`

**Country deltas**

* **Configuration deltas:** platform-defaults-only
* **Traceability:** A0

***

#### Action: `NOTIFY`

**Identity**

* **Kind:** core
* **Action ID:** `NOTIFY`

**Country deltas**

* **Configuration deltas:** platform-defaults-only
* **Traceability:** A1

***

#### Action: `DECLARE`

**Identity**

* **Kind:** core
* **Action ID:** `DECLARE`

**Country deltas**

* **Postconditions:**
  * **Flags added (conditionally):**
    * `late-registration-approval-required` when `record.dateOfDeclaration - record.dateOfBirth > 365 days`
  * **Flags removed (always):** `rejected`
* **Traceability:** A2.6, A5.2

***

#### Action: `EDIT`

**Identity**

* **Kind:** core
* **Action ID:** `EDIT`

**Country deltas**

* **Configuration deltas:** platform-defaults-only
* **Traceability:** A2, A5

***

#### Action: `REJECT`

**Identity**

* **Kind:** core
* **Action ID:** `REJECT`

**Country deltas**

* **Configuration deltas:** platform-defaults-only
* **Traceability:** A5.1

***

#### Action: `ARCHIVE`

**Identity**

* **Kind:** core
* **Action ID:** `ARCHIVE`

**Country deltas**

* **Configuration deltas:** platform-defaults-only
* **Traceability:** A6

***

#### Action: `REGISTER`

**Identity**

* **Kind:** core
* **Action ID:** `REGISTER`

**Country deltas**

* **Required flags (absent):** `late-registration-approval-required`, `potential-duplicate`, `escalated-to-provincial`, `escalated-to-legal`, `escalated-to-rg`, `correction-requested`
* **Action triggers fired:** `birth-registered-informant` (notification), `birth-registered-mosip` (UIN creation — conditional on parent authentication and citizenship)
* **Traceability:** A4.1, A4.2

***

#### Action: `REQUEST_CORRECTION`

**Identity**

* **Kind:** core
* **Action ID:** `REQUEST_CORRECTION`

**Country deltas**

* **Form:** `form:correction-birth`
* **Required flags (absent):** `revoked`
* **Postconditions:**
  * **Flags added (always):** `correction-requested`
* **Traceability:** A8.1

***

#### Action: `APPROVE_CORRECTION`

**Identity**

* **Kind:** core
* **Action ID:** `APPROVE_CORRECTION`

**Country deltas**

* **Required flags (present):** `correction-requested`
* **Postconditions:**
  * **Flags removed (always):** `correction-requested`
* **Action triggers fired:** `birth-correction-mosip` (conditional — when corrected fields include child name, DOB, or sex), `birth-correction-uin-creation` (conditional — when correction adds parent authentication satisfying UIN eligibility)
* **Traceability:** A8.2, A8.3, A8.4

***

#### Action: `REJECT_CORRECTION`

**Identity**

* **Kind:** core
* **Action ID:** `REJECT_CORRECTION`

**Country deltas**

* **Required flags (present):** `correction-requested`
* **Postconditions:**
  * **Flags removed (always):** `correction-requested`
* **Traceability:** A8

***

#### Action: `PRINT`

**Identity**

* **Kind:** core
* **Action ID:** `PRINT`

**Country deltas**

* **Required flags (absent):** `correction-requested`, `revoked`
* **Traceability:** A7.1, A7.3

***

#### Action: `REVIEW_DUPLICATES`

**Identity**

* **Kind:** core
* **Action ID:** `REVIEW_DUPLICATES`

**Country deltas**

* **Configuration deltas:** platform-defaults-only
* **Traceability:** A11

***

#### Action: `APPROVE_LATE_REGISTRATION`

**Identity**

* **Kind:** custom
* **Action ID:** `APPROVE_LATE_REGISTRATION`

**Country deltas**

* **Action menu label:** Approve late registration
* **Audit label:** Late registration approved
* **Icon:** CheckCircle
* **Visible in action menu:** Y
* **Menu order:** 8
* **Form:** `form:action-confirmation-approve-late-registration`
* **Required record status:** Declared
* **Required flags (present):** `late-registration-approval-required`
* **Postconditions:**
  * **Status change:** none
  * **Flags removed (always):** `late-registration-approval-required`
* **Traceability:** A4.1, XC-LEGAL-LATE-365

***

#### Action: `ESCALATE`

**Identity**

* **Kind:** custom
* **Action ID:** `ESCALATE`

**Country deltas**

* **Action menu label:** Escalate
* **Audit label:** Escalated
* **Icon:** FileArrowUp
* **Visible in action menu:** Y
* **Menu order:** 12
* **Form:** `form:action-confirmation-escalate`
* **Required record status:** Declared
* **Postconditions:**
  * **Status change:** none
  * **Flags added (conditionally):**
    * `escalated-to-provincial` when `actionForm.escalate_to = 'provincial-registrar'`
    * `escalated-to-legal` when `actionForm.escalate_to = 'legal-officer'`
    * `escalated-to-rg` when `actionForm.escalate_to = 'registrar-general'`
* **Traceability:** A10.1, A10.2, A10.3

***

#### Action: `RESPOND_TO_ESCALATION`

**Identity**

* **Kind:** custom
* **Action ID:** `RESPOND_TO_ESCALATION`

**Country deltas**

* **Action menu label:** Respond to escalation
* **Audit label:** Escalation responded
* **Icon:** MessageCircle
* **Visible in action menu:** Y
* **Menu order:** 13
* **Form:** `form:action-confirmation-respond-to-escalation`
* **Required record status:** Declared
* **Postconditions:**
  * **Status change:** none
  * **Flags removed (always):** `escalated-to-provincial`, `escalated-to-legal`, `escalated-to-rg`
* **Traceability:** A10.1, A10.2, A10.3

***

#### Action: `REVOKE_REGISTRATION`

**Identity**

* **Kind:** custom
* **Action ID:** `REVOKE_REGISTRATION`

**Country deltas**

* **Action menu label:** Revoke registration
* **Audit label:** Registration revoked
* **Icon:** XCircle
* **Visible in action menu:** Y
* **Menu order:** 14
* **Form:** `form:action-confirmation-revoke-registration`
* **Required record status:** Registered
* **Required flags (absent):** `revoked`
* **Postconditions:**
  * **Status change:** none
  * **Flags added (always):** `revoked`
* **Action triggers fired:** `birth-revocation-mosip` (UIN deactivation)
* **Traceability:** A9.1, A9.2

***

#### Action: `REINSTATE_REVOKED_REGISTRATION`

**Identity**

* **Kind:** custom
* **Action ID:** `REINSTATE_REVOKED_REGISTRATION`

**Country deltas**

* **Action menu label:** Reinstate registration
* **Audit label:** Revoked registration reinstated
* **Icon:** RotateCcw
* **Visible in action menu:** Y
* **Menu order:** 15
* **Form:** `form:action-confirmation-reinstate-revoked-registration`
* **Required record status:** Registered
* **Required flags (present):** `revoked`
* **Postconditions:**
  * **Status change:** none
  * **Flags removed (always):** `revoked`
* **Traceability:** A9.3

***

### Action menu order — derived view

| Position | Action                           | Visible | Notes                    |
| -------- | -------------------------------- | ------- | ------------------------ |
| —        | `CREATE`                         | N       | Platform — no menu entry |
| —        | `NOTIFY`                         | Y       | Platform default         |
| —        | `DECLARE`                        | Y       | Platform default         |
| —        | `EDIT`                           | Y       | Platform default         |
| —        | `REJECT`                         | Y       | Platform default         |
| —        | `ARCHIVE`                        | Y       | Platform default         |
| —        | `REGISTER`                       | Y       | Platform default         |
| —        | `REQUEST_CORRECTION`             | Y       | Platform default         |
| —        | `APPROVE_CORRECTION`             | Y       | Platform default         |
| —        | `REJECT_CORRECTION`              | Y       | Platform default         |
| —        | `PRINT`                          | Y       | Platform default         |
| —        | `REVIEW_DUPLICATES`              | Y       | Platform default         |
| 8        | `APPROVE_LATE_REGISTRATION`      | Y       | Custom                   |
| 12       | `ESCALATE`                       | Y       | Custom                   |
| 13       | `RESPOND_TO_ESCALATION`          | Y       | Custom                   |
| 14       | `REVOKE_REGISTRATION`            | Y       | Custom                   |
| 15       | `REINSTATE_REVOKED_REGISTRATION` | Y       | Custom                   |

***

### Traceability table

| Element ID                            | Element type    | Source rule (event spec Part A) | Notes for downstream skills                         |
| ------------------------------------- | --------------- | ------------------------------- | --------------------------------------------------- |
| `late-registration-approval-required` | flag            | A2.6                            | Drives `wq:pending-late-approval` queue             |
| `potential-duplicate`                 | flag            | A11.1                           | System-set; drives dedup review                     |
| `rejected`                            | flag            | A5.1, A5.2                      | Platform-provided; drives `wq:requires-updates`     |
| `correction-requested`                | flag            | A8.1                            | Gates PRINT; drives `wq:pending-correction`         |
| `revoked`                             | flag            | A9.1, A9.3                      | Gates PRINT and REQUEST\_CORRECTION                 |
| `escalated-to-provincial`             | flag            | A10.1                           | Branching flag from ESCALATE                        |
| `escalated-to-legal`                  | flag            | A10.2                           | Branching flag from ESCALATE                        |
| `escalated-to-rg`                     | flag            | A10.3                           | Branching flag from ESCALATE                        |
| `CREATE`                              | action (core)   | A0                              | Platform defaults only                              |
| `NOTIFY`                              | action (core)   | A1                              | Platform defaults only                              |
| `DECLARE`                             | action (core)   | A2.6, A5.2                      | Conditional late-registration flag; clears rejected |
| `EDIT`                                | action (core)   | A2, A5                          | Platform defaults only                              |
| `REJECT`                              | action (core)   | A5.1                            | Platform defaults only                              |
| `ARCHIVE`                             | action (core)   | A6                              | Platform defaults only                              |
| `REGISTER`                            | action (core)   | A4.1, A4.2                      | Flag gates; MOSIP trigger                           |
| `REQUEST_CORRECTION`                  | action (core)   | A8.1                            | Sets correction-requested flag                      |
| `APPROVE_CORRECTION`                  | action (core)   | A8.2, A8.3, A8.4                | Clears correction-requested; MOSIP triggers         |
| `REJECT_CORRECTION`                   | action (core)   | A8                              | Clears correction-requested                         |
| `PRINT`                               | action (core)   | A7.1, A7.3                      | Gated by correction-requested and revoked           |
| `REVIEW_DUPLICATES`                   | action (core)   | A11                             | Platform defaults only                              |
| `APPROVE_LATE_REGISTRATION`           | action (custom) | A4.1, XC-LEGAL-LATE-365         | Clears late-registration flag                       |
| `ESCALATE`                            | action (custom) | A10.1, A10.2, A10.3             | Branching flag effects                              |
| `RESPOND_TO_ESCALATION`               | action (custom) | A10.1, A10.2, A10.3             | Clears escalation flags                             |
| `REVOKE_REGISTRATION`                 | action (custom) | A9.1, A9.2                      | Sets revoked; MOSIP deactivation                    |
| `REINSTATE_REVOKED_REGISTRATION`      | action (custom) | A9.3                            | Clears revoked                                      |
