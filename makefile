all:
	stow --ignore='^zsh' --verbose --restow --target=/home/$(USER)/.config . 
	stow --verbose --restow zsh
delete:
	stow --ignore='^zsh' --verbose --delete --target=/home/$(USER)/.config .
	stow --verbose --delete zsh 
