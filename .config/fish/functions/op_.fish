function op_ --argument item
    function _signin
        set -l session_key (command op signin blomma --output=raw)
        set -e OP_SESSION_blomma
        set -gx OP_SESSION_blomma $session_key
    end

    function _test_and_achieve --argument r f
        set -l jq_command (string replace -a '#field' $f '.details?.sections[]?.fields[]? | select(.t=="#field").v')
        set -l result (echo $r | jq -r $jq_command 2>&1)

        if string length -q $result
            echo $result
        else
            set -l jq_command (string replace -a '#field' $f '.details?.fields[]? | select(.designation=="#field").value')
            set -l result (echo $r | jq -r $jq_command 2>&1)
            echo $result
        end
    end

    set result (command op get item $item 2>&1)
    if string match -ir 'session expired|not currently signed in' $result 2>&1 >/dev/null
        _signin
        set result (command op get item $item 2>&1)
    end

    # Nuke the item from the arguments passed
    set -e argv[1]
    set -l fields $argv

    for field in $fields
        _test_and_achieve $result $field
    end
end
