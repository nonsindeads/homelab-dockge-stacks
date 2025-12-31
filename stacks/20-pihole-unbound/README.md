# Pi-hole + Unbound Stack

This stack runs Pi-hole for DNS filtering with Unbound as a local recursive resolver.

## Setup
1. Copy `.env.example` to `.env` (use `scripts/render-env.sh` from the repo root).
2. Set `WG_BIND_IP` to the WireGuard interface IP used for private access.
3. Set `PIHOLE_WEBPASSWORD` and confirm `PIHOLE_UI_PORT`.
4. Start the stack from Dockge or via `docker compose up -d`.

## Notes
- Unbound is internal-only and is not exposed to the host.
- Pi-hole forwards DNS to Unbound at `unbound:5335`.
- DNS ports 53/tcp and 53/udp are bound to `WG_BIND_IP` only.
