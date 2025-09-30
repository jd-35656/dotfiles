# Emacs-style keybindings
bindkey -e

# History navigation
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Editing
bindkey '^[w' kill-region
bindkey '^u' kill-whole-line
bindkey '^k' kill-line

# FZF keybindings
bindkey '^r' fzf-history-widget
bindkey '^t' fzf-file-widget
bindkey '^[c' fzf-cd-widget

# Word navigation
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# Line navigation
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
