#!/usr/bin/env /usr/bin/fish

set -l bg 'output * bg' (random choice $HOME/.dotfiles/wallpaper/**.*) 'fill'
/usr/local/bin/swaymsg $bg
