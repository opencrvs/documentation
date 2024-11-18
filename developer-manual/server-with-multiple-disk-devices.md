# Server with multiple disk devices

**Good to understand:**

* `cryptfs_file_sparse.img` file is the thing that uses the physical disk space, not the `/data` directory. This means enough disk space needs to be allocated to where the sparse image file is located.
* Sparse image file always takes more space than what's in /data directory
* If your data takes 50Gb and then it reduces to be only 20Gb, the sparse image will remain 50Gb and cannot be reduced in size anymore with recreating it.&#x20;

**Useful commands:**

* `sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL`
* `df -h`



```
Filesystem           Size  Used Avail Use% Mounted on
tmpfs                3.2G  3.6M  3.2G   1% /run
/dev/vda1             97G   33G   65G  34% /
tmpfs                 16G     0   16G   0% /dev/shm
tmpfs                5.0M     0  5.0M   0% /run/lock
/dev/vda15           105M  6.1M   99M   6% /boot/efi
/dev/vdb             295G  233G   47G  84% /storage
/dev/mapper/cryptfs  274G  152G  109G  59% /data
tmpfs                3.2G  4.0K  3.2G   1% /run/user/1000
```

