# Forms

### 1. Introduction

In OpenCRVS, a **form** is the user interface used to collect and validate data for a specific action on a record. For example, different forms can be used when:

* Declaring a birth or death.
* Requesting a correction.
* Printing a certificate or certified copy.

Forms are fully configurable so that countries can match their legal requirements and data standards, while reusing common field types and behaviours.

***

### 2. Feature overview

Forms provide a flexible mechanism for collecting and validating data across many workflows in OpenCRVS, while keeping the experience manageable for frontline users.

**Core capabilities**

With forms, OpenCRVS supports:

* Unlimited configurable forms for different workflows (declarations, corrections, custom actions, print flows).
* Grouping questions into **pages** and sections to structure complex declarations.
* Conditional show / hide of pages and fields based on record data, user role, and previous answers.
* Field‑level **validation rules** (required, patterns, min / max, date ranges) to protect data quality at source.
* Marking specific fields as **analytics‑relevant** so that only safe, aggregated data flows to dashboards.
* Capturing and reviewing **supporting documents** via upload fields as part of the same flow.
* Triggering and clearing **flags** based on form conditions (for example, late registration, requires senior approval).
* Controlling which fields can be updated later as part of **correction** workflows.

{% hint style="warning" %}
**Versioning** — OpenCRVS does not currently support form versioning. Once a configuration is live, adding or removing fields (especially mandatory ones) can impact existing records and workflows. Plan carefully and test forms thoroughly before go-live.
{% endhint %}

***

### 3. Form properties

Each form has a small set of core properties that control how it behaves.

* **Pages**
  * **Declaration / record forms**, **Print** forms, and **Correction** forms can all have one or more pages.
  * Pages are used to group related questions and improve usability.
  * **Custom action forms** are shown in a dialog and are limited to a **single page**, but can still use conditional show / hide logic for individual fields.
* **Inputs (fields)**
  * Each page contains one or more input fields.
  * Each input can have an optional **label** and **hint/help text** to explain what should be entered.
  * Fields like **Text** and **Number** can also include a **prefix** (for example, currency symbol) and **postfix** (for example, unit such as "years"), to make expected values clearer.
* **Conditionals (show / hide)**
  * Pages and fields can be shown or hidden based on:
    * Values of other fields (for example, show spouse details only if "Married").
    * User role or scope (for example, extra questions for Registrars only).
* **Validations**
  * Field-level validations (for example, required, pattern, min / max, date ranges).
  * Error messages shown inline to guide users.
* **Analytics flag**
  * Mark fields whose data may be used in **performance / analytics dashboards** (for example, Metabase performance views).
  * Only fields with `analytics = true` are exposed to Metabase for dashboarding, to ensure that personally identifiable information (PII) is not available in analytics datasets.
  * Should **not** be set on fields that contain PII or other sensitive information.
* **Corrections**
  * Mark whether a field can be corrected as part of a correction workflow after registration.
* ~~**Security**~~
  * ~~Mark sensitive fields that require special handling (for example, visibility restricted to certain roles).~~
* **Flags**
  * Configure flags to be added or removed based on form conditions (for example, late registration, requires senior approval, requires health attestation).

***

### 4. Input field types

The following input field types are supported:

#### 4.1 Text

Free-text input for short strings (for example, names, occupations).

* Supports configurable max length and validation patterns.
* Use for data that cannot be reliably constrained to a fixed list.
* Avoid using for values that should be standardised (for example, sex, country) — prefer **Select** instead.
* **Storybook:** _(embed Text input example here)_

#### 4.2 Number

Numeric input (for example, age, number of children, parity).

* Supports min / max, step values, and integer or decimal constraints.
* Use for quantities that will be used in validation or analytics.
* **Storybook:** _(embed Number input example here)_

#### 4.3 Number with unit

Numeric input with a visible unit next to the field (for example, years, months, kg).

* Use when you want to standardise the unit (for example, always capture age in **years** or weight in **kg**).
* Helps users understand exactly what to enter and reduces ambiguity in reporting.
* **Storybook:** _(embed Number with unit example here)_

#### 4.4 Email

Email address input.

* Applies basic email pattern validation (for example, must contain `@` and a valid domain).
* Use when capturing contact details that may be used for email notifications or follow-up.
* **Storybook:** _(embed Email input example here)_

#### 4.5 Phone

Phone number input.

* Can apply country-specific formatting and validation.
* Use where follow-up SMS or phone contact is required.
* **Storybook:** _(embed Phone input example here)_

#### 4.6 Select

Drop-down or select list.

* Use when values should come from a **controlled vocabulary** (for example, sex, marital status, relationship to child).
* Options can be localised and ordered.
* Reduces data cleaning and improves reporting quality.
* **Storybook:** _(embed Select input example here)_

#### 4.7 ID Reader (QR / e-signat)

Specialised input for reading identifiers from QR codes or e-signat.

* Use to capture national ID, health ID, or other machine-readable identifiers.
* Can be combined with lookups to prepopulate other fields.
* **Storybook:** _(embed ID Reader example here)_

#### 4.8 Registration number validator / lookup

Field that validates or looks up data from another event record using a registration number or tracking ID.

* Use for scenarios such as:
  * Linking a marriage declaration to the bride’s or groom’s birth record.
  * Verifying an existing registration before issuing a certificate.
* Can populate related data fields read-only to avoid retyping.
* **Storybook:** _(embed Registration number lookup example here)_

#### 4.9 Date

Date (and optionally time) input.

* Use for dates of event, declaration, registration, or document issue.
* Supports validation (for example, cannot be in the future, must be after another date).
* **Storybook:** _(embed Date input example here)_

#### 4.10 Radio

Single-choice options presented as radio buttons.

* Use when there are few options and you want all options visible at once (for example, place of birth: facility / home / other).
* Behaviour is similar to **Select**, but optimised for short lists.
* **Storybook:** _(embed Radio input example here)_

#### 4.11 Checkbox

Boolean or multi-select using checkboxes.

* Single checkbox: yes/no conditions (for example, "Father’s details are unavailable").
* Multiple checkboxes: select all that apply (for example, signs and symptoms).
* **Storybook:** _(embed Checkbox input example here)_

#### 4.12 File Upload

File upload (JPG, PNG and PDF).

* Use for supporting documents (for example, medical certificates, ID scans).
* Consider storage, security, and retention policies on devices when enabling uploads.
* **Storybook:** _(embed Upload input example here)_

#### 4.13 HTTP (external link / integration)

Actionable button to open an external service.

* Use when users need to visit an external system (for example, external ID verification) as part of the workflow.
* Can be combined with **Data** fields that display results from previous integrations.
* Can be used to trigger notifications to informants
* **Storybook:** _(embed HTTP? / external link example here?)_

#### 4.14 Data (read-only display)

Displays data in read-only form.

* Use to show calculated values, lookup results, or existing record data alongside editable fields.
* Helps users validate that they are acting on the correct record without allowing changes.
* **Storybook:** _(embed Data display example here)_

#### 4.15 Print

Button used to generate a printable document using a preconfigured SVG template.

* Takes data captured in the form and populates an SVG template, which is then exported as a PDF.
* Can be used to generate a printable view of the declaration data, a certificate, a payment receipt or other official outputs.
* **Storybook:** _(embed Print trigger example here)_

***

### 5. Layout and formatting options

Forms can also include non-input blocks to structure content and guide users.

* **Headings (H1, H2)** — group related questions under clear titles.
* **Divider** — visually separate sections.
* **Paragraph** — provide instructions or legal text.
* **Bulleted lists** — explain requirements or examples.

Use these elements to:

* Explain why certain data is needed.
* Provide examples of acceptable values.
* Call out legal statements or consent text.

***

Worked example:

2 pager

…

#### Configuration input

..





***

### 6. Record review

When reviewing a declaration or registration, OpenCRVS presents:

* The **captured form data** for the record.
* Any **supporting documents** uploaded via Upload fields (for example, medical certificates, ID scans, marriage certificates).

The review experience is designed so that users can see data and documents **side by side**, making it easier to:

* Verify that key data values (for example, names, dates, locations) match the evidence provided.
* Spot inconsistencies or missing information before validation or registration.
* Capture additional notes if something requires follow-up.
* Capture informant signature.

\<image>

***
