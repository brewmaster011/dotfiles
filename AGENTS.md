# Notes for coding agents

Personal dotfiles, symlinked into `$HOME` with GNU Stow. **The repo is public**:
never commit credentials, tokens or other secrets.

## Layout

- A bare repo with worktrees (on cosmo `~/Documents/source/dotfiles.git/<branch>`).
  Each machine stows from one worktree, so its files *are* the live config:
  edits apply at once (Hyprland autoreloads, waybar reloads its CSS).
- Stow packages are the top-level dirs, stacked as layers: `common` (every
  machine, servers included), `dev` (machines you work on), `desktop` (Linux
  GUI) or `macos`, a window manager (`hyprland`, `dwm`), then one host package
  per Hyprland machine. A layer only adds to the ones below. `scripts/` is not
  stowed.
- Machines: cosmo, the desktop (Artix with runit, NVIDIA, OLED monitor):
  `common dev desktop hyprland cosmo`. Framework 13 laptop:
  `common dev desktop hyprland framework`. Mac: `common dev macos`. The
  homelab servers (Debian, managed from the homelab repo; SSH for emergencies
  only): `common`. The `agent` user on debbie: `common dev`. uConsole: on the
  `feature/uconsole-support` branch (still on the old layout).

## Working here

- After pulling, run `make restow PACKAGES='…'` with the machine's packages
  (preview with `stow -n -v -R … -t ~`) so new files get linked and links to
  deleted ones are pruned.
- Hyprland is configured in Lua (0.55+): `hyprland.lua` loads `core/`, then the
  host package's `host.lua`, which opts into `modules/`. Machine-specific
  behaviour belongs in a host package or a module, not in `core/`.
- The Hyprland setup copies dwm (the `brewmaster011/dwm` repo): `core/tile.lua`,
  `core/layouts.lua` and `core/tags.lua` are its tile layout, pertag layouts
  and tags. Tags are workspaces 1-9 of each monitor's range; windows are moved
  between them as the view changes, and their tags live on the window as
  Hyprland tags `tag1`..`tag9`. Lua state is lost on every config reload.
- `/usr/share/hypr/stubs/hl.meta.lua` doesn't list dispatcher arguments; check
  the Hyprland source for the installed version. `window.float` takes `on`/`off`,
  `window.fullscreen` takes `set`/`unset`, and unknown values silently become
  `toggle`.
- `common` must start cleanly on a server with only zsh and git: guard any
  other tool (`(( $+commands[x] ))` in zsh, `command -v` in the `.sh` alias
  files), and don't make it fetch anything (nvim plugins live in dev). Check
  with a throwaway HOME: `mkdir "$tmp/.config"; stow -t "$tmp" common`, then
  `env -i HOME="$tmp" PATH=/usr/bin:/bin TERM=xterm zsh -i -c exit`.
- zsh settings for a package go in drop-ins named `NN-<package>.zsh`:
  `~/.config/zsh/env.d/` (from `.zshenv`, every zsh) or `rc.d/` (end of
  `zshrc`); aliases in `aliases/<name>.aliases.sh`. 10 OS, 20 dev,
  30 desktop, 40 window manager, 50 host.
- pi's config is `dev/.config/pi/agent` (stowed to `~/.config/pi/agent`).
  `.gitignore` ignores everything else there; keep it deny-by-default.
