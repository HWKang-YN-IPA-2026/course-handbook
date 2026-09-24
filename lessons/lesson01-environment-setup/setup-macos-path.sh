#!/usr/bin/env bash
set -euo pipefail

profile_file="${ZDOTDIR:-$HOME}/.zprofile"
start_marker='# >>> 编程能力提升课程环境 >>>'
end_marker='# <<< 编程能力提升课程环境 <<<'

if [[ "$(uname -s)" != 'Darwin' ]]; then
  echo '本脚本仅适用于macOS。' >&2
  exit 1
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  brew_prefix=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  brew_prefix=/usr/local
else
  echo '未找到Homebrew，请先按 https://brew.sh/ 的官方说明安装。' >&2
  exit 1
fi

if grep -Fq "$start_marker" "$profile_file" 2>/dev/null; then
  echo "课程PATH配置已存在：$profile_file"
  exit 0
fi

{
  echo
  echo "$start_marker"
  printf 'eval "$(%s/bin/brew shellenv)"\n' "$brew_prefix"
  echo 'for pg_dir in /opt/homebrew/opt/postgresql@17/bin /opt/homebrew/opt/postgresql@16/bin /opt/homebrew/opt/postgresql@15/bin /usr/local/opt/postgresql@17/bin /usr/local/opt/postgresql@16/bin /usr/local/opt/postgresql@15/bin; do'
  echo '  [[ -d "$pg_dir" ]] && export PATH="$pg_dir:$PATH" && break'
  echo 'done'
  echo "$end_marker"
} >> "$profile_file"

echo "已更新 $profile_file，请执行：exec zsh -l"
