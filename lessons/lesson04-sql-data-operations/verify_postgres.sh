#!/usr/bin/env bash
set -euo pipefail
db_name="${1:-lesson04_demo}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"
for file in 00a_reset_extensions.sql 00_v02_schema.sql 00b_reset_school.sql 00_v02_seed.sql 01_sharing_migration.sql 02_sharing_seed.sql 03_basic_queries.sql 04_insert_constraints.sql 05_update_delete_safety.sql 06_acceptance_checks.sql; do
  psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$file" >/dev/null
done
echo "PASS AC-301 v0.3 migration and backfill"
echo "PASS AC-302 fixed baseline rows"
echo "PASS AC-303 aggregate expectations"
echo "PASS AC-304 insert rollback has no residue"
echo "PASS AC-305 temporary delete is isolated"
echo "PASS AC-306 unsafe update rolled back"
echo "PostgreSQL第04次课v0.3验证完成"
