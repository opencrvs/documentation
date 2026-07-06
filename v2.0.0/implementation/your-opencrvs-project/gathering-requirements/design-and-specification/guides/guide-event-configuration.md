# Guide: Event configuration

### 1. Introduction

The role of OpenCRVS is to enable **efficient, high‑quality civil registration services**. That starts with smart business processes that make the most of what digital technology can offer, instead of simply copying existing paper workflows.

Use this page when you are:

* Reviewing current CRVS processes before introducing OpenCRVS.
* Designing new or improved workflows (for example, late registration, corrections, certificate issuance).
* Preparing material to support legal or policy updates.

***

### 2. Do’s and don’ts

#### 2.1 Do

1.  **Use technology to enhance processes and satisfaction**

    Design workflows that reduce travel, waiting time, and manual re‑entry of data.
2.  **Explore digital options even if laws are not yet updated**

    Consider features such as **digital signatures**, QR‑code verification, and electronic notifications as target end‑states.
3.  **Use process redesign to inform legal change**

    Let improved workflows and service standards guide future **legislative updates** rather than being constrained only by existing law.
4.  **Design with real users**

    Co‑design with registrars, health workers, and community leaders. Validate each step against what they can realistically do.
5.  **Design to improve service delivery and experience**

    Optimise for faster registration, fewer visits, clearer responsibilities, and better communication with families.

#### 2.2 Don’t

1.  **Do not simply digitise paper processes**

    Avoid 1:1 replicas of forms, signatures, and approval chains that were designed for a paper world.
2.  **Do not design based on legislation alone**

    Start from real operational needs and pain points, then check what must change legally to support better service.
3.  **Do not dismiss features just because they are not yet legal**

    Treat these as a **vision** to work towards and as input to law and policy reform.
4.  **Do not ignore what you already know is broken**

    If something causes delays or confusion today, redesign it. Do not carry known issues into your digital system.

***

### 3. Key CRVS terms

Get comfortable with core terms used in CRVS workflows. Countries sometimes use these words differently, so always confirm what each term means locally.

*   **Notification**

    The **minimal set of data** relating to a vital event, often created by someone close to where the event occurs (for example, a health facility or community leader).

    _Note: Some countries use “notification” and “declaration” interchangeably. Clarify how each term is used in your context._
*   **Declaration**

    The **complete set of data** required to register a vital event (for example, all fields in a birth or death registration form) plus supporting documents.
*   **Validation**

    The process of **checking the declaration** against rules and evidence. This includes verifying that data is complete, consistent, and supported by appropriate documents.
*   **Registration**

    The **legal act** of adding a validated event to the civil register. After registration, the event becomes an official record and can be referenced in certificates and extracts.
*   **Certificate issuance**

    The process of **generating, printing, and issuing a certificate or certified copy** from a registered record, following defined business rules and fees.

***

### 4. Designing the end‑to‑end process

When mapping business processes that OpenCRVS will support, think about the **full journey** from the moment an event occurs to the final issuance of a certificate, including who does what, where, and using which device.

Below is a simple example using the core CRVS steps. Adapt the actors and locations to your country context.

#### 4.1 Example mapping

**Step: Notification / Declaration**

*   **Who is best placed to complete this step?**

    Health administrator, health worker, or community leader close to where events occur.
*   **Where should this be done?**

    At or near the **place of occurrence** (for example, health facility, community meeting point, outreach visit).
*   **Why them?**

    They know when events occur and can notify promptly, reducing delays and under‑registration.
*   **Using what device?**

    Mobile phone or tablet (online or offline), or a simple web form if connectivity allows.

**Step: Validation**

*   **Who is best placed to complete this step?**

    Registration clerk or registration agent.
*   **Where should this be done?**

    At the **registration office** or service point where documents can be checked.
*   **Why them?**

    They handle daily administrative work on behalf of the Registrar and can follow clear validation checklists.
*   **Using what device?**

    PC or laptop with access to OpenCRVS, supporting review of both data and uploaded documents.

**Step: Registration**

*   **Who is best placed to complete this step?**

    Registrar (or a designated official with legal authority).
*   **Where should this be done?**

    Wherever the Registrar can securely access OpenCRVS (usually at the registration office, but potentially remote if allowed by policy).
*   **Why them?**

    They hold the **legal mandate** to register vital events and are accountable for the accuracy of the register.
*   **Using what device?**

    PC or laptop with secure access and appropriate scopes in OpenCRVS.

**Step: Certificate issuance**

*   **Who is best placed to complete this step?**

    Registration clerk or front‑office staff.
*   **Where should this be done?**

    At the **registration office** or service point where citizens collect certificates.
*   **Why them?**

    They handle most day‑to‑day interactions, payments, and printing on behalf of the Registrar.
*   **Using what device?**

    PC or laptop connected to a printer, using OpenCRVS Print actions.

***

### 5. Questions to guide process design

Use these prompts when mapping or refining your business processes:

* **Access and proximity**
  * How close is the person completing each step to where events actually occur?
  * Can some steps move closer to the community (for example, outreach, health facility notification)?
* **Roles and responsibilities**
  * Is the right level of staff doing the right work?
  * Can clerks and agents handle more of the routine tasks so Registrars focus on decisions?
* **Timing and deadlines**
  * How will processes support legal time limits for registration?
  * Where can reminders, flags, or workqueues help staff prioritise cases?
* **Channels and devices**
  * Which steps can safely be done on mobile devices, and which require office‑based PCs?
  * How will offline work be handled and synced?
* **Quality and fraud prevention**
  * Where in the process should additional checks or approvals be added?
  * How will you use flags, deduplication, or audit trails to manage risk?
* **Citizen experience**
  * How many visits, documents, and signatures does the citizen currently need?
  * Which of these can be reduced or removed with better process and digital tools?

Use the answers to these questions to propose **simpler, more reliable workflows** before you begin detailed configuration in OpenCRVS.
