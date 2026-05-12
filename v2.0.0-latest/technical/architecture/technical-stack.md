# Technical stack

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
| Internationalisation | React Intl (FormatJS) |
| Styling              | Styled Components     |

A shared component library (`@opencrvs/components`) provides the design system used across both the main client application and the login application. The component library is documented with Storybook.

All user-facing strings are externalised through React Intl, which allows country configurations to provide translations without modifying application code.

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

Backend services use **Hapi.js** as their HTTP framework. Hapi provides built-in request validation (via Joi), plugin-based middleware, and structured route definitions. Route schemas are published as Swagger/OpenAPI specifications.

#### Client–Server Communication

The frontend communicates with the backend using **tRPC**, a TypeScript-native RPC framework. Because both the client and the server share TypeScript types, mismatches are caught at compile time rather than at runtime. The same tRPC routes are also exposed as OpenAPI-compatible REST endpoints for integrating parties.

### Data Layer

OpenCRVS uses purpose-specific databases rather than a single general-purpose store. Each database is chosen for what it does well:

| Database          | Version | What it stores                                                      |
| ----------------- | ------- | ------------------------------------------------------------------- |
| **PostgreSQL**    | 17      | Civil registration events, user data, and metrics                   |
| **Elasticsearch** | 8.16    | Search index for records and analytics queries                      |
| **Redis**         | 8       | Session tokens, short-lived caches, rate limiting                   |
| **MinIO**         | —       | Supporting documents and attachments (S3-compatible object storage) |

PostgreSQL is the authoritative store for all registration data. Elasticsearch is a derived store — populated from PostgreSQL — that powers fast search and reporting queries without loading the primary database.

### APIs

| Surface          | Used by                                                            |
| ---------------- | ------------------------------------------------------------------ |
| **tRPC**         | Frontend applications (primary client–server communication)        |
| **REST/OpenAPI** | External integrations (national systems, third-party applications) |

An OpenAPI specification is generated automatically from the codebase and is the recommended integration point for country-level system integrations.

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
