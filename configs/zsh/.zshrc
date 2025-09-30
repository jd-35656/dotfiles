# Load modular configurations (order matters)
source "$HOME/.config/.zsh/exports.zsh"      # Environment variables first
source "$HOME/.config/.zsh/options.zsh"      # Shell options
source "$HOME/.config/.zsh/plugins.zsh"      # Plugins and tools
source "$HOME/.config/.zsh/completions.zsh"  # Completion system
source "$HOME/.config/.zsh/keybindings.zsh"  # Key mappings
source "$HOME/.config/.zsh/aliases.zsh"      # Aliases
source "$HOME/.config/.zsh/functions.zsh"    # Functions
source "$HOME/.config/.zsh/utils.zsh"        # Management utilities
