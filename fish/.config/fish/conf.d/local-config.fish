set -l host (echo $hostname | string lower  | string replace ".local" "" | string replace ".lan" "")
set -l LOCAL_CONFIG "$HOME/.config/fish"

# Load custom settings for current hostname
set -l host_specific_file $LOCAL_CONFIG/hosts/$host.fish
if test -f $host_specific_file
    source $host_specific_file
end
