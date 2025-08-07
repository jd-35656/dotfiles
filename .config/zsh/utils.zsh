# Zsh management utilities

# Reload zsh configuration
reload() {
  echo "Reloading zsh configuration..."
  source ~/.zshrc
  echo "✅ Configuration reloaded"
}

# Edit zsh modules
zshconfig() {
  local module="${1:-main}"
  case $module in
    main|zshrc) $EDITOR ~/.zshrc ;;
    exports|env) $EDITOR ~/.config/zsh/exports.zsh ;;
    options|opts) $EDITOR ~/.config/zsh/options.zsh ;;
    plugins) $EDITOR ~/.config/zsh/plugins.zsh ;;
    completions|comp) $EDITOR ~/.config/zsh/completions.zsh ;;
    keybindings|keys) $EDITOR ~/.config/zsh/keybindings.zsh ;;
    aliases) $EDITOR ~/.config/zsh/aliases.zsh ;;
    functions|funcs) $EDITOR ~/.config/zsh/functions.zsh ;;
    utils) $EDITOR ~/.config/zsh/utils.zsh ;;
    *) echo "Available modules: main, exports, options, plugins, completions, keybindings, aliases, functions, utils" ;;
  esac
}

# Benchmark zsh startup time
zshbench() {
  for i in {1..5}; do
    time zsh -i -c exit
  done
}

# Show loaded modules
zshmodules() {
  echo "Loaded zsh modules:"
  echo "├── exports.zsh"
  echo "├── options.zsh" 
  echo "├── plugins.zsh"
  echo "├── completions.zsh"
  echo "├── keybindings.zsh"
  echo "├── aliases.zsh"
  echo "├── functions.zsh"
  echo "└── utils.zsh"
}