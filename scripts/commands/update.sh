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

# Commands to upgrade packages/extensions per target
declare -A UPGRADE_FUNCTIONS=(
  [vscode-extensions]="upgrade_vscode_extensions"
  [brew-leaves]="upgrade_brew_leaves"
  [brew-casks]="upgrade_brew_casks"
  [asdf-plugins]="upgrade_asdf_plugins"
  [pipx-packages]="upgrade_pipx_packages"
  [gh-extensions]="upgrade_gh_extensions"
)

upgrade_vscode_extensions() {
  echo "🔹 Upgrading Visual Studio Code extensions..."
  if [[ -f "${DIRS[vscode-extensions]}/vscode-extensions.txt" ]]; then
    while read -r extension; do
      echo "  Upgrading $extension"
      code --install-extension "$extension" --force || true
    done < "${DIRS[vscode-extensions]}/vscode-extensions.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[vscode-extensions]}/vscode-extensions.txt${NC}"
    overall_success=false
  fi
}

upgrade_brew_leaves() {
  echo "🔹 Upgrading Brew leaves..."
  brew update || true
  if [[ -f "${DIRS[brew-leaves]}/brew-leaves.txt" ]]; then
    while read -r formula; do
      echo "  Upgrading $formula"
      brew upgrade "$formula" || true
    done < "${DIRS[brew-leaves]}/brew-leaves.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[brew-leaves]}/brew-leaves.txt${NC}"
    overall_success=false
  fi
}

upgrade_brew_casks() {
  echo "🔹 Upgrading Brew casks..."
  brew update || true
  if [[ -f "${DIRS[brew-casks]}/brew-casks.txt" ]]; then
    while read -r cask; do
      echo "  Upgrading $cask"
      brew upgrade --cask "$cask" || true
    done < "${DIRS[brew-casks]}/brew-casks.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[brew-casks]}/brew-casks.txt${NC}"
    overall_success=false
  fi
}

upgrade_asdf_plugins() {
  echo "🔹 Upgrading asdf plugins..."
  if [[ -f "${DIRS[asdf-plugins]}/asdf-plugins.txt" ]]; then
    while read -r plugin; do
      plugin_name=$(echo "$plugin" | awk '{print $1}')
      echo "  Upgrading plugin $plugin_name"
      # Upgrade plugin itself
      asdf plugin update "$plugin_name" || true

      # Upgrade to latest version
      asdf install "$plugin_name" latest || true
      asdf set -u "$plugin_name" latest || true
    done < "${DIRS[asdf-plugins]}/asdf-plugins.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[asdf-plugins]}/asdf-plugins.txt${NC}"
    overall_success=false
  fi
}

upgrade_pipx_packages() {
  echo "🔹 Upgrading pipx packages..."
  if [[ -f "${DIRS[pipx-packages]}/pipx-packages.txt" ]]; then
    while read -r package; do
      echo "  Upgrading $package"
      pipx upgrade "$package" || true
    done < "${DIRS[pipx-packages]}/pipx-packages.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[pipx-packages]}/pipx-packages.txt${NC}"
    overall_success=false
  fi
}

upgrade_gh_extensions() {
  echo "🔹 Upgrading GitHub extensions..."
  if [[ -f "${DIRS[gh-extensions]}/gh-extensions.txt" ]]; then
    while read -r extension; do
      echo "  Upgrading $extension"
      gh extension upgrade "$extension" || true
    done < "${DIRS[gh-extensions]}/gh-extensions.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[gh-extensions]}/gh-extensions.txt${NC}"
    overall_success=false
  fi
}

print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 [target ...]\n"
  echo -e "Upgrade lists of installed packages/extensions for various tools.\n"
  echo -e "${CYAN}Available targets:${NC}"
  for target in "${!DIRS[@]}"; do
    echo -e "  ${YELLOW}$target${NC}"
  done
  echo -e "\nIf no targets are specified, all targets will be upgraded.\n"
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit\n"
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  $0                   Upgrade all targets"
  echo -e "  $0 vscode-extensions  Upgrade only vscode extensions\n"
}

print_usage_if_unknown() {
  local target=$1
  if [[ -z "${DIRS[$target]:-}" ]]; then
    echo -e "${RED}❌ Unknown target: $target${NC}"
    print_usage
    exit 1
  fi
}

process() {
  local name=$1
  local function_name=$2

  echo -e "🔹 Upgrading ${YELLOW}$name${NC} ..."

  if $function_name; then
    echo -e "  ${GREEN}✅ Upgrade successful${NC}\n"
  else
    echo -e "  ${RED}❌ Upgrade failed for $name${NC}\n"
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

echo -e "📦 Starting upgrade...\n"

if [[ $# -eq 0 ]]; then
  for target in "${!DIRS[@]}"; do
    process "$target" "${UPGRADE_FUNCTIONS[$target]}"
  done
else
  for target in "$@"; do
    print_usage_if_unknown "$target"
    process "$target" "${UPGRADE_FUNCTIONS[$target]}"
  done
fi

if $overall_success; then
  echo -e "${GREEN}✅ Upgrade completed successfully.${NC}"
else
  echo -e "${RED}❌ Upgrade completed with errors.${NC}"
fi
