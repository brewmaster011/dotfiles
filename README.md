# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). The packages are layers: every machine stows `common`, and each layer on top only adds to the ones below, so a server stows `common` alone and a desktop stacks `dev`, `desktop`, a window manager and its host package on it.

## Quick Start

```bash
# Clone the repo
git clone --recursive https://github.com/brewmaster011/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the bootstrap script (installs packages, initializes submodules, runs stow)
./scripts/install.sh

# Or stow the packages yourself. The dirs first, or stow links them into the
# repo: ~/.config always, pi's dirs with dev (see "pi coding agent")
mkdir -p ~/.config/pi/agent/extensions
stow common dev desktop hyprland cosmo -t ~
```

## Stow Packages

| Layer | Package | Contents |
|-------|---------|----------|
| every machine | `common` | Zsh (prompt, vi mode, completion, plugins, fzf when installed), Neovim options and keymaps (no plugins), server aliases. Needs only zsh and git |
| machines you work on | `dev` | Neovim plugins (lazy.nvim, LSP, treesitter), Zellij, pi coding agent, yazi, ranger, btop, neofetch, toolchain PATHs, `^g` project jump |
| OS / GUI | `desktop` | Linux desktop: Alacritty, Dunst, Kanata, Pipewire, Runit ssh-agent, statusbar + playerctl scripts |
| OS / GUI | `macos` | AeroSpace, Alacritty, Kanata, posting, kubectl, Zsh, git ignore, shell profile |
| window manager | `hyprland` | Hyprland, Waybar, Wofi, Hyprlock, Hypridle, Hyprpaper |
| window manager | `dwm` | Picom, Xmodmap, .xinitrc, startx on TTY1 |
| host | `framework` | Framework 13 laptop: Hyprland host.lua (desk layout + eDP-1 off when docked; laptop, kanata, wluma + split-workspaces modules), waybar battery + VPN modules, wluma config, ICC profile, EasyEffects preset, thermal profile aliases |
| host | `cosmo` | Desktop: Hyprland host.lua (desk layout; nvidia + split-workspaces modules), waybar modules |
| — | `scripts` | Bootstrap script, Makefile, package lists (not stowed) |

A layer never undoes one below it. `common` is what a server gets, so it must
start cleanly with nothing but zsh and git: every other tool it uses (fzf, eza,
nvim, docker, ...) is only used when it's installed.

## Per-Machine Examples

```bash
# Server (homelab nodes; SSH for emergencies only)
make stow PACKAGES='common'

# Headless dev box (the agent user on debbie)
make stow PACKAGES='common dev'

# Framework laptop with Hyprland (Wayland)
make stow PACKAGES='common dev desktop hyprland framework'

# cosmo desktop with Hyprland (Wayland, NVIDIA)
make stow PACKAGES='common dev desktop hyprland cosmo'

# Desktop with dwm (X11)
make stow PACKAGES='common dev desktop dwm'

# macOS
make stow PACKAGES='common dev macos'
```

`make stow`/`restow` and `install.sh` create `~/.config` first: a new server
user has none, and stowing `common` alone would otherwise link all of
`~/.config` into this public repo. With plain stow, `mkdir -p ~/.config` first.

### Moving a machine from the old layout (`common linux ...`)

Only `common` and the OS package (`linux`, or `macos` on the Mac) changed
shape; the window manager and host packages stay stowed, so Hyprland never
loses its config mid-session.

1. Close every pi (its config links are in the old `common`), and commit or
   stash anything uncommitted under `common/`, `linux/` or `macos/` in the
   worktree.
2. Before pulling, unstow the packages that move:
   `make unstow PACKAGES='common linux'` (Mac: `'common macos'`)
3. Pull (or switch the worktree to the new branch), then delete the leftover
   `linux/` dir: git leaves it behind with runit's ignored `supervise/` files.
4. Stow the new layers next to the ones still stowed:
   `make stow PACKAGES='common dev desktop'` (Mac: `'common dev macos'`)
5. Linux: runit's ssh-agent ran from the old `linux/` path and stops when that goes:
   log out and back in (or restart the user `runsvdir`), then load the keys
   again (`~/.config/scripts/ssh-load-keys`).
6. The tracked `zshrc.local` files of `linux` and `macos` became `rc.d` files;
   `~/.config/zsh/zshrc.local` is now untracked and yours, for machine-local
   settings (see "Shell environment").

## Directory Structure

```
dotfiles/
├── common/                 # Every machine, servers too (needs only zsh + git)
│   ├── .zshenv             # Sources ~/.config/zsh/env.d/*.zsh
│   ├── .zshrc              # Sources ~/.config/zsh/zshrc
│   └── .config/
│       ├── nvim/           # Neovim: init.lua + lua/base (options, keymaps); lua/dev if dev is stowed
│       └── zsh/            # zshrc (sources rc.d/*.zsh), aliases (incl. server), plugins as submodules
│
├── dev/                    # Machines you work on (desktops, Mac, agent@debbie)
│   └── .config/
│       ├── nvim/           # lua/dev (lazy.nvim + plugins), after/plugin, lua/lsp, lazy-lock.json
│       ├── zsh/            # env.d/20-dev.zsh (PI_CODING_AGENT_DIR), rc.d/20-dev.zsh (PATHs, ^g)
│       ├── zellij/         # Terminal multiplexer
│       ├── pi/agent/       # pi coding agent: settings, theme, footer extension
│       ├── yazi/, ranger/  # File managers
│       └── btop/, neofetch/
│
├── desktop/                # Linux desktop, shared by hyprland and dwm
│   └── .config/
│       ├── alacritty/      # Terminal (base config + os.toml)
│       ├── dunst/          # Notifications
│       ├── kanata/         # Keyboard remapper (home row mods)
│       ├── pipewire/       # Starts wireplumber + pipewire-pulse (no systemd)
│       ├── runit/          # User services (SSH agent)
│       ├── scripts/        # Statusbar, playerctl hooks
│       └── zsh/            # SSH_AUTH_SOCK (env.d), MOZ_USE_XINPUT2 (rc.d), desktop aliases
│
├── hyprland/               # Hyprland (Wayland)
│   ├── .config/
│   │   ├── hypr/           # Hyprland, hyprlock, hypridle, hyprpaper
│   │   │   ├── hyprland.lua    # Entry point: core, then host.lua
│   │   │   ├── core/           # Shared config (env, autostart, look, input, binds, rules, dwm tile/layouts/tags)
│   │   │   ├── modules/        # Opt-in features a host enables (monitors, laptop, nvidia, kanata, wluma, split-workspaces)
│   │   │   └── plugins/        # Lua plugins as git submodules
│   │   ├── waybar/         # Status bar
│   │   ├── wofi/           # App launcher
│   │   └── feh/            # Wallpaper (fallback)
│   └── Pictures/wallpaper/ # Wallpaper images
│
├── dwm/                    # dwm (X11)
│   ├── .xinitrc            # X session startup
│   └── .config/
│       ├── picom/          # Compositor
│       ├── xmodmap/        # Keyboard mapping
│       └── zsh/            # rc.d/40-dwm.zsh: startx on TTY1
│
├── framework/              # Framework laptop (host package)
│   └── .config/
│       ├── hypr/host.lua       # Desk layout + built-in panel; laptop, kanata, wluma + split-workspaces modules
│       ├── wluma/config.toml   # Auto-brightness (ambient light sensor)
│       ├── waybar/host.jsonc   # modules-right incl. battery/backlight/VPN
│       ├── color-calibration/  # ICC profile
│       ├── easyeffects/        # Audio preset
│       └── zsh/aliases/        # Thermal profile aliases
│
├── cosmo/                  # Desktop (host package)
│   └── .config/
│       ├── hypr/host.lua       # Desk layout; nvidia + split-workspaces modules
│       └── waybar/host.jsonc   # modules-right
│
├── macos/                  # macOS
│   ├── .zprofile           # Homebrew shellenv + nvm
│   └── .config/
│       ├── aerospace/      # Tiling WM
│       ├── alacritty/      # Terminal (base config, a copy of desktop's, + os.toml)
│       ├── kanata/         # Keyboard remapper (home row mods)
│       ├── git/            # Global gitignore
│       ├── posting/        # HTTP client (TUI)
│       └── zsh/            # rc.d/10-macos.zsh, aws + kubernetes aliases, kubectl/argo completion
│
├── scripts/                # Installation tools
│   ├── install.sh          # Bootstrap script
│   └── packages/           # Package lists per stow package (common, dev, desktop, macos)
│
├── Makefile                # stow/unstow/update commands
└── README.md               # This file
```

## Requirements

### common (every machine)
- Git, [GNU Stow](https://www.gnu.org/software/stow/), Zsh — all it needs
- Used when installed: Neovim 0.10+ (Debian 13's is fine without dev),
  [fzf](https://github.com/junegunn/fzf) 0.48+ (key bindings, fzf-tab),
  [eza](https://github.com/eza-community/eza) (fzf-tab's cd preview)

### dev
- Neovim 0.11+ (native LSP config, nvim-treesitter's `main` branch). Debian 13
  ships 0.10.4, so install a release build there (debbie: `~/.local/bin/nvim`)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (Telescope)
- [fd](https://github.com/sharkdp/fd) (Telescope, the `^g` project jump; `fd-find` on Debian)
- [zellij](https://github.com/zellij-org/zellij) (terminal multiplexer; not packaged in Debian 13)
- A C compiler and `tree-sitter-cli` for nvim-treesitter's parsers

### Linux (Hyprland)
- Hyprland, Waybar, Wofi
- Hyprlock, Hypridle, Hyprpaper
- Pipewire, Dunst
- [Kanata](https://github.com/jtroo/kanata) (keyboard remapper)

### Linux (dwm)
- dwm, dwmblocks, slock (compiled separately)
- Picom, Dunst
- X11, xinit

### macOS
- [Homebrew](https://brew.sh/)
- Casks: `alacritty`, `aerospace`, `karabiner-elements` (provides the VirtualHIDDevice driver Kanata requires), `font-hack-nerd-font`
- `tree-sitter-cli` (Neovim compiles treesitter parsers with the CLI; the `tree-sitter` formula is library-only)
- [Kanata](https://github.com/jtroo/kanata) — home-row mods; requires approving the Karabiner system extension and granting Input Monitoring
- btop (system monitor)

## Per-host config

`hyprland/.config/hypr/hyprland.lua` loads `core/` (shared by every machine) and
then `~/.config/hypr/host.lua` if present. A host file only picks the features it
needs from `modules/`, e.g.
`require("modules.laptop").setup()`. Hyprland puts `~/.config/hypr/?.lua` and
`~/.config/hypr/?/init.lua` on the Lua module path, so no `package.path` setup is
needed. Waybar's `config.jsonc` includes
`~/.config/waybar/host.jsonc`, which supplies `modules-right`. Each machine
stows exactly one host package (`framework`, `cosmo`) that provides those two files.
To add a machine, create `<host>/.config/hypr/host.lua` and
`<host>/.config/waybar/host.jsonc` and stow it alongside `hyprland`.

## Shell environment

Each package adds its zsh settings as drop-in files named `NN-<package>.zsh`,
loaded in layer order (10 OS, 20 dev, 30 desktop, 40 window manager, 50 host):

- `~/.config/zsh/env.d/` — sourced by `.zshenv`, so every zsh gets it (scripts
  too). Only for variables that processes outside an interactive shell need.
- `~/.config/zsh/rc.d/` — sourced at the end of `zshrc`.
- `~/.config/zsh/aliases/` — every file there is sourced; a package adds its
  own `<name>.aliases.sh`.
- `~/.config/zsh/zshrc.local` — machine-local, untracked (`.gitignore`),
  sourced last.

Variables:

- `PROJECTS_DIR` — base directory the `^g` fzf project-jump widget (dev) searches (defaults to `~/Documents/source`). Set it per machine in `~/.config/zsh/zshrc.local` if your projects live elsewhere (macOS sets it in `rc.d/10-macos.zsh`).
- `PI_CODING_AGENT_DIR` — pi's config dir, `~/.config/pi/agent` on every machine. Set in dev's `env.d/20-dev.zsh` (every zsh, scripts included) and in Hyprland's `core/env.lua` for GUI launches; pi falls back to `~/.pi/agent` wherever it is unset (see below).
- `SSH_AUTH_SOCK` — the Linux desktops' runit ssh-agent socket, set in desktop's `env.d/30-desktop.zsh`. Servers don't set it, so agent forwarding over SSH works there.

## pi coding agent

`dev` carries [pi](https://pi.dev)'s config: `settings.json` (preferences and
the pi packages it installs at startup), the `gruvbox-pastel` theme and the
`context-footer` extension (the status bar at the bottom). It lives in
`~/.config/pi/agent` instead of pi's default `~/.pi/agent`; nothing of pi's is
kept in `~` itself. pi only honours `PI_CODING_AGENT_DIR` for that, so the
variable is exported from `~/.zshenv` (dev's `env.d`) and the Hyprland environment. A pi started
without it silently creates a fresh `~/.pi/agent`; if one appears, rerun
`scripts/migrate-pi.sh` after closing pi.

pi keeps its credentials (`auth.json`), sessions, its own install and caches in
the same directory. This repo is public, so `.gitignore` ignores everything
under `dev/.config/pi/agent` except the tracked config. pi writes
`settings.json` in place, so `/settings`, `pi install` and a new default model
show up as changes here.

- **New machine**: `~/.config/pi/agent` has to exist before `dev` is stowed,
  or stow turns `~/.config/pi` into a link to the repo and pi's credentials and
  sessions end up in the worktree. `make stow` and `install.sh` create it; with
  plain stow, `mkdir -p ~/.config/pi/agent/extensions` first (a real
  `extensions` dir, so extensions other tools install, like herdr's, stay out
  of the repo). Then open a new shell and
  install pi (the installer follows `PI_CODING_AGENT_DIR`).
- **Machine still on `~/.pi/agent`**, or macOS (already on `~/.config/pi/agent`):
  close pi and run `scripts/migrate-pi.sh` right after pulling and stowing
  `common` and `dev`. It moves the directory, re-points `~/.local/bin/pi` and links the
  tracked files. Copies that differed from the repo replace the repo's, so
  `git diff` shows them. Restart Hyprland (or any shell older than the stow)
  before starting pi there, so it has the variable.

## Makefile Commands

```bash
make help                                  # Show available commands
make install                               # Run bootstrap script
make stow PACKAGES='common dev'            # Stow specified packages
make restow PACKAGES='common dev'          # Restow after a pull (prunes links to deleted files)
make unstow PACKAGES='common dev'          # Unstow specified packages
make update                                # Update git submodules and nvim plugins
```

## Git Submodules

Zsh and Hyprland plugins are managed as git submodules:

- [fzf-tab](https://github.com/Aloxaf/fzf-tab) - FZF-powered tab completion
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - Shell syntax highlighting
- [split-monitor-workspaces](https://github.com/zjeffer/split-monitor-workspaces) - Per-monitor (dwm-style) workspaces for Hyprland's Lua config

To update submodules:
```bash
git submodule update --remote --merge
```

## Git Identity

Git identity is **not** committed to this repo. Set it per-machine:

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

## Detailed Documentation

- [Neovim Configuration](common/.config/nvim/README.md) - Plugins, LSP, keybindings
- [Zsh Configuration](common/.config/zsh/README.md) - Aliases, plugins, keybindings
- [Dev Package](dev/README.md) - What dev adds, Ranger
- [Desktop Package](desktop/README.md) - Kanata, Dunst, runit, scripts
- [Hyprland Package](hyprland/README.md) - Keybindings, Waybar, Wofi
- [dwm Package](dwm/README.md) - .xinitrc, Picom, dependencies
- [Scripts](scripts/README.md) - install.sh, Makefile, package lists

## License

Do whatever you want with this. Attribution appreciated but not required.
