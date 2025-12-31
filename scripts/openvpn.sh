#!/bin/sh
set -eu

STACK_DIR="stacks/15-openvpn"
COMPOSE_FILE="$STACK_DIR/compose.yml"
ENV_FILE="$STACK_DIR/.env"

usage() {
  cat <<USAGE
Usage:
  scripts/openvpn.sh init [--force]
  scripts/openvpn.sh add-client <name> [--out /absolute/path/client.ovpn]

Notes:
  - Run scripts/render-env.sh first and edit $ENV_FILE.
  - Client configs contain secrets; store them outside this repository.
USAGE
}

compose() {
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
}

require_env() {
  if [ ! -f "$ENV_FILE" ]; then
    echo "error: missing $ENV_FILE (run scripts/render-env.sh)" >&2
    exit 1
  fi
}

ensure_initialized() {
  if ! compose run --rm openvpn test -f /etc/openvpn/ovpn_env.sh >/dev/null 2>&1; then
    echo "error: OpenVPN is not initialized (run: scripts/openvpn.sh init)" >&2
    exit 1
  fi
}

cmd_init() {
  force=0
  if [ "${1-}" = "--force" ]; then
    force=1
    shift
  fi

  require_env

  if compose run --rm openvpn test -f /etc/openvpn/ovpn_env.sh >/dev/null 2>&1; then
    if [ "$force" -ne 1 ]; then
      echo "error: OpenVPN already initialized (use --force to reinit)" >&2
      exit 1
    fi
  fi

  set -a
  . "$ENV_FILE"
  set +a

  if [ -z "${OPENVPN_REMOTE_HOST:-}" ] || [ -z "${OPENVPN_PORT:-}" ] || [ -z "${OPENVPN_DNS:-}" ] || [ -z "${OPENVPN_SUBNET:-}" ]; then
    echo "error: OPENVPN_REMOTE_HOST, OPENVPN_PORT, OPENVPN_DNS, and OPENVPN_SUBNET must be set" >&2
    exit 1
  fi

  compose run --rm openvpn ovpn_genconfig \
    -u "udp://${OPENVPN_REMOTE_HOST}:${OPENVPN_PORT}" \
    -d "${OPENVPN_DNS}" \
    -s "${OPENVPN_SUBNET}" \
    -p "redirect-gateway def1"

  compose run --rm openvpn ovpn_initpki
}

cmd_add_client() {
  name="${1-}"
  out=""

  if [ -z "$name" ]; then
    usage
    exit 1
  fi

  if [ "${2-}" = "--out" ]; then
    out="${3-}"
    if [ -z "$out" ]; then
      echo "error: --out requires an absolute path" >&2
      exit 1
    fi
    case "$out" in
      /*) : ;;
      *)
        echo "error: --out requires an absolute path" >&2
        exit 1
        ;;
    esac
  fi

  require_env
  ensure_initialized

  compose run --rm openvpn easyrsa build-client-full "$name" nopass

  if [ -n "$out" ]; then
    compose run --rm openvpn ovpn_getclient "$name" > "$out"
    echo "wrote: $out"
  else
    compose run --rm openvpn ovpn_getclient "$name"
  fi
}

case "${1-}" in
  init)
    shift
    cmd_init "$@"
    ;;
  add-client)
    shift
    cmd_add_client "$@"
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
