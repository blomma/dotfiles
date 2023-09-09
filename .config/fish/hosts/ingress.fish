fish_add_path $HOME/go/bin $HOME/opt/bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.dotnet/tools /opt/homebrew/bin /opt/homebrew/opt/node@18/bin
fish_add_path /opt/homebrew/sbin $HOME/Library/Python/3.10/bin

set -x XDG_CONFIG_HOME $HOME/.config
set -x NODE_BINARY /opt/homebrew/opt/node@18/bin/node
set -x K9SCONFIG $HOME/.config/k9s

if status --is-interactive
    type -q rbenv; and source (rbenv init -|psub)

    set -x STARSHIP_CONFIG $HOME/.config/starship/config.toml

    starship init fish | source
end
