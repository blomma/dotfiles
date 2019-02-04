function op_github
    op get item qi6qiihln5d3zp732on2jiowv4 | jq -r '.details?.sections[1].fields[] | select(.t=="personal access token").v'
end

