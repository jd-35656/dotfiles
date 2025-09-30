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

# Define the JSON file and configs directory
JSON_FILE="symlink.json"
CONFIGS_DIR="configs"
DOTFILES_ROOT="$(pwd)"

# Function to show usage and available symlinks
print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 {link|unlink|show} [package1 package2 ...]"
  echo
  echo "  link     - create symlinks for specified packages (all if none specified)"
  echo "  unlink   - remove symlinks for specified packages (all if none specified)"
  echo "  show     - show all current symlinks"
  echo
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit"
  exit 0
}

# Show all current symlinks
show_symlinks() {
  echo -e "${CYAN}Available symlinks:${NC}"
  jq -r 'keys[]' "$JSON_FILE" | while read -r package; do
    echo -e "  ${YELLOW}$package${NC}:"
    jq -r --arg pkg "$package" '.[$pkg] | to_entries[] | "\(.key) -> \(.value)"' "$JSON_FILE"
  done
}

# Check for help flags before proceeding
for arg in "$@"; do
  if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
    print_usage
  fi
done

# Check if the script was run with any arguments
if [[ $# -lt 1 ]]; then
  print_usage
fi

# Action to be performed (link, unlink, show)
ACTION=$1
shift

# Get the list of packages to process
if [[ $# -gt 0 ]]; then
  packages=("$@")
else
  # If no packages are specified, use all available packages
  mapfile -t packages < <(jq -r 'keys[]' "$JSON_FILE")
fi

# Function to create symlinks for a package
link_package() {
  local package=$1
  echo -e "🔗 Linking package: ${YELLOW}$package${NC}"

  jq -r --arg pkg "$package" '.[$pkg] | to_entries[] | "\(.key) \(.value)"' "$JSON_FILE" | while read -r rel_path target_path; do
    src="$DOTFILES_ROOT/$CONFIGS_DIR/$package/$rel_path"
    dest="${target_path/#\~/$HOME}"  # expand ~ to $HOME

    mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" || -f "$dest" || -d "$dest" ]]; then
      echo -e "🗑 Removing existing: ${RED}$dest${NC}"
      rm -rf "$dest"
    fi

    echo -e "🔗 Creating symlink: ${CYAN}$dest → $src${NC}"
    ln -s "$src" "$dest"
  done
}

# Function to remove symlinks for a package
unlink_package() {
  local package=$1
  echo -e "🧹 Unlinking package: ${YELLOW}$package${NC}"

  jq -r --arg pkg "$package" '.[$pkg] | to_entries[] | .value' "$JSON_FILE" | while read -r target_path; do
    dest="${target_path/#\~/$HOME}"

    if [[ -L "$dest" ]]; then
      echo -e "❌ Removing symlink: ${RED}$dest${NC}"
      rm "$dest"
    else
      echo -e "⚠️  Skipping (not a symlink): ${CYAN}$dest${NC}"
    fi
  done
}

# Execute the action (link, unlink, show)
case "$ACTION" in
  link)   for package in "${packages[@]}"; do link_package "$package"; done ;;
  unlink) for package in "${packages[@]}"; do unlink_package "$package"; done ;;
  show)   show_symlinks ;;
  *)
    echo -e "${RED}❌ Invalid action: $ACTION${NC}"
    print_usage
    ;;
esac

# Final overall status message
echo -e "${GREEN}✅ Symlink process completed.${NC}"
