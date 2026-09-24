#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export PGHOST="${PGHOST:-localhost}"

db_name="${1:-lesson05_demo}"
project_dir="$(cd "$(dirname "$0")" && pwd)"
lesson4_dir="$(cd "$project_dir/../lesson04-sql-data-operations" && pwd)"

psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$project_dir/database/00_before_base_reset.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$lesson4_dir/00_v02_schema.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$project_dir/database/00_after_base_reset.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$lesson4_dir/00_v02_seed.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$lesson4_dir/01_sharing_migration.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$lesson4_dir/02_sharing_seed.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$project_dir/database/01_history_migration.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$project_dir/database/02_history_seed.sql"
psql -X -v ON_ERROR_STOP=1 -d "$db_name" -f "$project_dir/database/03_v04_acceptance.sql"
echo "数据库 $db_name 已重建为选课系统 v0.4。"
