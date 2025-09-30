#!/usr/bin/env bash
set -euo pipefail

# Track overall success
overall_success=true

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Backup directories mapped to target names
declare -A DIRS=(
  [vscode-extensions]="configs/vscode"
  [brew-leaves]="configs/brew"
  [brew-casks]="configs/brew"
  [asdf-plugins]="configs/asdf"
  [pipx-packages]="configs/pipx"
  [gh-extensions]="configs/gh"
)

# Commands to get current installed items
declare -A LIST_CMDS=(
  [vscode-extensions]="code --list-extensions | sort"
  [brew-leaves]="brew leaves | sort"
  [brew-casks]="brew list --cask | sort"
  [asdf-plugins]="asdf plugin list | sort"
  [pipx-packages]="pipx list --short | awk '{print \$1}' | sort"
  [gh-extensions]="gh extension list | tail -n +1 | awk '{print \$3}' | sort"
)

print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 [target ...]\n"
  echo -e "Compare currently installed packages/extensions against your tracked files.\n"
  echo -e "${CYAN}Available targets:${NC}"
  for target in "${!DIRS[@]}"; do
    echo -e "  ${YELLOW}$target${NC}"
  done
  echo -e "\nIf no targets are specified, all will be checked.\n"
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit\n"
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  $0                   Check all targets"
  echo -e "  $0 vscode-extensions  Check only VS Code extensions\n"
}

print_usage_if_unknown() {
  local target=$1
  if [[ -z "${DIRS[$target]:-}" ]]; then
    echo -e "${RED}❌ Unknown target: $target${NC}"
    print_usage
    exit 1
  fi
}

compare_state() {
  local name=$1
  local dir=${DIRS[$name]}
  local cmd=${LIST_CMDS[$name]}
  local file="$dir/${name}.txt"

  echo -e "🔍 Checking ${YELLOW}$name${NC} against ${CYAN}${file}${NC}..."

  if [[ ! -f "$file" ]]; then
    echo -e "  ${RED}❌ Backup file not found: $file${NC}\n"
    overall_success=false
    return
  fi

  local tmp_current
  tmp_current=$(mktemp)
  eval "$cmd" > "$tmp_current"

  local missing extra
  missing=$(comm -23 "$file" "$tmp_current")
  extra=$(comm -13 "$file" "$tmp_current")

  if [[ -z "$missing" && -z "$extra" ]]; then
    echo -e "  ${GREEN}✅ Installed list matches tracked list.${NC}\n"
  else
    if [[ -n "$missing" ]]; then
      echo -e "  ${RED}❌ Missing (in tracked file but not installed):${NC}"
      echo "$missing" | sed 's/^/    - /'
    fi
    if [[ -n "$extra" ]]; then
      echo -e "  ${YELLOW}⚠️  Extra (installed but not in tracked file):${NC}"
      echo "$extra" | sed 's/^/    - /'
    fi
    echo
    overall_success=false
  fi

  rm "$tmp_current"
}

# Check for -h or --help flags
for arg in "$@"; do
  if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
    print_usage
    exit 0
  fi
done

# Start audit
echo -e "🕵️  Auditing system against tracked configs...\n"

if [[ $# -eq 0 ]]; then
  for target in "${!DIRS[@]}"; do
    compare_state "$target"
  done
else
  for target in "$@"; do
    print_usage_if_unknown "$target"
    compare_state "$target"
  done
fi

if $overall_success; then
  echo -e "${GREEN}✅ All systems are in sync.${NC}"
else
  echo -e "${RED}❌ Some mismatches found.${NC}"
fi
