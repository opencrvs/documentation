---
description: Setting realistic business expectations of CRVS digitisation
---

# Effective digital CRVS systems

## A model for high-performing CRVS

It is important to understand that digitisation alone will not be able to transform under-performing CRVS systems. A number of operational aspects need to be in place if the intended results are to be achieved and benefits fully realised. These are presented in the following operating model diagram, which is intended to be illustrative of a high-performing scenario.

<figure><img src="https://lh7-us.googleusercontent.com/PzXcW10hhijzf4HzPdMjg9GD3JChu-GGd_6uQ0oDNAMpmzbi6_y1Q4OR8N3d3VtujGu991920Qlc4ZV8Q9RCFXmbAm3zQ8i4qEfJoNO48vYYiiGNmfyHGu_1zyh9CnjH0pBuKcEKMpdqlzlI3PtQfkgbJw=s2048" alt=""><figcaption><p>High-performing CRVS operating model</p></figcaption></figure>

## Business requirements of a digital CRVS system

A set of clear business requirements outlines the real purpose and objectives of the digital system. The following list provides a number of expectations that a government may have of their digital CRVS system and serves as a reference for CRVS modernisation programmes.

* Increase the registration completeness rates for all vital events in all areas&#x20;
* Digital first process with the removal of manual and error-prone processes
* Digital (and searchable) archive of all paper-based records to free up office space&#x20;
* Improve the efficiency of the registration process (decrease certification turn-around time, decrease time taken to process each record by staff)&#x20;
* Improve interoperability / utilization of civil registration data as a component of Digital Public Infrastructure&#x20;
* Ensure that civil registration data is secure and compliant with data protection laws&#x20;
* Ensure integrity of data across the foundational identity ecosystem, including civil registration and digital ID&#x20;
* Improve accuracy of civil registration data&#x20;
* Provide high quality and timely statistical data from civil registration records
* Standardisation and harmonisation of processes across the country&#x20;

Although each country will have their own specific business objectives, any modern CRVS system would expect to be able to provide a number of these requirements. OpenCRVS has been designed with these business requirements in mind to maximize the utility of the platform once implemented.

## Principles when digitising a civil registration system

When considering an OpenCRVS implementation it is important to understand some key best-practice concepts of digitisation.&#x20;

{% hint style="warning" %}
There is often a tendency to try to digitise an existing manual process, especially if it is enshrined within the legal framework and formal regulations. This should be avoided as it will limit the long-term effectiveness of the system.&#x20;
{% endhint %}

Moving from a manual system to a fully automated and effective digital system may take many years as a result of the legislative reforms required, but it is advisable to think about the long-term strategic direction from the outset and create a roadmap for how the change will be introduced and when.&#x20;

Below are a sample list of principles to consider when setting a long-term vision and roadmap for CRVS digitisation, which will help you get the best out of OpenCRVS:

* Try to conceptualise the Civil Registry in terms of digital records rather than a digital archive of paper-based records, which may be a symptom of outdated laws. One key question to ask would be "What do you consider is the actual registry?". If the answer to this question is "It's the data in the database", then you are probably good. If the answer is "It's the data in the paper-based register books", then you may not be maximizing the utility of OpenCRVS.
* Capture data in a digital format at source. Try to avoid initiating the process using a manual paper-based process and then transcribing from paper records to digital format later in the process as this may introduce data quality issues.
* As far as is possible, make data collection forms (e.g. for birth declarations) work using validation rules based on reference data . This will help with data validation at source, for example using a defined list of occupations, rather than allowing free text entry.
* Create a master repository of all civil registration data which is then accessible by various actors with different privileges. Creating multiple systems for decentralised or autonomous organisations will make maintenance tasks challenging and increase the total cost of ownership.
* Think about the way that the the CRVS system receives and shares data with other systems to maximize the value of civil registration data. See the next section on [OpenCRVS within a systems architecture ](opencrvs-within-a-government-systems-architecture.md)for more details.&#x20;
