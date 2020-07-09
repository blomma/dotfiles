source ~/.config/fish/color.fish

### DEFAULTS
set -x LC_ALL en_US.UTF-8
set -x EDITOR "nvim"
set -x VISUAL "$EDITOR"
set -x MAILDIR $HOME/.mail

set -x fish_user_paths $HOME/go/bin $HOME/opt/bin $HOME/.fzf/bin $HOME/.local/bin /home/linuxbrew/.linuxbrew/bin $HOME/Library/Python/3.7/bin $HOME/.dotnet/tools

if status --is-interactive
    ### Abbreviations
    abbr --add --global tma tmux attach -d -t
    type -q rbenv; and source (rbenv init -|psub)
end

### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
