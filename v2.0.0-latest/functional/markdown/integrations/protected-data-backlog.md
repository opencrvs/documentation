# Protected data (backlog)

### 1. Introduction

Some records in OpenCRVS may contain especially sensitive information, or be subject to special safeguarding rules (for example, adoption, domestic or gender-based violence cases, or court-ordered restrictions). To support stronger privacy controls in these situations, OpenCRVS allows certain records to be marked as **protected**.

When a record is protected:

* It is **removed from all standard search results** (quick search and advanced search) for most users.
* Only users with a specific **protected-search scope** can find and open the record.

This helps countries comply with data protection requirements and safeguarding policies by ensuring that highly sensitive records are only accessible to authorised roles.

***

### 2. What it means for a record to be protected

A **protected record** behaves differently from ordinary records in three main ways:

1. **Hidden from search results**
   * The record does not appear in quick search or advanced search results for users who do not have the required protected-search scope.
2. **Restricted retrieval**
   * Only users with the correct `search` scope (including the `protected` qualifier) can retrieve and view the record.
3. **Audited access**
   * Access to protected records is logged in **User Audit** for traceability and oversight.

Protected status does **not** change the underlying data of the record itself; it changes **who can find and view it** through the application.

***

### 3. Controlling access with search scopes

Access to protected records is controlled through the user’s **search scope configuration**.

For each event type that may include protected records (for example, birth, death, marriage), countries can define scopes of the form:

* `search[event=<event> protected]`

Where `<event>` is the event type, such as `birth`, `death`, or `marriage`.

#### 3.1 Examples

* A specialist role that must be able to search protected birth records:
  * `search[event=birth protected]`
* A national-level role that can search all protected birth and death records:
  * `search[event=birth protected]`
  * `search[event=death protected]`

Only users whose roles include the appropriate `protected` search scopes will see protected records in their search results and be able to open them.

***

### 4. Interaction with other search scopes and jurisdiction

Protected search always **builds on top of** existing search and jurisdiction rules:

* A user must still have the **underlying event search scope and jurisdiction** for the record (for example, `search[event=birth declared_in=my-administrative-area registered_in=my-administrative-area]`).
* The `protected` qualifier further restricts access to only those users explicitly allowed to include protected records in their searches.

In practice, a role that can search both ordinary and protected birth records in its own administrative area might combine scopes like:

* `search[event=birth declared_in=my-administrative-area registered_in=my-administrative-area]`
* `search[event=birth protected]`

Countries can decide whether protected access should be limited to national-level users, specific supervisory roles, or specialised units (for example, a data protection officer).

***

### 5. Reasons for protecting records

Countries may choose to protect records, or specific data within a record, in situations such as:

* **Adoption** — the original birth record is hidden once a child is legally adopted. Only the new birth record (showing adoptive parents) and the associated adoption record can be found in search. Access to the original record is restricted to authorised roles.
* **Domestic or gender-based violence cases** — records where disclosure of a parent's or informant's identity or address could put someone at risk.
* **High-profile or sensitive persons** — records relating to specific individuals (for example, public figures or protected witnesses) where additional privacy is required.
* **Court-ordered restrictions** — records that must be hidden or limited following a court decision (for example, sealed records).
* **Special safeguarding policies** — any other category defined in national policy (for example, children in alternative care, humanitarian protection cases).

These examples are illustrative. Each country should define its own criteria for when records or specific fields should be protected, and how long protection should apply.

***

### 6. Marking a record as protected or no longer protected

Protected status is typically controlled through a **custom action** on the record, for example **Mark protected**.

#### 6.1 Marking a record as protected

A user with the appropriate permissions can mark a record as protected from the record view:

1. Open the event record (for example, a birth record).
2. Select the **Mark protected** custom action.
3. Confirm the action (for example, in a confirmation dialog explaining that the record will be hidden from general search).

When **Mark protected** is applied:

* The system automatically adds a **Protected** flag (for example, `protected`) to the record.
* The record immediately behaves as a protected record:
  * It is removed from standard search results for users without the protected-search scope.
  * It remains visible only to users who have the relevant `search[event=<event> protected]` scope and the necessary jurisdiction.
* The action, including who performed it and when, is recorded in **Audit**.

#### 6.2 Removing protected status

When a record should no longer be treated as protected (for example, after a policy-defined period or following a supervisory decision), authorised users can reverse the protection:

1. Open the event record.
2. Select a corresponding custom action (for example, **Remove protected status**).
3. Confirm the change.

When protected status is removed:

* The **Protected** flag is cleared from the record.
* The record returns to normal search behaviour and can be found by any user whose search scopes and jurisdiction allow access to that event.
* The change is logged in **Audit**, alongside the original protection action.

These actions ensure that protection of records is explicit, auditable, and reversible only by appropriately authorised users.

***

### 6. Configuration considerations

When introducing protected records, countries should decide:

* **Which event types** can have protected records.
* **Which roles** should be allowed to search protected records (and in which jurisdictions).
* How to align protected access with broader **privacy and safeguarding policies** (for example, adoption law, child protection guidelines, or data protection legislation).

By carefully configuring protected records and the associated `search[event=<event> protected]` scopes, OpenCRVS helps ensure that only appropriately authorised users can retrieve and view the most sensitive records, while keeping them hidden from general search.
