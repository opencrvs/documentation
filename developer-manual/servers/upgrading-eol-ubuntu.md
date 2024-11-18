# Upgrading EOL Ubuntu

**Digital Ocean**

<pre><code><strong>sed -i -e 's/mirrors.digitalocean.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
</strong></code></pre>

**Others**

```
sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
```

```
apt-get update
apt-get upgrade
apt-get install update-manager-core
```

After this you need to reboot the machine

```
reboot now
```

after the machine is back, run

```
do-release-upgrade
```



\
Source\
[https://www.digitalocean.com/community/questions/upgrading-from-ubuntu-22-10](https://www.digitalocean.com/community/questions/upgrading-from-ubuntu-22-10)
