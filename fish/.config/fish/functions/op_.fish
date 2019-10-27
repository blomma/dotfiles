function op_ --argument item field
    set -l jq_command (string replace -a '#field' $field '.details?.sections[].fields[]? | select(.t=="#field").v')
    set -l result (op get item $item| jq -r $jq_command)

    if string length -q $result
        echo $result
    else
        set -l jq_command (string replace -a '#field' $field '.details?.fields[]? | select(.name=="#field").value')
        set -l result (op get item $item| jq -r $jq_command)
        echo $result
    end
end
