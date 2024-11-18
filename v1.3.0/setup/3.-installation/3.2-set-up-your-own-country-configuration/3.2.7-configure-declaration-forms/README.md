# 3.2.7 Configure declaration forms

### A brief history of form configuration in OpenCRVS

A key selling point of OpenCRVS has always been that you can configure the registration forms for your country needs.

In OpenCRVS alpha releases before v1.0, (e.g. [v1.0.0-alpha.3.1](https://github.com/opencrvs/opencrvs-farajaland/blob/1.0.0-alpha.3.1/src/farajaland/features/forms/register.json)) forms were configurable via [JSON](https://en.wikipedia.org/wiki/JSON).&#x20;

A developer could have complete control over all pages in the form, all field types and all form validations and conditional actions to show/hide a field depending on user input.  JSON strings would map to internal opencrvs-core javascript functions during deserialization to allow data to map to and from the FHIR standard.

However, as it was very easy for developers and implementers to make a syntax mistake when using JSON, we introduced a form configuration user interface for our first official OpenCRVS release v1.0.

The form configuration user interface allowed non-technical administration staff to be able to create basic form fields in some form sections.  These users could create custom form fields of certain types.

A lot of development and quality assurance work was continuously required to ensure that users could not introduce bugs to their form configuration which would break OpenCRVS.  For example, some fields are absolutely required to exist for successful registration.  Other fields are required to exist to enable notifications to informants via SMS or Email.

When we worked in various countries, we were often asked to edit or move these required fields to other sections.  We were often asked to make custom fields for all kinds of HTML input types, more than the provided basic selects and text input variations. &#x20;

We also noticed that despite developing a form configuration UI for non-technical staff, the UI was never used by such resources.  It was only ever used by the same previous developers tasked to configure the config files and servers.  These developers were technical enough to work in code but restricted in what they could do in the UI!

We eventually accepted that to make the form configuration UI capable of responding to every country's needs would require a massive investment of time and resources that would be better spent developing other features.  Form configuration UI became a sinkhole for development and quality assurance funding to code and review infinite form possibilities.

We therefore decided to dedicate form configuration as developer activity and invest in teh devops experience.  We spent the past months abstracting away the complex JSON into utility methods in the countryconfig repository and instead make form configuration a strictly-typed: [Typescript](https://www.typescriptlang.org/) development activity thus mitigating the chances of syntax mistakes.

In OpenCRVS v1.3 a developer has complete control again over the entire form and can use any form field available in the component library.  Some form fields and pages are still required, but these are clearly marked in the code.



### An important note regarding form configuration

{% hint style="danger" %}
After you have started registering real citizen data in production, you **CANNOT** make a change to your form configuration.
{% endhint %}

Why is that?  Well, if you make a change to a form in production, The form may no longer work for registrations made on a previous version of the form! &#x20;

This is because, you may have removed previously required questions, or added new ones.

An older registration may not have captured such data.

Therefore, imagine if you view or correct that record.  You may find that required data is now missing and form validation prevents the submission of the form!!

We have a backlog item to allow registration form changes to be made post live to and in this way support civil registration regulatory changes that may evolve over the years.

Subscribe to the status of [this issue](https://github.com/opencrvs/opencrvs-core/issues/3798) to understand when it is possible to make form configuration changes even after you have started registering citizens.

{% hint style="warning" %}
It is very important to therefore pilot OpenCRVS and thoroughly quality assure your configuration, having it reviewed by civil registrars in your country in the field with dummy citizen data.  You must make sure that your legal regulations can support or be amended to support your form configuration before you go live.
{% endhint %}

In the meantime, whenever you semantically increment the version number [here](https://github.com/opencrvs/opencrvs-countryconfig/blob/551e864ab59d59ae2e65eec8d1d0d9651ae0a3d7/src/form/index.ts#L49), we will save a version of your form in an immutable database.

This will allow us in future to potentially associate a registration with a previously drafted registration form even if the civil registration regulations evolve in your country.  **This is a beta feature.**

{% hint style="info" %}
But what if you just want to add an optional custom field after going live?  Or make a previously required \* field, now optional?  It will not be required for registration, but perhaps just to capture some extra information for edge case reasons.  Perhaps there was a situation arising that you did not consider before going live.
{% endhint %}

{% hint style="success" %}
If you are adding an optional, custom field post live then, as long as it is not required \* for registration, then it should be OK for you to do this.  But we do not guarantee this.
{% endhint %}

