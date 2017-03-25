function git_is_dirty -d "Check if there are changes to tracked files" --argument-names path
	if command git -C $path diff --no-ext-diff --quiet --exit-code ^ /dev/null
		return 1
	end
end
