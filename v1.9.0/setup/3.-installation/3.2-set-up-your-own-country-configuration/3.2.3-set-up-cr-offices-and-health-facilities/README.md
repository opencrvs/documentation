# 4.2.3 Set up CR offices and Health facilities

{% embed url="https://youtu.be/GNhLLJgMozA" %}

#### Configuring Civil Registration Offices and Health Facilities

The next step is to prepare **CSV files** that define all the **civil registration offices** and **health facilities** in your country.  These locations are critical for mapping where registration activities take place and where births and deaths occur in medical settings.

***

**🗂️ Data Overview**

You will import two main categories of locations into OpenCRVS:

| Location Type        | Purpose                                                               |
| -------------------- | --------------------------------------------------------------------- |
| **CRVS\_OFFICE**     | Civil registration offices where staff work and events are registered |
| **HEALTH\_FACILITY** | Medical institutions where births and deaths occur                    |

These locations are used across the system for workflow management, reporting, and ineroperability.

***

**🏛️ Civil Registration Offices (`CRVS_OFFICE`)**

Each civil registration office represents a physical or administrative location where registration staff operate.

* Every **civil registration employee** is assigned to a single `CRVS_OFFICE`.
* Each `CRVS_OFFICE` belongs to an **administrative division** (e.g., district, province).
* `CRVS_OFFICE` locations provide a structure for:
  * Managing user access and permissions
  * Auditing user actions in the registration process
  * Linking each registration to the office where it was recorded

The **CRVS\_OFFICE name** can be printed as the **registration location** on all issued certificates (e.g., birth or death certificates).

***

**🏥 Health Facilities (`HEALTH_FACILITY`)**

Each health facility represents a place where births or deaths may occur under medical care.

* A **HEALTH\_FACILITY** maps to real hospitals, clinics, or maternity wards in your country.
* When a birth or death occurs in a facility, its name is printed on the certificate as the **place of birth** or **place of death**.
* These facilities enable OpenCRVS to distinguish between:
  * **Hospital births/deaths**, and
  * **Home or non-facility events**

This distinction is important for both **analytics** and **interoperability** with national health information systems.

***

**📱 Offline Access for Field Agents**

To enable **offline registration**, all configured facilities are automatically **stored locally** on Field Agents’ mobile devices during app installation.

> ⚠️ Because countries often have **thousands of facilities**, combined with potentially **thousands of administrative levels**, this step can often represent the **largest initial data load** when installing OpenCRVS.

***
