# Go-live

### 1. Introduction

Go-live is the process of launching OpenCRVS for live vital event registration. This is a critical milestone in any implementation, marking the transition from development and testing to operational use.

We recommend making go-live as small and low-key as possible, with initially just a few users testing the application at selected test sites. This gives you the possibility to provide feedback and adjust the solution before wider scale rollout.

This section provides a comprehensive readiness checklist to ensure that your implementation is properly prepared for launch and subsequent nationwide rollout.

***

### 2. Go-live approach

A phased approach to go-live reduces risk and allows for early feedback and adjustment.

#### Recommended approach

* **Start small** — begin with a limited number of users at selected test sites.
* **Test in production** — validate that all processes work as expected in the live environment with real users.
* **Gather feedback** — collect user feedback and monitor system performance during the initial phase.
* **Adjust and iterate** — make necessary adjustments before expanding to additional sites.
* **Scale gradually** — roll out to additional locations only when the initial sites are stable and successful.

This approach minimizes disruption and allows you to identify and resolve issues before they affect a larger user base.

***

### 3. Go-live readiness checklist

Before launching your solution for live vital event registration, ensure that all of the following areas have been properly prepared.

#### 3.1 Office refurbishment

Are registration offices and staff properly equipped to be able to use the new application?

* **Equipment** — computers, printers, scanners, mobile devices, and accessories are in place and functioning.
* **Connectivity** — reliable internet connectivity (or offline-capable infrastructure) is available.
* **Power supply** — stable electricity or backup power solutions are in place.
* **Physical security** — sufficient security measures are in place to ensure that equipment is safe.
* **Work environment** — offices are set up to support efficient and secure registration processes.

#### 3.2 Training

Have the users been adequately trained, on the application but also on any new policies and processes?

* **Application training** — users understand how to perform key tasks (declare, validate, register, print).
* **Policy and process training** — users are familiar with new or updated civil registration policies and procedures.
* **Role-specific training** — training is tailored to different user roles (Registration Agents, Registrars, Administrators).
* **Training materials** — user guides, quick reference cards, and video tutorials are available.
* **Refresher training** — plans are in place for ongoing training and support.

#### 3.3 Change management

Have the changes to processes and tools been properly communicated and are users ready to adopt the new application?

* **Communication plan** — changes have been clearly communicated to all stakeholders.
* **User readiness** — users understand why the change is happening and how it will benefit them.
* **Leadership support** — managers and leaders are visibly supporting the transition.
* **Feedback mechanisms** — channels are in place for users to provide feedback and ask questions.

#### 3.4 Public communication

Have the changes to vital event registration processes been properly communicated to the public so that they are aware of what to do?

* **Public awareness campaign** — informants and the general public are aware of any changes to registration processes.
* **Information materials** — posters, brochures, radio announcements, or other materials explain what is changing.
* **Service locations** — the public knows where to go to register events.
* **Requirements** — the public understands what documents and information they need to bring.

#### 3.5 Data migration

Has legacy digital data been migrated to the new application? Have historical paper-based records been digitised and uploaded into the new application?

* **Legacy data migrated** — existing digital records have been successfully imported into OpenCRVS.
* **Data quality** — migrated data has been validated and cleaned.
* **Paper records digitised** — historical paper-based records have been digitised and uploaded (if required).
* **Migration testing** — data migration has been tested and verified before go-live.

#### 3.6 Testing

Have all standard operating procedures been tested and proven to work as designed? Can the application support peak user load? Has the application and infrastructure passed cyber-security penetration tests?

* **Functional testing** — all standard operating procedures have been tested end-to-end.
* **User acceptance testing** — users have validated that the system meets their needs.
* **Performance testing** — the application can support expected and peak user loads.
* **Security testing** — the application and infrastructure have passed independent cyber-security penetration tests.
* **Backup and recovery testing** — backup and disaster recovery procedures have been tested.

#### 3.7 Service management

Is there a team that can handle support requests and respond to the common queries and issues? Is it clear to users how to contact the support team?

* **Support team in place** — a dedicated team is ready to handle user support requests.
* **Support channels** — users know how to contact support (phone, email, in-person).
* **Issue tracking** — a system is in place to log, track, and resolve support tickets.
* **Common issues documented** — frequently asked questions and common issues are documented with solutions.
* **Service level agreements** — response and resolution times are defined and communicated.

#### 3.8 Application maintenance and support

Are there support teams in place with the necessary SLAs to be able to support the service management team, including technical monitoring and maintenance of the application?

* **Technical support team** — a team with the necessary skills is in place to maintain the application and infrastructure.
* **Monitoring in place** — system health, performance, and security are actively monitored.
* **Incident response** — procedures are in place to respond to and resolve incidents.
* **Maintenance schedule** — planned maintenance windows are scheduled and communicated.
* **SLAs defined** — service level agreements are in place for technical support and maintenance.

#### 3.9 Rollout planning

Is there a rollout plan with sufficient resources to scale up the use of the application nationwide? Are there checkpoints in place to help decide whether rollout should continue or should be paused?

* **Rollout plan** — a phased plan is in place to expand from initial sites to nationwide coverage.
* **Resource planning** — sufficient resources (staff, budget, equipment) are allocated for rollout.
* **Checkpoints and milestones** — clear decision points are defined to assess whether to continue or pause rollout.
* **Success criteria** — metrics are defined to measure success at each phase.
* **Contingency plans** — plans are in place to address issues that may arise during rollout.

***

### 4. Pre-deployment checklist

The following << [Pre-Deployment Checklist](https://documentation.opencrvs.org/setup/6.-go-live/3.3.4-set-up-an-smtp-server-for-opencrvs-monitoring-alerts)  >> should be completed by the **production** environment server administrator before going live.

This checklist covers technical infrastructure requirements including:

* Server configuration and security
* Database setup and backups
* Monitoring and alerting
* SSL certificates and encryption
* Performance optimization

Completing this checklist ensures that the technical infrastructure is properly configured and secured before launch.
