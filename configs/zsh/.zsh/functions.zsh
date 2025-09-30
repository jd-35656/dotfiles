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
