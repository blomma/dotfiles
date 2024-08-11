function ssh-t --argument-names host session
    if string match -iq $host five
        ssh -t $host "~/.local/bin/tmux new -A -s $session"
    else
        command ssh -t $host "tmux new -A -s $session"
    end
end
