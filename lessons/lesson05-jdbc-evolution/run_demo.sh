#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

project_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$project_dir"
mvn -q package dependency:copy-dependencies
  java -Dfile.encoding=UTF-8 -cp 'target/classes:target/dependency/*' edu.ynu.p1.v04.TeacherDemo
