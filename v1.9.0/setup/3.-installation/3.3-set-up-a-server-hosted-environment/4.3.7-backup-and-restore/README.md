# 4.3.7 Backup & Restore

OpenCRVS is automatically configured so that your **production** environment, creates a backup of all data into an encrypted file on your **backup** environment every night. This file is then immediately restored onto your **staging** server.&#x20;

{% hint style="info" %}
In this way, your staging server contains citizen data that is 24 hours old. The staging server can be used as a pre-production mirror for you to test any OpenCRVS upgrades or configuration changes on real citizen data without disturbing your production environment.
{% endhint %}

If you SSH into your **backup** server, you will find the default of 7 days of backups in this directory.

```
/home/backup/backups/<date of backup>/<date of backup>.tar.gz.enc
```

You will see directories like this, each with an encrypted .**tar.gz.enc** file inside which is the backup itself.

If you wish to retain more than the default of 7 days of backup data on the backup server, edit this variable in the backup server inventory file and **re-provision the backup environment**:

```yaml
amount_of_backups_to_keep
```

The backup process uses the `/data` directory on the **production** server for temporary files, and the restore process uses `/data` on the **staging** server. Make sure `/data` has enough free space for at least one full backup archive.

### MinIO attachments backup type

MinIO stores the attachments (images and documents) uploaded with records, and is usually the largest part of a backup. You can choose how it is backed up with the `minio_backup_type` variable in your **production.yml** and **staging.yml** inventory files (see [Install dependencies](../3.3.2-install-dependencies.md)).

{% hint style="danger" %}
**Always set the same `minio_backup_type` value in both production.yml and staging.yml, and re-provision both environments after changing it.**

Production uses this value to create the nightly backup, and staging uses it to restore that backup. If the values differ, staging looks for attachments in the wrong place and **the nightly restore on staging will fail**.
{% endhint %}

The two options compare as follows:

| | `dump` (default) | `differential` |
| --- | --- | --- |
| **How it works** | A full archive of all attachments is created every night | Only new and changed attachments are copied with rsync every night |
| **Where attachments are stored on the backup server** | Inside each nightly `<date of backup>.tar.gz.enc` file | In a single folder: `/home/backup/backups/minio/` |
| **Encrypted** | Yes | **No**, attachments are stored as plain files |
| **History** | One copy per day, rotated by `amount_of_backups_to_keep` | One current copy only, not rotated |
| **Best for** | Small to medium attachment volumes | Large attachment volumes, where a full dump takes hours |

{% hint style="warning" %}
With `differential`, attachments on the backup server are **not encrypted** and there is **no day-by-day history** of attachments: the `minio` folder always holds the latest copy. Attachments deleted from production are not deleted from this folder. Make sure the backup server and its disk are adequately secured before choosing this option.
{% endhint %}

{% hint style="danger" %}
Before going live, it's very important that you confirm that OpenCRVS is successfully backing up and restoring.  Make a test registration in **production** with image attachments, and **wait 24 hours**.  This test registration should exist in your **staging** environment the day after you created it.  "View" the registration on **staging** and make sure that image attachments are available.  To learn more about all the technical  checks that you should perform before going live with your OpenCRVS installation, read the [Pre-deployment Checklist](../../../6.-go-live/3.3.4-set-up-an-smtp-server-for-opencrvs-monitoring-alerts.md) section.  To reset your all your environments including production in readiness for going live, read the [reset](../3.3.6-deploy-automated-and-manual/4.3.6.5-resetting-a-server-environment.md) section.
{% endhint %}



### Disaster Recovery

{% hint style="info" %}
You should develop an operational process to make a hard copy of your encrypted backups on a secure peripheral such as an encrypted removable disk or hardware security module.  This is in case all servers in your data centre suffer a catastrophic incident such as fire or theft.  The frequency of this operational process should be related to the **`amount_of_backups_to_keep`** variable.  E.G.  performed once every 7 days.
{% endhint %}

Using the SSH user details for a user has permission to access the backup environment , e.g.: a user in your backup.yml inventory file, the following command will copy an encrypted backup file off the backup server and onto another environment.  Perhaps it will be useful to you in an automated script or manual process.

The `rsync` command uses SSH as its underlying protocol to securely transfer files, so it accesses SSH key details the same way any `ssh` command would. It searches for private keys in standard locations (such as `~/.ssh/id_rsa`, `~/.ssh/id_ed25519`, etc.)

The backup file will be copied from the backup server into the local directory from which the command is run in this format: **$DATE\_OF\_REQUIRED\_BACKUP.tar.gz.enc** where $DATE\_OF\_REQUIRED\_BACKUP is in this format: YYYY-MM-DD

```
rsync -a -r --delete --progress --rsh="ssh -o StrictHostKeyChecking=no -p $SSH_PORT" \
  $SSH_USER@$SSH_HOST:/home/backup/backups/$DATE_OF_REQUIRED_BACKUP/${DATE_OF_REQUIRED_BACKUP}.tar.gz.enc\
  ${DATE_OF_REQUIRED_BACKUP}.tar.gz.enc
```

If you use `minio_backup_type: differential`, the encrypted backup file does not contain attachments. Copy the `minio` folder as well:

```
rsync -a -r --progress --rsh="ssh -o StrictHostKeyChecking=no -p $SSH_PORT" \
  $SSH_USER@$SSH_HOST:/home/backup/backups/minio/ \
  minio/
```

{% hint style="warning" %}
The `minio` folder is not encrypted. Store it on encrypted media.
{% endhint %}

You can now restore this backup onto a newly provisioned set of OpenCRVS servers by following the steps [here](4.3.7.1-restoring-a-backup.md).

