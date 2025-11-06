# 4.2.2 Set up administrative address divisions

{% embed url="https://youtu.be/WU6nYHgHk2I" %}

#### 🗺️ Configuring Administrative Divisions

Now that your country configuration repository is ready, you can begin defining your **administrative divisions** — the geographic structure that allows OpenCRVS to correctly locate registrations, associate offices within the national hierarchy, and generate accurate performance analytics and vital statistics.

***

**🧩 Why Administrative Divisions Matter**

A consistent administrative structure is essential for:

* **Geo-locating registrations** and determining where each event occurs.
* **Positioning registration offices** within the national hierarchy (e.g., region → district → sub-district).
* **Generating key metrics** such as registration completeness, timeliness, and population coverage.
* **Exporting statistics** to national and international standards (e.g., SDG 16.9 indicators).

Even though OpenCRVS recognises that many countries have **non-standardised addressing systems**, particularly in rural or informal settlements, this should never be a barrier to registration.

To support this, OpenCRVS allows **optional and unstandardised address lines** in **event configuration**. These free-text address fields can capture local names or descriptions while still maintaining a structured hierarchy for analytics.

***

**🏛️ Defining Your Hierarchy Levels**

Each country must define a set of **standardised administrative levels** — for example:

| Level | Example Name       | Example Value      |
| ----- | ------------------ | ------------------ |
| 1     | Region             | “Northern Region”  |
| 2     | District           | “Gulu District”    |
| 3     | Sub-County         | “Awach Sub-County” |
| 4     | Village (optional) | “Lalogi Village”   |

You can present these levels in the user interface using **any labels** you prefer (e.g., “Province”, “Zone”, “Ward”), depending on your country’s terminology.

These levels will automatically appear as **dropdowns** in your event declaration forms wherever an `ADDRESS` component is used.

***

**📊 Administrative Divisions and Statistics**

Administrative divisions also underpin OpenCRVS analytics. One of the most important performance indicators for civil registration systems is the **completeness rate** — the percentage of events registered compared to the expected number of events in a given area and timeframe.

**Completeness rates** are a key international benchmark for CRVS performance and are used to track **Sustainable Development Goal (SDG) target 16.9**:

> _“By 2030, provide legal identity for all, including birth registration.”_

To calculate completeness rates, OpenCRVS uses the following formulas:

| Category   | Formula                                                                                    |
| ---------- | ------------------------------------------------------------------------------------------ |
| **Total**  | `((crude birth or death rate * total population) / 1000) * (target estimated days / 365)`  |
| **Male**   | `((crude birth or death rate * male population) / 1000) * (target estimated days / 365)`   |
| **Female** | `((crude birth or death rate * female population) / 1000) * (target estimated days / 365)` |

To enable these calculations, you must obtain from your **national statistical office**:

* The **crude birth rate** and **crude death rate**
* The **total population**, broken down by **gender**
* Data for your **highest administrative level** (e.g., _State_, _Province_, or _Admin Level 1_ following the [Humanitarian Data Exchange (Humdata)](https://data.humdata.org) standard)

***

**🧾 Creating Source Files**

Once you have gathered your administrative division data, this section will help you:

1. Create **source files** in your repository that define your hierarchy, populations, and rates.
2. These files will later be used to **seed the database**.

