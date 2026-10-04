set -l private_config "$__fish_config_dir/private/config.fish"
if test -f "$private_config"
    source "$private_config"
end
