#!/bin/sh
set -eu

files=$(find stacks -type f -name compose.yml -print)

if [ -z "$files" ]; then
  echo "error: no compose.yml files found under stacks/" >&2
  exit 1
fi

forbidden_re='8010|8085|3000'
if grep -nE "$forbidden_re" $files; then
  echo "error: forbidden ports (8010, 8085, 3000) found in compose files" >&2
  exit 1
fi

awk '
function add(port, proto, file, line) {
  if (port ~ /^[0-9]+$/) {
    key = port "/" proto
    if (key in seen) {
      dup[key] = dup[key] " " file ":" line
    } else {
      seen[key] = file ":" line
    }
  }
}
{
  line = $0
  sub(/#.*/, "", line)
  if (line !~ /-/ || line !~ /:/) next
  gsub(/^[ \t-]+/, "", line)
  gsub(/[ \t"\047]/, "", line)
  if (line == "") next

  proto = "tcp"
  if (line ~ /\/udp$/) proto = "udp"
  if (line ~ /\/tcp$/) proto = "tcp"
  sub(/\/(tcp|udp)$/, "", line)

  n = split(line, parts, ":")
  if (n == 2) {
    host = parts[1]
  } else if (n >= 3) {
    host = parts[2]
  } else {
    next
  }

  if (host ~ /\$/) next
  add(host, proto, FILENAME, NR)
}
END {
  for (k in dup) {
    print "error: duplicate host port", k, "in", seen[k], "and", dup[k] > "/dev/stderr"
    err = 1
  }
  if (err) exit 2
}
' $files
