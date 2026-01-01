#!/bin/sh
set -eu

force=0
if [ "${1-}" = "--force" ]; then
  force=1
  shift
fi

if [ "$#" -gt 0 ]; then
  dirs="$@"
else
  dirs=$(find stacks -maxdepth 2 -type f -name ".env.example" -print | sed 's#/\.env\.example$##')
fi

for dir in $dirs; do
  src="$dir/.env.example"
  dest="$dir/.env"

  if [ ! -f "$src" ]; then
    echo "skip: $src not found" >&2
    continue
  fi

  if [ -f "$dest" ] && [ "$force" -ne 1 ]; then
    # Merge new keys without overwriting existing values.
    added=0
    while IFS= read -r line; do
      case "$line" in
        ''|\#*) continue ;;
      esac
      case "$line" in
        [A-Za-z_][A-Za-z0-9_]*=*)
          key=${line%%=*}
          if ! grep -q "^${key}=" "$dest"; then
            printf '%s\n' "$line" >> "$dest"
            added=$((added + 1))
          fi
          ;;
      esac
    done < "$src"
    if [ "$added" -gt 0 ]; then
      echo "merged: $dest ($added new keys)"
    else
      echo "up-to-date: $dest"
    fi
    continue
  fi

  cp "$src" "$dest"
  echo "created: $dest"
done
