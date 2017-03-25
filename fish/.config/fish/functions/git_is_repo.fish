function git_is_repo -d "Check if directory is a repository" --argument-names path
	if test -n "$path"
		command git -C $path rev-parse --git-dir >/dev/null ^/dev/null
	else
		command git rev-parse --git-dir >/dev/null ^/dev/null
	end
end
