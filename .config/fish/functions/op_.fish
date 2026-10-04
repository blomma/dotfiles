function op_ --description 'Read 1Password item fields' --argument-names item
    if test (count $argv) -lt 2
        echo 'Usage: op_ <item> <field> [field ...]' >&2
        return 2
    end

    # Let the CLI handle authentication, including desktop app integration.
    # Read JSON once so field values retain their quotes, commas, and newlines.
    set -l item_json (command op item get --reveal --format json -- "$item")
    or return $status

    for field in $argv[2..-1]
        printf '%s\n' $item_json | command jq --raw-output --exit-status --arg field "$field" \
            '.fields[] | select(.label == $field) | .value'
        or return $status
    end
end
