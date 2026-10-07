# Run backup and restore

### Before you begin

The following sections describe how to manually run backup and restore workflows from GitHub Actions.

You can restore an environment from any date for which a backup exists. The restore workflow allows you to select the desired backup by specifying its date.

Backups can only be created from the current state of an environment. It is not possible to create a backup of a past state retrospectively.

### Run "Backup" workflow

Perform following steps to backup environment:

1. Navigate to GitHub Actions within `infrastructure` repository
2. Select "Backup" action
3. Select "Target environment" from dropdown menu, all environments created in the [Create a Github Environment](../deploy-set-up-a-server-hosted-environment/create-a-github-environment/) step, should be listed here.
4. Click "Run workflow" button

### Run "Restore" workflow

Perform following steps to backup environment:

1. Navigate to GitHub Actions within `infrastructure` repository
2. Select "Restore" action
3. Select "Target environment" from dropdown menu, all environments created in the [Create a Github Environment](../deploy-set-up-a-server-hosted-environment/create-a-github-environment/) step, should be listed here.
4. Provide restore data in format `YYYY-MM-DD`
5. Click "Run workflow" button

