function sif
    grep --line-buffered --color=never -r $argv * | fzf
end

