# Technical stack

## Technical Stack

OpenCRVS is built as a TypeScript-first, microservices application running on Node.js. All services — frontend and backend — share a single language and a single monorepo, which reduces context-switching and allows types and validation schemas to be shared across service boundaries.

### Language & Runtime

|              |                |
| ------------ | -------------- |
| **Language** | TypeScript 5.6 |
| **Runtime**  | Node.js 22     |

TypeScript is used throughout: frontend applications, backend services, database migrations, and configuration tooling. This makes it possible to share types and schema definitions between services without duplication, and catches integration errors at compile time rather than at runtime.

### Frontend

The registration and administration interface is a **Progressive Web App (PWA)** built with **React 18**. It is designed to work offline — field agents can continue registering vital events without an active internet connection, with data synchronised to the server once connectivity is restored. It connects to the backend exclusively through the API gateway.

| Concern              | Technology            |
| -------------------- | --------------------- |
| UI framework         | React 18              |
| Build tool           | Vite                  |
| Server state         | React Query           |
| Client state         | Zustand               |
| Forms                | Formik                |
| Form validation      | JSON Schema (AJV)     |
| Internationalisation | React Intl (FormatJS) |
| Styling              | Styled Components     |

A shared component library (`@opencrvs/components`) provides the design system used across both the main client application and the login application. The component library is documented with Storybook.

All user-facing strings are externalised through React Intl, which allows country configurations to provide translations without modifying application code.

Form validations are defined as **JSON Schema** and evaluated at runtime using **AJV**. This keeps validation logic declarative and portable — the same schemas are enforced on both the client and the server.

### Country Configuration Toolkit

Country configurers work with the **`@opencrvs/toolkit`** npm package rather than directly with the application internals. The toolkit provides TypeScript helpers and higher-level constructors for the most common configuration tasks — defining forms, writing validation rules, configuring workflows, and more — without needing to understand the underlying implementation. For most implementing countries, the toolkit is the primary development surface.

### Backend Services

OpenCRVS is composed of several focused services, each owning a specific domain:

| Service             | Responsibility                                                              |
| ------------------- | --------------------------------------------------------------------------- |
| **Gateway**         | Single entry point for all client requests. Routes to downstream services.  |
| **Auth**            | Issues and validates JWT tokens. Manages SMS-based login flow.              |
| **Events**          | Core civil registration logic. Source of truth for all registration events. |
| **User Management** | User accounts, roles, and permissions.                                      |
| **Documents**       | Stores and retrieves supporting documents and attachments.                  |

Each service is independently deployable and runs as a Docker container.

#### HTTP Framework

Backend services use **tRPC** as their primary HTTP framework. tRPC is a TypeScript-native RPC framework — because both the client and the server share TypeScript types, mismatches are caught at compile time rather than at runtime. The Events service, which contains the majority of the civil registration business logic, is built entirely on tRPC. Other microservices also use tRPC for their internal APIs.

The same tRPC routes are exposed as OpenAPI-compatible REST endpoints for external integrating parties.

Some supporting services still use **Hapi.js**, though this will be phased out over time in favour of tRPC.

### Data Layer

OpenCRVS uses purpose-specific databases rather than a single general-purpose store. Each database is chosen for what it does well:

<table><thead><tr><th width="186.42578125">Database</th><th>What it stores</th><th data-hidden>Version</th></tr></thead><tbody><tr><td><strong>PostgreSQL</strong></td><td>Civil registration events, user data, and metrics</td><td>17</td></tr><tr><td><strong>Elasticsearch</strong></td><td>Search index for records and analytics queries</td><td>8.16</td></tr><tr><td><strong>Redis</strong></td><td>Session tokens, short-lived caches, rate limiting</td><td>8</td></tr><tr><td><strong>MinIO</strong></td><td>Supporting documents and attachments (S3-compatible object storage)</td><td>—</td></tr></tbody></table>

PostgreSQL is the authoritative store for all registration data. Elasticsearch is a derived store — populated from PostgreSQL — that powers fast search and reporting queries without loading the primary database.

### APIs

OpenCRVS exposes a **REST/OpenAPI** interface for external integrations with national systems and third-party applications. The OpenAPI specification is generated automatically from the codebase and is the recommended integration point for country-level system integrations.

### Architecture Pattern

OpenCRVS follows an **event-sourced microservices** architecture:

* **Microservices** — each service owns its domain and database. There is no shared database between services.
* **Event sourcing** — civil registration actions (declarations, validations, registrations, corrections) are stored as an immutable sequence of events in the Events service. The current state of any record is derived from its event history.
* **API Gateway** — all external traffic enters through the Gateway service, which handles authentication verification and routes requests to the appropriate downstream service.

This pattern means registration records have a full, tamper-evident audit trail by design.

### Monorepo Structure

All services and packages live in a single repository managed with **Lerna** and **Yarn Workspaces**. This allows shared packages (`@opencrvs/commons`, `@opencrvs/components`) to be used across services without publishing them to a registry during development, and ensures that all services are always tested against compatible versions of shared code.

### Required Skills

The skills required depend on what your team is doing.

**Country configuration** — configuring and extending OpenCRVS for your country requires TypeScript knowledge only. The country configuration package is a TypeScript codebase that defines forms, workflows, business rules, and translations. Knowledge of React, databases, or infrastructure is not needed for this work.

**Core development** — contributing new features to OpenCRVS core requires familiarity with the full stack:

| Skill         | Where it applies                          |
| ------------- | ----------------------------------------- |
| TypeScript    | All services and packages                 |
| React         | Frontend applications                     |
| Node.js       | Backend services                          |
| PostgreSQL    | Events data, migrations, queries          |
| Elasticsearch | Search configuration and index management |
| Docker        | Container operation and deployment        |
| REST/OpenAPI  | External system integration               |
