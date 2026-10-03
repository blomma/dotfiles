function backup-size --description 'Browse backup sizes with ncdu' --argument-names profile snapshot
    if test -z "$profile"
        set profile default
    end
    
    if test -z "$snapshot"
        set snapshot latest
    end
    
    command resticprofile --stderr --name "$profile" ls "$snapshot" --ncdu | command ncdu -f -
end
