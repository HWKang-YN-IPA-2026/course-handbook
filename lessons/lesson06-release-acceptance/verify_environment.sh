#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export PGHOST="${PGHOST:-localhost}"

for command in psql createdb java mvn; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "MISSING: $command"
    exit 1
  fi
  echo "FOUND: $command -> $(command -v "$command")"
done
pg_isready -h "$PGHOST" -p "${PGPORT:-5432}"
java -version
mvn -version
echo 'ENVIRONMENT READY'
