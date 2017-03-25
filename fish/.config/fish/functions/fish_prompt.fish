# Fish git prompt
set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_showupstream "informative,name"

# Colors
set __fish_git_prompt_color_branch blue
set __fish_git_prompt_color_branch_detached red
set __fish_git_prompt_color_dirtystate red
set __fish_git_prompt_color_stagedstate green
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_cleanstate green
set __fish_git_prompt_color_flags blue

# Status Chars
set __fish_git_prompt_char_cleanstate        ''
set __fish_git_prompt_char_dirtystate        '*'
set __fish_git_prompt_char_invalidstate      '#'
set __fish_git_prompt_char_stagedstate       '+'
set __fish_git_prompt_char_stashstate        '$'
set __fish_git_prompt_char_stateseparator    '|'
set __fish_git_prompt_char_untrackedfiles    '!'
set __fish_git_prompt_char_upstream_ahead    '>'
set __fish_git_prompt_char_upstream_behind   '<'
set __fish_git_prompt_char_upstream_diverged '<>'
set __fish_git_prompt_char_upstream_equal    '='
set __fish_git_prompt_char_upstream_prefix   ' '

function fish_prompt
	echo -n -s (set_color 555555) "[$__hostname]" ' ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt) (set_color $fish_color_cwd) '> ' (set_color normal)
end
