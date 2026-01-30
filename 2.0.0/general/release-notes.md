---
metaLinks:
  alternates:
    - https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/general/release-notes
---

# Release notes

## Configuration template files

## Deployment, Monitoring & Data Security

{% file src="../.gitbook/assets/Deployment, Monitoring & Data Security.zip" %}
Deployment & Monitoring checklist, Data Security Framework
{% endfile %}

## Dependencies & Network Diagram

{% file src="../.gitbook/assets/Dependencies & Network Diagram.zip" %}
Dependency table, Network Diagram with VPN & approx. costs associated
{% endfile %}

## v1.9.1: Release notes

### OpenCRVS Core v1.9.1

### Breaking changes

*   `QUERY_PARAM_READER` now returns picked params under a `data` object. For example, `code` and `state` are now accessed via `data.code` and `data.state`.

    Previously: field(.query-params).get('code') Now: field(.query-params).get('data.code')
* **Removed support for following scopes**
  * `NATLSYSADMIN`
  * `DECLARE`
  * `VALIDATE`
  * `CERTIFY`
  * `PERFORMANCE`
  * `SYSADMIN`
  * `TEAMS`
  * `CONFIG`
  * `RECORD_EXPORT_RECORDS`
  * `RECORD_DECLARATION_PRINT`
  * `RECORD_PRINT_RECORDS_SUPPORTING_DOCUMENTS`
  * `RECORD_REGISTRATION_PRINT`
  * `RECORD_PRINT_CERTIFIED_COPIES`
  * `RECORD_REGISTRATION_VERIFY_CERTIFIED_COPIES`
  * `PROFILE_UPDATE`

### New features

* Add multi-field search with a single component [#10617](https://github.com/opencrvs/opencrvs-core/issues/10617)
* **Search Field**: A new form field that allows searching previous records and using the data to pre-fill the current form. [#10131](https://github.com/opencrvs/opencrvs-core/issues/10131)
* HTTP input now accepts `field('..')` references in the HTTP body definition.
* **Searchable Select**: A new select component that allows searching through options. Useful for selects with a large number of options. Currently being used in address fields. [#10749](https://github.com/opencrvs/opencrvs-core/issues/10749)

### Bug fixes

* During user password reset, email address lookup is now case insensitive [#9869](https://github.com/opencrvs/opencrvs-core/issues/9869)
* Users cannot activate or reactivate users with roles not specified in the `user.edit` scope [#9933](https://github.com/opencrvs/opencrvs-core/issues/9933)
* Login page no longer show "Farajaland CRVS" before showing the correct title [#10958](https://github.com/opencrvs/opencrvs-core/issues/10958)
* `ALPHA_PRINT_BUTTON` does not get disabled after first print [#10953](https://github.com/opencrvs/opencrvs-core/issues/10953)

### OpenCRVS Country config template v1.9.0

### Breaking changes

* **Remove Unused Scopes**: Removed `RECORD_PRINT_RECORDS_SUPPORTING_DOCUMENTS` and `RECORD_EXPORT_RECORDS` scopes from `REGISTRATION_AGENT`, `LOCAL_REGISTRAR` and `NATIONAL_REGISTRAR`

### Improvements

* Make encryption step optional [#1123](https://github.com/opencrvs/opencrvs-countryconfig/pull/1123)
* Added validation for ENCRYPTION\_KEY [#10896](https://github.com/opencrvs/opencrvs-core/issues/10896)

### New content keys requiring translation

```
searchField.indicators.clearButton,Clear button text,Clear,Effacer
searchField.indicators.clearModal.cancel,Cancel button for clear confirmation modal,Cancel,Annuler
searchField.indicators.clearModal.confirm,Confirm button for clear confirmation modal,Confirm,Confirmer
searchField.indicators.clearModal.description,Description for the clear confirmation modal,This will remove the current search results.,Cela supprimera les résultats de recherche actuels.
searchField.indicators.clearModal.title,Title for the clear confirmation modal,Clear search results?,Effacer les résultats de recherche ?
searchField.indicators.confirmButton,Confirm button text,Search,Rechercher
searchField.indicators.httpError,HTTP error indicator,"{statusCode, select, 408{Timed out} other{An error occurred while fetching data}}","{statusCode, select, 408{Délai d'attente dépassé} other{Une erreur s'est produite lors de la récupération des données}}"
searchField.indicators.loading,Loading indicator,Searching...,Recherche en cours...
searchField.indicators.noResultsError,No results found indicator,No record found,Aucun enregistrement trouvé
searchField.indicators.offline,Offline indicator,Search is unavailable while offline,La recherche n'est pas disponible hors ligne
searchField.indicators.ok,OK button text,Found {count} results,{count} résultats trouvés
```

## v1.9.0: Release notes

### OpenCRVS Core v1.9.0

### Breaking changes

* Dashboard configuration through **Metabase** has been fully migrated to **countryconfig**, and the standalone dashboard package has been removed. For details on configuring dashboards and information about the latest updates, refer to the [ANALYTICS.md](https://github.com/opencrvs/opencrvs-countryconfig/blob/v1.9.0/ANALYTICS.md) documentation.

### New features

#### Events V2

We are excited to announce a major overhaul of our events system: **Events V2**. This is a complete rewrite that introduces a new level of flexibility and configurability to how life events are defined and managed across the system.

The new Events V2 architecture is built around a set of core concepts designed to make event management more powerful and customizable.

**Events**

An **Event** represents a life event (or any kind of event), such as a birth or a marriage. Each event is defined by a configuration that specifies the sequence of **Actions** required to register it.

**Actions**

**Declaration Actions**

Declaration actions are used to modify an event’s declaration. These actions must be executed in a defined order and cannot be skipped.

1. **DECLARE**
2. **VALIDATE**
3. **REGISTER**

Each action must be accepted by **countryconfig** before the next one can be performed.

**Rejecting and Archiving**

After declaration, instead of proceeding with registration, an event may be either **rejected** or **archived**.

If **deduplication** is enabled for an action, performing that action may trigger a **DUPLICATE\_DETECTED** action if duplicates are found. When this occurs, two additional actions become available:

* **MARK\_AS\_DUPLICATE** – archives the event.
* **MARK\_AS\_NOT\_DUPLICATE** – resumes the normal action flow.

If an event is rejected by a user, the preceding action must be repeated before continuing.

**Actions Before Declaration**

1. **NOTIFY** – a partial version of the `DECLARE` action.
2. **DELETE** – an event can be deleted only if no declaration action has yet been performed.

**Actions After Registration**

Once an event has been registered, a certificate may be printed. If a correction is required due to an error in the registered declaration, a correction workflow must be initiated.

1. **PRINT\_CERTIFICATE**
2. **REQUEST\_CORRECTION**
3. **REJECT\_CORRECTION**
4. **APPROVE\_CORRECTION**

**General / Meta Actions**

1. **READ** – appended to the action trail whenever a complete event record is retrieved.
2. **ASSIGN** – required before any action can be performed. By default, the user is automatically unassigned after completing an action.
3. **UNASSIGN** – triggered either automatically by the system or manually by a user (if the record is assigned to themselves or if the user has the appropriate permission).

**Forms, Pages, and Fields**

Event data is collected through **Forms**, which come in two types:

* **Declaration Form** – collects data about the event itself
* **Action Form** – collects data specific to a particular action, also known as annotation data in the system

Forms are composed of **Pages**, and pages are composed of **Fields**. Fields can be shown, hidden, or enabled dynamically based on the values of other fields, allowing for a responsive and intuitive user experience.

To simplify configuration, we’ve introduced a set of helper functions:

```ts
defineDeclarationForm()
defineActionForm()
definePage()
defineFormPage()
```

All of these are available in a **type-safe** manner via the new `@opencrvs/toolkit` npm package.

**Conditionals & Validation**

Validation has been significantly improved through the adoption of **AJV** and **JSON Schema**, providing standardized, robust, and extensible validation.

The `field` function (exported from `@opencrvs/toolkit`) includes a set of helpers for defining complex validation rules and conditional logic.

**Available helpers include:**

* **Boolean connectors**: `and`, `or`, `not`
* **Basic conditions**: `alwaysTrue`, `never`
* **Comparisons**: `isAfter`, `isBefore`, `isGreaterThan`, `isLessThan`, `isBetween`, `isEqualTo`
* **Field state checks**: `isFalsy`, `isUndefined`, `inArray`, `matches` (regex patterns)
* **Age-specific helpers**: `asAge`, `asDob` (to compare age or date of birth)
*   **Nested fields**:

    ```ts
    field('parent.field.name').get('nested.field').isFalsy()
    ```

The `user` object, also exported from `@opencrvs/toolkit`, includes helpers for user-based conditions such as:

```ts
user.hasScope()
user.hasRole()
user.isOnline()
```

These conditions can control:

* `SHOW` – whether a component is visible
* `ENABLE` – whether a component is interactive
* `DISPLAY_ON_REVIEW` – whether a field appears on review pages

They can also be used to validate form data dynamically based on the current form state or user context.

#### Drafts

The new **Drafts** feature allows users to save progress on an event that has not yet been registered. Drafts act as temporary storage for an action and are visible only to the user who created them.

#### Advanced Search

Advanced search is now configurable through the `EventConfig.advancedSearch` property, allowing different sections of an advanced search form to be defined.

You can search across:

* **Declaration Fields** – using the same `field` function from declaration forms with helpers such as `range`, `exact`, `fuzzy`, and `within`
* **Event Metadata** – using the `event` function to search against metadata such as:
  * `trackingId`
  * `status`
  * `legalStatuses.REGISTERED.acceptedAt`
  * `legalStatuses.REGISTERED.createdAtLocation`
  * `updatedAt`

More details about the metadata fields are available in `packages/commons/src/events/EventMetadata.ts`.

#### Deduplication

Event deduplication is now configurable **per action** via the `EventConfig.actions[].deduplication` property. Helpers for defining deduplication logic—such as `and`, `or`, `not`, and `field`—are available from `@opencrvs/toolkit/events/deduplication`.

The `field` helper can reference declaration form fields and be combined with:

```ts
strictMatches()
fuzzyMatches()
dateRangeMatches()
```

to define precise deduplication rules.

#### Greater Control over Actions

Each action now progresses through three possible states: **`requested`**, **`accepted`**, and **`rejected`**. When a user performs an action, it is first marked as **`requested`** and forwarded to **countryconfig** via the `/trigger/events/{event}/actions/{action}` route, with the complete event details included in the payload.

Countryconfig has full control over how the action is processed and may choose to **accept** or **reject** the action either **synchronously** or **asynchronously**.

By hooking into these action trigger routes, countryconfig can also:

* Send customized **Notifications**
* Access the full event data at the time an action is performed

#### Configurable Workqueues

Workqueues can now be configured from countryconfig using the `defineWorkqueues` function from `@opencrvs/toolkit/events`. This enables the creation of role- or workflow-specific queues without requiring code changes in core.

* The **`actions`** property is used to define the default actions displayed for records within a workqueue.
* The **`query`** property is used to determine which events are included in the workqueue.
* The **`workqueue[id=workqueue-one|workqueue-two]`** scope is used to control the visibility of workqueues for particular roles.

Details on the available configuration options can be found in the `WorkqueueConfig.ts` file.

#### Event Overview

The configuration of the event overview page (formerly known as _Record Audit_) has been made customizable through the `EventConfig.summary` property. The record details displayed on this page can be referenced directly from the declaration form or defined as custom fields that combine multiple form values. If some value contains PII data, they can optionally be hidden via the `secured` flag so that the data will only be visible once the record is assigned to the user.

#### Quick Search

The dropdown previously available in the search bar has been removed. Any search performed through the **Quick Search** bar is now executed against common record properties such as names, tracking ID, and registration number by default, providing a more streamlined and consistent search experience.

#### Certificate Template Variables

The following variables are available for use within certificate templates:

* **`$declaration`** – Contains the latest raw declaration form data. Typically used with the `$lookup` Handlebars helper to resolve values into human-readable text.
* **`$metadata`** – Contains the `EventMetadata` object. Commonly used with the `$lookup` helper for resolving metadata fields into readable values.
* **`$review`** – A boolean flag indicating whether the certificate is being rendered in review mode.
* **`$references`** – Contains reference data for locations and users, accessible via `{{ $references.locations }}` and `{{ $references.users }}`. This is useful when manually resolving values from `$declaration`, `$metadata` or `action`.

**Handlebars Helpers**

The following helpers are supported within certificate templates:

* **`$lookup`** – Resolves values from `$declaration`, `$metadata`, or `action` data into a human-readable format.
*   **`$intl`** – Dynamically constructs a translation key by joining multiple string parts. Example:

    ```hbs
    {{ $intl 'constants.greeting' (lookup $declaration "child.name") }}
    ```
*   **`$intlWithParams`** – Enables dynamic translations with parameters. Takes a translation ID as the first argument, followed by parameter name–value pairs. Example:

    ```hbs
    {{ $intlWithParams 'constants.greeting' 'name' (lookup $declaration "child.name") }}
    ```
*   **`$actions`** – Resolves all actions for a specified action type. Example:

    ```hbs
    {{ $actions "PRINT_CERTIFICATE" }}
    ```
*   **`$action`** – Retrieves the latest action data for a specific action type. Example:

    ```hbs
    {{ $action "PRINT_CERTIFICATE" }}
    ```
*   **`ifCond`** – Compares two values (`v1` and `v2`) using the specified operator and conditionally renders a block based on the result. **Supported operators:**

    * `'==='` – strict equality
    * `'!=='` – strict inequality
    * `'<'`, `'<='`, `'>'`, `'>='` – numeric or string comparisons
    * `'&&'` – both values must be truthy
    * `'||'` – at least one value must be truthy

    **Usage example:**

    ```hbs
    {{#ifCond value1 '===' value2}}
      ...
    {{/ifCond}}
    ```
* **`$or`** – Returns the first truthy value among the provided arguments.
* **`$json`** – Converts any value to its JSON string representation (useful for debugging).

Besides the ones introduced above, all built-in [Handlebars helpers](https://handlebarsjs.com/guide/builtin-helpers.html) are available.

Custom helpers can also be added by exposing functions from this [file](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/form/common/certificate/handlebars/helpers.ts#L0-L1).

***

To see Events V2 in action, check out the example configurations in the **countryconfig** repository.

***

* **Redis password support with authorization and authentication** [#9338](https://github.com/opencrvs/opencrvs-core/pull/9338). By default password is disabled for local development environment and enabled on server environments.
* **Switch back to default redis image** [#10173](https://github.com/opencrvs/opencrvs-core/issues/10173)
* **Certificate Template Conditionals**: Certificate template conditionals allow dynamic template selection based on print history using the template conditional helpers.. [#7585](https://github.com/opencrvs/opencrvs-core/issues/7585)
* Expose number of copies printed for a certificate template so it can be printed on the certificate. [#7586](https://github.com/opencrvs/opencrvs-core/issues/7586)
* Add Import/Export system client and `record.export` scope to enable data migrations [#10415](https://github.com/opencrvs/opencrvs-core/issues/10415)
* Add an Alpha version of configurable "Print" button that will be refactored in a later release - this button can be used to print certificates during declaration/correction flow. [#10039](https://github.com/opencrvs/opencrvs-core/issues/10039)
* Add bulk import endpoint [#10590](https://github.com/opencrvs/opencrvs-core/pull/10590)

### Improvements

*   **Upgrade node version to 22**

    This version enforces environment to have Node 22 installed (supported until 30 April 2027) and removes support for Node 18 for better performance and using [new features](https://github.com/nodejs/node/releases/tag/v22.0.0) offered by NodeJS

    * Use nvm to upgrade your local development environment to use node version `22.x.x.`
* **UI enhancements**
  * Replaced the `Download` icon with a `FloppyDisk` save icon when saving an event as draft.
* Use unprivileged version of nginx container image [#6501](https://github.com/opencrvs/opencrvs-core/issues/6501)
* **Upgraded MinIO** to RELEASE.2025-06-13T11-33-47Z and MinIO Client (mc) to RELEASE.2025-05-21T01-59-54Z and ensured compatibility across both amd64 and arm64 architectures.
* Add retry on deploy-to-feature-environment workflow at core repo [#9847](https://github.com/opencrvs/opencrvs-core/issues/9847)
* Save certificate templateId so it can be shown in task history and made available for conditional [#9959](https://github.com/opencrvs/opencrvs-core/issues/9959)
* Deprecate external id/ statistical id in V2. Remove external\_id column from locations table and location seeding step [#9974](https://github.com/opencrvs/opencrvs-core/issues/9974)
* **Updated environment variable**
  * Renamed `COUNTRY_CONFIG_URL` → `COUNTRY_CONFIG_URL_EXTERNAL` in the auth service to make its purpose clearer and more explicit.
* Tiltfile: Improved Kubernetes support for development environment [#10672](https://github.com/opencrvs/opencrvs-core/issues/10672)

### Bug fixes

* Fix informant details not populating in API [#10311](https://github.com/opencrvs/opencrvs-core/issues/10311)

### OpenCRVS Country config template v1.9.0

### New features

* Render number of copies printed count on a certificate template. [#7586](https://github.com/opencrvs/opencrvs-core/issues/7586)
* **Certificate Template Conditionals**: Added support for conditional filtering of certificate templates based on declaration form data and event metadata using JSON Schema validation. Templates can now be dynamically shown or hidden based on specific criteria such as demographics, registration status, action history, and regional variations. Includes helper functions for improved readability and maintainability. See [Certificate Template Conditionals documentation](../../v1.9.0/general/docs/CERTIFICATE_TEMPLATE_CONDITIONALS.md) for implementation details. [#7585](https://github.com/opencrvs/opencrvs-core/issues/7585)

### Improvements

*   **Upgrade node version to 22**

    This version enforces environment to have Node 22 installed (supported until 30 April 2027) and removes support for Node 18 for better performance and using [new features](https://github.com/nodejs/node/releases/tag/v22.0.0) offered by NodeJS

    * Use nvm to upgrade your local development environment to use node version `22.x.x.`
    * Add conditions for the certified copy certificate to ensure it's only available to children who are 1 year or older. [#9684](https://github.com/opencrvs/opencrvs-core/issues/9684)
    * Available disk space in root file system alert adjusted to fire when 20GB are remaining, rather than when diskspace usage is at 70%.
* **Upgraded MinIO** to RELEASE.2025-06-13T11-33-47Z and MinIO Client (mc) to RELEASE.2025-05-21T01-59-54Z and ensured compatibility across both amd64 and arm64 architectures.
* Remove the remnants of OpenHIM from the backup & restore scripts. [#9732](https://github.com/opencrvs/opencrvs-core/issues/9732)
* Store system monitoring data for 1 month [#10515](https://github.com/opencrvs/opencrvs-core/issues/10515)
* Restricted filesystem usage for journal service and file rotation strategy [#10518](https://github.com/opencrvs/opencrvs-core/issues/10518))
* Tiltfile: Improved Kubernetes support for development environment [#10672](https://github.com/opencrvs/opencrvs-core/issues/10672)

### Bug fixes

* Allow non-interactive upgrades with apt [#10204](https://github.com/opencrvs/opencrvs-core/issues/10204)
* Don't restart events service after data cleanup [#10704](https://github.com/opencrvs/opencrvs-core/issues/10704)

### New content keys requiring translation

```
action.view.record,Label for view record,View,Afficher
actionModal.PrimaryAction,The label for primary action button of action modal,"{action, select, declare{Declare} other{{action}}}","{action, select, declare{Declare} other{{action}}}"
actionModal.cancel,The label for cancel button of action modal,Cancel,Annuler
actionModal.confirm,The label for confirm button of action modal,Confirm,Confirmer
actionModal.description,The description for action modal,The informant will be notified of this decision and a record of this decision will be recorded,L'informateur sera informé de cette décision et celle-ci sera consignée dans un dossier.
actionModal.description.incomplete,Description shown in the action modal when a declaration is incomplete,This incomplete declaration will be submitted for review.,Cette déclaration incomplète sera soumise à l'examen.
actionModal.title,The title for action modal,"{action, select, declare{Declare} other{{action}}} the member?","{action, select, declare{Declare} other{{action}}} the member?"
advancedSearch.form.recordStatusArchived,Option for form field: status of record,Archived,Archivé
advancedSearch.form.recordStatusDeclared,Option for form field: status of record,Declared,Déclaré
advancedSearch.form.recordStatusNotified,Option for form field: status of record,Notified,Notifié
advancedSearch.registeredAt,Label for date of registration field,Date of registration,Date d'enregistrement
advancedSearch.registeredAtLocation,Label for place of registration field,Place of registration,Lieu d'enregistrement
advancedSearch.registeredAtLocation.helperText,Helper text for place of registration field,"Search for a province, district or registration office","Rechercher une province, un district ou un bureau d'enregistrement"
advancedSearch.status,Label for status field,Status of record,Statut de l'enregistrement
advancedSearch.trackingId,Label for tracking ID field,Tracking ID,ID de suivi
advancedSearch.updatedAt,Label for date of update field,Time period,Période
advancedSearch.updatedAt.helperText,Helper text for date of update field,Period of time since the record status changed,Période écoulée depuis le changement de statut de l'enregistrement
birth.search.criteria.label.prefix.child,Child prefix,Child's,De l'enfant
birth.search.criteria.label.prefix.father,Father prefix,Father's,Du père
birth.search.criteria.label.prefix.informant,Informant prefix,Informant's,Du déclarant
birth.search.criteria.label.prefix.mother,Mother prefix,Mother's,De la mère
buttons.back,Back button text,Back,Retour
buttons.backToReview,Back to review button text,Back to review,Retour à la revue
buttons.change,The label for the change button,Change,Modifier
buttons.changeAll,The label for the change all button,Change all,Changer tous
buttons.confirm,Confirm button,Confirm,Confirmer
buttons.correctRecord,Rectord correction button text,Correct record,Correct record
buttons.exit,Label for Exit button on EventTopBar,Exit,Quitter
buttons.saveExit,The label for the save and exit button,Save & Exit,Enregistrer et quitter
buttons.submitCorrectionRequest,Submit correction request button text,Submit correction request,Soumettre une demande de correction
certificates.birth.printedCertificateCount,Number of printed copies, Copy #{copiesPrintedForTemplate}, Copie #{copiesPrintedForTemplate}
changeModal.description,The description for change modal,A record will be created of any changes you make,Un enregistrement sera créé pour toute modification que vous apporterez
changeModal.title,The title for change modal,Edit declaration?,Modifier la déclaration ?
configuration.dateFormat,Default format for date values,d MMMM y,d MMMM y
configuration.timeFormat,Default time format for timestamps,"MMMM dd, yyyy · hh.mm a","MMMM dd, yyyy · hh.mm a"
constants.communityLeader,The description for Community Leader type,Community Leader,Chef de communauté
constants.humanName,Formatted full name,{firstName} {middleName} {lastName},{firstName} {middleName} {lastName}
constants.socialWorker,The description for Hospital Clerk type,Hospital Clerk,Commis d'hôpital
correction.correctRecordDialog.title,The title for the dialog when record correction sent by a registrar,Correct record?,enregistrement correct?
correction.correctionForApprovalDialog.title,The title for the dialog when record correction sent by registration agent for approval,Send record correction for approval?,Envoyer la correction de l'enregistrement pour approbation?
correction.correctionReject.reason,Correction request rejection reason,Reason for rejection,Motif du rejet
correction.correctionRequest,Correction request text,Correction request,Demande de correction
correction.corrector.identity.instruction,The title for the corrector form,Please verify the identity of the person making this request,Please verify the identity of the person making this request
correction.corrector.identity.verified,Label for verified option in corrector identity check page,I have verified their identity,I have verified their identity
correction.corrector.identity.verified.label,The title for the corrector form,@todo,@todo
correction.corrector.paragraph.title,The title for the corrector form,"For all record corrections at a minimum an affidavit must be provided. For material errors and omissions eg. in paternity cases, a court order must also be provided.","Pour toutes les corrections de dossiers, il faut au moins fournir un affidavit. Pour les erreurs matérielles et les omissions, par exemple dans les cas de paternité, une décision de justice doit également être fournie."
correction.label.verifyIdentity.cancel,Label for cancellation of identity verificationin correction request,No,Non
correction.label.verifyIdentity.confirm,Label for verification of identity in correction request,Yes,Oui
correction.reason.title,The title for the corrector form,Reason for correction?,Quelle était la raison de la correction?
correction.requester.relationshop.intro.label,The title for the corrector form,Note: In the case that the child is now of legal age (18) then only they should be able to request a change to their birth record.,"Note : Si l'enfant a atteint l'âge légal (18 ans), il est le seul à pouvoir demander une modification de son acte de naissance."
correction.requesterOffice,Correction requester office label,Office,Bureau
correction.submittedBy,Correction submitted by label,Submitter,Déposant
correction.submittedOn,Correction submitted on label,Submitted on,Date de soumission
correction.summary.change,Change link label,Change,Modifier
correction.summary.section.title,Corrections section title,Request correction(s),Corrections
correction.supportingDocuments.attest.label,Label for attestation of supporting documents,Attest,Attestation
correction.supportingDocuments.notNeeded.label,Label for indicating supporting documents are not needed,Not Needed,Non nécessaire
dashboard.completenessTitle,Completeness title,Completeness Dashboard,Tableau de bord de complétude
dashboard.registrationsTitle,Registrations title,Registrations Dashboard,Tableau de bord des enregistrements
dashboard.registryTitle,Registry title,Registry,Registre
duplicates.content.registeredAt,Registered at label for duplicates comparison,Registered at,Enregistré à
duplicates.content.registeredBy,Registered by label for duplicates comparison,Registered by,Enregistré par
duplicates.content.title,Duplicates content title message,Is {name} ({trackingId}) a duplicate?,Est-ce que {name} ({trackingId}) est un doublon?
error.child.weightAtBirth.invalidNumberRange,This is the error message for invalid number range,Must be within 0 and 6,Doit être compris entre 0 et 6
error.invalidInput,Error message when generic field is invalid,Invalid input,Entrée invalide
error.invalidName,This is the error message for invalid name,"Input contains invalid characters. Please use only letters (a-z, A-Z), numbers (0-9), hyphens (-) and apostrophes(')","L'entrée contient des caractères non valides. Veuillez n'utiliser que des lettres (a-z, A-Z), des chiffres (0-9), des traits d'union (-) et des apostrophes (')"
errors.notAssigned,User not assigned error toast message,You've been unassigned from the event,Vous avez été désassigné de l'événement
errors.somethingWentWrong,Error toast message for general errors,Something went wrong. Please try again,Une erreur s'est produite. Veuillez réessayer
event.action.declare.form.section.person.field.age.error,Error message for invalid age,Age must be between 12 and 120,L'auteur doit avoir entre 12 et 120 ans
event.action.notAvailableForEvent,Shown when user tries to perform an action that is not available for the event,The action you're trying to perform is not available for this event anymore,L'action que vous essayez d'effectuer n'est plus disponible pour cet événement
event.action.outbox-retry.label,Label for retry button for outbox,Retry,Réessayer
event.action.review-correction.label,Label for review correction button in dropdown menu,Review,Revoir
event.birth.action.archive.label,Label for archive record button in dropdown menu,Archive,Aarchiver
event.birth.action.certificate.form.section.collectPayment.data.label,Title for the data section,Payment details,Détails du paiement
event.birth.action.certificate.form.section.collectPayment.fee.label,Title for the data entry,Fee,Frais
event.birth.action.certificate.form.section.collectPayment.service.label,Title for the data entry,Service,Service
event.birth.action.certificate.form.section.collectPayment.service.label.afterLateRegistrationTarget,Birth registration after 365 days of date of birth,Birth registration after 365 days of date of birth,Enregistrement de naissance après 365 jours de la date de naissance
event.birth.action.certificate.form.section.collectPayment.service.label.beforeRegistrationTarget,Birth registration before 30 days of date of birth,Birth registration before 30 days of date of birth,Enregistrement de naissance avant 30 jours de la date de naissance
event.birth.action.certificate.form.section.collectPayment.service.label.inBetweenRegistrationTargets,Birth registration after 30 days but before 365 days of date of birth,Birth registration after 30 days but before 365 days of date of birth,Enregistrement de naissance après 30 jours mais avant 365 jours de la date de naissance
event.birth.action.certificate.form.section.verifyIdentity.data.label,Label for identity verification data block,Identity details,Détails de l'identité
event.birth.action.collect-certificate.label,This is shown as the action name anywhere the user can trigger the action from,Print,Imprimer
event.birth.action.correction.form.section.requester.identity.verify.title,This is the title of the section,Verify their identity,Vérifier l'identité
event.birth.action.declare.form.label,This is what this form is referred as in the system,Birth decalration form,Birth decalration form
event.birth.action.declare.form.review.comment.label,Label for the comment field in the review section,Comment,Commentaire
event.birth.action.declare.form.review.signature.label,Label for the signature field in the review section,Signature of informant,Signature de l'informateur
event.birth.action.declare.form.review.title,Title of the form to show in review page,"{child.name.firstname, select, __EMPTY__ {Birth declaration} other {{child.name.surname, select, __EMPTY__ {Birth declaration for {child.name.firstname}} other {Birth declaration for {child.name.firstname} {child.name.surname}}}}}","{child.name.firstname, select, __EMPTY__ {Déclaration de naissance} other {{child.name.surname, select, __EMPTY__ {Déclaration de naissance pour {child.name.firstname}} other {Déclaration de naissance pour {child.name.firstname} {child.name.surname}}}}}"
event.birth.action.declare.form.section.child.field.attendantAtBirth.label,This is the label for the field,Attendant at birth,Accoucheur(se)
event.birth.action.declare.form.section.child.field.birthLocation.label,This is the label for the field,Location of birth,Lieu de naissance
event.birth.action.declare.form.section.child.field.birthType.label,This is the label for the field,Type of birth,Type d'accouchement
event.birth.action.declare.form.section.child.field.dob.error,This is the error message for invalid date,Must be a valid birth date,Doit être une date de naissance valide
event.birth.action.declare.form.section.child.field.dob.label,This is the label for the field,Date of birth,Date de naissance
event.birth.action.declare.form.section.child.field.gender.label,This is the label for the field,Sex,Sexe
event.birth.action.declare.form.section.child.field.name.label,This is the label for the field,Child's name,Nom de l'enfant
event.birth.action.declare.form.section.child.field.placeOfBirth.label,This is the label for the field,Place of delivery,Lieu de l'accouchement
event.birth.action.declare.form.section.child.field.weightAtBirth.label,This is the label for the field,Weight at birth,Poids à la naissance
event.birth.action.declare.form.section.child.field.weightAtBirth.postfix,This is the postfix for the weight field,Kilograms (kg),Kilograms (kg)
event.birth.action.declare.form.section.documents.field.proofOfFather.label,This is the label for the field,Proof of father's ID,Identité du père
event.birth.action.declare.form.section.documents.field.proofOfMother.label,This is the label for the field,Proof of mother's ID,Identité de la mère
event.birth.action.declare.form.section.father.field.address.addressSameAs.label,This is the label for the field,Same as mother's usual place of residence?,Identique au lieu de résidence habituel de la mère?
event.birth.action.declare.form.section.father.field.age.label,This is the label for the field,Age of father,Âge du père
event.birth.action.declare.form.section.father.field.name.label,This is the label for the field,Father's name,Nom du père
event.birth.action.declare.form.section.father.field.reason.label,This is the label for the field,Reason,Raison
event.birth.action.declare.form.section.informant.field.age.label,This is the label for the field,Age of informant,Âge de l'informateur
event.birth.action.declare.form.section.informant.field.email.label,This is the label for the field,Email,E-mail
event.birth.action.declare.form.section.informant.field.name.label,This is the label for the field,Informant's name,Nom du déclarant
event.birth.action.declare.form.section.informant.field.other.relation.label,This is the label for the field,Relationship to child,Relation avec l'enfant
event.birth.action.declare.form.section.informant.field.phoneNo.error,The error message that appears on phone numbers where the first two characters must be a 01 and length must be 11,Must be a valid 10 digit number that starts with 0(7|9),Doit être un nombre valide de  {num} chiffres qui commence par  {start}
event.birth.action.declare.form.section.informant.field.phoneNo.label,This is the label for the field,Phone number,Numéro de téléphone
event.birth.action.declare.form.section.informant.field.relation.label,This is the label for the field,Relationship to child,Relation avec l'enfant
event.birth.action.declare.form.section.mother.field.age.label,This is the label for the field,Age of mother,Âge de la mère
event.birth.action.declare.form.section.mother.field.name.label,This is the label for the field,Mother's name,Nom de la mère
event.birth.action.declare.form.section.mother.field.previousBirths.label,This is the label for the field,No. of previous births,Nombre de naissances antérieures
event.birth.action.declare.form.section.mother.field.reason.label,This is the label for the field,Reason,Raison
event.birth.action.declare.form.section.person.field.address.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.birth.action.declare.form.section.person.field.addressHelper.label,This is the label for the field,Usual place of residence,Adresse du domicile
event.birth.action.declare.form.section.person.field.age.checkbox.label,This is the label for the field,Exact date of birth unknown,Date de naissance exacte inconnue
event.birth.action.declare.form.section.person.field.age.postfix,This is the postfix for age field,years,years
event.birth.action.declare.form.section.person.field.brn.label,This is the label for the field,ID Number,Numéro d'identification
event.birth.action.declare.form.section.person.field.dob.error,This is the error message for invalid date,Must be a valid birth date,Doit être une date de naissance valide
event.birth.action.declare.form.section.person.field.dob.label,This is the label for the field,Date of birth,Date de naissance
event.birth.action.declare.form.section.person.field.educationalAttainment.label,This is the label for the field,Level of education,Niveau d'éducation
event.birth.action.declare.form.section.person.field.idType.label,This is the label for the field,Type of ID,Type d'identification
event.birth.action.declare.form.section.person.field.maritalStatus.label,This is the label for the field,Marital Status,Marital Status
event.birth.action.declare.form.section.person.field.nationality.label,This is the label for the field,Nationality,Nationalité
event.birth.action.declare.form.section.person.field.nid.label,This is the label for the field,ID Number,Numéro d'identification
event.birth.action.declare.form.section.person.field.occupation.label,This is the label for the field,Occupation,Profession
event.birth.action.declare.form.section.person.field.passport.label,This is the label for the field,ID Number,Numéro d'identification
event.birth.action.declare.label,This is shown as the action name anywhere the user can trigger the action from,Declare,Declare
event.birth.action.delete.label,Label for delete button in dropdown menu,Delete,Supprimer
event.birth.action.form.section.collector.other.field.name.label,This is the label for the name field of OTHER collector,Collector's name,Nom du collecteur
event.birth.action.mark-as-duplicate.label,Label for review potential duplicate button in dropdown menu,Review,Revoir
event.birth.action.register.label,Label for review record button in dropdown menu,Review,Revoir
event.birth.action.request-correction.label,This is shown as the action name anywhere the user can trigger the action from,Correct record,Enregistrement correct
event.birth.action.validate.label,This is shown as the action name anywhere the user can trigger the action from,Review,Revoir
event.birth.label,This is what this event is referred as in the system,Birth,Naissance
event.birth.summary.child.dob.empty,Label for date of birth not available,No date of birth,Pas de date de naissance
event.birth.summary.child.placeOfBirth.empty,Label for place of birth not available,No place of birth,Pas de lieu de naissance
event.birth.summary.child.placeOfBirth.label,Label for place of birth,Place of birth,Lieu de naissance
event.birth.summary.informant.contact.empty,This is shown when there is no informant information,No contact details provided,Pas de coordonnées fournies
event.birth.summary.informant.contact.label,This is the label for the informant information,Contact,Contact
event.birth.summary.informant.contact.value,This is the contact value of the informant,{informant.phoneNo} {informant.email},{informant.phoneNo} {informant.email}
event.birth.title,This is the title of the summary,{child.name.firstname} {child.name.surname},{child.name.firstname} {child.name.surname}
event.death.action.Read.label,This is shown as the action name anywhere the user can trigger the action from,Read,Lire
event.death.action.certificate.form.cancel,This is the label for the verification cancellation button,Identity does not match,L'identité ne correspond pas
event.death.action.certificate.form.cancel.confirmation.body,This is the body for the verification cancellation modal,"Please be aware that if you proceed, you will be responsible for issuing a certificate without the necessary proof of ID from the collector","Veuillez noter que si vous continuez, vous serez responsable de la délivrance d'un certificat sans la preuve d'identité nécessaire du collecteur."
event.death.action.certificate.form.cancel.confirmation.title,This is the title for the verification cancellation modal,Print without proof of ID?,Imprimer sans preuve d'identité ?
event.death.action.certificate.form.label,This is what this form is referred as in the system,Death certificate collector,Collecteur de certificat de décès
event.death.action.certificate.form.section.collectPayment.data.label,Title for the data section,Payment details,Détails du paiement
event.death.action.certificate.form.section.collectPayment.fee.label,Title for the data entry,Fee,Frais
event.death.action.certificate.form.section.collectPayment.fee.label,Title for the data entry,Fee,Frais
event.death.action.certificate.form.section.collectPayment.service.label,Title for the data entry,Service,Service
event.death.action.certificate.form.section.collectPayment.service.label,Title for the data entry,Service,Service
event.death.action.certificate.form.section.collectPayment.service.label.afterRegistrationTarget,Death registration after 45 days of date of death message,Death registration after 45 days of date of death,Enregistrement du décès après 45 jours de la date du décès
event.death.action.certificate.form.section.collectPayment.service.label.beforeRegistrationTarget,Death registration before 45 days of date of death message,Death registration before 45 days of date of death,Enregistrement du décès avant 45 jours de la date du décès
event.death.action.certificate.form.section.requester.label,This is the label for the field,Requester,Demandeur
event.death.action.certificate.form.section.requester.other.label,This is the label for the field,Print and issue to someone else,Imprimer et délivrer à quelqu'un d'autre
event.death.action.certificate.form.section.requester.printInAdvance.label,This is the label for the field,Print in advance,Imprimer à l'avance
event.death.action.certificate.form.section.requester.spouse.label,This is the label for the field,Print and issue to Spouse,Imprimer et délivrer au conjoint
event.death.action.certificate.form.section.verifyIdentity.data.label,Label for identity verification data block,Identity details,Détails de l'identité
event.death.action.certificate.form.section.who.title,This is the title of the section,Certify record,Certifier l'enregistrement
event.death.action.certificate.form.verify,This is the label for the verification button,Verified,Vérifié
event.death.action.collect-certificate.label,This is shown as the action name anywhere the user can trigger the action from,Print certificate,Imprimer le certificat
event.death.action.correction.documents.supportingDocs.affidavit.label,Label for the affidavit option,Affidavit,Affidavit
event.death.action.correction.documents.supportingDocs.courtDocument.label,Label for the court document option,Court Document,Document judiciaire
event.death.action.correction.documents.supportingDocs.label,Label for the supporting documents field,Supporting documents,Documents justificatifs
event.death.action.correction.documents.supportingDocs.other.label,Label for the other option,Other,Autre
event.death.action.correction.fees.amount.label,Label for the amount field,Fee total,Frais totaux
event.death.action.correction.fees.amount.prefix,Prefix for the amount field,$,€
event.death.action.correction.form.cancel,This is the label for the verification cancellation button,Identity does not match,L'identité ne correspond pas
event.death.action.correction.form.cancel.confirmation.body,This is the body for the verification cancellation modal,"Please be aware that if you proceed, you will be responsible for making a change to this record without the necessary proof of identification","Veuillez noter que si vous continuez, vous serez responsable d'apporter une modification à cet enregistrement sans la preuve d'identification nécessaire."
event.death.action.correction.form.cancel.confirmation.title,This is the title for the verification cancellation modal,Correct without proof of ID?,Correction sans preuve d'identité ?
event.death.action.correction.form.label,This is the label for the death correction form,Correct record,Corriger le dossier
event.death.action.correction.form.requester.type.daughter,This is the label for the correction requester field,Daughter,Fille
event.death.action.correction.form.requester.type.daughterInLaw,This is the label for the correction requester field,Daughter-in-law,Belle-fille
event.death.action.correction.form.requester.type.father,This is the label for the correction requester field,Father,Père
event.death.action.correction.form.requester.type.granddaughter,This is the label for the correction requester field,Granddaughter,Petite-fille
event.death.action.correction.form.requester.type.grandson,This is the label for the correction requester field,Grandson,Petit-fils
event.death.action.correction.form.requester.type.mother,This is the label for the correction requester field,Mother,Mère
event.death.action.correction.form.requester.type.other,This is the label for the correction requester field,Other,Autre
event.death.action.correction.form.requester.type.son,This is the label for the correction requester field,Son,Fils
event.death.action.correction.form.requester.type.sonInLaw,This is the label for the correction requester field,Son-in-law,Gendre
event.death.action.correction.form.requester.type.spouse,This is the label for the correction requester field,Spouse,Conjoint
event.death.action.correction.form.section.details.divider.label,This is the title of the section,,
event.death.action.correction.form.section.details.title,This is the title of the section,Correction details,Détails de la correction
event.death.action.correction.form.section.fees.title,This is the title of the section,Collect fees,Collecter les frais
event.death.action.correction.form.section.reason.title,This is the title of the section,Reason for correction,Raison de la correction
event.death.action.correction.form.section.requester.brn.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.correction.form.section.requester.father.label,This is the label for the field,Father,Père
event.death.action.correction.form.section.requester.idType.label,This is the label for the field,Type of ID,Type d'identité
event.death.action.correction.form.section.requester.identity.verify.title,This is the title of the section,Verify their identity,Vérifier l'identité
event.death.action.correction.form.section.requester.label,This is the label for the field,Requester,Demandeur
event.death.action.correction.form.section.requester.mother.label,This is the label for the field,Mother,Mère
event.death.action.correction.form.section.requester.name.label,This is the label for the field,Name,Nom
event.death.action.correction.form.section.requester.nid.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.correction.form.section.requester.passport.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.correction.form.section.requester.relationship.label,This is the label for the field,Relationship to child,Relation avec l'enfant
event.death.action.correction.form.section.requester.relationship.placeholder,This is the placeholder for the field,eg. Grandmother,ex. Grand-mère
event.death.action.correction.form.section.supporting-documents.title,This is the title of the section,Upload supporting documents,Télécharger les documents justificatifs
event.death.action.correction.form.section.verifyIdentity.data.label,Title for the data section,,
event.death.action.correction.form.verify,This is the label for the verification button,Verified,Vérifié
event.death.action.correction.reason.option.clericalError.label,Label for the clerical error option,Myself or an agent made a mistake (Clerical error),Une erreur a été commise par moi-même ou un agent (Erreur administrative)
event.death.action.correction.reason.option.judicialOrder.label,Label for the judicial order option,Requested to do so by the court (Judicial order),Demandé par le tribunal (Ordonnance judiciaire)
event.death.action.correction.reason.option.materialError.label,Label for the material error option,Informant provided incorrect information (Material error),L'informateur a fourni des informations incorrectes (Erreur matérielle)
event.death.action.correction.reason.option.materialOmission.label,Label for the material omission option,Informant did not provide this information (Material omission),L'informateur n'a pas fourni cette information (Omission matérielle)
event.death.action.correction.reason.option.other.label,Label for the other option,Other,Autre
event.death.action.correction.reason.other.label,Label for the reason,Specify reason,Préciser la raison
event.death.action.declare.form.label,This is what this form is referred as in the system,Death declaration form,Formulaire de déclaration de décès
event.death.action.declare.form.nid.unique,This is the error message for non-unique ID Number,National id must be unique,L'identifiant national doit être unique
event.death.action.declare.form.nid.unique,This is the error message for non-unique ID Number,National id must be unique,L'identifiant national doit être unique
event.death.action.declare.form.nid.unique,This is the error message for non-unique ID Number,National id must be unique,L'identifiant national doit être unique
event.death.action.declare.form.review.comment.label,Label for the comment field in the review section,Comment,Commentaire
event.death.action.declare.form.review.signature.label,Label for the signature field in the review section,Signature of informant,Signature de l'informateur
event.death.action.declare.form.review.title,Title of the form to show in review page,"{deceased.name.firstname, select, __EMPTY__ {Death declaration} other {{deceased.name.surname, select, __EMPTY__ {Death declaration for {deceased.name.firstname}} other {Death declaration for {deceased.name.firstname} {deceased.name.surname}}}}}","{deceased.name.firstname, select, __EMPTY__ {Déclaration de décès} other {{deceased.name.surname, select, __EMPTY__ {Déclaration de décès de {deceased.name.firstname}} other {Déclaration de décès de {deceased.name.firstname} {deceased.name.surname}}}}}"
event.death.action.declare.form.section.deceased.field.address.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.death.action.declare.form.section.deceased.field.addressHelper.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.death.action.declare.form.section.deceased.field.age.checkbox.label,This is the label for the field,Exact date of birth unknown,Date exacte de naissance inconnue
event.death.action.declare.form.section.deceased.field.age.error,Error message for invalid age,Age must be between 0 and 120,L'auteur doit avoir entre 0 et 120 ans
event.death.action.declare.form.section.deceased.field.age.label,This is the label for the field,Age of deceased,Âge du défunt
event.death.action.declare.form.section.deceased.field.age.postfix,This is the postfix for age field,years,ans
event.death.action.declare.form.section.deceased.field.deathLocation.label,This is the label for the field,Health Institution,Établissement de santé
event.death.action.declare.form.section.deceased.field.deathLocationOther.label,This is the label for the field,Death location address,Adresse du lieu de décès
event.death.action.declare.form.section.deceased.field.dob.error,This is the error message for invalid date,Must be a valid Birthdate,Doit être une date de naissance valide
event.death.action.declare.form.section.deceased.field.dob.error.laterThanDeath,This is the error message for date of birth later than date of death,Date of birth must be before the date of death,La date de naissance doit être antérieure à la date de décès
event.death.action.declare.form.section.deceased.field.dob.label,This is the label for the field,Date of birth,Date de naissance
event.death.action.declare.form.section.deceased.field.gender.label,This is the label for the field,Sex,Sexe
event.death.action.declare.form.section.deceased.field.maritalStatus.label,This is the label for the field,Marital Status,État civil
event.death.action.declare.form.section.deceased.field.name.label,This is the label for the field,Deceased's name,Nom du défunt
event.death.action.declare.form.section.deceased.field.numberOfDependants.label,This is the label for the field,No. of dependants,Nombre de personnes à charge
event.death.action.declare.form.section.deceased.field.placeOfDeath.label,This is the label for the field,Place of death,Lieu du décès
event.death.action.declare.form.section.documents.field.proofOfCauseOfDeath.label,This is the label for the field,Proof of cause of death,Preuve de la cause du décès
event.death.action.declare.form.section.documents.field.proofOfDeath.label,This is the label for the field,Proof of death of deceased,Preuve du décès du défunt
event.death.action.declare.form.section.documents.field.proofOfDeceased.label,This is the label for the field,Proof of deceased's ID,Preuve de l'identité du défunt
event.death.action.declare.form.section.documents.field.proofOfInformant.label,This is the label for the field,Proof of informant's ID,Preuve de l'identité de l'informateur
event.death.action.declare.form.section.event.field.addressHelper.label,This is the label for the field,Place of death,Lieu du décès
event.death.action.declare.form.section.event.field.causeOfDeath.label,This is the label for the field,Cause of death has been established,La cause du décès a été établie
event.death.action.declare.form.section.event.field.date.error,This is the error message for invalid date,Must be a valid date,Doit être une date valide
event.death.action.declare.form.section.event.field.date.error.beforeBirth,This is the error message for date of death before date of birth,Date of death must be after the deceased's birth date,La date du décès doit être postérieure à la date de naissance du défunt
event.death.action.declare.form.section.event.field.date.label,This is the label for the field,Date of death,Date du décès
event.death.action.declare.form.section.event.field.description.label,Description of cause of death by lay person or verbal autopsy,Description,Description
event.death.action.declare.form.section.event.field.manner.label,This is the label for the field,Manner of death,Mode de décès
event.death.action.declare.form.section.event.field.reason.label,This is the label for the field,Reason for late registration,Raison de l'inscription tardive
event.death.action.declare.form.section.event.field.sourceCauseDeath.label,This is the label for the field,Source of cause of death,Source de la cause du décès
event.death.action.declare.form.section.informant.field.address.addressSameAs.label,This is the label for the field,Same as deceased's usual place of residence?,Identique au lieu de résidence habituel du défunt ?
event.death.action.declare.form.section.informant.field.address.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.death.action.declare.form.section.informant.field.addressHelper.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.death.action.declare.form.section.informant.field.age.checkbox.label,This is the label for the field,Exact date of birth unknown,Date exacte de naissance inconnue
event.death.action.declare.form.section.informant.field.age.label,This is the label for the field,Age of informant,Âge de l'informateur
event.death.action.declare.form.section.informant.field.age.postfix,This is the postfix for age field,years,ans
event.death.action.declare.form.section.informant.field.brn.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.informant.field.dob.error,This is the error message for invalid date,Must be a valid Birthdate,Doit être une date de naissance valide
event.death.action.declare.form.section.informant.field.dob.label,This is the label for the field,Date of birth,Date de naissance
event.death.action.declare.form.section.informant.field.email.label,This is the label for the field,Email,Email
event.death.action.declare.form.section.informant.field.idType.label,This is the label for the field,Type of ID,Type d'identité
event.death.action.declare.form.section.informant.field.name.label,This is the label for the field,Informant's name,Nom de l'informateur
event.death.action.declare.form.section.informant.field.nationality.label,This is the label for the field,Nationality,Nationalité
event.death.action.declare.form.section.informant.field.nid.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.informant.field.other.relation.label,This is the label for the field,Relationship to deceased,Relation avec le défunt
event.death.action.declare.form.section.informant.field.passport.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.informant.field.phoneNo.error,The error message that appears on phone numbers where the first two characters must be 07 or 09 and length must be 10,Must be a valid 10 digit number that starts with 0(7|9),Doit être un nombre valide de 10 chiffres qui commence par 0(7|9)
event.death.action.declare.form.section.informant.field.phoneNo.label,This is the label for the field,Phone number,Numéro de téléphone
event.death.action.declare.form.section.informant.field.relation.label,This is the label for the field,Informant type,Type d'informateur
event.death.action.declare.form.section.person.field.brn.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.person.field.idType.label,This is the label for the field,Type of ID,Type d'identité
event.death.action.declare.form.section.person.field.nationality.label,This is the label for the field,Nationality,Nationalité
event.death.action.declare.form.section.person.field.nid.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.person.field.passport.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.spouse.field.address.addressSameAs.label,This is the label for the field,Same as deceased's usual place of residence?,Identique au lieu de résidence habituel du défunt ?
event.death.action.declare.form.section.spouse.field.address.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.death.action.declare.form.section.spouse.field.addressHelper.label,This is the label for the field,Usual place of residence,Lieu de résidence habituel
event.death.action.declare.form.section.spouse.field.age.checkbox.label,This is the label for the field,Exact date of birth unknown,Date exacte de naissance inconnue
event.death.action.declare.form.section.spouse.field.age.label,This is the label for the field,Age of spouse,Âge du conjoint
event.death.action.declare.form.section.spouse.field.age.postfix,This is the postfix for age field,years,ans
event.death.action.declare.form.section.spouse.field.brn.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.spouse.field.detailsNotAvailable.label,This is the label for the field,Spouse's details are not available,Les informations du conjoint ne sont pas disponibles
event.death.action.declare.form.section.spouse.field.dob.error,This is the error message for invalid date,Must be a valid Birthdate,Doit être une date de naissance valide
event.death.action.declare.form.section.spouse.field.dob.label,This is the label for the field,Date of birth,Date de naissance
event.death.action.declare.form.section.spouse.field.idType.label,This is the label for the field,Type of ID,Type d'identité
event.death.action.declare.form.section.spouse.field.name.label,This is the label for the field,Spouse's name,Nom du conjoint
event.death.action.declare.form.section.spouse.field.nationality.label,This is the label for the field,Nationality,Nationalité
event.death.action.declare.form.section.spouse.field.nid.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.spouse.field.passport.label,This is the label for the field,ID Number,Numéro d'identité
event.death.action.declare.form.section.spouse.field.reason.label,This is the label for the field,Reason,Raison
event.death.action.declare.label,This is shown as the action name anywhere the user can trigger the action from,Declare,Déclarer
event.death.action.form.section.alienNumberDetails.label,Field for entering Alien Number details,Alien Number,Numéro d'étranger
event.death.action.form.section.brn.label,Field for entering Birth Registration Number,Birth Registration Number,Numéro d'enregistrement de naissance
event.death.action.form.section.collector.other.field.name.label,This is the label for the name field of OTHER collector,Collector's name,Nom du collecteur
event.death.action.form.section.drivingLicenseDetails.label,Field for entering Driving License details,Drivers License,Permis de conduire
event.death.action.form.section.idNumberOther.label,Field for entering ID Number if Other is selected,ID Number,Numéro d'identité
event.death.action.form.section.idType.alienNumber.label,Option for selecting Alien Number as the ID type,Alien Number,Numéro d'étranger
event.death.action.form.section.idType.brn.label,Option for selecting Birth Registration Number as the ID type,Birth Registration Number,Numéro d'enregistrement de naissance
event.death.action.form.section.idType.drivingLicense.label,Option for selecting Driving License as the ID type,Drivers License,Permis de conduire
event.death.action.form.section.idType.label,This is the label for selecting the type of ID,Type of ID,Type d'identité
event.death.action.form.section.idType.nid.label,Option for selecting National ID as the ID type,National ID,Carte nationale d'identité
event.death.action.form.section.idType.noId.label,Option for selecting No ID as the ID type,No ID available,Aucune identité disponible
event.death.action.form.section.idType.other.label,Option for selecting Other as the ID type,Other,Autre
event.death.action.form.section.idType.passport.label,Option for selecting Passport as the ID type,Passport,Passeport
event.death.action.form.section.idType.refugeeNumber.label,Option for selecting Refugee Number as the ID type,Refugee Number,Numéro de réfugié
event.death.action.form.section.idTypeOther.label,Field for entering ID type if Other is selected,Other type of ID,Autre type d'identité
event.death.action.form.section.nid.label,Field for entering ID Number,National ID,Carte nationale d'identité
event.death.action.form.section.passportDetails.label,Field for entering Passport details,Passport,Passeport
event.death.action.form.section.refugeeNumberDetails.label,Field for entering Refugee Number details,Refugee Number,Numéro de réfugié
event.death.action.form.section.relationshipToDeceased.label,This is the label for the relationship to deceased field,Relationship to deceased,Relation avec le défunt
event.death.action.form.section.signedAffidavit.fileName,This is the label for the file name,Signed Affidavit,Déclaration signée
event.death.action.form.section.signedAffidavit.label,This is the label for uploading a signed affidavit,Signed Affidavit (Optional),Déclaration signée (Optionnel)
event.death.action.register.label,This is shown as the action name anywhere the user can trigger the action from,Register,Enregistrer
event.death.action.request-correction.label,This is shown as the action name anywhere the user can trigger the action from,Correct record,Corriger l'enregistrement
event.death.action.validate.label,This is shown as the action name anywhere the user can trigger the action from,Validate,Valider
event.death.label,This is what this event is referred as in the system,Death,Décès
event.death.summary.eventDetails.date.empty,This is shown when there is no date of death information,No date of death,Aucune date de décès
event.death.summary.eventDetails.deathLocation.empty,This is shown when there is no death location information,No place of death,Aucun lieu de décès
event.death.summary.eventDetails.deathLocation.label,Label for place of death,Place of death,Lieu de décès
event.death.summary.eventDetails.placeOfDeath.empty,This is shown when there is no place of death information,No place of death,Aucun lieu de décès
event.death.summary.eventDetails.placeOfDeath.label,Label for place of death,Place of death,Lieu de décès
event.death.summary.informant.contact.empty,This is shown when there is no informant information,No contact details provided,Aucun contact fourni
event.death.summary.informant.contact.label,This is the label for the informant information,Contact,Contact
event.death.summary.informant.contact.value,This is the contact value of the informant,{informant.phoneNo} {informant.email},{informant.phoneNo} {informant.email}
event.death.title,This is the title of the summary,{deceased.name.firstname} {deceased.name.surname},{deceased.name.firstname} {deceased.name.surname}
event.default.action.certificate.template.type.label,Select certificate template,Type,Taper
event.default.action.certificate.template.type.notFound,Select certificate template options not found,"No template available for this event, contact Admin","Aucun modèle disponible pour cette event, contactez l’admin"
event.history.role,Label for the role in event history,"{role, select, LOCAL_REGISTRAR {Local Registrar} FIELD_AGENT {Field Agent} POLICE_OFFICER {Police Officer} REGISTRATION_AGENT {Registration Agent} HEALTHCARE_WORKER {Healthcare Worker} HOSPITAL_CLERK {Hospital Clerk} LOCAL_SYSTEM_ADMIN {Administrator} NATIONAL_REGISTRAR {Registrar General} PERFORMANCE_MANAGER {Operations Manager} NATIONAL_SYSTEM_ADMIN {National Administrator} COMMUNITY_LEADER {Community Leader} HEALTH {Health integration} IMPORT {Import integration} NATIONAL_ID {National ID integration} RECORD_SEARCH {Record search integration} WEBHOOK {Webhook} other {Unknown}}","{role, select, LOCAL_REGISTRAR {Officier d'état civil local} POLICE_OFFICER {Agent de police} FIELD_AGENT {Agent de terrain} REGISTRATION_AGENT {Agent d'enregistrement} HEALTHCARE_WORKER {Professionnel de santé} PERFORMANCE_MANAGER {Responsable des opérations} LOCAL_SYSTEM_ADMIN {Administrateur} NATIONAL_SYSTEM_ADMIN {Administrateur national} NATIONAL_REGISTRAR {Registraire général} HOSPITAL_CLERK {Employé administratif à l'hôpital} HEALTH {Intégration santé} IMPORT {Intégration d'importation} NATIONAL_ID {Intégration ID nationale} RECORD_SEARCH {Intégration de recherche d'enregistrements} WEBHOOK {Webhook} COMMUNITY_LEADER {Responsable communautaire} other {Inconnu}}"
event.history.system,Name for system initiated actions in the event history,System,System
event.history.systemDefaultName,Fallback for system integration name in the event history,System integration,Intégration système
event.not.downloaded,Shown when user tries to perform an action on event that is not available,Please ensure the event is first assigned and downloaded to the browser.,Veuillez vous assurer que l'événement est d'abord attribué et téléchargé dans le navigateur.
event.summary.assignedTo.empty,Not assigned message,Not assigned,Non assigné
event.summary.assignedTo.label,Assigned to label,Assigned to,Assigné à
event.summary.assignedTo.value,Assigned to value,{event.assignedTo},{event.assignedTo}
event.summary.event.label,Label for the event field,Event,Événement
event.summary.flags.label,Flags of the event,Flags,Drapeaux
event.summary.flags.placeholder,Message when no flags are present,No flags,Pas de drapeaux
event.summary.registrationNumber.empty,No registration number message,No registration number,Aucun numéro d'inscription
event.summary.registrationNumber.label,Label for the registration number field,Registration Number,Numéro d'inscription
event.summary.registrationNumber.value,Value for the registration number field,{event.registrationNumber},{event.registrationNumber}
event.summary.status.label,Label for the status field,Status,Statut
event.summary.status.value,Value for the status field,"{event.status, select, CREATED {Draft} NOTIFIED {Notified} VALIDATED {Validated} DRAFT {Draft} DECLARED {Declared} REGISTERED {Registered} CERTIFIED {Certified} REJECTED {Requires update} ARCHIVED {Archived} MARKED_AS_DUPLICATE {Marked as a duplicate} MARK_AS_NOT_DUPLICATE {Marked not a duplicate} other {Unknown}}","{event.status, select, CREATED {Brouillon} NOTIFIED {Incomplet} VALIDATED {Validé} DRAFT {Brouillon} DECLARED {Déclaré} REGISTERED {Enregistré} CERTIFIED {Certifié} REJECTED {Requiert une mise à jour} ARCHIVED {Archivé} MARKED_AS_DUPLICATE {Marqué comme doublon} MARK_AS_NOT_DUPLICATE {Marqué comme non en doublon} other {Inconnu}}"
event.summary.trackingId.empty,Message when tracking ID is empty,No tracking ID,Aucun ID de suivi
event.summary.trackingId.label,Label for the tracking ID field,Tracking ID,ID de suivi
event.summary.trackingId.value,Value for the tracking ID field,{event.trackingId},{event.trackingId}
event.tennis-club-membership.action.certificate.form.label,This is what this form is referred as in the system,Tennis club membership certificate collector,Tennis club membership certificate collector
event.tennis-club-membership.action.certificate.form.section.requester.informant.label,This is the label for the field,Print and issue Informant,Print and issue Informant
event.tennis-club-membership.action.certificate.form.section.requester.label,This is the label for the field,Requester,Requester
event.tennis-club-membership.action.certificate.form.section.requester.other.label,This is the label for the field,Print and issue someone else,Print and issue someone else
event.tennis-club-membership.action.certificate.form.section.requester.printInAdvance.label,This is the label for the field,Print in advance,Imprimer à l'avance pour les signatures et la collecte
event.tennis-club-membership.action.certificate.form.section.who.title,This is the title of the section,Print certified copy,Imprimer une copie certifiée
event.tennis-club-membership.action.collect-certificate.label,This is shown as the action name anywhere the user can trigger the action from,Print certificate,Imprimer le certificat
event.tennis-club-membership.action.declare.form.label,This is what this form is referred as in the system,Tennis club membership application,Tennis club membership application
event.tennis-club-membership.action.declare.form.review.title,Title of the form to show in review page,"{applicant.name.firstname, select, __EMPTY__ {Member declaration} other {{applicant.name.surname, select, __EMPTY__ {Member declaration for {applicant.name.firstname}} other {Member declaration for {applicant.name.firstname} {applicant.name.surname}}}}}","{applicant.name.firstname, select, __EMPTY__ {Déclaration des membres} other {{applicant.name.surname, select, __EMPTY__ {Déclaration des membres pour {applicant.name.firstname}} other {Déclaration des membres pour {applicant.name.firstname} {applicant.name.surname}}}}}"
event.tennis-club-membership.action.declare.form.section.recommender.field.firstname.label,This is the label for the field,Recommender's first name,Recommender's first name
event.tennis-club-membership.action.declare.form.section.recommender.field.firstname.label,This is the label for the field,Recommender's name,Nom du recommandataire
event.tennis-club-membership.action.declare.form.section.recommender.field.id.label,This is the label for the field,Recommender's membership ID,Recommender's membership ID
event.tennis-club-membership.action.declare.form.section.recommender.field.none.label,This is the label for the field,No recommender,No recommender
event.tennis-club-membership.action.declare.form.section.recommender.title,This is the title of the section,Who is recommending the applicant?,Who is recommending the applicant?
event.tennis-club-membership.action.declare.form.section.who.field.dob.error,This is the error message for invalid date,Must be a valid birth date,Doit être une date de naissance valide
event.tennis-club-membership.action.declare.form.section.who.field.dob.label,This is the label for the field,Applicant's date of birth,Applicant's date of birth
event.tennis-club-membership.action.declare.form.section.who.field.image.label,This is the label for the field,Applicant's profile picture,Applicant's profile picture
event.tennis-club-membership.action.declare.form.section.who.field.name.label,This is the title for the name field,Name of applicant,Nom du demandeur
event.tennis-club-membership.action.declare.form.section.who.title,This is the title of the section,Who is applying for the membership?,Who is applying for the membership?
event.tennis-club-membership.action.declare.label,This is shown as the action name anywhere the user can trigger the action from,Send an application,Send an application
event.tennis-club-membership.action.delete.label,This is shown as the action name anywhere the user can trigger the action from,Delete draft,Delete draft
event.tennis-club-membership.action.form.section.alienNumberDetails.label,Field for entering Alien Number details,Alien Number Details,Alien Number Details
event.tennis-club-membership.action.form.section.drivingLicenseDetails.label,Field for entering Driving License details,Driving License Details,Driving License Details
event.tennis-club-membership.action.form.section.firstName.label,This is the label for the first name field,First Name,First Name
event.tennis-club-membership.action.form.section.idType.alienNumber.label,Option for selecting Alien Number as the ID type,Alien Number,Numéro de l'étranger
event.tennis-club-membership.action.form.section.idType.drivingLicense.label,Option for selecting Driving License as the ID type,Driving License,Driving License
event.tennis-club-membership.action.form.section.idType.label,This is the label for selecting the type of ID,Select Type of ID,Select Type of ID
event.tennis-club-membership.action.form.section.idType.noId.label,Option for selecting No ID as the ID type,No ID,No ID
event.tennis-club-membership.action.form.section.idType.other.label,Option for selecting Other as the ID type,Other,Autre
event.tennis-club-membership.action.form.section.idType.passport.label,Option for selecting Passport as the ID type,Passport,Passeport
event.tennis-club-membership.action.form.section.idType.refugeeNumber.label,Option for selecting Refugee Number as the ID type,Refugee Number,Numéro du réfugié
event.tennis-club-membership.action.form.section.idTypeOther.label,Field for entering ID type if Other is selected,Other ID Type (if applicable),Other ID Type (if applicable)
event.tennis-club-membership.action.form.section.lastName.label,This is the label for the last name field,Last Name,Last Name
event.tennis-club-membership.action.form.section.passportDetails.label,Field for entering Passport details,Passport Details,Passport Details
event.tennis-club-membership.action.form.section.refugeeNumberDetails.label,Field for entering Refugee Number details,Refugee Number Details,Refugee Number Details
event.tennis-club-membership.action.form.section.relationshipToMember.label,This is the label for the relationship to member field,Relationship to Member,Relationship to Member
event.tennis-club-membership.action.form.section.signedAffidavit.label,This is the label for uploading a signed affidavit,Signed Affidavit (Optional),Signed Affidavit (Optional)
event.tennis-club-membership.action.register.label,This is shown as the action name anywhere the user can trigger the action from,Register,Enregistrer
event.tennis-club-membership.action.requestCorrection.form.section.corrector,This is the title of the section,Correction requester,Qui demande une modification de ce dossier ?
event.tennis-club-membership.action.requestCorrection.form.section.verify,This is the title of the section,Verify their identity,Vérifier leur identité
event.tennis-club-membership.action.requestCorrection.label,This is shown as the action name anywhere the user can trigger the action from,Request correction,Request correction
event.tennis-club-membership.action.validate.label,This is shown as the action name anywhere the user can trigger the action from,Validate,Validate
event.tennis-club-membership.label,This is what this event is referred as in the system,Tennis club membership application,Tennis club membership application
event.tennis-club-membership.search.applicants,Applicant details search field section title,Applicant's details,Détails du demandeur
event.tennis-club-membership.search.recommender,Recommender details search field section title,Recommender's details,Détails du référent
event.tennis-club-membership.summary.field.applicant.firstname.empty,Shown when the applicant's first name is missing in summary,Applicant's first name missing,Applicant's first name missing
event.tennis-club-membership.summary.field.applicant.firstname.label,Label for the applicant's first name field,Applicant's First Name,Applicant's First Name
event.tennis-club-membership.summary.field.recommender.firstname.empty,Shown when the recommender first name is missing in summary,Recommender's first name missing,Recommender's first name missing
event.tennis-club-membership.summary.field.recommender.firstname.label,Label for the recommender's first name field,Recommender's First Name,Recommender's First Name
event.tennis-club-membership.summary.field.recommender.id.empty,Shown when the recommender id is missing in summary,Recommender's id missing,Recommender's id missing
event.tennis-club-membership.summary.field.recommender.id.label,Label for the recommender's ID field,Recommender's ID,Recommender's ID
events.history.status,Events status history,"{status, select, CREATE {Declaration started} NOTIFY {Sent incomplete} VALIDATE {Sent for approval} DRAFT {Draft} DECLARE {Sent for review} REGISTER {Registered} PRINT_CERTIFICATE {Certified} REJECT {Rejected} ARCHIVE {Archived} DUPLICATE_DETECTED {Flagged as potential duplicate} MARKED_AS_DUPLICATE {Marked as a duplicate} MARK_AS_NOT_DUPLICATE {Marked not a duplicate} CORRECTED {Record corrected} REQUEST_CORRECTION {Correction requested} APPROVE_CORRECTION {Correction approved} REJECT_CORRECTION {Correction rejected} READ {Viewed} ASSIGN {Assigned} UNASSIGN {Unassigned} UPDATE {Updated} other {Unknown}}","{status, select, CREATE {Déclaration commencée} NOTIFY {Envoyé incomplet} VALIDATE {Envoyé pour approbation} DRAFT {Brouillon} DECLARE {Envoyé pour révision} REGISTER {Enregistré} PRINT_CERTIFICATE {Certifié} REJECT {Rejeté} ARCHIVE {Archivé} DUPLICATE_DETECTED {Marqué comme doublon} MARKED_AS_DUPLICATE {Marqué comme doublon} MARK_AS_NOT_DUPLICATE {Marqué comme non en doublon} CORRECTED {Enregistrement corrigé} REQUEST_CORRECTION {Correction demandée} APPROVE_CORRECTION {Correction approuvée} REJECT_CORRECTION {Correction refusée} READ {Consulté} ASSIGN {Attribué} UNASSIGN {Désattribué} UPDATE {Mis à jour} other {Inconnu}}"
events.outbox.processingAction,Message in outbox when processing action,"{action, select, DECLARE {Sending} REGISTER {Registering} VALIDATE {Sending for approval} NOTIFY {Sending} REJECT {Sending for updates} ARCHIVE {Archiving} PRINT_CERTIFICATE {Certifying} REQUEST_CORRECTION {Requesting correction} APPROVE_CORRECTION {Approving correction} REJECT_CORRECTION {Rejecting correction} ASSIGN {Assigning} UNASSIGN {Unassigning} other {processing action}}","{action, select, DECLARE {Envoi} REGISTER {Enregistrement} VALIDATE {Envoi pour approbation} NOTIFY {Envoi} REJECT {Envoi pour mise à jour} ARCHIVE {Archivage} PRINT_CERTIFICATE {Certification} REQUEST_CORRECTION {Demande de correction} APPROVE_CORRECTION {Approbation de la correction} REJECT_CORRECTION {Rejet de la correction} ASSIGN {Attribution} UNASSIGN {Désattribution} other {action en cours}}"
events.outbox.waitingForAction,Message in outbox when waiting for action,"Waiting to {action, select, DECLARE {send} CREATE {send} REGISTER {register} VALIDATE {send for approval} NOTIFY {send} REJECT {send for updates} ARCHIVE {archive} PRINT_CERTIFICATE {certify} REQUEST_CORRECTION {request correction} APPROVE_CORRECTION {approve correction} REJECT_CORRECTION {reject correction} ASSIGN {assign} UNASSIGN {unassign} other {action}}","En attente de {action, select, DECLARE {l'envoi} CREATE {l'envoi} REGISTER {l'enregistrement} VALIDATE {l'envoi pour approbation} NOTIFY {l'envoi} REJECT {l'envoi pour mise à jour} ARCHIVE {l'archivage} PRINT_CERTIFICATE {la certification} REQUEST_CORRECTION {la demande de correction} APPROVE_CORRECTION {l'approbation de la correction} REJECT_CORRECTION {le rejet de la correction} ASSIGN {l'attribution} UNASSIGN {la désattribution} other {l'action}}"
events.status,Dynamic event status,"{status, select, OUTBOX {Syncing..} CREATED {Draft} VALIDATED {Validated} DRAFT {Draft} DECLARED {Declared} REGISTERED {Registered} CERTIFIED {Certified} REJECTED {Rejected} ARCHIVED {Archived} MARKED_AS_DUPLICATE {Marked as a duplicate} MARK_AS_NOT_DUPLICATE {Marked not a duplicate} NOTIFIED {In progress} other {Unknown}}","{status, select, OUTBOX {Synchronisation..} CREATED {Brouillon} VALIDATED {Validé} DRAFT {Brouillon} DECLARED {Déclaré} REGISTERED {Enregistré} CERTIFIED {Certifié} REJECTED {Nécessite une mise à jour} ARCHIVED {Archivé} MARKED_AS_DUPLICATE {Marqué comme doublon} MARK_AS_NOT_DUPLICATE {Marqué comme non en doublon} NOTIFIED {Notifié} other {Inconnu}}"
exitModal.cancel, Modal cancel button,Cancel,Annuler
exitModal.exitWithoutSaving,exitmodal without saving label,Exit without saving changes?,Quitter sans enregistrer les modifications?
exitModal.exitWithoutSavingDescription, exitmodal without saving  description,You have unsaved changes on your declaration form. Are you sure you want to exit without saving?,Vous avez des modifications non enregistrées sur votre formulaire de déclaration. Voulez-vous vraiment quitter sans enregistrer ?
field.address.addressLine1.label,This is the label for the field,Address Line 1,Adresse Ligne 1
field.address.addressLine2.label,This is the label for the field,Address Line 2,Adresse Ligne 2
field.address.addressLine3.label,This is the label for the field,Address Line 3,Adresse Ligne 3
field.address.cityOrTown.label,This is the label for the field,City / Town,Ville / Commune
field.address.country.label,Label for country in address,Country,Pays
field.address.district.label,Label for district in address,District,District
field.address.district2.label,This is the label for the field,District,District
field.address.number.label,Label for address number,Number,Numéro
field.address.postcodeOrZip.label,This is the label for the field,Postcode / Zip,Code postal / Zip
field.address.province.label,Label for province in address,Province,Province
field.address.residentialArea.label,Label for residential area in address,Residential Area,Zone de résidence
field.address.state.label,This is the label for the field,State,État
field.address.street.label,Label for street in address,Street,Rue
field.address.town.label,Label for town in address,Town,Ville
field.name.firstname.label,This is the label for the firstname field,First name(s),Prénom(s)
field.name.middlename.label,This is the label for the middleName field,Middle name,Deuxième prénom(s)
field.name.surname.label,This is the label for the surname field,Last name,Nom(s)
file.upload.fileSize.error,Error message when the selected file is too large,File size must be less than {maxSize}mb,La taille du fichier doit être inférieure à {maxSize}M
file.upload.fileType.error,Error message when the selected file type is not supported,File format not supported. Please attach {types} (max {maxSize}mb),Format de fichier non pris en charge. Veuillez joindre un {types} (max {maxSize}mb)
flags.builtin.correction-requested.label,Label for flag,Correction requested,Correction demandée
flags.builtin.incomplete.label,Label for flag,Incomplete,Incomplet
flags.builtin.pending-certification.label,Label for flag,Pending certification,En attente de certification
flags.builtin.potential-duplicate.label,Label for flag,Potential duplicate,Doublon potentiel
flags.builtin.rejected.label,Label for flag,Rejected,Rejeté
form.birth.child.title,Form section title for Child,Child's details,information de l'enfant
form.field.label.No,Label for form field radio option No,No,Non
form.field.label.Yes,Label for form field radio option Yes,Yes,Ouio
form.field.label.attendantAtBirthLayperson,Label for layperson attendant,Layperson,personne lamda
form.field.label.attendantAtBirthMidwife,Label for midwife attendant,Midwife,Sage-femme
form.field.label.attendantAtBirthNone,Label for no attendant,None,Aucun
form.field.label.attendantAtBirthNurse,Label for nurse attendant,Nurse,Infirmière
form.field.label.attendantAtBirthOtherParamedicalPersonnel,Label for other paramedical personnel,Other paramedical personnel,Autre personnel paramédical
form.field.label.attendantAtBirthPhysician,Label for physician attendant,Physician,Médecin
form.field.label.attendantAtBirthTraditionalBirthAttendant,Label for traditional birth attendant,Traditional birth attendant,Accoucheur(se) Traditionnel(le)
form.field.label.birthTypeHigherMultipleDelivery,Label for higher multiple delivery birth,Higher multiple delivery,Accouchement multiple supérieur
form.field.label.birthTypeQuadruplet,Label for quadruplet birth,Quadruplet,Quadruplet
form.field.label.birthTypeSingle,Label for single birth,Single,Célibataire
form.field.label.birthTypeTriplet,Label for triplet birth,Triplet,Triplet
form.field.label.birthTypeTwin,Label for twin birth,Twin,Jumeau
form.field.label.educationAttainmentISCED1,Option for form field: ISCED1 education,Primary,Primaire
form.field.label.educationAttainmentISCED4,Option for form field: ISCED4 education,Secondary,Secondaire
form.field.label.educationAttainmentISCED5,Option for form field: ISCED5 education,Tertiary,Tertiaire
form.field.label.educationAttainmentNone,Option for form field: no education,No schooling,Pas de scolarité
form.field.label.healthInstitution,Select item for Health Institution,Health Institution,Institution de santé
form.field.label.iDTypeBRN,Option for form field: Type of ID,Birth Registration Number,Numéro d'enregistrement de naissance
form.field.label.iDTypeNationalID,Option for form field: Type of ID,National ID,Carte d'identité nationale
form.field.label.iDTypePassport,Option for form field: Type of ID,Passport,Passeport
form.field.label.informantRelation.others,Label for option someone else,Someone else,Quelqu'un d'autre
form.field.label.informantRelation.sister,Label for option Sister,Sister,Sœur
form.field.label.maritalStatusDivorced,Option for form field: Marital status,Divorced,Divorcé(e)
form.field.label.maritalStatusMarried,Option for form field: Marital status,Married,Marié(e)
form.field.label.maritalStatusNotStated,Option for form field: Marital status,Not stated,Non déclaré
form.field.label.maritalStatusSeparated,Option for form field: Marital status,Separated,Séparé(e)
form.field.label.maritalStatusSingle,Option for form field: Marital status,Single,Célibataire
form.field.label.maritalStatusWidowed,Option for form field: Marital status,Widowed,Veuf(ve)
form.field.label.otherInstitution,Select item for Other location,Other,Autre
form.field.label.privateHome,Select item for Private Home,Residential address,Adresse de résidence
form.field.label.sexFemale,Label for option female,Female,Femme
form.field.label.sexMale,Label for option male,Male,Homme
form.field.label.sexUnknown,Label for option unknown,Unknown,Inconnu
form.section.documents.title,Form section title for documents,Upload supporting documents,Joindre des documents justificatifs
form.section.father.title,Form section title for fathers details,Father's details,Information du père
form.section.informant.title,Form section title for informants details,Informant's details,Coordonnées de l'informateur
form.section.information.birth.bullet1,Form information for birth,I am going to help you make a declaration of birth.,Je vais vous aider à faire une déclaration de naissance.
form.section.information.birth.bullet2,Form information for birth,As the legal Informant it is important that all the information provided by you is accurate.,"En tant qu'informateur légal, il est important que toutes les informations que vous fournissez soient exactes."
form.section.information.birth.bullet3.sms,Form information for birth,Once the declaration is processed you will receive an SMS to tell you when to visit the office to collect the certificate - Take your ID with you.,Once the declaration is processed you will receive an SMS to tell you when to visit the office to collect the certificate - Take your ID with you.
form.section.information.birth.bullet4,Form information for birth,"Make sure you collect the certificate. A birth certificate is critical for this child, especially to make their life easy later on. It will help to access health services, school examinations and government benefits.",Attendez un SMS vous indiquant quand vous devez vous rendre au bureau pour retirer le certificat - Prenez votre carte d'identité avec vous.
form.section.information.birth.bulletList.label,Label for the birth information bullet list,Birth Information,Birth Information
form.section.mother.title,Form section title for mothers details,Mother's details,Information de la mère
home.header.searchTool.placeholder,Search tool placeholder,"Search for a tracking ID, name, registration number, national ID, phone number or email","Rechercher un identifiant de suivi, un nom, un numéro d'enregistrement, un numéro d'identité nationale, un numéro de téléphone ou une adresse e-mail"
integrations.type.import,Label for import type system,Import,Importer
integrations.type.importExport,Label for import export type system,Import/Export,Importer/Exporter
loading.records,Loading indicator while fetching records,Loading records...,Chargement des enregistrements...
messages.emptyString,Empty string, ,
modal.approveCorrection,The title for approve correction modal,Approve correction?,Approuver la correction ?
modal.rejectCorrection,The title for reject correction modal,Reject correction?,Rejeter la correction ?
navigation.CREATED,In progress label in navigation,In progress,En cours
navigation.DECLARED,Ready for review label in navigation,Ready for review,Prêt pour l'examen
navigation.REGISTERED,Ready to print label in navigation,Ready to print,Prêt à imprimer
print.certificate,label for the print button used in the offline flow,Print,Imprimer
print.certificate.button.makeCorrection,The label for correction button of print action,"No, make correction","Non, faites la correction"
print.certificate.onlineOnly,Print certificate online only message,Print certificate is an online only action. Please go online to print the certificate,L'impression du certificat est une action en ligne uniquement. Veuillez vous connecter pour imprimer le certificat.
print.certificate.review.modal.body.print,Print certificate modal body text,A Pdf of the certificate will open in a new tab for printing. The record will move to the ready-to-issue queue.,Un Pdf du certificat s'ouvrira dans un nouvel onglet que vous pourrez imprimer. Cet enregistrement sera ensuite déplacé vers votre file d'attente de travail prêt à émettre
print.certificate.review.modal.body.printAndIssue,Print certificate modal body text,A Pdf of the certificate will open in a new tab for printing and issuing.,Un Pdf du certificat s'ouvrira dans un nouvel onglet que vous pourrez imprimer et émettre.
printAction.description,The description for print action,Please confirm that the informant has reviewed that the information on the certificate is correct and that it is ready to print.,Veuillez confirmer que l'informateur a vérifié que les informations figurant sur le certificat sont correctes et que celui-ci est prêt à être imprimé.
printAction.title,The title for print action,Print certificate,Imprimer le certificat
record-corrected.summary.section.title,Corrections section title,Correction(s),Correction(s)
register.eventInfo.birth.title,Event information title for the birth,Introduce the birth registration process to the informant,Présenter la procédure d'enregistrement des naissances à l'informateur
register.form.modal.description.deleteDeclarationConfirm,Description for delete declaration confirmation modal,Are you sure you want to delete this declaration?,Êtes-vous sûr de vouloir supprimer cette déclaration ?
register.selectVitalEvent.registerNewEventHeader,The section heading on the page,What type of event do you want to declare?,What type of event do you want to declare?
rejectModal.description,The description for reject modal,Please describe the updates required to this record for follow up action.,Veuillez décrire les mises à jour nécessaires à cet enregistrement pour le suivi de l'action.
rejectModal.markAsDuplicate,The label for mark as duplicate checkbox of reject modal,Mark as a duplicate,Marquer comme duplicata
rejectModal.title,The title for reject modal,Reason for rejection?,Quelle mise à jour la déclaration nécessite-t-elle ?
review.declare.confirm,The label for review action button when declaring,Send for review,Envoyer pour révision
review.declare.confirmModal.cancel,The label for modal cancel button when declaring,Cancel,Annuler
review.declare.confirmModal.confirm,The label for modal confirm button when declaring,Confirm,Confirmer
review.declare.confirmModal.description,The description for review action modal when declaring,This declaration will be sent for review,Cette déclaration sera envoyée pour révision.
review.declare.confirmModal.title,The title for review action modal when declaring,Send for review?,Envoyer pour révision ?
review.declare.description.complete,The description for declare action when form is complete,The informant will receive an email with a registration number that they can use to collect the certificate,L'informateur recevra un e-mail avec un numéro d'enregistrement qu'il pourra utiliser pour récupérer le certificat.
review.declare.description.incomplete,The description for declare action when form is complete,The informant will receive an email with a tracking ID that they can use to provide the additional mandatory information required for registration,Cette déclaration sera envoyée au greffier pour être complétée. Veuillez informer l'informateur qu'il devra se présenter au bureau avec les informations manquantes et les documents justificatifs.
review.declare.incomplete.confirmModal.cancel,The label for modal cancel button when declaring,Cancel,Annuler
review.declare.incomplete.confirmModal.confirm,The label for modal confirm button when declaring,Confirm,Confirmer
review.declare.incomplete.confirmModal.description,The description for review action modal when declaring incomplete,This incomplete declaration will be sent for review.,Cette déclaration sera envoyée au greffier pour être complétée. Veuillez informer l'informateur qu'il devra se présenter au bureau avec les informations manquantes et les documents justificatifs.
review.declare.incomplete.confirmModal.title,The title for review action modal when declaring,Send for review?,Envoyer pour révision ?
review.declare.title.complete,The title shown when reviewing an incomplete record to declare,Declaration complete,Déclaration complète
review.declare.title.incomplete,The title shown when reviewing an incomplete record to declare,Declaration incomplete,Déclaration incomplète
review.form.title,Review form label for update action,Review form,Formulaire de révision
review.register.confirm,The label for register button of review action,Register,Enregistrer
review.register.confirmModal.cancel,The label for modal cancel button when registering,Cancel,Annuler
review.register.confirmModal.confirm,The label for modal confirm button when registering,Register,Enregistrer
review.register.confirmModal.description,The description for review action modal when registering,‎,
review.register.confirmModal.title,The title for review action modal when registering,Register the {event}?,Enregistrer cet {event}?
review.register.description.complete,The description for registration action when form is complete,"By clicking register, you confirm that the information entered is correct and the event can be registered.","En cliquant sur enregistrer, vous confirmez que les informations saisies sont correctes et que l'événement peut être enregistré."
review.register.reject,The label for reject button of review action,Reject,Rejeter
review.register.title,The title shown when reviewing a record to register,Register event,Enregistrer l'événement
review.validate.confirm,The label for review action button when validating,Send for approval,Envoyer pour approbation
review.validate.confirmModal.cancel,The label for modal cancel button when validating,Cancel,Annuler
review.validate.confirmModal.confirm,The label for modal confirm button when validating,Confirm,Confirmer
review.validate.confirmModal.description,The description for review action modal when validating,This declaration will be sent for approval prior to registration.,Cette déclaration sera envoyée pour approbation avant l'enregistrement.
review.validate.confirmModal.title,The title for review action modal when validating,Send for approval?,Envoyer pour approbation ?
review.validate.description.complete,The description for validate action when form is complete,The informant will receive an email with a registration number that they can use to collect the certificate,L'informateur recevra un e-mail avec un numéro d'enregistrement qu'il pourra utiliser pour récupérer le certificat.
review.validate.description.incomplete,The description for validate action when form is complete,Please add mandatory information before sending for approval,Veuillez ajouter les informations obligatoires avant d'envoyer pour approbation.
review.validate.reject,The label for reject button of review action,Reject,Rejeter
review.validate.title,The title shown when reviewing a record to validate,Send for approval,Envoyer pour approbation
reviewAction.register.description.incomplete,The description for registration action when form is incomplete,Please add mandatory information before registering,Veuillez ajouter les informations obligatoires avant d'enregistrer.
saveAndExit.desc.saveDeclarationConfirm,Description for save declaration confirmation modal,All inputted data will be kept secure for future editing. Are you ready to save any changes to this declaration form?,Toutes les données saisies seront conservées en toute sécurité pour de futures modifications. Êtes-vous prêt à enregistrer les modifications apportées à ce formulaire de déclaration?
saveAndExit.title.saveDeclarationConfirm,Title for save declaration confirmation modal,Save & exit?,Enregistrer et quitter?
search.advancedSearch.result.title,Advanced search result title,Search results ({count}),résultat de la recherche pour ({count})
search.noRecord,The no record text,"No records {slug, select, draft {in my drafts} outbox {require processing} other {{title}}}","Aucun enregistrement {slug, select, draft {dans mes brouillons} outbox {à traiter} other {{title}}}"
search.noResult,The no result text,No result,Pas de résultats”
search.noResultForSearchTerm,The no result text,No results for “{searchTerm}”,Pas de résultats pour “{searchTerm}”
search.quickSearch.result.title,Quick search result title,Search result for “{searchTerm}”,résultat de la recherche pour “{searchTerm}”
serviceWorker.cacheKey.WorkBoxRuntime.error.button.logout,Button label for logging out when WorkBox runtime cache key is missing,Log out,Se déconnecter
serviceWorker.cacheKey.WorkBoxRuntime.error.button.reload,Button label for logging out when WorkBox runtime cache key is missing,Reload,Recharger
serviceWorker.cacheKey.WorkBoxRuntime.error.content,Content shown when WorkBox runtime cache key is missing,"Something went wrong with loading the app. Reload this page, or log out and log back in to continue.",Un problème est survenu lors du chargement de l’application. Rechargez cette page ou déconnectez-vous puis reconnectez-vous pour continuer.
serviceWorker.cacheKey.WorkBoxRuntime.error.header,Header shown when WorkBox runtime cache key is missing,⚠️  Application Cache Error,⚠️  Erreur du cache de l'application
signature.upload.modal.title,Title for the signature upload modal,Upload Signature,Télécharger la signature
userRole.communityLeader,Name for user role Community Leader,Community Leader,Leader communautaire
userRole.hospitalClerk,Name for user role Hospital Clerk,Hospital Clerk,Commis d'hôpital
verified,This is the label for the verification field,Verified,Vérifié
views.idReader.label.manualInput,Label that shows below the divider on the id reader component,Complete fields below,Remplissez les champs ci-dessous
views.idReader.label.or,Label that shows on the divider,Or,Ou
workqueues.dateOfEvent,Label for workqueue column: dateOfEvent,Date of Event,Date de l'événement
workqueues.draft.title,Title of draft workqueue,My drafts,Mes brouillons
workqueues.outbox.title,Title of outbox workqueue,Outbox,Boîte d'envoi
wq.noRecords.CREATED,No records messages for empty draft tab,No records in progress,Aucun enregistrement en cours
wq.noRecords.DECLARED,No records messages for ready for review tab,No records ready for review,Aucun document prêt à être examiné
wq.noRecords.REGISTERED,No records messages for ready to print tab,No records ready to print,Aucun document prêt à être imprimé
```
