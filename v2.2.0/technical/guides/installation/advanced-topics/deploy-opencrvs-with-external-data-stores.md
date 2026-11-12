# Deploy OpenCRVS with external data stores

## General information

OpenCRVS can be deployed on decoupled infrastructure with clear permissions and responsibilities segregation. Default environment configuration script doesn't support advanced deployment scenario.

On managed Kubernetes you can grant access to managed data stores per pod rather than per node by mapping OpenCRVS service accounts to cloud identities, see [Kubernetes service accounts](kubernetes-service-accounts.md).

Only full backup and restore process jobs have support for decoupled data stores. Please refer to official Postgres and MinIO documentation how to configure backup/restore.

Supported data stores:

* MinIO
* Elasticsearch
* Postgres

## Postgres

This guide doesn't cover Postgres installation and configuration

Assumptions made:

* Database server port 5432 is available from Kubernetes nodes
* OpenCRVS DevOps/Sysadmin has Postgres admin user credentials

### Configure OpenCRVS to use external Postgres

1. Modify GitHub secrets for your environment:
   1. `POSTGRES_USER`
   2. `POSTGRES_PASSWORD`
2. Modify Dependencies helm chart configuration:
   1.  Open `environments/<environment>/dependencies/values.override.yaml` and add following lines to disable postgres:

       ```yaml
       postgres:
         enabled: false
       ```
   2.  Open `environments/<environment>/opencrvs-services/values.override.yaml` and add following lines to point OpenCRVS to external database server:<br>

       ```yaml
       postgres:
         host: <hostname or IP address>
       ```
3. Commit your changes to GitHub
4. Deploy Dependencies
5. Deploy OpenCRVS

### Postgres admin user configuration

Suppose you want your admin user to be called `adminuser`:

```sql
CREATE ROLE adminuser WITH LOGIN PASSWORD 'your_secure_password';
ALTER ROLE adminuser WITH SUPERUSER CREATEDB CREATEROLE REPLICATION;
```

Copy

**Explanation:**

* `WITH LOGIN`: Allows the user to log in.
* `PASSWORD 'your_secure_password'`: Sets the password (replace this with a strong password).
* `SUPERUSER`: Grants all access; the user can create roles, databases, schemas, tables, etc.
* `CREATEDB`: Allows creating new databases.
* `CREATEROLE`: Allows creating new roles.
* `REPLICATION`: Not necessary unless you want replication privileges (optional).

## S3 object store (RustFS)

The documents service uses the plain S3 API. You can use any S3-compatible store. The dependencies chart deploys RustFS by default.

Assumptions made:

* The S3 API port of the store is available from Kubernetes cluster nodes
* OpenCRVS DevOps/Sysadmin has the admin user credentials of the store
* The store is exposed to browsers on a URL that you set as `s3.public_endpoint` (for example `https://s3.example.org`). The services chart signs document URLs for this URL.

### Configure OpenCRVS to use an external S3 store

1. Modify GitHub secrets for your environment:
   1. `S3_ADMIN_ACCESS_KEY`
   2. `S3_ADMIN_SECRET_KEY`
2. Modify Dependencies helm chart configuration:
   1.  Open `environments/<environment>/dependencies/values.override.yaml` and add following lines to disable RustFS:

       ```yaml
       rustfs:
         enabled: false
       ```
   2.  Open `environments/<environment>/opencrvs-services/values.override.yaml` and add following lines to point OpenCRVS to external S3 server:<br>

       ```yaml
       s3:
         host: <hostname or IP address>
         port: <port>
         public_endpoint: <URL that browsers use, with protocol>
       ```
3. Commit your changes to GitHub
4. Deploy Dependencies
5. Deploy OpenCRVS

## Elasticsearch

Assumptions made:

* Elasticsearch server port 9200 is available from Kubernetes nodes
* Elasticsearch admin user name is `elastic` and OpenCRVS DevOps/Sysadmin has password.

### Configure OpenCRVS to use external Elasticsearch

1. Modify GitHub secret for your environment:
   1. `ELASTICSEARCH_SUPERUSER_PASSWORD`
2. Modify Dependencies helm chart configuration:
   1.  Open `environments/<environment>/dependencies/values.override.yaml` and add following lines to disable Elasticsearch:

       ```yaml
       elasticsearch:
         enabled: false
       ```
   2.  Open `environments/<environment>/opencrvs-services/values.override.yaml` and add following lines to point OpenCRVS to external Elasticsearch server:<br>

       ```yaml
       elasticsearch:
         host: <hostname or IP address>
       ```
3. Commit your changes to GitHub
4. Deploy Dependencies
5. Deploy OpenCRVS
