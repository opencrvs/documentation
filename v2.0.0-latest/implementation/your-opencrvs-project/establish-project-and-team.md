# Establish project & team

### 1. Introduction

OpenCRVS is designed to minimise technical effort for setup and configuration, but a small, well-structured team is still essential for a successful implementation.

This page defines the roles and skills required to set up, configure, develop, and maintain OpenCRVS effectively.

***

### 2. Core roles to set up OpenCRVS

At a minimum, countries should identify **two core roles** to install and configure OpenCRVS:

#### 2.1 Technical System Administrator

**Responsible for:** Installing, running, and maintaining the OpenCRVS infrastructure.

**Required skills and knowledge:**

* Working knowledge of **Linux / Unix operating systems** and ability to run terminal commands
* Familiarity with **Docker** and containerised deployments
* Understanding of **Node.js** web application concepts (OpenCRVS consists of multiple servers running in Docker containers and requires Node.js)
* Basic understanding of DevOps practices for deployment and monitoring

**Key responsibilities:**

* Install and configure OpenCRVS on servers (development, staging, production environments)
* Manage system infrastructure, including databases, storage, and networking
* Perform system upgrades and apply security patches
* Monitor system performance and troubleshoot technical issues
* Implement backup and disaster recovery procedures

#### 2.2 Business Analyst / National System Administrator

**Responsible for:** Configuring application details, forms, workflows, and vital event certificates.

**Required skills and knowledge:**

* Strong **business analysis skills** and deep understanding of CRVS processes
* Experience in managing systems for **enterprise-level organisations**
* Ability to translate legal and policy requirements into functional specifications
* Understanding of data standards and reference data management
* Strong stakeholder engagement and requirements gathering skills

**Key responsibilities:**

* Analyse current CRVS processes and define future-state workflows
* Configure OpenCRVS forms, certificates, and workflows to meet country requirements
* Define user roles, permissions, and scope-based access control
* Manage application reference data (locations, facilities, occupations, etc.)
* Document configuration decisions and maintain business rules
* Coordinate with stakeholders to validate configuration against requirements

{% hint style="info" %}
**Getting started:** These two roles are sufficient to set up and configure OpenCRVS for a Proof of Concept or pilot implementation.
{% endhint %}

***

### 2. Additional technical roles (when custom development is needed)

When countries plan to extend OpenCRVS with custom development or significant technical modifications, consider building a team with the following additional skills:

#### 2.1 Designer (UI/UX)

**Purpose:** Translate business and system requirements into user interfaces and experiences that reflect local needs.

**Required skills:**

* UI and UX design experience
* Familiarity with design tools (Figma, Sketch, etc.)
* Understanding of accessibility and usability principles

**Key responsibilities:**

* Design user interfaces for custom features using the OpenCRVS component library
* Conduct user research and usability testing
* Ensure design consistency with the core OpenCRVS product
* Create design specifications for developers

#### 2.2 Scrum Master

**Purpose:** Manage agile delivery of additional features and functionality in line with OpenCRVS standards.

**Required skills:**

* Qualified Scrum Master certification
* Experience managing software development teams
* Understanding of agile methodologies

**Key responsibilities:**

* Facilitate sprint planning, daily stand-ups, and retrospectives
* Remove blockers and manage dependencies
* Coordinate with the OpenCRVS core team on technical standards
* Track progress and manage the development backlog

#### 2.3 Full-stack Developers

**Purpose:** Develop custom features, integrations, and extensions to OpenCRVS.

**Required skills:**

* Expertise in **Node.js** (HapiJS or Express)
* Strong experience with **React** and **TypeScript**
* Working knowledge of Unix operating systems (macOS / Linux)
* Proficiency with **Git**, **MongoDB**, and **Docker**
* Familiarity with DevOps and software testing practices
* Understanding of RESTful APIs and microservices architecture

**Key responsibilities:**

* Develop custom features and integrations
* Write automated tests (unit, integration, end-to-end)
* Participate in code reviews and maintain code quality
* Work with the Technical System Administrator on deployments
* Document custom code and integration specifications

**Team size:** The number of developers required depends on the scope of custom work and available timeline.

#### 2.4 Quality Assurance Engineer(s)

**Purpose:** Perform comprehensive testing of configuration and custom code before implementation.

**Required skills:**

* Experience in software testing methodologies
* Ability to write test cases and test plans
* Familiarity with automated testing tools
* Understanding of CRVS business processes

**Key responsibilities:**

* Develop test plans and test cases for configuration and custom features
* Perform functional, integration, and regression testing
* Document and track defects
* Validate that system behaviour meets requirements
* Support user acceptance testing (UAT) activities

***

### 4. Programme and change management roles

Technology alone cannot transform civil registration services. Integrated programme components are required to ensure effective buy-in, adoption, and long-term sustainability of the new system and services.

#### 4.1 Change Management Lead

**Purpose:** Design and implement an effective change management strategy that ensures buy-in and take-up of the new system and services.

**Required skills:**

* Change management certification or extensive experience
* Stakeholder engagement and communication skills
* Understanding of organisational change processes

**Key responsibilities:**

* Develop and implement change management strategy
* Engage stakeholders and secure leadership buy-in
* Design communication and awareness campaigns
* Support staff transition to new processes and systems
* Monitor adoption and address resistance

#### 4.2 Training Lead

**Purpose:** Design and implement an effective training programme that equips users with the skills required to efficiently use the system and deliver excellent services.

**Required skills:**

* Training design and delivery experience
* Adult learning principles
* Ability to develop training materials and job aids

**Key responsibilities:**

* Conduct training needs assessment
* Design scalable training curriculum (for different user roles)
* Develop training materials, user guides, and job aids
* Deliver train-the-trainer sessions
* Establish ongoing capacity building mechanisms
* Monitor training effectiveness and adjust approach

#### 4.3 Deployment Lead

**Purpose:** Design and implement a deployment approach and plan that enables efficient rollout of the system across the country.

**Required skills:**

* Project management experience
* Logistics and coordination skills
* Understanding of phased implementation approaches

**Key responsibilities:**

* Develop national rollout plan and schedule
* Coordinate logistics for new site activation (hardware, connectivity, user setup)
* Manage site readiness assessments
* Support go-live activities at new sites
* Track rollout progress and resolve issues

#### 4.4 Monitoring & Evaluation Lead

**Purpose:** Design and implement a continuous improvement approach that allows you to continuously learn and improve both the product and implementation approach over time.

**Required skills:**

* M\&E methodology and data analysis skills
* Understanding of performance indicators and KPIs
* Experience with data visualisation and reporting

**Key responsibilities:**

* Define key performance indicators (KPIs) for the implementation
* Design data collection and monitoring frameworks
* Analyse system usage data and identify improvement opportunities
* Produce regular performance reports for stakeholders
* Support evidence-based decision making
* Document lessons learned and best practices

***

### 5. Resources and support

For broader guidance on skills and roles in CRVS digitisation, see the [CRVS Digitisation Guidebook](http://www.crvs-dgb.org/en/skills-required/).

For any questions about establishing a team to configure, further develop, or manage and maintain OpenCRVS effectively, contact [**team@opencrvs.org**](mailto:team@opencrvs.org).

{% hint style="info" %}
**Team sizing guidance:** The size and composition of your team should reflect the scope of your implementation. A Proof of Concept may only require the two core roles, while a national-scale digitisation programme typically requires all programme and change management roles in addition to technical staff.
{% endhint %}
