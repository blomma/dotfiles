function op
    if command op list users ^| string match -ir 'You are not currently signed in. Please run `op signin --help` for instructions|\(ERROR\)  401: Authentication required\.' > /dev/null
        set -l session_key (command op signin blomma --output=raw)

        # When called python this needs to be done before setting it again
        set -e OP_SESSION_blomma

        set -Ux OP_SESSION_blomma $session_key
    end

    command op $argv
end

