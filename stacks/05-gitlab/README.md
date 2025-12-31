# GitLab Stack (Omnibus CE)

This stack runs a self-hosted GitLab CE instance using the official omnibus image.

## Setup
1. Copy `.env.example` to `.env` (use `scripts/render-env.sh` from the repo root).
2. Set `WG_BIND_IP` to your WireGuard interface IP so the UI and SSH are not public.
3. Set `GITLAB_EXTERNAL_URL` to the final URL you will use for GitLab.
4. Start the stack from Dockge or via `docker compose up -d`.

## Notes
- First startup can take several minutes; wait for the web UI to become available.
- Web UI is on `${WG_BIND_IP}:${GITLAB_WEB_PORT}` and SSH is on `${WG_BIND_IP}:${GITLAB_SSH_PORT}`.
- The initial admin password is stored inside GitLab's persistent data and is not in this repo.
- TLS is not configured here; add it later if needed.
