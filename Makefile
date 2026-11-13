# ABOUTME: Makefile for dotfiles management
# ABOUTME: Provides stow, restow, unstow, and update commands

.PHONY: install stow restow unstow update help

STOW_TARGET := $(HOME)

# Dirs that must be real before stowing, or stow folds them into one link to
# this (public) repo and whatever tools write there lands in the worktree:
# - ~/.config: a fresh server user has none, and common alone would fold it
# - pi's agent dir (dev): pi writes its credentials, sessions and install there
#   (see "pi coding agent" in README.md)
# - its extensions dir: other tools install extensions there (herdr's
#   integration), so only our extensions may be links
PI_AGENT_DIR := $(STOW_TARGET)/.config/pi/agent
make_dirs = @mkdir -p $(STOW_TARGET)/.config $(if $(filter dev,$(PACKAGES)),$(PI_AGENT_DIR)/extensions)

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install                           - Run bootstrap script"
	@echo "  make stow PACKAGES='common dev'        - Stow specified packages"
	@echo "  make restow PACKAGES='common dev'      - Restow after a pull (also prunes links to deleted files)"
	@echo "  make unstow PACKAGES='common dev'      - Unstow specified packages"
	@echo "  make update                            - Update submodules and nvim plugins"
	@echo ""
	@echo "Available packages:"
	@echo "  common     - Every machine, servers too (zsh, nvim without plugins, server aliases)"
	@echo "  dev        - Machines you work on (nvim plugins + LSP, zellij, pi, yazi, ranger, btop)"
	@echo "  desktop    - Linux desktop (alacritty, dunst, kanata, pipewire, runit ssh-agent, scripts)"
	@echo "  macos      - macOS (aerospace, alacritty, kanata, kubectl, shell profile)"
	@echo "  hyprland   - Hyprland/Wayland (hypr, waybar, wofi, feh)"
	@echo "  dwm        - X11/dwm (picom, xmodmap, .xinitrc, startx on TTY1)"
	@echo "  framework  - Framework laptop host (hypr host.lua, waybar, wluma, color-calibration, easyeffects, thermal aliases)"
	@echo "  cosmo      - Desktop host (hypr host.lua, waybar, NVIDIA env)"
	@echo ""
	@echo "Examples:"
	@echo "  make stow PACKAGES='common'                                # server"
	@echo "  make stow PACKAGES='common dev'                            # headless dev box (agent@debbie)"
	@echo "  make stow PACKAGES='common dev desktop hyprland framework' # Framework laptop"
	@echo "  make stow PACKAGES='common dev desktop hyprland cosmo'     # cosmo desktop"
	@echo "  make stow PACKAGES='common dev macos'                      # macOS"

install:
	@./scripts/install.sh

stow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make stow PACKAGES='common dev')
endif
	$(make_dirs)
	stow $(PACKAGES) -t $(STOW_TARGET)

# Unstow + stow: picks up new files and removes links to files deleted from a package
restow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make restow PACKAGES='common dev')
endif
	$(make_dirs)
	stow -R $(PACKAGES) -t $(STOW_TARGET)

unstow:
ifndef PACKAGES
	$(error PACKAGES is required. Example: make unstow PACKAGES='common dev')
endif
	stow -D $(PACKAGES) -t $(STOW_TARGET)

update:
	git submodule update --remote --merge
	@if [ -e "$(STOW_TARGET)/.config/nvim/lua/dev/init.lua" ]; then \
		nvim --headless "+Lazy! sync" +qa; \
	else \
		echo "No nvim plugins to sync (dev isn't stowed)"; \
	fi
