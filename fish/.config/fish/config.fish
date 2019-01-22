set fish_greeting "くコ:彡 welcome to fish"

source ~/.config/fish/color.fish

### DEFAULTS
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"

if status --is-interactive
    ### Abbreviations
    abbr --add --global tma tmux attach -d -t


    ### Ruby (rbenv) ###
    if command -s rbenv >/dev/null
        rbenv init - | source
    end

    ### Python (pyenv) ###
    if command -s pyenv >/dev/null
        pyenv init - | source
    end

    if test -e ~/.fzf/shell/key-bindings.fish
        source ~/.fzf/shell/key-bindings.fish
    end
end

### PATH ###
# set -U fish_user_paths $HOME/go/bin $HOME/.bin $HOME/opt/bin $HOME/.pyenv/bin $HOME/.rbenv/bin /home/linuxbrew/.linuxbrew/bin

set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/.bin $PATH
set -gx PATH $HOME/opt/bin $PATH
set -gx PATH $HOME/.pyenv/bin $PATH
set -gx PATH $HOME/.rbenv/bin $PATH
set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH
set -gx PATH $HOME/.fzf/bin $PATH

### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
