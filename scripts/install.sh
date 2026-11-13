#!/usr/bin/env bash
# ABOUTME: Bootstrap script for dotfiles installation
# ABOUTME: Picks the stow packages, installs their system packages, then stows them
#
# Interactive by default. Set PACKAGES to skip the prompt (provisioning):
#   PACKAGES='common' ./scripts/install.sh

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

# Pick the stow packages
if [[ -z "${PACKAGES:-}" ]]; then
    echo ""
    echo "Available stow packages:"
    echo "  common     - Every machine, servers too (zsh, nvim without plugins, server aliases)"
    echo "  dev        - Machines you work on (nvim plugins + LSP, zellij, pi, yazi, ranger, btop)"
    echo "  desktop    - Linux desktop (alacritty, dunst, kanata, pipewire, runit ssh-agent, scripts)"
    echo "  macos      - macOS (aerospace, alacritty, kanata, kubectl, shell profile)"
    echo "  hyprland   - Hyprland/Wayland (hypr, waybar, wofi, feh)"
    echo "  dwm        - X11/dwm (picom, xmodmap, .xinitrc, startx on TTY1)"
    echo "  framework  - Framework laptop host (hypr host.lua, waybar, wluma, color-calibration, easyeffects, thermal aliases)"
    echo "  cosmo      - Desktop host (hypr host.lua, waybar, NVIDIA env)"
    echo ""
    if [[ "$OS_TYPE" == "macos" ]]; then
        PACKAGES="common dev macos"
        echo "Default for macOS: $PACKAGES"
        read -p "Use these packages? [Y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            read -p "Enter packages to install (space-separated): " PACKAGES
        fi
    else
        echo "Examples:"
        echo "  Server: common"
        echo "  Framework laptop with Hyprland: common dev desktop hyprland framework"
        echo "  cosmo desktop with Hyprland: common dev desktop hyprland cosmo"
        echo ""
        read -p "Enter packages to install (space-separated): " PACKAGES
    fi
fi

# System packages: scripts/packages/<package>.txt for each chosen package that
# has a list, without comments
lists=()
for pkg in $PACKAGES; do
    [[ -f "$SCRIPT_DIR/packages/$pkg.txt" ]] && lists+=("$SCRIPT_DIR/packages/$pkg.txt")
done
wanted=()
if (( ${#lists[@]} )); then
    while read -r name; do wanted+=("$name"); done \
        < <(sed 's/#.*//' "${lists[@]}" | tr -s ' \t' '\n' | grep -v '^$')
fi

if (( ${#wanted[@]} == 0 )); then
    echo "No system packages listed for: $PACKAGES"
elif [[ "$OS_TYPE" == "macos" ]]; then
    # Install Homebrew if missing
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # The installer doesn't put brew on this shell's PATH
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    # One at a time: a formula Homebrew has disabled (e.g. neofetch) must not
    # stop the rest, or the submodules and stow below
    failed=()
    for name in "${wanted[@]}"; do
        brew install "$name" || failed+=("$name")
    done
    (( ${#failed[@]} )) && echo "Could not install (continuing): ${failed[*]}"
elif command -v pacman &>/dev/null; then
    echo "Detected Arch Linux (pacman)"
    # Skip what isn't in the repos (AUR-only, e.g. kanata, or dropped)
    pac_pkgs=()
    for name in "${wanted[@]}"; do
        if pacman -Si "$name" &>/dev/null; then
            pac_pkgs+=("$name")
        else
            echo "Not in the pacman repos, skipped: $name"
        fi
    done
    if (( ${#pac_pkgs[@]} )); then
        sudo pacman -S --needed "${pac_pkgs[@]}"
    fi
elif command -v apt-get &>/dev/null; then
    echo "Detected Debian/Ubuntu (apt)"
    # Debian names (fd is fd-find); skip what the release doesn't package
    # (zellij, kanata and neofetch aren't in Debian 13)
    apt_pkgs=()
    for name in "${wanted[@]}"; do
        case $name in fd) name=fd-find ;; esac
        if [[ -n "$(apt-cache policy "$name" 2>/dev/null | awk '/Candidate:/ && $2 != "(none)" {print $2}')" ]]; then
            apt_pkgs+=("$name")
        else
            echo "Not packaged for this release, skipped: $name"
        fi
    done
    if (( ${#apt_pkgs[@]} )); then
        sudo apt-get install -y "${apt_pkgs[@]}"
    fi
else
    echo "Warning: Unknown package manager. Skipping package installation."
fi

# Initialize git submodules
echo "Initializing git submodules..."
cd "$DOTFILES_DIR"
git submodule update --init --recursive

# Run stow
if [[ -n "$PACKAGES" ]]; then
    echo "Running: stow $PACKAGES -t ~"
    cd "$DOTFILES_DIR"
    # Real dirs, so stow doesn't fold them into links to the repo (see the
    # Makefile): ~/.config always, pi's agent and extensions dirs for dev
    mkdir -p ~/.config
    if [[ " $PACKAGES " == *" dev "* ]]; then
        mkdir -p ~/.config/pi/agent/extensions
    fi
    stow $PACKAGES -t ~
    echo ""
    if [[ " $PACKAGES " == *" dev "* ]]; then
        echo "Done! Run 'nvim' to trigger lazy.nvim plugin installation."
    else
        echo "Done!"
    fi
else
    echo "No packages selected. You can run stow manually later:"
    echo "  cd $DOTFILES_DIR && stow <packages> -t ~"
fi
