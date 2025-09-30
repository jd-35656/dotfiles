#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Map targets to tracked file paths
declare -A FILE_PATHS=(
  [vscode-extensions]="configs/vscode/vscode-extensions.txt"
  [brew-leaves]="configs/brew/brew-leaves.txt"
  [brew-casks]="configs/brew/brew-casks.txt"
  [asdf-plugins]="configs/asdf/asdf-plugins.txt"
  [pipx-packages]="configs/pipx/pipx-packages.txt"
  [gh-extensions]="configs/gh/gh-extensions.txt"
)

print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 [target ...]\n"
  echo -e "Show contents of tracked package/extension lists.\n"
  echo -e "${CYAN}Available targets:${NC}"
  for target in "${!FILE_PATHS[@]}"; do
    echo -e "  ${YELLOW}$target${NC}"
  done
  echo -e "\nIf no targets are specified, all targets will be listed.\n"
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit\n"
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  $0                    List all tracked entries"
  echo -e "  $0 gh-extensions      List only GitHub CLI extensions\n"
}

print_usage_if_unknown() {
  local target=$1
  if [[ -z "${FILE_PATHS[$target]:-}" ]]; then
    echo -e "${RED}❌ Unknown target: $target${NC}"
    print_usage
    exit 1
  fi
}

list_tracked() {
  local name=$1
  local file=${FILE_PATHS[$name]}

  echo -e "📄 Listing ${YELLOW}$name${NC} from ${CYAN}$file${NC} ..."

  if [[ -f "$file" ]]; then
    if [[ -s "$file" ]]; then
      cat "$file" | sed 's/^/  - /'
      echo -e "  ${GREEN}✅ Listed successfully${NC}\n"
    else
      echo -e "  ${YELLOW}⚠️  File is empty${NC}\n"
    fi
  else
    echo -e "  ${RED}❌ File not found${NC}\n"
  fi
}

# Handle help flag
for arg in "$@"; do
  if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
    print_usage
    exit 0
  fi
done

echo -e "📂 Showing tracked entries...\n"

# If no arguments, list all
if [[ $# -eq 0 ]]; then
  for target in "${!FILE_PATHS[@]}"; do
    list_tracked "$target"
  done
else
  for target in "$@"; do
    print_usage_if_unknown "$target"
    list_tracked "$target"
  done
fi

echo -e "${GREEN}✅ Done listing tracked entries.${NC}"
