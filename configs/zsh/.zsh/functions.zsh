# Directory utilities
mkcd() { mkdir -p "$1" && cd "$1" }

# Archive extraction
extract() {
  case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted" ;;
  esac
}

# ───────────────────────────────────────────────
# 🚀 Git Utility Functions
# ───────────────────────────────────────────────

# Clone a repo and cd into it
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Clone your own GitHub repo over SSH and cd into it
gcloneme() {
  local user="jd-35656"
  local repo="$1"
  git clone "git@github.com:$user/$repo.git" && cd "$repo"
}

# Set origin to your GitHub repo (initialize Git if needed)
setoriginme() {
  local user="jd-35656"
  local repo="$1"
  local url="git@github.com:$user/$repo.git"

  [ ! -d ".git" ] && git init

  if git remote get-url origin &>/dev/null; then
    local current_url
    current_url=$(git remote get-url origin)
    if [[ "$current_url" != *"$user/"* ]]; then
      git remote set-url origin "$url"
      echo "🔄 Replaced origin with: $url"
    else
      echo "✅ Origin already correct: $current_url"
    fi
  else
    git remote add origin "$url"
    echo "➕ Added origin: $url"
  fi
}

# Commit all with a message
gcommit() {
  git add . && git commit -m "$1"
}

# Commit all with message and push
gpush() {
  git add . && git commit -m "$1" && git push
}

# Clone your GitHub repo and open in VS Code
gcode() {
  local user="jd-35656"
  local repo="$1"
  git clone "git@github.com:$user/$repo.git" && cd "$repo" && code .
}

# Open GitHub repo in browser
gopen() {
  local user="jd-35656"
  local repo="$1"
  open "https://github.com/$user/$repo" 2>/dev/null || xdg-open "https://github.com/$user/$repo"
}

# List all your GitHub repos (requires: gh + jq)
ghmyrepos() {
  gh repo list jd-35656 --limit 100 --source --json name,visibility,updatedAt \
    | jq -r '.[] | "\(.name)\t\(.visibility)\t\(.updatedAt)"' | column -t
}

# Create new private GitHub repo and push current dir
ghcreate() {
  local name="$1"
  gh repo create "jd-35656/$name" --private --source=. --push
}

# Show git status for all repos in current directory
gstatusall() {
  for dir in */.git; do
    repo_dir=$(dirname "$dir")
    echo "📁 $repo_dir"
    (cd "$repo_dir" && git status -s)
    echo
  done
}

# Pretty log
glog() {
  git log --oneline --graph --decorate --all
}

# Clean up merged branches (excluding main/master)
gcleanup() {
  git branch --merged | grep -vE '^\*|main|master' | xargs -r git branch -d
}


# Development utilities
serve() { python3 -m http.server "${1:-8000}" }
ports() { lsof -i -P -n | grep LISTEN }
myip() { curl -s ifconfig.me }

# File search
ff() { find . -type f -name "*$1*" }
fd() { find . -type d -name "*$1*" }


master_updater() {
    # Configuration
    local exit_code=0
    local start_time=$(date +%s)

    # Print header
    echo "════════════════════════════════════════════════════════════"
    echo "🚀 MASTER UPDATE"
    echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "════════════════════════════════════════════════════════════\n"

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # STEP 1: Homebrew
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ STEP 1/5: Homebrew                                      │"
    echo "└─────────────────────────────────────────────────────────┘"

    echo "  → Updating Homebrew repositories..."
    if brew update > /dev/null 2>&1; then
        echo "  ✓ Repositories updated"
    else
        echo "  ✗ Failed to update repositories"
        exit_code=1
    fi

    echo "  → Upgrading packages (including casks)..."
    if brew upgrade --greedy; then
        echo "  ✓ Packages upgraded"
    else
        echo "  ✗ Failed to upgrade packages"
        exit_code=1
    fi

    echo "  → Cleaning up old versions and cache..."
    if brew cleanup --prune=all; then
        echo "  ✓ Cleanup complete"
    else
        echo "  ✗ Cleanup failed"
        exit_code=1
    fi

    echo ""

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # STEP 2: pipx
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ STEP 2/5: pipx Python Applications                      │"
    echo "└─────────────────────────────────────────────────────────┘"

    echo "  → Upgrading all pipx packages..."
    if pipx upgrade-all; then
        echo "  ✓ All pipx packages upgraded"
    else
        echo "  ✗ Failed to upgrade pipx packages"
        exit_code=1
    fi

    echo ""

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # STEP 3: Mac App Store
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ STEP 3/5: Mac App Store                                 │"
    echo "└─────────────────────────────────────────────────────────┘"

    echo "  → Checking for App Store updates..."
    local mas_outdated=$(mas outdated 2>/dev/null)

    if [ -z "$mas_outdated" ]; then
        echo "  ✓ All App Store apps are up to date"
    else
        echo "  → Found updates for:"
        echo "$mas_outdated" | sed 's/^/    /'
        echo "  → Installing updates..."

        if mas upgrade; then
            echo "  ✓ App Store updates installed"
        else
            echo "  ✗ Failed to install App Store updates"
            exit_code=1
        fi
    fi

    echo ""

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # STEP 4: asdf Plugin Repositories
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ STEP 4/5: asdf Plugin Repositories                      │"
    echo "└─────────────────────────────────────────────────────────┘"

    echo "  → Updating all asdf plugin repositories..."
    if asdf plugin update --all > /dev/null 2>&1; then
        echo "  ✓ Plugin repositories updated"
    else
        echo "  ✗ Failed to update plugin repositories"
        exit_code=1
    fi

    echo ""

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # STEP 5: asdf Package Updates
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ STEP 5/5: asdf Packages (Install Latest & Cleanup)      │"
    echo "└─────────────────────────────────────────────────────────┘"

    # Get list of installed plugins
    local plugins=$(asdf plugin list 2>/dev/null)

    if [ -z "$plugins" ]; then
        echo "  ℹ  No asdf plugins installed"
    else
        local total_plugins=$(echo "$plugins" | wc -l | xargs)
        local current_plugin=0
        local updated_count=0
        local skipped_count=0
        local failed_count=0

        echo "  → Processing $total_plugins plugin(s)...\n"

        echo "$plugins" | while read -r plugin; do
            # Skip empty lines
            [ -z "$plugin" ] && continue

            ((current_plugin++))

            echo "  [$current_plugin/$total_plugins] Processing: $plugin"

            # Get latest version
            echo "    → Fetching latest version..."
            local latest=$(asdf latest "$plugin" 2>/dev/null)

            if [ -z "$latest" ]; then
                echo "    ✗ Could not determine latest version"
                ((failed_count++))
                echo ""
                continue
            fi

            echo "    → Latest available: $latest"

            # Get current version from asdf list (line with asterisk)
            # Output: " *1.25.4" or "  1.25.3" or " *1.25.4"
            local current=$(asdf list "$plugin" 2>/dev/null | grep '\*' | sed 's/\*//g' | xargs)

            if [ -n "$current" ]; then
                echo "    → Current version: $current"
            else
                current=""
                echo "    → Current version: (none set)"
            fi

            # Check if already on latest
            if [ -n "$current" ] && [ "$current" = "$latest" ]; then
                echo "    ✓ Already on latest version"
                ((skipped_count++))
                echo ""
                continue
            fi

            # Install latest version
            echo "    → Installing $latest..."
            if asdf install "$plugin" "$latest" > /dev/null 2>&1; then
                echo "    ✓ Installation successful"
            else
                echo "    ✗ Installation failed"
                ((failed_count++))
                echo ""
                continue
            fi

            # Set as global default
            echo "    → Setting $latest as global default..."
            if asdf set -u "$plugin" "$latest" > /dev/null 2>&1; then
                echo "    ✓ Global version set"
            else
                echo "    ✗ Failed to set global version"
                ((failed_count++))
                echo ""
                continue
            fi

            # Remove old versions
            echo "    → Removing old versions..."
            local old_versions=$(asdf list "$plugin" 2>/dev/null | grep -v "$latest")

            if [ -z "$old_versions" ]; then
                echo "    ℹ  No old versions to remove"
            else
                local removed_count=0
                echo "$old_versions" | while read -r old_version; do
                    # Trim whitespace and remove asterisks
                    old_version=$(echo "$old_version" | xargs | sed 's/\*//g')

                    # Skip empty lines and the latest version
                    [ -z "$old_version" ] && continue
                    [ "$old_version" = "$latest" ] && continue

                    if asdf uninstall "$plugin" "$old_version" > /dev/null 2>&1; then
                        echo "      ✓ Removed $old_version"
                        ((removed_count++))
                    else
                        echo "      ✗ Failed to remove $old_version"
                    fi
                done

                echo "    ✓ Cleanup complete"
            fi

            echo "    ✓ $plugin successfully updated to $latest"
            ((updated_count++))
            echo ""
        done
    fi

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # Final Summary
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    echo "════════════════════════════════════════════════════════════"
    echo "📊 SUMMARY"
    echo "────────────────────────────────────────────────────────────"
    echo "  Duration: ${duration}s"

    if [ $exit_code -eq 0 ]; then
        echo "  Status: ✅ All updates completed successfully"
    else
        echo "  Status: ⚠️  Completed with some errors"
    fi

    echo "  Finished: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "════════════════════════════════════════════════════════════"

    return $exit_code
}
