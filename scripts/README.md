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

## migrate-pi.sh

One-off, per machine: moves pi's agent dir from `~/.pi/agent` to
`~/.config/pi/agent` (where `PI_CODING_AGENT_DIR` from `common/.zshenv` points), removes a leftover `~/.pi/agent` link,
re-points `~/.local/bin/pi`, and links the pi config tracked in `common`. Run it with every pi session closed. See
"pi coding agent" in the top-level README.

## Makefile

| Command                            | Description                   |
|------------------------------------|-------------------------------|
| `make help`                        | Show usage and package list   |
| `make install`                     | Run install.sh                |
| `make stow PACKAGES='...'`         | Symlink packages to home      |
| `make restow PACKAGES='...'`       | Restow after a pull (prunes links to deleted files) |
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
  migrate-pi.sh   # One-off move of pi's agent dir to ~/.config/pi/agent
  packages/
    base.txt      # Cross-platform packages
    linux.txt     # Linux packages
    macos.txt     # macOS packages
  post-install/   # (Reserved for post-install hooks)
```
