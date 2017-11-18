set fish_greeting "くコ:彡 welcome to fish"

source ~/.config/fish/aliases.fish
source ~/.config/fish/color.fish

not set -gq __hostname; and set -g __hostname (hostname|cut -d . -f 1|tr '[:upper:]' '[:lower:]')

### DEFAULTS
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"
set -gx GOPATH ~/.go

test -e ~/.config/fish/config.d/$__hostname.fish; and source ~/.config/fish/config.d/$__hostname.fish

### PATH ###
test -d $HOME/.go/bin; and set -gx PATH $HOME/.go/bin $PATH
test -d $HOME/.bin; and set -gx PATH $HOME/.bin $PATH
