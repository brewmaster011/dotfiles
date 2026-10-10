# Notes for coding agents

Personal dotfiles, symlinked into `$HOME` with GNU Stow. **The repo is public**:
never commit credentials, tokens or other secrets.

## Layout

- A bare repo with worktrees (on cosmo `~/Documents/source/dotfiles.git/<branch>`).
  Each machine stows from one worktree, so its files *are* the live config:
  edits apply at once (Hyprland autoreloads, waybar reloads its CSS).
- Stow packages are the top-level dirs: `common` (every machine), `linux`,
  `macos`, `hyprland`, `dwm`, plus one host package per Hyprland machine.
  `scripts/` is not stowed.
- Machines: cosmo, the desktop (Artix with runit, NVIDIA, OLED monitor):
  `common linux hyprland cosmo`. Framework 13 laptop:
  `common linux hyprland framework`. Mac: `common macos`. uConsole: on the
  `feature/uconsole-support` branch.

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
- pi's config is `common/.config/pi/agent` (stowed to `~/.config/pi/agent`).
  `.gitignore` ignores everything else there; keep it deny-by-default.
