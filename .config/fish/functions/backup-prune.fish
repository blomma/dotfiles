function backup-prune --description 'Select snapshots to delete, then prune' --argument-names profile
    if test (count $argv) -gt 1
        echo 'Usage: backup-prune [profile]' >&2
        return 2
    end
    if test -z "$profile"
        set profile default
    end

    set -l rp resticprofile --stderr --command-output console --name "$profile"
    set -l snapshots (command $rp snapshots --json --group-by=)
    or return $status

    set -l rows (printf '%s\n' $snapshots | command jq -r '
        def human_size:
            if . == null then "unknown"
            else
                ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"] as $units |
                {bytes: ., unit: 0} |
                until(.bytes < 1024 or .unit == 6;
                      .bytes /= 1024 | .unit += 1) |
                "\((.bytes * 10 | round) / 10) \($units[.unit])"
            end;
        sort_by(.time) | reverse | .[] |
        [.id, .id[0:8], .time,
         (if .summary == null then null
          else .summary.total_bytes_processed // 0 end | human_size),
         .hostname,
         (.paths | join(", ")), ((.tags // []) | join(", "))] | @tsv
    ')
    or return $status
    if not set -q rows[1]
        echo 'No snapshots found.'
        return 0
    end

    # Pad by terminal width, preserving complete timestamps and Unicode text.
    set -l snapshot_ids (string split --fields 1 \t -- $rows)
    set -l short_ids (string split --fields 2 \t -- $rows)
    set -l dates (string pad --right -- (string split --fields 3 \t -- $rows))
    set -l sizes (string pad -- (string split --fields 4 \t -- $rows))
    set -l hosts (string pad --right -- (string split --fields 5 \t -- $rows))
    set -l paths (string pad --right -- (string split --fields 6 \t -- $rows))
    set -l tags (string split --fields 7 \t -- $rows)
    set -l picker_rows
    for index in (seq (count $rows))
        set -a picker_rows (printf '%s\t%s  %s  %s  %s  %s  %s\n' \
            "$snapshot_ids[$index]" "$short_ids[$index]" "$dates[$index]" \
            "$sizes[$index]" "$hosts[$index]" "$paths[$index]" "$tags[$index]")
    end

    set -l chosen (printf '%s\n' $picker_rows | command fzf --multi --no-sort \
        --delimiter '\t' --with-nth '2..' \
        --header 'ID / DATE / SIZE (files) / HOST / PATHS / TAGS — Tab: select; Enter: review; Esc: cancel')
    or return $status
    set -q chosen[1]; or return 0

    set -l ids (string split --fields 1 \t -- $chosen)
    for id in $ids
        string match -qr '^[0-9a-f]{64}$' -- "$id"; or return 1
    end
    set -q ids[1]; or return 1

    echo 'Selected snapshots:'
    string replace -r '^[^\t]+\t' '' -- $chosen
    command $rp forget --json=false --dry-run --prune -- $ids
    or return $status

    read -l -P 'Delete these snapshots and reclaim unused storage? Type delete: ' confirm
    or return $status
    if test "$confirm" != delete
        echo 'Cancelled.'
        return 0
    end

    command $rp forget --json=false --dry-run=false --prune -- $ids
end
