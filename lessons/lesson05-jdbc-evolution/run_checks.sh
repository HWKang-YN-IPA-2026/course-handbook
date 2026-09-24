#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

project_dir="$(cd "$(dirname "$0")" && pwd)"
db_name="${1:-lesson05_demo}"
"$project_dir/prepare_database.sh" "$db_name"
cd "$project_dir"
mvn -q package dependency:copy-dependencies
DB_URL="jdbc:postgresql://localhost:5432/$db_name" \
  java -Dfile.encoding=UTF-8 -cp 'target/classes:target/dependency/*' edu.ynu.p1.v04.IntegrationCheck
