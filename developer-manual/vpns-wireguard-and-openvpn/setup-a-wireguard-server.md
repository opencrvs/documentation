# Setup a Wireguard server

We've tested the setup in the following countries:

* [Cameroon](https://github.com/newlegacydigital/opencrvs-cameroon)

If you're setting up a VPN for a country, remember it's great for accessing internal network services, but it doesn't increase your application's security. If you for whatever reason cannot get the services hidden, make sure your Traefik is configured to only allow connections from the VPN server IP.

**Good to understand before the install**

* WireGuard networking model
* How DNS works on the surface level, what is Dnsmasq
* What end-user devices are being used and if WireGuard has a client for it
* You might also need to investigate Docker networks to find the right IP addresses and subnets&#x20;

**You need to decide**

* Is the VPN server going to be running on a separate machine?
  * If yes, networking can be simpler but operating costs higher

**In most cases, you need these things to get the setup working:**

* A VPN server (wg-easy)
* A DNS Server
  * This is so that clients can still use domains like login.crvs.suomi.fi.
  * All VPN clients must be forced to use this, so it needs to be a part of their VPN profile file

#### Required setup for VPN

_docker-compose.yml_

```yaml
  dnsmasq:
    image: andyshinn/dnsmasq
    configs:
      - source: dnsmsq-conf.{{ts}}
        target: /etc/dnsmasq.conf
    command: --no-daemon --log-queries
    ports:
      - 53:53/udp
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
    deploy:
      labels:
        - 'traefik.enable=false'
    networks:
      - vpn
  wg-easy:
    image: weejewel/wg-easy:7
    environment:
      - WG_HOST=<YOUR_VPN_MANAGEMENT_UI_URL>
      - PASSWORD=<WIREGUARD_UI_ADMIN_PASSWORD>
      - WG_DEFAULT_DNS=<YOUR_DNS_SERVER_ADDRESS>
      - WG_DEFAULT_ADDRESS=10.13.13.x
      - WG_ALLOWED_IPS=0.0.0.0/0
      - WG_PORT=51822
      - WG_POST_UP=iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE
      - WG_POST_DOWN=iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE
    volumes:
      - /data/wireguard:/etc/wireguard
    ports:
      - '51822:51820/udp'
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
    deploy:
      labels:
        - 'traefik.enable=true'
        - 'traefik.http.routers.vpn.rule=Host(`<YOUR_VPN_MANAGEMENT_UI_URL>`)'
        - 'traefik.http.services.vpn.loadbalancer.server.port=51821'
        - 'traefik.http.routers.vpn.tls=true'
        - 'traefik.http.routers.vpn.entrypoints=web,websecure'
        - 'traefik.docker.network=opencrvs_vpn'
        - 'traefik.http.middlewares.vpn.headers.customresponseheaders.Pragma=no-cache'
        - 'traefik.http.middlewares.vpn.headers.customresponseheaders.Cache-control=no-store'
        - 'traefik.http.middlewares.vpn.headers.customresponseheaders.X-Robots-Tag=none'
        - 'traefik.http.middlewares.vpn.headers.stsseconds=31536000'
        - 'traefik.http.middlewares.vpn.headers.stsincludesubdomains=true'
        - 'traefik.http.middlewares.vpn.headers.stspreload=true'
    restart: unless-stopped
    networks:
      - vpn
```

For there to work you need to also define a new network. I recommend not using the opencrvs\_overlay network as the VPN users would then be to access services directly.

```yaml
networks:
  vpn:
    driver: overlay
    attachable: true
```

And a config file for DNSMasq

```yaml
configs:
  dnsmsq-conf.{{ts}}:
    file: ./infrastructure/vpn/dnsmsq.conf
```

In my case the file looks like the following but it might be different for you if the VPN is for instance running on the same machine with the services

```
address=/.staging.crvs.cm/10.0.2.251
address=/.mbouda.crvs.cm/165.210.33.242
address=/.dschang.crvs.cm/165.210.33.136
```



**Remember to add  this task to your Ansible playbooks to ensure wireguard has a data directory.**

```yaml
- name: 'Create wireguard data directory'
  file:
    path: /data/wireguard
    state: directory
  tags:
    - data

```



