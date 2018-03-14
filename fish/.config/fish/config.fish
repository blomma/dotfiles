set fish_greeting "くコ:彡 welcome to fish"

source ~/.config/fish/aliases.fish
source ~/.config/fish/color.fish

### DEFAULTS
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"

### PATH ###
test -d $HOME/.go/bin; and set -gx PATH $HOME/.go/bin $PATH
test -d $HOME/.bin; and set -gx PATH $HOME/.bin $PATH
test -d $HOME/opt/bin; and set -gx PATH $HOME/opt/bin $PATH
