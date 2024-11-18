# Connect Github Actions with Wireguard

**Notice only one pipeline can be connected at one time!**

```yaml
- name: Install WireGuard
  run: sudo apt-get install wireguard resolvconf -y

- name: Setup WireGuard
  run: |
    echo "${{ secrets.WIREGUARD_CONFIG }}" > wg0.conf
    chmod 600 wg0.conf
    sudo wg-quick up ./wg0.conf
  env:
    WIREGUARD_CONFIG: ${{ secrets.WIREGUARD_CONFIG }}
```
