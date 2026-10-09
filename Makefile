# ABOUTME: Makefile for dotfiles management
# ABOUTME: Provides stow, restow, unstow, and update commands

.PHONY: install stow restow unstow update help

STOW_TARGET := $(HOME)

# pi's agent dir has to exist before common is stowed: otherwise stow folds
# ~/.config/pi into a link to this repo, and pi then writes its credentials,
# sessions and install into the worktree (see "pi coding agent" in README.md)
PI_AGENT_DIR := $(STOW_TARGET)/.config/pi/agent
make_pi_dir = $(if $(filter common,$(PACKAGES)),@mkdir -p $(PI_AGENT_DIR))

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install                           - Run bootstrap script"
	@echo "  make stow PACKAGES='common linux'      - Stow specified packages"
	@echo "  make restow PACKAGES='common linux'    - Restow after a pull (also prunes links to deleted files)"
	@echo "  make unstow PACKAGES='common linux'    - Unstow specified packages"
	@echo "  make update                            - Update submodules and nvim plugins"
	@echo ""
	@echo "Available packages:"
	@echo "  common     - Cross-platform (nvim, zsh, alacritty, zellij, pi)"
	@echo "  linux      - Linux-only (dunst, kanata, ranger, neofetch, runit, scripts)"
	@echo "  macos      - macOS-specific (aerospace)"
	@echo "  hyprland   - Hyprland/Wayland (hypr, waybar, wofi, feh)"
	@echo "  dwm        - X11/dwm (picom, xmodmap, .xinitrc)"
	@echo "  framework  - Framework laptop host (hypr host.lua, waybar, wluma, color-calibration, easyeffects)"
	@echo "  cosmo      - Desktop host (hypr host.lua, waybar, NVIDIA env)"
	@echo ""
	@echo "Examples:"
	@echo "  make stow PACKAGES='common linux hyprland framework'  # Framework laptop"
	@echo "  make stow PACKAGES='common linux hyprland cosmo'      # cosmo desktop"
	@echo "  make stow PACKAGES='common macos'                     # macOS"

install:
	@./scripts/install.sh

stow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make stow PACKAGES='common linux')
endif
	$(make_pi_dir)
	stow $(PACKAGES) -t $(STOW_TARGET)

# Unstow + stow: picks up new files and removes links to files deleted from a package
restow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make restow PACKAGES='common linux')
endif
	$(make_pi_dir)
	stow -R $(PACKAGES) -t $(STOW_TARGET)

unstow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make unstow PACKAGES='common linux')
endif
	stow -D $(PACKAGES) -t $(STOW_TARGET)

update:
	git submodule update --remote --merge
	nvim --headless "+Lazy! sync" +qa 2>/dev/null || echo "Note: Lazy.nvim sync skipped (not yet migrated)"
