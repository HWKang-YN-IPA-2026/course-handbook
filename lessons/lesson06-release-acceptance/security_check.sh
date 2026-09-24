#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")" && pwd)"
lesson5_dir="$(cd "$project_dir/../lesson05-jdbc-evolution" && pwd)"

if [ -f "$lesson5_dir/config.properties" ]; then
  echo 'FAIL: config.properties must not be submitted'
  exit 1
fi
if find "$lesson5_dir" -path '*/target' -prune -o -type f ! -name 'config.example.properties' -print0 | xargs -0 grep -En 'gho_[A-Za-z0-9]+|db\.password=[^[:space:]]+'; then
  echo 'FAIL: possible credential found'
  exit 1
fi
if ! grep -q 'config.properties' "$lesson5_dir/.gitignore"; then
  echo 'FAIL: config.properties is not ignored'
  exit 1
fi
if ! grep -q 'prepareStatement' "$lesson5_dir/src/main/java/edu/ynu/p1/v04/EnrollmentService.java"; then
  echo 'FAIL: PreparedStatement evidence missing'
  exit 1
fi
echo 'RG-02 PASS: credentials, generated files and parameterized SQL checked'
echo 'RELEASE SECURITY CHECK PASSED'
