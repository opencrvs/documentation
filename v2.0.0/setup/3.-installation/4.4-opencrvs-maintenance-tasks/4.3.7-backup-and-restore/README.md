# 4.4.3 Backup & Restore

### General information

{% hint style="info" %}
Backup and restore is automatically configured while environment creation by `yarn environment:init` script, check [4.3.1-create-a-github-environment](../../3.3-set-up-a-server-hosted-environment/4.3.1-create-a-github-environment/ "mention"). This guide dives into details:

* How to configure backup and restore without GitHub integration?
* How to perform manual backup?
* How to perform disaster recovery?
{% endhint %}

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

### Backup and restore configuration flow

OpenCRVS deploy dependencies GitHub Actions workflows configure backup and restore at deployment time and creates all required secrets.

Here are high level concepts how backup/restore is configured and working:

* Production servers should have only backup job configured.
* Staging servers should have only restore job configured.
* Private ssh key for restore job should be same as on production.
* Production backup and staging restore keys should be same.

<figure><img src="../../../../.gitbook/assets/k8s-infra-backup-restore-secrets.png" alt=""><figcaption></figcaption></figure>

### Backup types

Following backup types are supported by datastores:

* Postgres:
  * `dump`: (Default) Database dump, without instance configuration. Backup is performed by `pg_dump` utility. Database credentials are preserved. Backup is suitable for average country with small population (up to 1 million of people).
  * `differential` : Differential backup between last full backup. Backup is performed at instance (cluster) level by `pgBackRest` tool. Database credentials are replaced with credentials from backup server at restore time. By default weekly full and daily differential backups are made.
* MinIO:
  * `dump`: (Default) Full filesystem copy clone archived and encrypted on daily basics.
  * `differential`: Full filesystem copy mirrored on remote backup server folder with rsync.
* MongoDB: Database dump stored as encrypted archive
* InfluxDB: Database dump stored as encrypted archive

Please check helm chart documentation and `values.yaml` for more information about available configuration options. Backup schedule and backup types.

### Backup configuration

Each datastore has its own backup job, configured as a Kubernetes `CronJob`. Backup settings are defined in the `backup` section of the chart values file. You can configure a separate backup (restore) schedule and remote directory for each datastore.

Example:

```yml
minio:
  backup:
    schedule: "0 1 * * *"
postgres:
  backup:
    schedule:
      dump: "0 2 * * *"
```

Check helm chart documentation and `values.yaml` for more information about available options, e/g Postgres has support for several backup types.

Usually backup is configured only on production environment and restore is configured on staging environment, but there is no limitations to configure backup/restore on any other servers. E/g for testing purposes backup/restore can be configured between development and qa environments.

Backup server configuration is fully automated with Ansible playbooks, you need to provide backup server IP address (or hostname) to `yarn environment:init` script and bootstrap backup server.

{% hint style="info" %}
A server can have either backup or restore configured — never both at the same time.
{% endhint %}

### Backup server filesystem structure

Full datastore backups are stored as compressed and encrypted archive on backup server remote repository. Example:

* Backups are structured by date
* Backup folder contains one encrypted archive for each datastore

```
backup@poc-backup:~$ ls -l /home/backup/production/
total 60
drwxrwxr-x 2 backup backup 4096 Feb  5 01:00 2026-02-05
...
drwxrwxr-x 2 backup backup 4096 Feb 13 01:00 2026-02-13
backup@poc-backup:~$ ls -l /home/backup/production/2026-02-05
total 124
-rw-r--r-- 1 backup backup 70800 Feb  5 01:00 influxdb_backup_2026-02-05.tar.gz.enc
-rw-r--r-- 1 backup backup   112 Feb  5 01:00 minio_backup_2026-02-05.tar.gz.enc
-rw-r--r-- 1 backup backup 11984 Feb  5 01:00 mongo_backup_2026-02-05.tar.gz.enc
-rw-r--r-- 1 backup backup 33040 Feb  5 01:00 postgres_backup_2026-02-05.tar.gz.enc
```

Differential backups are stored as in uncompressed way backup server and don't have folder by date structure.

For Postgres differential backups are managed by `pgBackRest` and the only available configuration option is destination folder:

```
backup@poc-backup:~$ ls -l /home/backup/production/postgres/
total 8
drwxr-x--- 3 backup backup 4096 Feb 17 16:07 archive
drwxr-x--- 3 backup backup 4096 Feb 17 16:07 backup
```

In this example the folder `/home/backup/production/postgres/` is managed by `pgBackRest`.
