set -g PATH $HOME/go/bin $HOME/opt/bin $HOME/.local/bin $PATH

if status --is-interactive
    ### Abbreviations
    # abbr --add --global tma tmux attach -d -t
    type -q rbenv; and source (rbenv init -|psub)
end

