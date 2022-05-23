fish_add_path /usr/local/share/dotnet/x64/ /opt/homebrew/opt/ruby/bin /opt/homebrew/lib/ruby/gems/3.0.0/bin $HOME/go/bin $HOME/opt/bin $HOME/.local/bin $HOME/.cargo/bin /opt/homebrew/bin /opt/homebrew/opt/node@16/bin

set -x NODE_BINARY /opt/homebrew/opt/node@16/bin/node

if status --is-interactive
    type -q rbenv; and source (rbenv init -|psub)

    set -x STARSHIP_CONFIG $HOME/.config/starship/config.toml

    starship init fish | source
end
