# ABOUTME: Makefile for dotfiles management
# ABOUTME: Provides stow, unstow, and update commands

.PHONY: install stow unstow update help

STOW_TARGET := $(HOME)

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install                           - Run bootstrap script"
	@echo "  make stow PACKAGES='common linux'      - Stow specified packages"
	@echo "  make unstow PACKAGES='common linux'    - Unstow specified packages"
	@echo "  make update                            - Update submodules and nvim plugins"
	@echo ""
	@echo "Available packages:"
	@echo "  common     - Cross-platform (nvim, zsh, alacritty, zellij)"
	@echo "  linux      - Linux-only (dunst, kanata, ranger, neofetch, runit, scripts)"
	@echo "  macos      - macOS-specific (aerospace)"
	@echo "  hyprland   - Hyprland/Wayland (hypr, waybar, wofi, feh)"
	@echo "  dwm        - X11/dwm (picom, xmodmap, .xinitrc)"
	@echo "  framework  - Framework laptop (color-calibration, easyeffects)"
	@echo ""
	@echo "Examples:"
	@echo "  make stow PACKAGES='common linux hyprland framework'  # Framework laptop"
	@echo "  make stow PACKAGES='common linux dwm'                 # Desktop with dwm"
	@echo "  make stow PACKAGES='common macos'                     # macOS"

install:
	@./scripts/install.sh

stow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make stow PACKAGES='common linux')
endif
	stow $(PACKAGES) -t $(STOW_TARGET)

unstow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make unstow PACKAGES='common linux')
endif
	stow -D $(PACKAGES) -t $(STOW_TARGET)

update:
	git submodule update --remote --merge
	nvim --headless "+Lazy! sync" +qa 2>/dev/null || echo "Note: Lazy.nvim sync skipped (not yet migrated)"
