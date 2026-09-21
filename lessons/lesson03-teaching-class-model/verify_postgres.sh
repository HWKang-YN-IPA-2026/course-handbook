#!/usr/bin/env bash
set -euo pipefail

# 只在专用course_demo数据库中运行；01_schema.sql会重建五张演示表。
cd "$(dirname "$0")"
db=course_demo
command -v psql >/dev/null || { echo '需要安装psql并启动PostgreSQL' >&2; exit 2; }
psql -X -v ON_ERROR_STOP=1 -d "$db" -f 00_v01_counterexample.sql
psql -X -v ON_ERROR_STOP=1 -d "$db" -f 01_schema.sql
psql -X -v ON_ERROR_STOP=1 -d "$db" -f 02_seed.sql
psql -X -v ON_ERROR_STOP=1 -d "$db" -f 03_checks.sql

count=$(psql -X -At -v ON_ERROR_STOP=1 -d "$db" -c "SELECT COUNT(*) FROM enrollment WHERE student_id='S001' AND course_id='MATH101' AND term_id='2026-FALL';")
[[ "$count" == 1 ]] || { echo "AC-001失败：预期1条，实际$count条" >&2; exit 1; }
echo 'PASS AC-001 normal count = 1'

expect_error() {
  local file=$1 state=$2 label=$3 output
  if output=$(psql -X -v ON_ERROR_STOP=1 -v VERBOSITY=verbose -d "$db" -f "$file" 2>&1); then
    echo "FAIL $label: 意外成功" >&2; exit 1
  fi
  if [[ "$output" != *"$state"* ]]; then
    echo "FAIL $label: 未得到预期SQLSTATE $state" >&2
    echo "$output" >&2; exit 1
  fi
  echo "PASS $label SQLSTATE $state"
}

expect_error 04_negative_same_class.sql 23505 AC-004
expect_error 05_negative_cross_class.sql 23505 AC-005
expect_error 06_negative_fk.sql 23503 AC-006
psql -X -v ON_ERROR_STOP=1 -d "$db" -f 07_query_plan.sql
echo 'PostgreSQL课堂演示验证完成；AC-002/003留给服务层验收。'
