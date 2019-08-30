function op
    if command op list users ^| string match -ir "(401: Authentication required|You are not currently signed in)" > /dev/null
        set -l session_key (command op signin blomma --output=raw)
        set -gx OP_SESSION_blomma $session_key
    end

    # At this point we should have a valid session going
    command op $argv
end

