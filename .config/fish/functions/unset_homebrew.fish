function unset_homebrew
	set PATH -gx (string match -v /home/linuxbrew/.linuxbrew/bin $PATH
end
