function fish_greeting -d "What's up, fish?"
    echo -n "くコ:彡 "
    set_color $fish_color_autosuggestion
    echo -n (uname -nmsr | string lower | string replace ".local" "")
    echo -n " "
    command -q -s uptime; and uptime
    set_color normal
end
