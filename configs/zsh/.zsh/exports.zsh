# Environment variables
export EDITOR="code"
export BROWSER="open"
export PAGER="less"
export LESS="-R"

# PATH configuration
export PATH="$HOME/.local/bin:$PATH"              # pipx, local binaries
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"  # ASDF version manager
export PATH="$HOME/custombin/bin:$PATH"

# History configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE

# Development
export NODE_ENV="development"
export PYTHONDONTWRITEBYTECODE=1

# Colors
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
