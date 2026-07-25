# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Modular packages allow mixing and matching configurations for different machines (Linux desktop, laptop, Raspberry Pi, macOS).

## Quick Start

```bash
# Clone the repo
git clone --recursive https://github.com/brewmaster011/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the bootstrap script (installs packages, initializes submodules, runs stow)
./scripts/install.sh

# Or manually stow specific packages
stow common linux hyprland -t ~
```

## Stow Packages

| Package | Platform | Contents |
|---------|----------|----------|
| `common` | All | Neovim, Zsh, Alacritty, Zellij |
| `linux` | Linux | Dunst, Kanata, Ranger, Neofetch, Runit services, Scripts, Wallpaper |
| `hyprland` | Linux | Hyprland, Waybar, Wofi, Hyprlock, Hypridle, Hyprpaper |
| `dwm` | Linux | Picom, .xinitrc |
| `framework` | Linux | Color calibration (ICC profile), EasyEffects preset, thermal aliases |
| `uconsole` | Linux | ClockworkPi uConsole DSI panel rotation |
| `macos` | macOS | AeroSpace, Alacritty, Kanata, btop, posting, Zsh, git ignore, shell profile |
| `scripts` | N/A | Bootstrap script, Makefile, package lists (not stowed) |

## Per-Machine Examples

```bash
# Framework laptop with Hyprland (Wayland)
make stow PACKAGES='common linux hyprland framework'

# Desktop with dwm (X11)
make stow PACKAGES='common linux dwm'

# ClockworkPi uConsole (X11 handheld)
make stow PACKAGES='common linux dwm uconsole'

# Raspberry Pi / Headless server
make stow PACKAGES='common linux'

# macOS
make stow PACKAGES='common macos'
```

## Directory Structure

```
dotfiles/
├── common/                 # Cross-platform configs
│   ├── .zshrc              # Sources ~/.config/zsh/zshrc
│   └── .config/
│       ├── nvim/           # Neovim (lazy.nvim, native LSP)
│       ├── zsh/            # Zsh (plugins as git submodules)
│       ├── alacritty/      # Terminal emulator (base config, imports os.toml)
│       └── zellij/         # Terminal multiplexer
│
├── linux/                  # Linux-specific
│   └── .config/
│       ├── alacritty/      # OS-specific window settings (os.toml)
│       ├── dunst/          # Notifications
│       ├── kanata/         # Keyboard remapper (home row mods)
│       ├── ranger/         # File manager
│       ├── neofetch/       # System info
│       ├── runit/          # User services (SSH agent)
│       ├── scripts/        # Statusbar, playerctl hooks
│       ├── feh/            # Wallpaper setter (fehbg)
│       └── zsh/            # Linux-only aliases + zshrc.local
│   └── Pictures/wallpaper/ # Wallpaper images
│
├── hyprland/               # Hyprland (Wayland)
│   ├── .config/
│   │   ├── hypr/           # Hyprland, hyprlock, hypridle, hyprpaper
│   │   ├── waybar/         # Status bar
│   │   └── wofi/           # App launcher
│
├── dwm/                    # dwm (X11)
│   ├── .xinitrc            # X session startup (sources ~/.config/x11/xinitrc.local)
│   └── .config/
│       └── picom/          # Compositor
│
├── framework/              # Framework laptop
│   └── .config/
│       ├── color-calibration/  # ICC profile
│       ├── easyeffects/        # Audio preset
│       ├── x11/                # xinitrc.local - applies ICC profile
│       └── zsh/                # Thermal / power profile aliases
│
├── uconsole/               # ClockworkPi uConsole
│   └── .config/
│       └── x11/            # xinitrc.local - rotates the DSI panel
│
├── macos/                  # macOS
│   ├── .zprofile           # Homebrew shellenv + nvm
│   └── .config/
│       ├── aerospace/      # Tiling WM
│       ├── alacritty/      # OS-specific window settings (os.toml)
│       ├── kanata/         # Keyboard remapper (home row mods)
│       ├── btop/           # System monitor (config + bundled theme)
│       ├── git/            # Global gitignore
│       ├── posting/        # HTTP client (TUI)
│       └── zsh/            # macOS aliases + zshrc.local
│
├── scripts/                # Installation tools
│   ├── install.sh          # Bootstrap script
│   └── packages/           # Package lists (base.txt, linux.txt, macos.txt)
│
├── Makefile                # stow/unstow/update commands
└── README.md               # This file
```

## Requirements

### All Platforms
- Git
- [GNU Stow](https://www.gnu.org/software/stow/)
- Zsh
- Neovim 0.10+ (0.11+ recommended for native LSP config)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd) (used by the fzf project-jump widget, `^g`)
- [eza](https://github.com/eza-community/eza) (modern `ls`)
- [zellij](https://github.com/zellij-org/zellij) (terminal multiplexer)

### Linux (Hyprland)
- Hyprland, Waybar, Wofi
- Hyprlock, Hypridle, Hyprpaper
- Pipewire, Dunst
- [Kanata](https://github.com/jtroo/kanata) (keyboard remapper)

### Linux (dwm)
- dwm, dwmblocks, slock (compiled separately)
- Picom, Dunst
- X11, xinit, xss-lock, unclutter
- [brightnessctl](https://github.com/Hummer12007/brightnessctl), [pamixer](https://github.com/cdemoulins/pamixer), feh (statusbar scripts and wallpaper)

### Linux (ClockworkPi uConsole)
- Everything from the dwm list above
- dunst **>= 1.9** - Debian 11 ships 1.5.0, which cannot read the shared
  `linux/` dunstrc. See [uconsole/README.md](uconsole/README.md).

### macOS
- [Homebrew](https://brew.sh/)
- Casks: `alacritty`, `aerospace`, `karabiner-elements` (provides the VirtualHIDDevice driver Kanata requires), `font-hack-nerd-font`
- `tree-sitter-cli` (Neovim compiles treesitter parsers with the CLI; the `tree-sitter` formula is library-only)
- [Kanata](https://github.com/jtroo/kanata) — home-row mods; requires approving the Karabiner system extension and granting Input Monitoring
- btop (system monitor)

## Shell environment

- `PROJECTS_DIR` — base directory the `^g` fzf project-jump widget searches (defaults to `~/Documents/source`). Set it per-machine in the OS `zshrc.local` if your projects live elsewhere.

## Makefile Commands

```bash
make help                                  # Show available commands
make install                               # Run bootstrap script
make stow PACKAGES='common linux'          # Stow specified packages
make unstow PACKAGES='common linux'        # Unstow specified packages
make update                                # Update git submodules and nvim plugins
```

## Git Submodules

Zsh plugins are managed as git submodules:

- [fzf-tab](https://github.com/Aloxaf/fzf-tab) - FZF-powered tab completion
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - Shell syntax highlighting

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
- [Linux Package](linux/README.md) - Kanata, Dunst, Ranger, scripts
- [Hyprland Package](hyprland/README.md) - Keybindings, Waybar, Wofi
- [dwm Package](dwm/README.md) - .xinitrc, Picom, dependencies
- [Framework Package](framework/README.md) - Colour calibration, thermal aliases
- [uConsole Package](uconsole/README.md) - Hardware notes, dunst caveat
- [Scripts](scripts/README.md) - install.sh, Makefile, package lists

## License

Do whatever you want with this. Attribution appreciated but not required.
