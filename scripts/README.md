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

Bootstrap script that:

1. Detects OS (Linux or macOS)
2. Prompts for stow packages to install (skipped when `PACKAGES` is set)
3. Installs the system packages listed for them (`packages/<package>.txt`)
4. Initializes git submodules
5. Symlinks configs to home directory via stow

Non-interactive, e.g. for provisioning a server:

```bash
PACKAGES='common' ./scripts/install.sh
```

On Debian/Ubuntu `fd` is installed as `fd-find`, and packages the release
doesn't have (zellij, kanata and neofetch on Debian 13) are skipped with a
note.

### Supported Package Managers

| OS       | Package Manager |
|----------|-----------------|
| Arch     | pacman          |
| Debian   | apt             |
| macOS    | Homebrew        |

## migrate-pi.sh

One-off, per machine: moves pi's agent dir from `~/.pi/agent` to
`~/.config/pi/agent` (where `PI_CODING_AGENT_DIR` from dev's `env.d` points), removes a leftover `~/.pi/agent` link,
re-points `~/.local/bin/pi`, and links the pi config tracked in `dev`. Run it with every pi session closed. See
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
make stow PACKAGES='common dev desktop hyprland framework'

# Desktop with dwm
make stow PACKAGES='common dev desktop dwm'

# macOS
make stow PACKAGES='common dev macos'

# Server
make stow PACKAGES='common'
```

## Package Lists

Located in `scripts/packages/`:

| File          | Purpose                                    |
|---------------|--------------------------------------------|
| `common.txt`  | Every machine (git, stow, zsh, neovim, fzf) |
| `dev.txt`     | dev (ripgrep, fd, eza, zellij, ranger...)  |
| `desktop.txt` | Linux desktop (dunst, kanata)              |
| `macos.txt`   | macOS-only (Homebrew packages)             |

install.sh installs the lists of the stow packages you pick.

Edit these files to customize which packages get installed.

## Directory Structure

```
scripts/
  install.sh      # Main bootstrap script
  migrate-pi.sh   # One-off move of pi's agent dir to ~/.config/pi/agent
  packages/
    common.txt    # every machine
    dev.txt       # dev
    desktop.txt   # Linux desktop
    macos.txt     # macOS
  post-install/   # (Reserved for post-install hooks)
```
