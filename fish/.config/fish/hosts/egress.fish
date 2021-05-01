fish_add_path $HOME/go/bin $HOME/opt/bin $HOME/.local/bin $HOME/.cargo/bin

if status --is-interactive
    ### Abbreviations
    # abbr --add --global tma tmux attach -d -t
    type -q rbenv; and source (rbenv init -|psub)
end

