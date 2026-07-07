fish_add_path $HOME/go/bin $HOME/opt/bin $HOME/.local/bin $HOME/.dotnet/tools /opt/homebrew/bin /opt/homebrew/opt/node@20/bin /opt/homebrew/sbin
fish_add_path /Users/blomma/.opencode/bin

set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/Library/Caches
set -x NODE_BINARY /opt/homebrew/opt/node@20/bin/node
set -x K9SCONFIG $HOME/.config/k9s
set -x HOMEBREW_NO_REQUIRE_TAP_TRUST 1

if status --is-interactive
    set -x STARSHIP_CONFIG $HOME/.config/starship/config.toml

    starship init fish | source

    source "$HOME/.cargo/env.fish" # For fish
end
