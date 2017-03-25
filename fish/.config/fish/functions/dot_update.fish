function git_clone --argument-names prompt path clone_url
	set_color $fish_color_cwd
	echo $prompt
	set_color normal
	git clone $clone_url $path
	echo -e "\n"
end

function git_pull --argument-names prompt path
	set_color $fish_color_cwd
	echo $prompt
	set_color normal

	if not git_is_dirty $path
		git -C $path pull
	else
		echo "Not updating, state is dirty"
	end

	echo -e "\n"
end

function dot_update
	if test -f ~/.dot
		cat ~/.dot | while read foo;
			switch $foo
				case xcode
					set prompt 'Updating xcode'
					set path ~/.xcode

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/xcode-dotfiles.git
					else
						git_pull $prompt $path
					end

					if not test -e ~/Library/Developer/Xcode/UserData/KeyBindings
						ln -sf ~/.xcode/KeyBindings ~/Library/Developer/Xcode/UserData/KeyBindings
					end

					if not test -e ~/Library/Developer/Xcode/UserData/FontAndColorThemes
						ln -sf ~/.xcode/FontAndColorThemes ~/Library/Developer/Xcode/UserData/FontAndColorThemes
					end

					if not test -e ~/Library/Developer/Xcode/Templates
						ln -sf ~/.xcode/Templates ~/Library/Developer/Xcode/Templates
					end
				case vim
					set prompt 'Updating vim'
					set path ~/.vim

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/vim-dotfiles.git
					else
						git_pull $prompt $path
					end

					if not test -e ~/.vimrc
						ln -sf ~/.vim/vimrc ~/.vimrc
					end

				case git
					set prompt 'Updating git'
					set path ~/.git

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/git-dotfiles.git
					else
						git_pull $prompt $path
					end

					if not test -e ~/.gitconfig
						cp ~/.git/gitconfig.local ~/.gitconfig
						set system (uname|tr '[:upper:]' '[:lower:]')

						switch $system
							case darwin
								git config --global credential.helper osxkeychain
							case linux
								git config --global credential.helper cache
						end
					end

				case atom
					set prompt 'Updating atom'
					set path ~/.atom

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/atom-dotfiles.git
					else
						git_pull $prompt $path
					end

				case tmux
					set prompt 'Updating tmux'
					set path ~/.tmux

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/tmux-dotfiles.git
					else
						git_pull $prompt $path
					end

					if not test -e ~/.tmux.conf
						ln -sf ~/.tmux/tmux.conf ~/.tmux.conf
					end

				case fish
					set prompt 'Updating fish'
					set path ~/.config/fish

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/fish-shell-dotfiles.git
					else
						git_pull $prompt $path
					end

				case ssh
					set prompt 'Updating ssh'
					set path ~/.ssh

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/ssh-dotfiles.git
					else
						git_pull $prompt $path
					end

				case textmate
					set prompt 'Updating textmate'
					set path ~/.textmate

					if not test -d $path
						git_clone $prompt $path https://github.com/blomma/textmate-dotfiles.git
					else
						git_pull $prompt $path
					end

					if not test -e ~/.tm_properties
						ln -sf ~/.textmate/tm_properties ~/.tm_properties
					end
				end
			end
	end
end
