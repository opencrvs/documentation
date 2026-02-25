---
description: >-
  Perform an advanced search of civil registration records from a trusted,
  external e-Gov service
---

# Record Search clients

The Record Search client can perform an advanced search of civil registration records. Use this to help support social protection systems, check the existence of civil registration records or check citizen demographics.

<figure><img src="../../../.gitbook/assets/Screenshot 2023-01-11 at 17.17.45 (1).png" alt=""><figcaption></figcaption></figure>

To stop abuse of such a powerful API, all results returned are audited as having been downloaded by the client. System Administrators should be careful to ensure that citizen data is not exposed to untrustworthy individuals by using this API.

{% hint style="danger" %}
All client behaviour is audited and is ultimately the personal responsibility of the National System Administrator of OpenCRVS that created the client. Protect citizen data and do not expose it unnecessarily as you may be in breach of local laws.
{% endhint %}

{% hint style="info" %}
A daily limit of 2000 Record Search requests per client, per day is hardcoded into OpenCRVS Core. Any subsequent requests will fail.
{% endhint %}

**Submitting a Record Search**

To submit an Record Search, your client must first request an [authorization token ](authenticate-a-client.md)using your `client_id` and `client_secret`.

#### Record Search Requests

With the token as an authorization header, the following example request will submit a record search. It utilises queries that are used buy the OpenCRVS GUI.



We recommend that you use the Advanced Search feature in the OpenCRVS application and monitor the GraphQL payload that is sent to the Gateway using the Chrome Developer Tools "Network" tab, in order to understand how these parameters are formatted. The table below lists all possible parameters with a description and example where we feel further explanation is helpful.

**Record Search Response**

The response from a record search ...&#x20;

After a search has completed and if you search for any record returned, you will see that in Record Audit, an entry shows that this client has accessed the personally identifiable citizen data on the record.

<figure><img src="../../../.gitbook/assets/Screenshot 2023-01-16 at 11.49.25 (1).png" alt=""><figcaption></figcaption></figure>
