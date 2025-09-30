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

# Commands to uninstall packages
declare -A FUNCTIONS=(
  [vscode-extensions]="uninstall_vscode_extensions"
  [brew-leaves]="uninstall_brew_leaves"
  [brew-casks]="uninstall_brew_casks"
  [asdf-plugins]="uninstall_asdf_plugins"
  [pipx-packages]="uninstall_pipx_packages"
  [gh-extensions]="uninstall_gh_extensions"
)

# Uninstall functions for each target
uninstall_vscode_extensions() {
  echo "🔹 Uninstalling all Visual Studio Code extensions..."
  local local installed_extensions=$(code --list-extensions | sort)
  if [[ -f "${DIRS[vscode-extensions]}/vscode-extensions.txt" ]]; then
    for extension in $(cat "${DIRS[vscode-extensions]}/vscode-extensions.txt"); do
      if echo "$installed_extensions" | grep -q "$extension"; then
        echo "  Uninstalling $extension"
        code --uninstall-extension "$extension" || true
        continue
      fi

      echo "    $extension not installed"
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[vscode-extensions]}/vscode-extensions.txt${NC}"
    overall_success=false
  fi
}

uninstall_brew_leaves() {
  echo "🔹 Uninstalling all Brew leaves..."
  brew update || true
  local installed_leaves=$(brew leaves | sort)
  if [[ -f "${DIRS[brew-leaves]}/brew-leaves.txt" ]]; then
    for formula in $(cat "${DIRS[brew-leaves]}/brew-leaves.txt"); do
      if echo "$installed_leaves" | grep -q "$formula"; then
        echo "  Uninstalling $formula"
        brew uninstall --force "$formula" || true
        continue
      fi
      echo "    $formula not installed"
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[brew-leaves]}/brew-leaves.txt${NC}"
    overall_success=false
  fi
}

uninstall_brew_casks() {
  echo "🔹 Uninstalling all Brew casks..."
  brew update || true
  local installed_casks=$(brew list --cask | sort)
  if [[ -f "${DIRS[brew-casks]}/brew-casks.txt" ]]; then
    for cask in $(cat "${DIRS[brew-casks]}/brew-casks.txt"); do
      if echo "$installed_casks" | grep -q "$cask"; then
        echo "  Uninstalling $cask"
        brew uninstall --cask --force "$cask" || true
        continue
      fi
      echo "    $cask not installed"
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[brew-casks]}/brew-casks.txt${NC}"
    overall_success=false
  fi
}

uninstall_asdf_plugins() {
  echo "🔹 Uninstalling all asdf plugins and versions..."
  local installed_plugins=$(asdf plugin list | sort)
  if [[ -f "${DIRS[asdf-plugins]}/asdf-plugins.txt" ]]; then
    while read -r plugin; do
      plugin_name=$(echo "$plugin" | awk '{print $1}')
      if echo "$installed_plugins" | grep -q "$plugin_name"; then
        versions=$(asdf list "$plugin" 2>/dev/null || true)
        while read -r version; do
          version=$(echo "$version" | sed -e 's/^[* ]*//' -e 's/[[:space:]]*$//')
          [[ -z "$version" ]] && continue
          echo "  Removing $plugin version $version"
          asdf uninstall "$plugin" "$version" || true
        done <<< "$versions"
        echo "  Removing plugin $plugin"
        asdf plugin remove "$plugin" || true
        continue
      fi
      echo "    $plugin_name not installed"
    done < "${DIRS[asdf-plugins]}/asdf-plugins.txt"
  else
    echo -e "${RED}❌ File not found: ${DIRS[asdf-plugins]}/asdf-plugins.txt${NC}"
    overall_success=false
  fi
}

uninstall_pipx_packages() {
  echo "🔹 Uninstalling all pipx packages..."
  local installed_packages=$(pipx list --short | awk '{print $1}' | sort)
  if [[ -f "${DIRS[pipx-packages]}/pipx-packages.txt" ]]; then
    for package in $(cat "${DIRS[pipx-packages]}/pipx-packages.txt"); do
    if echo "$installed_packages" | grep -q "$package"; then
        echo "  Uninstalling $package"
        pipx uninstall "$package" || true
        continue
      fi
      echo "    $package not installed"
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[pipx-packages]}/pipx-packages.txt${NC}"
    overall_success=false
  fi
}

uninstall_gh_extensions() {
  echo "🔹 Uninstalling GitHub extensions..."
  local installed_extensions=$(gh extension list | tail -n +1 | awk '{print $3}' | sort | sort)
  if [[ -f "${DIRS[gh-extensions]}/gh-extensions.txt" ]]; then
    for extension in $(cat "${DIRS[gh-extensions]}/gh-extensions.txt"); do
      if echo "$installed_extensions" | grep -q "$extension"; then
        echo "  Uninstalling $extension"
        gh extension remove "$extension" || true
        continue
      fi

      echo "    $extension not installed"
    done
  else
    echo -e "${RED}❌ File not found: ${DIRS[gh-extensions]}/gh-extensions.txt${NC}"
    overall_success=false
  fi
}

print_usage() {
  echo -e "${CYAN}Usage:${NC} $0 [target ...]\n"
  echo -e "Uninstall lists of installed packages/extensions for various tools.\n"
  echo -e "${CYAN}Available targets:${NC}"
  for target in "${!DIRS[@]}"; do
    echo -e "  ${YELLOW}$target${NC}"
  done
  echo -e "\nIf no targets are specified, all targets will be uninstalled.\n"
  echo -e "${CYAN}Options:${NC}"
  echo -e "  -h, --help    Show this help message and exit\n"
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  $0                   Uninstall all targets"
  echo -e "  $0 vscode-extensions  Uninstall only vscode extensions\n"
}

print_usage_if_unknown() {
  local target=$1
  if [[ -z "${DIRS[$target]:-}" ]]; then
    echo -e "${RED}❌ Unknown target: $target${NC}"
    print_usage
    exit 1
  fi
}

# Generic uninstall function that calls target-specific functions
uninstall() {
  local name=$1
  local function_name=${FUNCTIONS[$name]}

  echo -e "🔹 Uninstalling ${YELLOW}$name${NC} ..."

  if $function_name; then
    echo -e "  ${GREEN}✅ Uninstallation successful${NC}\n"
  else
    echo -e "  ${RED}❌ Uninstallation failed for $name${NC}\n"
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

# If no help flag is provided, print the starting uninstallation message
echo -e "📦 Starting uninstallation...\n"

# Main script logic
if [[ $# -eq 0 ]]; then
  # Uninstall all targets
  for target in "${!DIRS[@]}"; do
    uninstall "$target"
  done
else
  # Uninstall only specified targets
  for target in "$@"; do
    print_usage_if_unknown "$target"
    uninstall "$target"
  done
fi

# Final overall status message
if $overall_success; then
  echo -e "${GREEN}✅ Uninstallation completed successfully.${NC}"
else
  echo -e "${RED}❌ Uninstallation completed with errors.${NC}"
fi
