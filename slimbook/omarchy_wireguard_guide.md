# Omarchy (Arch) wireguard vpn configuration guide

```bash
sudo pacman -S wireguard-tools
sudo install -d -m 700 /etc/wireguard
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
sudo chmod 600 /etc/wireguard/private.key
sudo chmod 644 /etc/wireguard/public.key
sudo cat /etc/wireguard/public.key   # copy this for step 3
```
