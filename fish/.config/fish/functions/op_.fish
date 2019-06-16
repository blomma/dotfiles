function op_ --argument item field
    set -l jq_command (string replace -a '#field' $field '.details?.sections[0].fields[] | select(.t=="#field").v')
    op get item $item | jq -r $jq_command
end
