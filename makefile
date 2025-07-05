all:
	stow --ignore='^zsh|wallpapers' --verbose --restow --target=/home/$(USER)/.config . 
	stow --verbose --restow zsh wallpapers 
delete:
	stow --ignore='^zsh|wallpapers' --verbose --delete --target=/home/$(USER)/.config .
	stow --verbose --delete zsh wallpapers 
