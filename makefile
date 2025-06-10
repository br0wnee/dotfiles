all:
	stow --ignore='^zsh' --verbose --restow --target=/home/br0wnie/.config . 
	stow --verbose --restow zsh
delete:
	stow --ignore='^zsh' --verbose --delete --target=/home/br0wnie/.config .
	stow --verbose --delete zsh 
