#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export PGHOST="${PGHOST:-localhost}"

db_name="${1:-lesson06_acceptance}"
project_dir="$(cd "$(dirname "$0")" && pwd)"
lesson5_dir="$(cd "$project_dir/../lesson05-jdbc-evolution" && pwd)"

"$project_dir/prepare_release_database.sh" "$db_name"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$project_dir/database/acceptance_checks.sql"

cd "$lesson5_dir"
mvn -q package dependency:copy-dependencies
DB_URL="jdbc:postgresql://localhost:5432/$db_name" \
  java -Dfile.encoding=UTF-8 -cp 'target/classes:target/dependency/*' edu.ynu.p1.v04.IntegrationCheck

echo 'AC-11 PASS: JDBC transaction and concurrent last-seat checks passed'
"$project_dir/run_reliability_demo.sh"
"$project_dir/security_check.sh"
echo 'LESSON-06 RELEASE ACCEPTANCE PASSED (AC-01..AC-11)'
