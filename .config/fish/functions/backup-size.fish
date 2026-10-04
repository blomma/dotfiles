function backup-size --description 'Browse backup sizes with ncdu' --argument-names profile snapshot
    if test -z "$profile"
        set profile default
    end

    if test -z "$snapshot"
        set snapshot latest
    end

    command resticprofile --stderr --name "$profile" ls "$snapshot" --ncdu | command ncdu -f -
    set -l pipeline_status $pipestatus
    if test $pipeline_status[2] -ne 0
        return $pipeline_status[2]
    end
    return $pipeline_status[1]
end
