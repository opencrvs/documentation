# Running validation checks

### Run validation checks

"Deploy OpenCRVS" workflow runs validation checks before and after deployment to confirm that the environment is ready and that the deployed services are reachable. Use following stepts to run validation checks manually

1. Navigate to GitHub Actions within `infrastructure` repository
2. Select "Validate pre/post deploy" action
3. Select "Target environment" from dropdown menu, all environments created at [Create a GitHub Environment](../create-a-github-environment/) step should be listed here.
4. Select "Target stage":
   1. predeploy
   2. postdeploy
5. Click "Run workflow" button

### Deployment validation checks

| Stage                      | When to run                   | What it checks                                                                                                                                                                                |
| -------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pre-deployment validation  | Before running the deployment | Required datastores are reachable from the deployment environment, and SMTP configuration is present when two-factor authentication is enabled.                                               |
| Post-deployment validation | After deployment completes    | Public service domains resolve in DNS, have valid HTTPS certificates, are covered by the certificate SANs, and respond over HTTPS. SMTP connectivity is also checked when SMTP is configured. |

Following checks are running at pre-deployment:

* Postgres connectivity
* Redis connectivity
* MinIO connectivity
* Elasticsearch connectivity, if configured
* SMTP configuration:
  * Server availability
  * Configuration

Following checks are running at post-deployment:

1. For each public domain, validation runs the following checks in order:
   1. DNS resolution
   2. SSL certificate fetch
   3. SSL certificate SAN coverage
   4. HTTPS availability
   5. Public IP validation
2. Events service readiness check
3. Email integration check
