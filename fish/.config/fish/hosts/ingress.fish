fish_add_path /opt/homebrew/opt/ruby/bin /opt/homebrew/lib/ruby/gems/3.0.0/bin $HOME/go/bin $HOME/opt/bin $HOME/.local/bin $HOME/.cargo/bin /opt/homebrew/bin /opt/homebrew/opt/node@16/bin

if status --is-interactive
    ### Abbreviations
    # abbr --add --global tma tmux attach -d -t
    type -q rbenv; and source (rbenv init -|psub)
end

set -x STARSHIP_CONFIG $HOME/.config/starship/config.toml
starship init fish | source
