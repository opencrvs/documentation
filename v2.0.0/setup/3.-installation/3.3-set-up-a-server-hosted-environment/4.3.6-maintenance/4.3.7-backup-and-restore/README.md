# 4.3.7 Backup & Restore

OpenCRVS dependencies helm chart has an configuration options for automated backups and restores.

OpenCRVS dependencies helm chart includes a built-in backup and restore features that supports automated backups and restores for internal components (datastores). Backups are uploaded on an external server via an SSH connection.

Supported datastores:

* MongoDB
* PostgreSQL
* MinIO
* InfluxDB

{% hint style="info" %}
Elasticsearch doesn't support backup and restore, please use re-index job instead
{% endhint %}

Each datastore has its own backup job, configured as a Kubernetes `CronJob`. Backup settings are defined in the `backup` section of the chart values file. You can configure a separate backup (restore) schedule and remote directory for each datastore.

Usually backup is configured only on production environment and restore is configured on staging environment, but there is no limitations to configure backup/restore on any other servers. E/g for testing purposes backup/restore can be configured between development and qa environments.
