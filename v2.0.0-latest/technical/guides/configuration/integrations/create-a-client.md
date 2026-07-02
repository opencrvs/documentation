# Create a client



#### Introduction

In order to interoperate with OpenCRVS' via APIs, you must create a system client.

You can create a system client to perform record search & event notifications from a health system via the National System Administrator UI.

In 2.0.1 you can create other clients with whatever scope you wish via country configuration.  Docs TBC.

The option to create clients for managing Locations, Importing Legacy Records or integrating with Citizen Portals via the UI has been deprecated for security reasons in 2.0, as these clients are extremely powerful.

Docs will be updated in this section by Aug 2026 to include information on the creation of those types of client.&#x20;

<figure><img src="../../../../.gitbook/assets/Screenshot 2023-01-11 at 11.34.03.png" alt=""><figcaption></figcaption></figure>

***

#### Process of creation via the UI

Click **+ Create client**

You will see a modal overlay where you can select the type of client you wish to create. The business functionality available for each client is explained in subsequent pages in this section of our documentation.

**The type of client you create is important and can only perform API requests associated with the business functionality relevant to that type.** A Record Search client is not authorized to perform an Event Notification for example.

You must give each client a unique name.

When you click "Create", you will be shown the authentication details for the client along with a SHA Secret used to sign, encrypt, decrypt and verify the authenticity of payloads.

{% hint style="warning" %}
**You must copy these keys now! The Client Secret will never be displayed to you again and it cannot be retrieved from our database as it is encrypted.  It can only be refreshed in the UI.**
{% endhint %}

<figure><img src="../../../../.gitbook/assets/Screenshot 2023-01-11 at 11.35.15.png" alt=""><figcaption></figcaption></figure>

6\. You can manage existing clients by using the **3 dots** menu after the client has been created. You can **reveal the Client ID and SHA Secret keys** at any time and **refresh the Client Secret** to create a new one by selecting "**Reveal Keys**".

{% hint style="warning" %}
When you refresh a Client Secret, the old secret will no longer work for authentication.
{% endhint %}

You can also temporarily "**Deactivate**" and "**Enable**" a client or alternatively "**Delete**" it.

<figure><img src="../../../../.gitbook/assets/Screenshot 2023-01-11 at 11.35.35.png" alt=""><figcaption></figcaption></figure>

{% hint style="danger" %}
All client behaviour is audited and is ultimately the personal responsibility of the National System Administrator of OpenCRVS that created the client. Protect citizen data and do not expose access unnecessarily, as you may be in breach of local privacy laws.
{% endhint %}

<figure><img src="../../../../.gitbook/assets/Screenshot 2023-01-11 at 11.34.39.png" alt=""><figcaption></figcaption></figure>



