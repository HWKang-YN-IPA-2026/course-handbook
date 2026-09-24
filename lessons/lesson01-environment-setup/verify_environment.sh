#!/usr/bin/env bash
set -u

failed=0
for command in java javac git psql pg_isready; do
  if command -v "$command" >/dev/null 2>&1; then
    printf 'FOUND: %s -> %s\n' "$command" "$(command -v "$command")"
  else
    printf 'MISSING: %s\n' "$command"
    failed=1
  fi
done

if command -v java >/dev/null 2>&1; then java -version; fi
if command -v git >/dev/null 2>&1; then git --version; fi
if command -v psql >/dev/null 2>&1; then psql --version; fi
if command -v pg_isready >/dev/null 2>&1; then pg_isready -h "${PGHOST:-localhost}" -p "${PGPORT:-5432}" || failed=1; fi

if [[ "$failed" -eq 0 ]]; then
  echo 'ENVIRONMENT READY'
else
  echo 'ENVIRONMENT INCOMPLETE'
  exit 1
fi
