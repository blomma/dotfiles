#source ~/.config/fish/color.fish

### DEFAULTS
set -x LC_ALL en_US.UTF-8
set -x EDITOR "nvim"
set -x VISUAL "$EDITOR"
set -x MAILDIR $HOME/.mail

### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
