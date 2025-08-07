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

# Git utilities
gclone() { git clone "$1" && cd "$(basename "$1" .git)" }
gcommit() { git add . && git commit -m "$1" }
gpush() { git add . && git commit -m "$1" && git push }

# Development utilities
serve() { python3 -m http.server "${1:-8000}" }
ports() { lsof -i -P -n | grep LISTEN }
myip() { curl -s ifconfig.me }

# File search
ff() { find . -type f -name "*$1*" }
fd() { find . -type d -name "*$1*" }