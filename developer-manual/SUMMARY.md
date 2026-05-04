# Table of contents

## 🚞 Servers

* [Swarm Server crashed re-mount disk](README.md)
* [Kubernetes - accessing dbs](servers/page.md)
* [Upgrading EOL Ubuntu](servers/upgrading-eol-ubuntu.md)
* [Debugging Github Actions with tmate](servers/debugging-github-actions-with-tmate.md)
* [How to open a debugger to events service on Docker Swarm](servers/how-to-open-a-debugger-to-events-service-on-docker-swarm.md)

***

* [VPNs - Wireguard & OpenVPN](vpns-wireguard-and-openvpn/README.md)
  * [Connect Github Actions with Wireguard](vpns-wireguard-and-openvpn/connect-github-actions-with-wireguard.md)
  * [Setup a Wireguard server](vpns-wireguard-and-openvpn/setup-a-wireguard-server.md)
* [Setting up MOSIP - OpenCRVS](setting-up-mosip-opencrvs.md)
* [Advanced debugging tips & tricks](advanced-debugging-tips-and-tricks/README.md)
  * [Connecting to remote MongoDB from a local machine](advanced-debugging-tips-and-tricks/connecting-to-remote-mongodb-from-a-local-machine.md)
* ```yaml
  type: builtin:openapi
  props:
    models: true
  dependencies:
    spec:
      ref:
        kind: openapi
        spec: opencrvs-api
  ```
