# OpenVPN Stack

This stack provides an OpenVPN server for remote clients. Client traffic is configured as full-tunnel and should use Pi-hole/Unbound for DNS.

## Setup
1. Copy `.env.example` to `.env` (use `scripts/render-env.sh` from the repo root).
2. Set `OPENVPN_REMOTE_HOST`, `OPENVPN_BIND_IP`, and `OPENVPN_DNS` (Pi-hole DNS IP).
3. Initialize the server PKI and base config:
   - `scripts/openvpn.sh init`
4. Create a client profile:
   - `scripts/openvpn.sh add-client <client-name> --out /path/to/client.ovpn`
5. Start the stack from Dockge or via `docker compose up -d`.

## Notes
- Uses `/dev/net/tun` and `NET_ADMIN` to run the VPN tunnel.
- The init step pushes `redirect-gateway def1` (full-tunnel) and the DNS server from `OPENVPN_DNS`.
- Store generated `.ovpn` files outside this repository.
