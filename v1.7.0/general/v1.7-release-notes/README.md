# Release notes

## Configuration template files

{% file src="../../.gitbook/assets/1.7 OpenCRVS Configuration Files.zip" %}
Templates to configure your OpenCRVS instance
{% endfile %}

## Deployment, Monitoring & Data Security

{% file src="../../.gitbook/assets/Deployment, Monitoring & Data Security.zip" %}
Deployment & Monitoring checklist, Data Security Framework
{% endfile %}

## Dependencies & Network Diagram

{% file src="../../.gitbook/assets/Dependencies & Network Diagram.zip" %}
Dependency table, Network Diagram with VPN & approx. costs associated.
{% endfile %}

## Before you update

**Upgrading your country config package from v1.6 to v1.7**

In order to make the upgrade easier, there are a couple of steps that need to be performed which will make the codebase ready for the upgrade:\


1. **Run this command from the root of your country config repository**

```shell

curl https://raw.githubusercontent.com/opencrvs/opencrvs-countryconfig/release-v1.7.0/src/upgrade-to-1_7.ts | npx ts-node -T --cwd ./src

```

It will remove `roles.csv` and generate a `roles.ts` file. It will also update your `default-employees.csv` & `prod-employees.csv` files to match our new configuration syntax for [User roles & scopes](https://documentation.opencrvs.org/default-configuration/opencrvs-configuration-in-farajaland/user-role-mapping) while adding the corresponding translations in `client.csv`.

The employee CSV files only affect deployments of new environments. If you already have a v1.6.x of OpenCRVS deployed, the data in the environment will automatically get migrated after deploying the upgrade. The changes in these two files are made to keep the roles in sync with your previously deployed environments, if any.\


2. **Verify and review changes made made by our upgrade script**

```bash
❯ git status
Changes not staged for commit:
(use "git add/rm <file>..." to update what will be committed)
(use "git restore <file>..." to discard changes in working directory)

modified: src/data-seeding/employees/source/default-employees.csv
deleted: src/data-seeding/roles/source/roles.csv
modified: src/translations/client.csv

Untracked files:
(use "git add <file>..." to include in what will be committed)
src/data-seeding/roles/roles.ts

```

3. **Commit the changes and follow our** [**migration notes**](https://documentation.opencrvs.org/general/releases/migration-notes) **to complete the upgrade**

{% hint style="info" %}
After pulling in the v1.7.0 changes, you can safely reject all changes incoming to `roles.ts`, `default-employees.csv` & `prod-employees.csv` files.
{% endhint %}

The `roles.ts` file now defines all the roles available in the system. New roles can be added & existing roles can be customised by giving them different scopes.

{% hint style="warning" %}
Once a role is defined in `roles.ts`, it should never be deleted. This is to prevent situations where historical data might refer to a user role that does not exist or have configuration for it anymore.
{% endhint %}

## OpenCRVS Core

### New features

#### **Customisable user roles**

• From OpenCRVS 1.7 onwards, it’s possible to create new user types with a granular set of scopes described [here](https://documentation.opencrvs.org/product-specifications/users). This allows OpenCRVS to be used for even more use cases.

#### **Multiple certificate templates for all events**

• **Template Selection for Certified Copies**: Added support for multiple certificate templates for each event (birth, death, marriage). Users can now select a template during the certificate issuance process.

• **Template-based Payment Configuration**: Implemented payment differentiation based on the selected certificate template, ensuring the correct amount is charged.

• **Template Action Tracking**: Each template printed is tracked in the history table, showing which specific template was used.

#### **Integrations**

• Auth now allows a registrar’s token to be exchanged for a new token that strictly allows confirming or rejecting a specific record. Core now passes this token to country configuration instead of the registrar’s token [#7728](https://github.com/opencrvs/opencrvs-core/issues/7728) [#7849](https://github.com/opencrvs/opencrvs-core/issues/7849)

• **QR code scanner**: A form field component allows pre-populating an informant’s details based on an ID card [#8196](https://github.com/opencrvs/opencrvs-core/pull/8196)

• Updated GraphQL mutation confirmRegistration to allow adding a comment for record audit [#8197](https://github.com/opencrvs/opencrvs-core/pull/8197)

• A new GraphQL mutation upsertRegistrationIdentifier is added to allow updating the patient identifiers of a registration record, such as NID [#8034](https://github.com/opencrvs/opencrvs-core/pull/8034)

### **Improvements**

#### **Search**

• Allow configuring the default search criteria for “quick search” [#6924](https://github.com/opencrvs/opencrvs-core/issues/6924)

• Two new record statuses are added: Validated and Correction Requested for advanced search parameters [#6365](https://github.com/opencrvs/opencrvs-core/issues/6365)

• A new field, Time Period, is added to advanced search [#6365](https://github.com/opencrvs/opencrvs-core/issues/6365)

#### **Reliability**

• Added checks to validate that the client and server are always on the same version. This prevents browsers with cached or outdated client versions from making potentially invalid requests to the backend [#6695](https://github.com/opencrvs/opencrvs-core/issues/6695)

#### **UI**

• Deploy UI-Kit Storybook to [opencrvs.pages.dev](https://opencrvs.pages.dev) to allow extending OpenCRVS using the component library

• Record audit action buttons are moved into the action menu [#7390](https://github.com/opencrvs/opencrvs-core/issues/7390)

• Reordered the system user add/edit field for surname to be first; also changed labels from Last name to User's surname, and removed the NID question from the form [#6830](https://github.com/opencrvs/opencrvs-core/issues/6830)

• Introduced a new customisable UI component: Banner [#8276](https://github.com/opencrvs/opencrvs-core/issues/8276)

#### **Form**

• Added isAgeInYearsBetween validator to enable validation that constrains a date to be valid only if it falls within a specified range. The isInformantOfLegalAge validator is now deprecated and removed in favour of isAgeInYearsBetween [#7636](https://github.com/opencrvs/opencrvs-core/issues/7636)

#### **Technical**

• Auth token, IP address, and remote address redacted from technical server logs

• **Align Patient data model with FHIR**: Previously, we used string\[] for the Patient.name.family field instead of string, as per the FHIR standard. We’ve now aligned the field with the standard.

• **Certificate Fetching**: Removed certificates from the database, allowing them to be fetched directly from the country configuration via a simplified API endpoint.

### **Deprecations**

• validator-api, age-verification-api, and nationalId scopes are deprecated as unused. Corresponding scopes are removed from systemScopes and also removed from the audience when creating the token [#7904](https://github.com/opencrvs/opencrvs-core/issues/7904)

### **Bug fixes**

• Corrected the total amount displayed for _certification_ and _correction_ fees on the Performance Page, ensuring accurate fee tracking across certification and correction sequences [#7793](https://github.com/opencrvs/opencrvs-core/issues/7793)

• Fixed task history getting corrupted if a user views a record while it’s in external validation [#8278](https://github.com/opencrvs/opencrvs-core/issues/8278)

• Fixed health facilities missing from dropdown after correcting a record address [#7528](https://github.com/opencrvs/opencrvs-core/issues/7528)

• “Choose a new password” form now allows submission using the “Enter/Return” key [#5502](https://github.com/opencrvs/opencrvs-core/issues/5502)

• Dropdown options now flow to multiple rows in forms [#7653](https://github.com/opencrvs/opencrvs-core/pull/7653)

## Country config template

### **Breaking changes**

#### **Application config**

• INFORMANT\_SIGNATURE & INFORMANT\_SIGNATURE\_REQUIRED are now deprecated.

#### **Certificates**

• Existing implementations relying on database-stored SVGs need to be updated to use the new configuration-based approach. Default certificate templates must be created for each event type, following the convention ${event}-certificate as the certificate template ID.

#### **Users & Roles**

• **Roles**: The previous roles.csv file has been deprecated. It will be removed once you run the upgrade command before pulling in the v1.7 changes. The command automatically generates a roles.ts file, which can be used as a baseline to configure roles as per your requirements.

### **New features**

• **User scopes**: Introduced granular scopes to grant specific permissions to particular roles. The specifics about the introduced scopes can be found here: _Link to scopes description file_

• **Refactored certificate handling**: SVGs are no longer stored in the database; streamlined configurations now include certificate details, and clients request SVGs directly via URLs.

• Added constant.humanName to allow countries to define custom ordering for full names, e.g. starting with lastName or firstName [#6830](https://github.com/opencrvs/opencrvs-core/issues/6830)

### **Improvements**

• Updated the translations for the System user add/edit form: Last name to User's surname and First name to User's first name, to make them less confusing for system users [#6830](https://github.com/opencrvs/opencrvs-core/issues/6830)

• Auth token, IP address, remote address, mobile number, and email are redacted/masked from server logs.

• Optimised deployment times by enabling parallel Docker image downloads.

• Country alpha-3 ISO code is now derived from variables in the Docker Compose files and no longer needs to be hardcoded.

• Added isAgeInYearsBetween validator to enable validation that constrains a date to be valid only if it falls within a specified range. The isInformantOfLegalAge validator is now deprecated and removed in favour of isAgeInYearsBetween [#7636](https://github.com/opencrvs/opencrvs-core/issues/7636)

### **Bug fixes**

• Protected the individual certificate endpoint with a token.

• Kibana disk space alerts now work regardless of disk device names. Alerts listen for devices mounted to both / and /data (encrypted data partition).

• “Publish release” pipeline now correctly uses the “Branch to build from” value as the branch to be tagged. Previously, it attempted to tag “master”. “Release tag” is now used as the release version as-is, instead of reading it from package.json.

• Backup process no longer requires an internet connection to download Docker images, making it more reliable with unstable connections. Previously, non-active images were cleaned nightly; now, this only happens as part of deployment. [#7896](https://github.com/opencrvs/opencrvs-core/issues/7896)

• Ensured that the automatic cleanup job only runs before deployment, instead of using a cron schedule.

• Previously, MongoDB replica sets and users were sometimes left randomly uninitialised after deployment. The MongoDB initialisation container now retries on failure.

• On some machines, the file utility was not preinstalled, causing provisioning to fail. We now install the utility if it doesn’t exist.

### **Infrastructure breaking changes**

{% hint style="info" %}
All Metabase configuration that is not persisted into metabase.init.db.sql will be cleared as part of upgrading to OpenCRVS 1.7.0 and on all subsequent deployments!
{% endhint %}

• Metabase data is no longer backed up by the default OpenCRVS country configuration. This change ensures that Metabase can be properly started as part of OpenCRVS deployment, even when a Metabase version upgrade has occurred. To learn more about configuring Metabase persistently, please refer to our documentation on [4.2.5.2 Configuring Metabase Dashboards](https://documentation.opencrvs.org/setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.5-set-up-application-settings/4.2.5.2-configuring-metabase-dashboards) [#8043](https://github.com/opencrvs/opencrvs-core/issues/8043)

### New content keys requiring translation

```

action.action,Label for action button,Action

action.archive,Label for archive record button in dropdown menu,Archive declaration

action.assignee,Label for asignee,Assigned to {name } at {officeName}

action.correct,Label for correct record button in dropdown menu,Correct record

action.issue,Label for reinstate issue button in dropdown menu,Issue certificate

action.print,Label for reinstate print button in dropdown menu,Print certified copy

action.reinstate,Label for reinstate record button in dropdown menu,Reisntate declaration

action.review.correction,Label for review correction in dropdown menu,Review correction request

action.review.declaration,Label for review declaration button in dropdown menu,"Review {isDuplicate, select, true{potential duplicate} other{declaration}}"

action.update,Label for reinstate update button in dropdown menu,Update declaration

action.view,Label for view button in dropdown menu,View {recordOrDeclaration}

advancedSearch.form.recordStatusValidated,Option for form field: status of record,Validated

advancedSearch.form.timePeriodHelperText,Helper text for input Time period,Period of time since the record status changed

advancedSearch.form.timePeriodLabel,Label for input Time period,Time period

advancedSearchResult.pill.timePeriod,The label for time period in active advancedSearchParams,Time period

certificate.selectTemplate,Select certificate template,Type

certificate.selectedTemplate,Selected certificate template,Selected certificate template

certificates.birth.certificate,Birth Certificate,Birth Certificate

certificates.birth.certificate.copy,Birth Certificate Certified Copy,Birth Certificate Certified Copy

certificates.birth.registration.receipt,Birth Registration Receipt,Birth Registration Receipt

certificates.death.certificate,Death Certificate,Death Certificate

certificates.death.certificate.copy,Death Certificate Certified Copy,Death Certificate Certified Copy

certificates.marriage.certificate,Marriage Certificate,Marriage Certificate

certificates.marriage.certificate.copy,Marriage Certificate Certified Copy,Marriage Certificate Certified Copy

changeModal.cancel,The label for cancel button of change modal,Cancel

changeModal.continue,The label for continue button of change modal,Continue

changeModal.description,The description for change modal,A record will be created of any changes you make

changeModal.title,The title for change modal,Edit declaration?

config.emailAllUsers.subtitle,Subtitle for email all users,This email will be sent to all users who are active. Emails will be sent over the next 24 hours. Only one email can be sent per day

constants.humanName,Formatted full name, {lastName} {middleName} {firstName}

event.history.timeFormat,"MMMM dd, yyyy · hh.mm a","MMMM dd, yyyy · hh.mm a"

event.tennis-club-membership.action.declare.form.label,This is what this form is referred as in the system,Tennis club membership application

event.tennis-club-membership.action.declare.form.section.recommender.field.firstname.label,This is the label for the field,Recommender's first name

event.tennis-club-membership.action.declare.form.section.recommender.field.id.label,This is the label for the field,Recommender's membership ID

event.tennis-club-membership.action.declare.form.section.recommender.field.surname.label,This is the label for the field,Recommender's surname

event.tennis-club-membership.action.declare.form.section.recommender.title,This is the title of the section,Who is recommending the applicant?

event.tennis-club-membership.action.declare.form.section.who.field.dob.label,This is the label for the field,Applicant's date of birth

event.tennis-club-membership.action.declare.form.section.who.field.firstname.label,This is the label for the field,Applicant's first name

event.tennis-club-membership.action.declare.form.section.who.field.surname.label,This is the label for the field,Applicant's surname

event.tennis-club-membership.action.declare.form.section.who.title,This is the title of the section,Who is applying for the membership?

event.tennis-club-membership.action.declare.form.version.1,This is the first version of the form,Version 1

event.tennis-club-membership.action.declare.label,This is shown as the action name anywhere the user can trigger the action from,Send an application

event.tennis-club-membership.label,This is what this event is referred as in the system,Tennis club membership application

exitModal.cancel,The label for cancel button in exit modal,Cancel

exitModal.exitWithoutSaving,The title for exit without saving modal,Exit without saving changes?

exitModal.exitWithoutSavingDescription,The description for exit without saving modal,You have unsaved changes on your declaration form. Are you sure you want to exit without saving?

form.field.label.informantRelation.other,,Other ({otherInformantType})

form.field.label.userFirstName,,User's first name

form.field.label.userSurname,,User's surname

form.section.label.timePeriodLast30Days,Label for option of time period select: last 30 days,Last 30 days

form.section.label.timePeriodLast7Days,Label for option of time period select: last 7 days,Last 7 days

form.section.label.timePeriodLast90Days,Label for option of time period select: last 90 days,Last 90 days

form.section.label.timePeriodLastYear,Label for option of time period select: last year,Last year

integrations.type.nationalId,Label for national id,National id

navigation.my-drafts,My drafts label in navigation,My drafts

print.certificate.collector.form.error.template,Form level error for collector form template type,Please select certificate type

registerModal.cancel,The label for cancel button of register modal,Cancel

registerModal.description,The description for register modal,The declarant will be notified of this correction and a record of this decision will be recorded

registerModal.register,The label for register button of register modal,Register

registerModal.title,The title for register modal,Register the member?

rejectModal.archive,The label for archive button of reject modal,Archive

rejectModal.cancel,The label for cancel button of reject modal,Cancel

rejectModal.description,The description for reject modal,Please describe the updates required to this record for follow up action.

rejectModal.markAsDuplicate,The label for mark as duplicate checkbox of reject modal,Mark as a duplicate

rejectModal.sendForUpdate,The label for send For Update button of reject modal,Send For Update

rejectModal.title,The title for reject modal,Reason for rejection?

reloadmodal.body,Body of reload modal,There’s a new version of {app_name} available. Please update to continue.

reloadmodal.button.update,Label of update button,Update

reloadmodal.title,Title when update is available,Update available

reviewAction.description,The description for review action,"By clicking register, you confirm that the information entered is correct and the member can be registered."

reviewAction.register,The label for register button of review action,Register

reviewAction.reject,The label for reject button of review action,Reject

reviewAction.title,The title for review action,Register member

userRole.fieldAgent,Name for user role Field Agent,Field Agent

userRole.healthcareWorker,Name for user role Healthcare Worker,Healthcare Worker

userRole.localLeader,Name for user role Local Leader,Local Leader

userRole.localRegistrar,Name for user role Local Registrar,Local Registrar

userRole.localSystemAdmin,Name for user role Local System Admin,Local System Admin

userRole.nationalRegistrar,Name for user role National Registrar,National Registrar

userRole.nationalSystemAdmin,Name for user role National System Admin,National System Admin

userRole.performanceManager,Name for user role Performance Manager,Performance Manager

userRole.policeOfficer,Name for user role Police Officer,Police Officer

userRole.registrationAgent,Name for user role Registration Agent,Registration Agent

userRole.socialWorker,Name for user role Social Worker,Social Worker

validations.isAgeInYearsBetween,The error message that appears when age for the given date is outside the legal age range,Age must be between {min} and {max} years.

wq.noRecords.draft,No records messages for empty draft tab,No records in my drafts

```



