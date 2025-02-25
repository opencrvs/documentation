# 4.2.7 Configure declaration forms

### Understanding form configuration in OpenCRVS

For a step-by-step explanation of form configuration, refer to this example video and all the pages in this section.

{% embed url="https://youtu.be/C5XgcNoQQs8" %}

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

