WM_TO_IGNORE ?= sway|hyprland
BASE_IGNORE = ^wallpapers
IGNORE_PATTERN = $(BASE_IGNORE)|$(WM_TO_IGNORE)

.PHONY: all delete sway hyprland delete-sway delete-hyprland

all:
	stow --ignore='$(IGNORE_PATTERN)' --verbose --restow --target=/home/$(USER)/.config .
	stow --verbose --restow zsh wallpapers

delete:
	stow --ignore='$(IGNORE_PATTERN)' --verbose --delete --target=/home/$(USER)/.config .
	stow --verbose --delete zsh wallpapers

sway:
	$(MAKE) all WM_TO_IGNORE=hyprland

hyprland:
	$(MAKE) all WM_TO_IGNORE=sway

delete-sway:
	$(MAKE) delete WM_TO_IGNORE=hyprland

delete-hyprland:
	$(MAKE) delete WM_TO_IGNORE=sway
