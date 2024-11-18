# Advanced debugging tips & tricks

## Start up node debugger locally

I’ve started using Node.js debugger quite a lot lately. It can be started by seeing the PID of the microservice you want to start it and then sending a SIGUSR1 signal to\


```
❯ lsof -i:5050
COMMAND   PID USER   FD   TYPE            DEVICE SIZE/OFF NODE NAME
node    18039 riku   22u  IPv4 0x1f72eeceba1a8dd      0t0  TCP *:mmcc (LISTEN)

❯ kill -SIGUSR1 18039
```

\
After that you can open it in Chrome’s devtools, add breakpoints and so on



## Download QA database to your local environment

Run this on QA to create a new backup to /data/backups

```
sudo bash /opt/opencrvs/infrastructure/backups/backup.sh --replicas=1 --ssh_user=riku --ssh_host=localhost --ssh_port=22 --production_ip=localhost --remote_dir=$(pwd) --passphrase=tests
```



Then run this locally

```
rsync -r --rsync-path="sudo rsync" <YOUR USERNAME>@farajaland-qa.opencrvs.org:'/data/backups/*' <PATH TO YOUR opencrvs-core/data/backups/>
```

Then on country config run

```
bash ./infrastructure/backups/restore.sh --label=2024-04-25 --replicas=1
```
