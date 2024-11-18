# VPNs - Wireguard & OpenVPN

In many OpenCRVS production installations, OpenCRVS is not accessible in the public internet but instead its hidden in an internal network. This is how governmental software typically works and also what we recommend for countries.

The problem is however that it makes deployment and other automated pipelines more complex.&#x20;

#### Add a OpenVPN client to a Github Action

Insert the following steps to your pipeline. It's worth to explore creating a vpn.yml pipeline that could be [reused in other pipelines](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

```yaml
- name: Install openconnect ppa
 run: sudo add-apt-repository ppa:dwmw2/openconnect -y && sudo apt update

- name: Install openconnect
 run: sudo apt install -y openconnect

- name: Connect to VPN
 run: |
   echo "${{ secrets.VPN_PWD }}" | sudo openconnect -u ${{ secrets.VPN_USER }} --passwd-on-stdin --protocol=${{ secrets.VPN_PROTOCOL }} ${{ secrets.VPN_HOST }}:${{ secrets.VPN_PORT }} --servercert ${{ secrets.VPN_SERVERCERT }} --background

- name: Test if IP is reachable
 run: |
   ping -c4 ${{ secrets.SSH_HOST }}
```









