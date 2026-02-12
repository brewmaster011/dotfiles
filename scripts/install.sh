#!/usr/bin/env bash
# ABOUTME: Bootstrap script for dotfiles installation
# ABOUTME: Handles package installation and stow package selection across Linux and macOS

set -euo pipefail

# Detect OS
case "$(uname -s)" in
    Linux*)  OS_TYPE="linux";;
    Darwin*) OS_TYPE="macos";;
    *)       echo "Unsupported OS"; exit 1;;
esac

echo "Detected OS: $OS_TYPE"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Install packages
if [[ "$OS_TYPE" == "macos" ]]; then
    # Install Homebrew if missing
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    if [[ -f "$SCRIPT_DIR/packages/macos.txt" ]]; then
        echo "Installing macOS packages..."
        xargs brew install < "$SCRIPT_DIR/packages/macos.txt"
    fi
    if [[ -f "$SCRIPT_DIR/packages/base.txt" ]]; then
        echo "Installing base packages..."
        xargs brew install < "$SCRIPT_DIR/packages/base.txt"
    fi
else
    # Detect Linux distro
    if command -v pacman &>/dev/null; then
        echo "Detected Arch Linux (pacman)"
        if [[ -f "$SCRIPT_DIR/packages/linux.txt" ]] && [[ -f "$SCRIPT_DIR/packages/base.txt" ]]; then
            sudo pacman -S --needed $(cat "$SCRIPT_DIR/packages/linux.txt" "$SCRIPT_DIR/packages/base.txt")
        fi
    elif command -v apt &>/dev/null; then
        echo "Detected Debian/Ubuntu (apt)"
        if [[ -f "$SCRIPT_DIR/packages/linux.txt" ]] && [[ -f "$SCRIPT_DIR/packages/base.txt" ]]; then
            sudo apt install -y $(cat "$SCRIPT_DIR/packages/linux.txt" "$SCRIPT_DIR/packages/base.txt")
        fi
    else
        echo "Warning: Unknown package manager. Skipping package installation."
    fi
fi

# Initialize git submodules
echo "Initializing git submodules..."
cd "$DOTFILES_DIR"
git submodule update --init --recursive

# Prompt for packages to stow
echo ""
echo "Available stow packages:"
echo "  common     - Cross-platform (nvim, zsh, alacritty, zellij)"
echo "  linux      - Linux-only (dunst, kanata, ranger, neofetch, runit, scripts)"
echo "  macos      - macOS-specific (aerospace)"
echo "  hyprland   - Hyprland/Wayland (hypr, waybar, wofi, feh)"
echo "  dwm        - X11/dwm (picom, xmodmap, .xinitrc)"
echo "  framework  - Framework laptop (color-calibration, easyeffects)"
echo ""

if [[ "$OS_TYPE" == "macos" ]]; then
    PACKAGES="common macos"
    echo "Default for macOS: $PACKAGES"
    read -p "Use these packages? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        read -p "Enter packages to install (space-separated): " PACKAGES
    fi
else
    echo "Examples:"
    echo "  Framework laptop with Hyprland: common linux hyprland framework"
    echo "  Desktop with dwm: common linux dwm"
    echo ""
    read -p "Enter packages to install (space-separated): " PACKAGES
fi

# Run stow
if [[ -n "$PACKAGES" ]]; then
    echo "Running: stow $PACKAGES -t ~"
    cd "$DOTFILES_DIR"
    stow $PACKAGES -t ~
    echo ""
    echo "Done! Run 'nvim' to trigger lazy.nvim plugin installation."
else
    echo "No packages selected. You can run stow manually later:"
    echo "  cd $DOTFILES_DIR && stow <packages> -t ~"
fi
