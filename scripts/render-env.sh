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
    echo "exists: $dest (use --force to overwrite)" >&2
    continue
  fi

  cp "$src" "$dest"
  echo "created: $dest"
done
