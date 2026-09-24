#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

project_dir="$(cd "$(dirname "$0")" && pwd)"
db_name="${1:-lesson05_demo}"
cd "$project_dir"

mvn -q package dependency:copy-dependencies

echo "[Course0-A] classpath中没有pgJDBC，预期失败"
set +e
java -Dfile.encoding=UTF-8 -cp target/classes edu.ynu.p1.v04.Course0DriverCheck
course0_status=$?
set -e
if [ "$course0_status" -eq 0 ]; then
  echo "UNEXPECTED: Course0-A should fail" >&2
  exit 1
fi
echo "EXPECTED_FAIL exit=$course0_status"

echo "[Course0-B] classpath加入target/dependency/*，预期加载驱动"
java -Dfile.encoding=UTF-8 -cp 'target/classes:target/dependency/*' edu.ynu.p1.v04.Course0DriverCheck

echo "[Course1] 使用PreparedStatement执行多表连接"
DB_URL="jdbc:postgresql://localhost:5432/$db_name" \
  java -Dfile.encoding=UTF-8 -cp 'target/classes:target/dependency/*' edu.ynu.p1.v04.Course1JoinQuery S002
