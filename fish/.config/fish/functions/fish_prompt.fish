function _git_is_dirty
    echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _git_ahead_verbose -S -d 'Print a more verbose ahead/behind state for the current branch'
    set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
    or return

    set -l behind (count (for arg in $commits; echo $arg; end | command grep '^<'))
    set -l ahead (count (for arg in $commits; echo $arg; end | command grep -v '^<'))

    set -l git_ahead_glyph \u21E1
    set -l git_behind_glyph \u21E3

    switch "$ahead $behind"
        case '' # no upstream
        case '0 0' # equal to upstream
            echo "·"
        case '* 0' # ahead of upstream
            echo "·$git_ahead_glyph$ahead"
        case '0 *' # behind upstream
            echo "·$git_behind_glyph$behind"
        case '*' # diverged from upstream
            echo "·$git_ahead_glyph$ahead$git_behind_glyph$behind"
    end
end

function fish_prompt
    set -l last_status $status

    set -l normal (set_color normal)

    set -l blue (set_color blue)
    set -l cwd $blue(echo $PWD | string replace (echo $HOME) "~")

    # Output the prompt, left to right
    echo -n -s $cwd $normal

    # Show git branch and status
    set -l git_branch (command git symbolic-ref --short HEAD ^/dev/null)
    if test $status -eq 0
        if [ (_git_is_dirty) ]
            set -l yellow (set_color yellow)
            set -l cyan (set_color cyan)
            set git_info '(' $yellow $git_branch $cyan"±" $normal ')'
        else
            set -l green (set_color green)
            set git_info '(' $green $git_branch $normal ')'
        end

        set -l git_ahead (_git_ahead_verbose)
        echo -n -s ' ' $git_ahead ' ' $git_info $normal
    end

    set -l prompt_color $normal
    if test $last_status -ne 0
        set -l red (set_color red)
        set prompt_color $red
    end

    # Terminate with a nice prompt char
    echo -e -n -s $prompt_color ' ⟩⟩ ' $normal
end
