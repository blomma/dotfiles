function ssh-t --argument-names host session
    command ssh -t $host "tmux new -A -s $session"
end

