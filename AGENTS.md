# Repository Guidelines

## Project Structure & Module Organization
Stacks are managed by Dockge and live under `stacks/`, one directory per stack. Each stack directory contains:

- `compose.yml` for the stack definition.
- `.env.example` with non-secret placeholders.
- `README.md` with stack-specific setup notes.

Top-level helpers:
- `scripts/` for automation (`render-env.sh`, `validate-ports.sh`, `openvpn.sh`).
- `.gitlab-ci.yml` for CI validation.
- `README.md` for repo-wide guidance and the port plan.

## Build, Test, and Development Commands
There is no build step. Common commands:

- `scripts/render-env.sh`: copy `.env.example` to `.env` for all stacks.
- `scripts/validate-ports.sh`: check for forbidden or duplicate host ports.
- `scripts/openvpn.sh`: initialize OpenVPN and generate client configs.
- `docker compose -f stacks/<stack>/compose.yml config`: validate a single compose file.
- `docker compose up -d` (from a stack directory): start a stack locally.

## Coding Style & Naming Conventions
- Use 2-space indentation for YAML.
- Keep stack names and directories in lowercase kebab-case (example: `stacks/05-gitlab/`).
- Use explicit image tags (no `latest`).
- Use `CHANGE_ME_*` placeholders in `.env.example` and keep `.env` untracked.

## Testing Guidelines
CI runs port validation and `docker compose config` for each stack. Add any new checks to `scripts/` and wire them into `.gitlab-ci.yml`.

## Commit & Pull Request Guidelines
Use short, imperative commit messages. Include a scope when helpful (example: `stacks: add service`). For pull requests, include a summary, list of changes, and note any config or port updates.

## Security & Configuration Tips
Do not commit secrets, tokens, or keys. Bind management UIs to `WG_BIND_IP` and document any public ports. Keep DNS and UI access private unless explicitly required.
