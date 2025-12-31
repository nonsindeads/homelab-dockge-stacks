# Dockge Stack

This stack runs Dockge to manage the other stacks in this repository.

## Setup
1. Copy `.env.example` to `.env` (use `scripts/render-env.sh` from the repo root).
2. Set `WG_BIND_IP` to the WireGuard interface IP you want to bind the UI to.
3. Set `DOCKGE_STACKS_HOST_DIR` to the absolute host path of the repo `stacks/` directory.
4. Start the stack from Dockge or via `docker compose up -d`.

## Notes
- UI is exposed on `${WG_BIND_IP}:${DOCKGE_UI_PORT}` (container port 5001).
- The Docker socket is mounted so Dockge can manage stacks.
- Data persists in the `dockge_data` named volume.
