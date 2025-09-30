#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to show usage
print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 {symlink|install|uninstall|backup} [subcommand] [options]"
  echo
  echo -e "${CYAN}Subcommands:${NC}"
  echo -e "  ${GREEN}symlink${NC}   - Manage symlinks (link, unlink, show)"
  echo -e "  ${GREEN}install${NC}   - Manage installation tasks (install packages, etc.)"
  echo -e "  ${GREEN}uninstall${NC} - Manage uninstall tasks (uninstall packages, etc.)"
  echo -e "  ${GREEN}backup${NC}    - Manage backups of installed packages, extensions, etc."
  echo
  echo "Run '$0 {symlink|install|uninstall|backup} --help' for more information on each subcommand."
}

# Check if at least one argument is provided
if [[ $# -lt 1 ]]; then
  print_usage
  exit 1
fi

# Check for -h or --help flags and print the usage
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  print_usage
  exit 0
fi

# Subcommand logic
case "$1" in
  symlink)
    # Shift and forward arguments to symlink.sh
    shift
    ./scripts/commands/symlink.sh "$@"
    ;;
  install)
    # Shift and forward arguments to install.sh
    shift
    ./scripts/commands/install.sh "$@"
    ;;
  uninstall)
    # Shift and forward arguments to uninstall.sh
    shift
    ./scripts/commands/uninstall.sh "$@"
    ;;
  backup)
    # Shift and forward arguments to backup.sh
    shift
    ./scripts/commands/backup.sh "$@"
    ;;
  *)
    echo -e "${RED}❌ Invalid subcommand: $1${NC}"
    print_usage
    exit 1
    ;;
esac
