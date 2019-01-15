set fish_greeting "くコ:彡 welcome to fish"

source ~/.config/fish/aliases.fish
source ~/.config/fish/color.fish

### DEFAULTS
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"

### PATH ###
set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/.bin $PATH
set -gx PATH $HOME/opt/bin $PATH
set -gx PATH $HOME/.pyenv/bin $PATH
set -gx PATH $HOME/.rbenv/bin $PATH

### Ruby (rbenv) ###
if command -s rbenv >/dev/null
	status --is-interactive; and source (rbenv init -|psub)
end

### Python (pyenv) ###
if command -s pyenv >/dev/null
	status --is-interactive; and source (pyenv init -|psub)
end

### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end