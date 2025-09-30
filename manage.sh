#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to show usage
print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 {subcommand} [options]"
  echo
  echo -e "${CYAN}Available subcommands:${NC}"

  # List all executable scripts in ./scripts/commands without .sh extension
  for script in ./scripts/commands/*.sh; do
    subcmd=$(basename "$script" .sh)
    echo -e "  ${GREEN}$subcmd${NC}"
  done

  echo
  echo "Run '$0 {subcommand} --help' for more information on each subcommand."
}

# Check if at least one argument is provided
if [[ $# -lt 1 ]]; then
  print_usage
  exit 1
fi

# Check for -h or --help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  print_usage
  exit 0
fi

subcommand=$1
shift

# Check if the subcommand script exists and is executable
cmd_script="./scripts/commands/${subcommand}.sh"

if [[ -x "$cmd_script" ]]; then
  "$cmd_script" "$@"
else
  echo -e "${RED}❌ Invalid subcommand: $subcommand${NC}"
  print_usage
  exit 1
fi
