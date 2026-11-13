# Dev Package

What a machine you work on adds to `common`: the desktops, the Mac and the
`agent` user on debbie (headless). Servers don't stow it.

```bash
make stow PACKAGES='common dev'                            # headless
make stow PACKAGES='common dev desktop hyprland framework' # with a desktop
```

`~/.config/pi/agent` has to exist before stowing dev (`make stow` and
`install.sh` create it); see "pi coding agent" in the top-level README.

## Contents

| Path | Description |
|------|-------------|
| `.config/nvim/` | The plugin half of the Neovim config: `lua/dev` (lazy.nvim and the plugin list), `after/plugin`, `lua/lsp`, `lazy-lock.json`. common's `init.lua` loads `lua/dev` when it's there |
| `.config/zsh/env.d/20-dev.zsh` | `PI_CODING_AGENT_DIR` |
| `.config/zsh/rc.d/20-dev.zsh` | PATH for Go, opencode, cargo and .NET; the `^g` project jump (`fzf_cd`) |
| `.config/zellij/` | Terminal multiplexer |
| `.config/pi/agent/` | pi coding agent: settings, theme, footer extension |
| `.config/yazi/`, `.config/ranger/` | File managers |
| `.config/btop/`, `.config/neofetch/` | System monitor, system info |

Neovim needs 0.11+ here (Debian 13 ships 0.10.4; common alone is fine with it).

## Ranger (File Manager)

Terminal file manager with vim-like keybindings.

### Key Ranger Bindings

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate (vim-style) |
| `gg` / `G` | Top / Bottom |
| `H` / `L` | History back / forward |
| `Space` | Mark file |
| `yy` | Copy (yank) |
| `dd` | Cut |
| `pp` | Paste |
| `dD` | Delete |
| `cw` | Rename |
| `/` | Search |
| `n` / `N` | Next / Previous match |
| `zh` | Toggle hidden files |
| `zp` | Toggle preview |

### Directory Shortcuts

| Key | Directory |
|-----|-----------|
| `gh` | Home (`~`) |
| `ge` | `/etc` |
| `gu` | `/usr` |
| `gd` | `/dev` |
| `go` | `/opt` |
| `gm` | `/media` |
| `gr` | `/` (root) |

See `rc.conf` for the full list of keybindings.
