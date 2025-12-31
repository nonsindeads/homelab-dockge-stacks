# WireGuard Stack

This stack provides a WireGuard VPN endpoint for secure access to internal services.

## Setup
1. Copy `.env.example` to `.env` (use `scripts/render-env.sh` from the repo root).
2. Set `WIREGUARD_SERVER_URL`, `WIREGUARD_PORT`, and `WIREGUARD_SUBNET`.
3. Start the stack from Dockge or via `docker compose up -d`.

## Notes
- Requires `NET_ADMIN` and `SYS_MODULE` capabilities and IP forwarding sysctls.
- Configuration is stored in the `wireguard_config` named volume.
- No keys are stored in this repository; peer setup happens at runtime.
