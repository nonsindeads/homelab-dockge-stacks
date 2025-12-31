# Homelab Dockge Stacks

This repository contains Docker Compose stacks designed to be managed by Dockge. Each stack lives in its own directory under `stacks/` and includes a `compose.yml`, `.env.example`, and `README.md`.

## Repository Layout
- `stacks/00-dockge/`: Dockge UI for managing stacks.
- `stacks/05-gitlab/`: Self-hosted GitLab (omnibus CE).
- `stacks/10-wireguard/`: WireGuard VPN endpoint.
- `stacks/15-openvpn/`: OpenVPN VPN endpoint.
- `stacks/20-pihole-unbound/`: Pi-hole with Unbound resolver.
- `scripts/`: Helper scripts for environment files and validation.

## Port Plan
| Service | Host Port | Protocol | Stack | Notes |
| --- | --- | --- | --- | --- |
| Dockge UI | 8120 | TCP | 00-dockge | Bound to `WG_BIND_IP` |
| GitLab Web | 8920 | TCP | 05-gitlab | Bound to `WG_BIND_IP` |
| GitLab SSH | 2222 | TCP | 05-gitlab | Bound to `WG_BIND_IP` |
| WireGuard | 51820 | UDP | 10-wireguard | Public VPN endpoint |
| OpenVPN | 1194 | UDP | 15-openvpn | Bound to `OPENVPN_BIND_IP` |
| Pi-hole UI | 8121 | TCP | 20-pihole-unbound | Bound to `WG_BIND_IP` |
| DNS | 53 | TCP/UDP | 20-pihole-unbound | Bound to `WG_BIND_IP` |

Ports 8010, 8085, and 3000 are reserved elsewhere and are not used here.

## Environment Files
Create `.env` files from the examples:
- `scripts/render-env.sh` to generate `.env` for all stacks.
- `scripts/render-env.sh --force` to overwrite existing `.env` files.

Update `WG_BIND_IP` to your WireGuard interface IP to avoid binding UIs or DNS to `0.0.0.0`.
For OpenVPN, set `OPENVPN_BIND_IP` to the public IP you want to expose.

## Erststart (Kurz)
1. Erzeuge lokale `.env` Dateien: `scripts/render-env.sh`.
2. Passe die Platzhalter in den `.env` Dateien an (keine Secrets im Repo):
   - `stacks/00-dockge/.env`: `WG_BIND_IP`, `DOCKGE_STACKS_HOST_DIR`, `TZ`.
   - `stacks/05-gitlab/.env`: `WG_BIND_IP`, `GITLAB_EXTERNAL_URL`, `TZ`.
   - `stacks/10-wireguard/.env`: `WIREGUARD_SERVER_URL`, `WIREGUARD_PORT`, `WIREGUARD_SUBNET`.
   - `stacks/15-openvpn/.env`: `OPENVPN_BIND_IP`, `OPENVPN_REMOTE_HOST`, `OPENVPN_DNS`, `OPENVPN_SUBNET`.
   - `stacks/20-pihole-unbound/.env`: `WG_BIND_IP`, `PIHOLE_WEBPASSWORD`, `TZ`.
3. Starte Dockge einmalig (CLI):\n   `docker compose -f stacks/00-dockge/compose.yml --env-file stacks/00-dockge/.env up -d`
4. Öffne die Dockge UI unter `http://<WG_BIND_IP>:8120` und füge die Stack-Ordner hinzu.
5. OpenVPN initialisieren (vor dem Start des OpenVPN-Stacks):\n   `scripts/openvpn.sh init`
6. Starte die Stacks über Dockge (empfohlen: 20-pihole-unbound, 10-wireguard, 05-gitlab, 15-openvpn).

## Using Dockge
1. Start the Dockge stack in `stacks/00-dockge/`.
2. Add each stack directory in the Dockge UI.
3. Start or stop stacks from Dockge as needed.

## GitLab Notes
`GITLAB_EXTERNAL_URL` is a placeholder in `.env.example` and must be set to the final URL you will use. No secrets are stored in this repository; use placeholders and add real values locally.

## OpenVPN Notes
Use `scripts/openvpn.sh init` to initialize the PKI and base config, then `scripts/openvpn.sh add-client <name>` to generate client profiles. Store `.ovpn` files outside this repository.
