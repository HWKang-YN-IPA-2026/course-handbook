#!/usr/bin/env bash
set -euo pipefail
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

project_dir="$(cd "$(dirname "$0")" && pwd)"
build_dir="${TMPDIR:-/tmp}/lesson06-reliability-demo"
mkdir -p "$build_dir"
javac -encoding UTF-8 -d "$build_dir" "$project_dir/examples/ReliabilitySecurityDemo.java"
java -Dfile.encoding=UTF-8 -cp "$build_dir" ReliabilitySecurityDemo
echo 'RG-01 PASS: exception, resource release and injection contrast demonstrated'
