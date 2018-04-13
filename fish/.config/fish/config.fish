set fish_greeting "くコ:彡 welcome to fish"

source ~/.config/fish/aliases.fish
source ~/.config/fish/color.fish

### DEFAULTS
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"

### PATH ###
test -d $HOME/go/bin; and set -gx PATH $HOME/go/bin $PATH
test -d $HOME/.bin; and set -gx PATH $HOME/.bin $PATH
test -d $HOME/opt/bin; and set -gx PATH $HOME/opt/bin $PATH
test -d $HOME/.pyenv/bin; and set -gx PATH $HOME/.pyenv/bin $PATH

### BOBTHEFISH
set -g theme_display_git_ahead_verbose yes
set -g theme_display_cmd_duration no
set -g theme_display_git_dirty_verbose yes

### Ruby (rbenv) ###
if command -s rbenv >/dev/null
	status --is-interactive; and source (rbenv init -|psub)
end

### Python (pyenv) ###
if command -s pyenv >/dev/null
	status --is-interactive; and source (pyenv init -|psub)
end

