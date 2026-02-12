# Scripts

Bootstrap and installation scripts for dotfiles setup.

## Quick Start

```bash
# Clone and run the installer
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

Or use the Makefile:

```bash
make install
```

## install.sh

Interactive bootstrap script that:

1. Detects OS (Linux or macOS)
2. Installs system packages via package manager
3. Initializes git submodules
4. Prompts for stow packages to install
5. Symlinks configs to home directory via stow

### Supported Package Managers

| OS       | Package Manager |
|----------|-----------------|
| Arch     | pacman          |
| Debian   | apt             |
| macOS    | Homebrew        |

## Makefile

| Command                            | Description                   |
|------------------------------------|-------------------------------|
| `make help`                        | Show usage and package list   |
| `make install`                     | Run install.sh                |
| `make stow PACKAGES='...'`         | Symlink packages to home      |
| `make unstow PACKAGES='...'`       | Remove package symlinks       |
| `make update`                      | Update submodules and plugins |

### Examples

```bash
# Framework laptop with Hyprland
make stow PACKAGES='common linux hyprland framework'

# Desktop with dwm
make stow PACKAGES='common linux dwm'

# macOS
make stow PACKAGES='common macos'
```

## Package Lists

Located in `scripts/packages/`:

| File        | Purpose                              |
|-------------|--------------------------------------|
| `base.txt`  | Cross-platform (git, neovim, zsh...) |
| `linux.txt` | Linux-only (dunst, kanata, ranger)   |
| `macos.txt` | macOS-only (Homebrew packages)       |

Edit these files to customize which packages get installed.

## Directory Structure

```
scripts/
  install.sh      # Main bootstrap script
  packages/
    base.txt      # Cross-platform packages
    linux.txt     # Linux packages
    macos.txt     # macOS packages
  post-install/   # (Reserved for post-install hooks)
```
