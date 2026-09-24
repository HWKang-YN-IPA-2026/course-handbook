#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export PGHOST="${PGHOST:-localhost}"

db_name="${1:-lesson06_acceptance}"
project_dir="$(cd "$(dirname "$0")" && pwd)"
lesson5_dir="$(cd "$project_dir/../lesson05-jdbc-evolution" && pwd)"
"$lesson5_dir/prepare_database.sh" "$db_name"
echo "发布候选数据库 $db_name 已从空基线重建到 v0.4。"
