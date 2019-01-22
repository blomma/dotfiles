function _git_branch_name
    echo (command git symbolic-ref --short HEAD ^/dev/null)
end

function _git_is_dirty
    echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
    set -l last_status $status

    set -l normal (set_color normal)

    set -l blue (set_color blue)
    set -l cwd $blue(echo $PWD | string replace (echo $HOME) "~")

    # Output the prompt, left to right
    echo -e ''

    echo -n -s $cwd $normal

    # Show git branch and status
    set -l git_branch (_git_branch_name)
    if test $status -eq 0
        if [ (_git_is_dirty) ]
            set -l yellow (set_color yellow)
            set git_info '(' $yellow $git_branch "±" $normal ')'
        else
            set -l green (set_color green)
            set git_info '(' $green $git_branch $normal ')'
        end
        echo -n -s ' · ' $git_info $normal
    end

    set -l prompt_color $normal
    if test $last_status -ne 0
        set -l red (set_color red)
        set prompt_color $red
    end

    # Terminate with a nice prompt char
    echo -e ''
    echo -e -n -s $prompt_color '⟩ ' $normal
end
