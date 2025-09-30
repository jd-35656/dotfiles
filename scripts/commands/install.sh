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

# Commands to install packages
declare -A INSTALL_FUNCTIONS=(
  [vscode-extensions]="install_vscode_extensions"
  [brew-leaves]="install_brew_leaves"
  [brew-casks]="install_brew_casks"
  [asdf-plugins]="install_asdf_plugins"
  [pipx-packages]="install_pipx_packages"
)

# Install functions for each target
install_vscode_extensions() {
  echo "🔹 Installing Visual Studio Code extensions..."
  local installed_extensions=$(code --list-extensions | sort)
  if [[ -f "${DIRS[vscode-extensions]}/vscode-extensions.txt" ]]; then
    for extension in $(cat "${DIRS[vscode-extensions]}/vscode-extensions.txt"); do
      if echo "$installed_extensions" | grep -q "$extension"; then
        echo "    $extension already installed"
        continue
      fi

      code --install-extension "$extension" || true
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[vscode-extensions]}/vscode-extensions.txt${NC}"
    overall_success=false
  fi
}

install_brew_leaves() {
  echo "🔹 Installing Brew leaves..."
  brew update || true
  local installed_leaves=$(brew leaves | sort)
  if [[ -f "${DIRS[brew-leaves]}/brew-leaves.txt" ]]; then
    for formula in $(cat "${DIRS[brew-leaves]}/brew-leaves.txt"); do
      if echo "$installed_leaves" | grep -q "$formula"; then
        echo "    $formula already installed"
        continue
      fi
      echo "  Installing $formula"
      brew install "$formula" || true
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[brew-leaves]}/brew-leaves.txt${NC}"
    overall_success=false
  fi
}

install_brew_casks() {
  echo "🔹 Installing Brew casks..."
  brew update || true
  local installed_casks=$(brew list --cask | sort)
  if [[ -f "${DIRS[brew-casks]}/brew-casks.txt" ]]; then
    for cask in $(cat "${DIRS[brew-casks]}/brew-casks.txt"); do
      if echo "$installed_casks" | grep -q "$cask"; then
        echo "    $cask already installed"
        continue
      fi
      echo "  Installing $cask"
      brew install --cask "$cask" || true
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[brew-casks]}/brew-casks.txt${NC}"
    overall_success=false
  fi
}

install_asdf_plugins() {
  echo "🔹 Installing asdf plugins..."
  local installed_plugins=$(asdf plugin list | sort)
  if [[ -f "${DIRS[asdf-plugins]}/asdf-plugins.txt" ]]; then
    while read -r plugin; do
      plugin_name=$(echo "$plugin" | awk '{print $1}')
      if echo "$installed_plugins" | grep -q "$plugin_name"; then
        echo "    $plugin_name already installed"
        continue
      fi
      echo "  Installing plugin $plugin_name"
      asdf plugin add "$plugin_name" || true
    done < "${DIRS[asdf-plugins]}/asdf-plugins.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[asdf-plugins]}/asdf-plugins.txt${NC}"
    overall_success=false
  fi
}

install_pipx_packages() {
  echo "🔹 Installing pipx packages..."
  local installed_packages=$(pipx list --short | awk '{print $1}' | sort)
  if [[ -f "${DIRS[pipx-packages]}/pipx-packages.txt" ]]; then
    for package in $(cat "${DIRS[pipx-packages]}/pipx-packages.txt"); do
    if echo "$installed_packages" | grep -q "$package"; then
        echo "    $package already installed"
        continue
      fi
      echo "  Installing $package"
      pipx install "$package" || true
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[pipx-packages]}/pipx-packages.txt${NC}"
    overall_success=false
  fi
}

print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 [target ...]\n"
  echo -e "Install lists of installed packages/extensions for various tools.\n"
  echo -e "${CYAN}Available targets:${NC}"
  for target in "${!DIRS[@]}"; do
    echo -e "  ${YELLOW}$target${NC}"
  done
  echo -e "\nIf no targets are specified, all targets will be installed.\n"
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit\n"
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  $0                   Install all targets"
  echo -e "  $0 vscode-extensions  Install only vscode extensions\n"
}

print_usage_if_unknown() {
  local target=$1
  if [[ -z "${DIRS[$target]:-}" ]]; then
    echo -e "${RED}❌ Unknown target: $target${NC}"
    print_usage
    exit 1
  fi
}

# Generic install function that calls target-specific functions
process() {
  local name=$1
  local function_name=$2

  echo -e "🔹 Installing ${YELLOW}$name${NC} ..."

  if $function_name; then
    echo -e "  ${GREEN}✅ Install successful${NC}\n"
  else
    echo -e "  ${RED}❌ Install failed for $name${NC}\n"
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

# Main script logic
echo -e "📦 Starting installation...\n"

# If no arguments are passed, install all targets
if [[ $# -eq 0 ]]; then
  for target in "${!DIRS[@]}"; do
    process "$target" "${INSTALL_FUNCTIONS[$target]}"
  done
else
  # Install only specified targets
  for target in "$@"; do
    print_usage_if_unknown "$target"
    process "$target" "${INSTALL_FUNCTIONS[$target]}"
  done
fi

# Final overall status message
if $overall_success; then
  echo -e "${GREEN}✅ Installation completed successfully.${NC}"
else
  echo -e "${RED}❌ Installation completed with errors.${NC}"
fi
