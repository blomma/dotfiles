source ~/.config/fish/color.fish

### DEFAULTS
set -x LC_ALL en_US.UTF-8
set -x EDITOR nvim
set -x VISUAL "$EDITOR"
set -x MAILDIR $HOME/.mail

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
