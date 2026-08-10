# Manual backup creation

### Before you begin

{% hint style="info" %}
Manual backup process assumes automated backup workflow is already configured and working properly.

Manual backup process invokes same Kubernetes cronjobs as for automated process.
{% endhint %}

Reasons for manual backup:

* Before environment reset
* Before OpenCRVS or dependencies upgrade
* Migration to new hardware or cloud
* Off-boarding from OpenCRVS

Following components are backed up:

* PostgreSQL
* MinIO

### Running all components backup

1. Connect to your cluster with `kubectl`
2.  Change namespace to opencrvs-deps-\<environment>:

    ```
    kubectl config set-context --current --namespace=opencrvs-deps-<environment>
    ```
3.  Run following command to trigger backup jobs for all components:

    ```
    for cj in $(kubectl get cronjob -l job-type=backup -o jsonpath='{.items[*].metadata.name}'); do \
      kubectl delete job $cj-job --ignore-not-found; \
      kubectl create job --from=cronjob/$cj $cj-job; \
    done
    ```

    Example output:

    ```
    job.batch "minio-backup-job" deleted
    job.batch/minio-backup-job created
    job.batch "postgres-backup-job" deleted
    job.batch/postgres-backup-job created
    ```
4.  Verify all jobs completed without issues:<br>

    ```
    kubectl get job -ljob-type=backup
    ```

    Example output: Check job names like `*-backup-job` without ending number, jobs with number were triggered per schedule:

    ```
    NB01NSTL012:~ vmudryi$ kubectl get job -ljob-type=backup
    NAME                       STATUS     COMPLETIONS   DURATION   AGE
    minio-backup-29384700      Complete   1/1           9s         6h9m
    minio-backup-job           Complete   1/1           10s        2m30s
    postgres-backup-29384700   Complete   1/1           12s        6h9m
    postgres-backup-job        Complete   1/1           12s        2m28s
    ```
5. SSH (Login) to backup server and verify backup was completed successfully.

### Running Single component (Postgers) backup

1. Connect to your cluster with `kubectl`
2.  Change namespace to opencrvs-deps-\<environment>:

    ```
    kubectl config set-context --current --namespace=opencrvs-deps-<environment>
    ```
3.  Run following command to trigger MongoDB backup:

    ```
    kubectl create job \
      --from cronjob/postgres-backup postgres-backup-manual
    ```

    Example output:

    ```
    job.batch/postgres-backup-manual created
    ```
4.  Verify MongoDB backup completed successfully:

    ```
    kubectl logs -f job/postgres-backup-manual
    ```

    Example output:

    ```
    [2025-11-12 07:01:38] Starting Postgres backup script
    ...
    [2025-11-12 07:01:52] Encrypted backup file /tmp/postgres_backup_2025-11-12.tar.gz.enc transferred to backup host 10.2.0.3:/home/backup/production/2025-11-12
    ```

### Verify backup was created

1. SSH (Login) to backup server
2.  Become backup user:

    ```
    sudo -i
    su - backup
    ```
3.  Check backup directory content:

    ```
    ls -l /home/backup/<environment>
    ls -l /home/backup/<environment>/<date>
    ```

    Example output:

    ```
    backup@tmp-backup:~$ ls -l /home/backup/production/2025-11-12
    total 25972
    -rw-r--r-- 1 backup backup 26506864 Nov 12 01:00 minio_backup_2025-11-12.tar.gz.enc
    -rw-r--r-- 1 backup backup      448 Nov 12 01:00 postgres_backup_2025-11-12.tar.gz.enc
    ```
