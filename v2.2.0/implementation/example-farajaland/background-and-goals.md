# Background & goals

### 1. Introduction

This page describes the **civil registration context in Farajaland** and the **goals of the Civil Registration Authority (CRA)**. It explains why Farajaland needs a digital CRVS system and what OpenCRVS is expected to achieve.

***

### 2. Civil registration in Farajaland today

The **Civil Registration Authority (CRA)** has the legal mandate to register all births and deaths in Farajaland, as defined in the **Births and Deaths Registration Act**, last amended in 2021. Key characteristics of the current system:

#### **2.1 Legal framework**

The Births and Deaths Registration Act of 2021 recognises **electronic civil registration processes**, including:

* Electronic signatures.
* Electronic storage of vital event records.
* The law provides a basis for digitising registration, but implementation is still in transition.

#### **2.2 Institutional setup**

* The CRA is headed by the **Registrar General**, who has overall accountability for civil registration in Farajaland.
* The CRA’s **Headquarters (HQ)** is based in **Isamba District**.
* HQ includes several key roles, such as:
  * **Operations Manager** – responsible for service delivery and performance.
  * **National System Administrator** – responsible for managing the OpenCRVS platform and integrations.

#### **2.3 Decentralised service delivery**

* Civil registration is administered at the **District level**.
* There is a **Civil Registration Office in each of the 16 districts**.
* In each district office:
  * A **Local Registrar** is responsible for formally registering vital events and issuing certificates.
  * **2–3 Registration Officers** support day‑to‑day operations.
  * A number of **Community Leaders** have a formal role in **notifying vital events** in the community.

#### **2.4 Health–CRVS collaboration**

* There is a **Memorandum of Understanding (MoU)** between the CRA and the **Ministry of Health**.
* The MoU sets out how **health and civil registration systems are integrated**, so that:
  * Births and deaths captured electronically in **hospitals and health facilities** can be shared digitally with the Civil Registration Office.
  * A **Hospital Clerk** can declare births and deaths directly in OpenCRVS.

#### **2.5 Historical reliance on paper**

* Until recently, Farajaland relied heavily on **manual, paper‑based processes**.
* As a result:
  * **Completeness rates** (registration within 1 year of event) are low:
    * \~40% for births.
    * \~15% for deaths.
  * Data quality is poor, with **many duplicate entries** in the civil registry.
  * The **customer experience is weak**:
    * Families often have to visit the Civil Registration Office multiple times.
    * Registration is time‑consuming and expensive, especially for rural households.

***

### 3. Strategic goals for 2026

In 2021, the CRA developed a **CRVS National Strategic Plan**. This plan defines a number of strategic goals to be achieved by **2026**.

Headline goals include:

* **90% completeness** for both **birth** and **death** registration (within the legally defined timeframe).
* **95% certification rate** for both birth and death registration.
* A **fully digitised and searchable civil registration archive** containing all historical records of births and deaths in Farajaland.
* Increased **efficiency** of civil registration staff.
* Improved **quality of vital events data**.
* Increased **value of CRVS data** through interoperability and safe data sharing with:
  * Foundational ID systems.
  * Health information systems.
  * The National Bureau of Statistics.
* Improved **cost‑effectiveness** of civil registration service delivery.
* Better **customer experience**, including:
  * Reduced time taken to register events.
  * Reduced number of visits required.
  * Reduced out‑of‑pocket costs for families.

These goals set the direction for how Farajaland configures OpenCRVS.

***

### 4. Strategies to reach these goals

To achieve the strategic goals, the CRA is implementing a combination of **policy, process, and technology** changes. OpenCRVS is one of the key enablers. Core strategies include:

#### **4.1 Digitally enabled service delivery models**

* Deploy new models that bring registration services **closer to the community**, for example:
  * Community‑based notifications and declarations via **Community Leaders** and **Mobile Registration Agents**.
  * Facility‑based capture of events at **hospitals and health centres**.
  * District office registration supported by better case management.

#### **4.2 Improved data quality and duplicate reduction**

* Use automated validation and **duplicate detection** to reduce multiple registrations for the same person.
* Apply **business rules** and **flags** to ensure cases that look suspicious are reviewed by a Registrar.

#### **4.3 Performance management and monitoring**

* Use dashboards and reports to identify **poor‑performing areas** (for example, districts with low completeness or high late registration rates).
* Implement **remediation measures**, such as targeted outreach or additional training.

#### **4.4 Automation of manual steps**

* Automate repetitive and time‑consuming registration steps, such as:
  * Generating tracking numbers and registration numbers.
  * Producing certificates and certified copies.
  * Notifying other systems when records are registered, corrected, or revoked.

#### **4.5 Digitisation of historical records**

* Digitise paper archives of past births and deaths.
* Make them **searchable** in OpenCRVS and link them to current records where relevant.

#### **4.6Interoperability and data sharing**

* Ensure that vital events data can be **safely shared** with other systems (Foundational ID, health, statistics), in line with policy and privacy requirements.

***

### 5. Role of OpenCRVS in Farajaland

OpenCRVS is implemented in Farajaland as part of a broader **digital transformation programme** led by the CRA. The CRA has invested in the necessary infrastructure and connectivity at **District Registration Offices**, which now have stable broadband service.

In the Farajaland configuration, OpenCRVS is used to:

* Support **end‑to‑end workflows** for birth and death registration (declaration, validation, registration, printing, corrections, revocations).
* Implement the **Farajaland business rules** described on the companion page (who can declare, who approves, how late registrations and corrections are governed, etc.).
* Provide a **realistic example** of how a country can move from paper‑based CRVS to a modern, digital, interoperable system.

When using Farajaland as a reference, this page provides the **context and rationale**, while other pages (Farajaland business rules, Users in Farajaland, Actions, Status, Flags, Workqueues, Certificates) show the concrete configuration that implements these goals.
