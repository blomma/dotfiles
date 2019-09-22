function bright
    set -l bri (brightnessctl -m)
    echo $bri | read -d , -l a b c d e
    echo (string replace '%' '' $d)
end
