---
description: >-
  Authenticating and verifying the identity of informants and parents during the
  event application process both offline and online.
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/technology/interoperability/national-id/in-form-authentication-verification
---

# In-form authentication / verification

It's possible to [configure](../../../setup/3.-installation/3.2-set-up-your-own-country-configuration/3.2.7-configure-declaration-forms/) 3 types of form component that can interact with methods of National ID authentication and verification. Choice of component depends on your business rules and availabilty of the relevant dependencies.

### Offline

If your user has no connectivity, and if your country issues a National ID card to users that contains a QR code, then a form field component of **ID\_READER** type can parse the contents of the QR code and pre-populate some fields in the form.

```
```

### Online

If your user has connectivity, then of course it is possible to query a National ID system in 1 of 2 ways.

**API integration within an event form**

A form field component of **HTTP** type can connect with an external API. Use it along with a **BUTTON** and any relevant form pre-population field types such as **TEXT** where you may wish to store a response.&#x20;

Alternatively, we supply many display UI components to show message responses, or simply to display if someone is authenticated or verified, such as **ID\_VERIFICATION\_BANNER**.  Just adopt the copy appropriately.

```
```

**Redirect to NID auth portal from within an event form**

A form field component of **LINK\_BUTTON** type can redirect the user to an external NID web interface for authentication.  An auuthorised token can then be returned to the form and used in a similar way to the API example above to retrieve further values from the NID system for form pre-population.

```
```
