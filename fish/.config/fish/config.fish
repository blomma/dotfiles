set fish_greeting "くコ:彡 welcome to fish"

source ~/.config/fish/color.fish

### DEFAULTS
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"

### Abbreviations
if status --is-interactive
    abbr --add --global tma tmux attach -d -t
end

### PATH ###
set -U fish_user_paths $fish_user_paths $HOME/go/bin
set -U fish_user_paths $fish_user_paths $HOME/.bin
set -U fish_user_paths $fish_user_paths $HOME/opt/bin
set -U fish_user_paths $fish_user_paths $HOME/.pyenv/bin
set -U fish_user_paths $fish_user_paths $HOME/.rbenv/bin
set -U fish_user_paths $fish_user_paths /home/linuxbrew/.linuxbrew/bin

### Ruby (rbenv) ###
if command -s rbenv >/dev/null
    status --is-interactive
    and source (rbenv init -|psub)
end

### Python (pyenv) ###
if command -s pyenv >/dev/null
    status --is-interactive
    and source (pyenv init -|psub)
end

### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
