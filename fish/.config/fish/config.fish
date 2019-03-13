source ~/.config/fish/color.fish

### DEFAULTS
set -x LC_ALL en_US.UTF-8
set -x EDITOR "vim"
set -x VISUAL "$EDITOR"
set -x MAILDIR $HOME/.mail

### PATH ###
# set -U fish_user_paths $HOME/go/bin $HOME/.bin $HOME/opt/bin $HOME/.pyenv/bin $HOME/.rbenv/bin /home/linuxbrew/.linuxbrew/bin

set -x PATH $HOME/go/bin $PATH
set -x PATH $HOME/.bin $PATH
set -x PATH $HOME/opt/bin $PATH
set -x PATH $HOME/.pyenv/bin $PATH
set -x PATH $HOME/.rbenv/bin $PATH
set -x PATH /home/linuxbrew/.linuxbrew/bin $PATH
set -x PATH $HOME/.fzf/bin $PATH

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


### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
