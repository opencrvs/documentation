# Off-boarding from OpenCRVS

Perhaps you may wish to manually decrypt and extract the raw data from an encrypted OpenCRVS backup file if migrating the data to another vendor's civil registration system.

Each daily backup directory on the backup server (`/home/backup/<environment>/<YYYY-MM-DD>`) contains one encrypted archive per datastore:

* `postgres_backup_<YYYY-MM-DD>.tar.gz.enc`
* `minio_backup_<YYYY-MM-DD>.tar.gz.enc`

Using the BACKUP\_ENCRYPTION\_PASSPHRASE the backup archives downloaded in the **Disaster Recovery Procedure** can be decrypted and unzipped (extracted) like this:

**Decrypt:**

```
openssl enc -d -aes-256-cbc -salt -pbkdf2 -in postgres_backup_${DATE_OF_REQUIRED_BACKUP}.tar.gz.enc --out postgres_backup_${DATE_OF_REQUIRED_BACKUP}.tar.gz -pass pass:$BACKUP_ENCRYPTION_PASSPHRASE
```

Repeat the same command for the `minio_backup_${DATE_OF_REQUIRED_BACKUP}.tar.gz.enc` archive.

**Extract the raw data into a directory named "extracted\_data":**

```
mkdir extracted_data
tar -xvf postgres_backup_${DATE_OF_REQUIRED_BACKUP}.tar.gz -C extracted_data
```

The PostgreSQL archive contains one `<database>.dump` file per database, created with `pg_dump` in custom format (restore it with `pg_restore`), and a `roles.sql` file with the database roles (without passwords). The MinIO archive contains the supporting document attachments as plain files.

You can now write whatever custom migration script you wish using the raw PostgreSQL and MinIO files.
