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
)

# Commands to generate backup data for each target
declare -A LIST_CMDS=(
  [vscode-extensions]="code --list-extensions | sort"
  [brew-leaves]="brew leaves | sort"
  [brew-casks]="brew list --cask | sort"
  [asdf-plugins]="asdf plugin list | sort"
  [pipx-packages]="pipx list --short | awk '{print \$1}' | sort"
)

print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 [target ...]\n"
  echo -e "Back up lists of installed packages/extensions for various tools.\n"
  echo -e "${CYAN}Available targets:${NC}"
  for target in "${!DIRS[@]}"; do
    echo -e "  ${YELLOW}$target${NC}"
  done
  echo -e "\nIf no targets are specified, all targets will be backed up.\n"
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit\n"
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  $0                   Back up all targets"
  echo -e "  $0 vscode-extensions  Back up only vscode extensions\n"
}

print_usage_if_unknown() {
  local target=$1
  if [[ -z "${DIRS[$target]:-}" ]]; then
    echo -e "${RED}❌ Unknown target: $target${NC}"
    print_usage
    exit 1
  fi
}

backup() {
  local name=$1
  local dir=${DIRS[$name]}
  local cmd=${LIST_CMDS[$name]}

  mkdir -p "$dir"
  echo -e "🔹 Backing up ${YELLOW}$name${NC} to ${CYAN}$dir/${name}.txt${NC} ..."

  if eval "$cmd" > "$dir/${name}.txt"; then
    echo -e "  ${GREEN}✅ Backup successful${NC}\n"
  else
    echo -e "  ${RED}❌ Backup failed for $name${NC}\n"
    overall_success=false
  fi
}

# Check for -h or --help flags before proceeding
for arg in "$@"; do
  if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
    print_usage
    exit 0
  fi
done

# If no help flag is provided, print the starting backup message
echo -e "📦 Starting backup...\n"

# Main script logic
if [[ $# -eq 0 ]]; then
  # Backup all targets
  for target in "${!DIRS[@]}"; do
    backup "$target"
  done
else
  # Backup only specified targets
  for target in "$@"; do
    print_usage_if_unknown "$target"
    backup "$target"
  done
fi

# Final overall status message
if $overall_success; then
  echo -e "${GREEN}✅ Backup completed successfully.${NC}"
else
  echo -e "${RED}❌ Backup completed with errors.${NC}"
fi
