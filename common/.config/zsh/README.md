# Zsh Configuration

Shell configuration for Zsh with Vi mode, fzf integration, and minimal prompt.

This is common's, so every machine gets it, servers included. It must start
cleanly with only zsh and git installed: fzf, eza, nvim and the server
tools are used only where they're installed.

## Features

- **Vi mode** with cursor shape changes (block in normal, beam in insert)
- **fzf-tab** for fuzzy tab completion (when fzf is installed)
- **zsh-syntax-highlighting** for command highlighting
- **History search** with arrow keys (prefix-based)
- **OS detection** (Linux vs macOS) for platform-specific settings
- **Drop-ins** for the other stow packages (below)

## Drop-ins from other packages

Every other package adds its settings as files named `NN-<package>.zsh`,
loaded in layer order (10 OS, 20 dev, 30 desktop, 40 window manager, 50 host):

| Dir | Sourced by | Used for |
|-----|-----------|----------|
| `env.d/` | `~/.zshenv`, every zsh (scripts too) | Variables processes outside an interactive shell need: `PI_CODING_AGENT_DIR` (dev), `SSH_AUTH_SOCK` (desktop) |
| `rc.d/` | the end of `zshrc` | Interactive settings: PATHs and `^g` (dev), `MOZ_USE_XINPUT2` (desktop), startx on TTY1 (dwm), macOS's PATHs and completions |
| `aliases/` | `zshrc`, every file | `<name>.aliases.sh` per package |

`~/.config/zsh/zshrc.local` is machine-local and untracked, sourced last.

`rc.d` runs after `compinit`, so adding to `fpath` there has no effect on
completion; source the completion script instead (as macos does for kubectl).

## Plugins

Plugins are managed as git submodules in `plugins/`:

| Plugin | Purpose |
|--------|---------|
| [fzf-tab](https://github.com/Aloxaf/fzf-tab) | FZF-powered tab completion |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Command syntax highlighting |

To update plugins:
```bash
git submodule update --remote --merge
```

## Keybindings

### Vi Mode

Standard Vi keybindings apply. The cursor changes shape:
- **Block** (`▋`) in normal mode
- **Beam** (`|`) in insert mode

### Menu Navigation (Tab Completion)

| Key | Action |
|-----|--------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |

### Shortcuts

| Key | Action |
|-----|--------|
| `Ctrl+e` | Edit current line in `$EDITOR` |
| `Ctrl+r` | Incremental history search backward |
| `Ctrl+a` | Open bc calculator |
| `Ctrl+n` | Run `notes` command |
| `Ctrl+f` | cd to fzf-selected file's directory |
| `Ctrl+g` | cd to fzf-selected project, then worktree (`$PROJECTS_DIR`, default `~/Documents/source`; dev) |
| `Space` | Magic space (expands history) |
| `Up` | History search (prefix-based) |
| `Down` | History search (prefix-based) |

## Aliases

Aliases are organized in `aliases/`:

### General (`general.aliases.sh`)

| Alias | Command | Description |
|-------|---------|-------------|
| `vim` | `nvim` | Use Neovim (only where it's installed) |
| `c` | `clear` | Clear terminal |
| `src` | `source ~/.zshrc` | Reload config |
| `cp` | `cp -iv` | Interactive, verbose copy |
| `mv` | `mv -iv` | Interactive, verbose move |
| `mkdir` | `mkdir -pv` | Create parents, verbose |
| `grep` | `grep --color=auto` | Colored grep |
| `diff` | `diff --color=auto` | Colored diff |
| `df` | `df -h` | Human-readable disk usage |
| `du` | `du -h` | Human-readable sizes |
| `free` | `free -h` | Human-readable memory (Linux) |
| `perm` | `stat --printf ...` | Octal permissions (Linux) |
| `pretty` | `jq -R ...` | Pretty print JSON logs |

### Server (`server.aliases.sh`)

Read-only shortcuts for break-glass work on the homelab nodes. Each group only
exists where its command is installed; nothing that changes state gets one.

| Alias | Command |
|-------|---------|
| `dnl` | `docker node ls` |
| `dsl` | `docker service ls` |
| `dps` | `docker service ps --no-trunc` |
| `dlog` | `docker service logs -f --tail 100` |
| `dstl` | `docker stack ls` |
| `sst` | `systemctl status` |
| `sfail` | `systemctl --failed` |
| `jfu` | `journalctl -fu` |
| `jx` | `journalctl -xe` |
| `zl` | `zfs list` |
| `zps` | `zpool status -x` |

Kubernetes aliases (`k`, `ke`, `kc`) and kubectl completion are in the macos
package.

### Directory Listing (`ls.aliases.sh`)

| Alias | Description |
|-------|-------------|
| `l` | Long listing, sort by newest |
| `L` | Long listing, sort by oldest |
| `la` | Show hidden files |
| `ll` | Long listing with all files |
| `lt` | Sort by date |
| `lk` | Sort by size |
| `lo` | Sort by size (largest first) |
| `lr` | Recursive directory tree |

### Chmod (`chmod.aliases.sh`)

Permission shortcuts for common chmod operations.

## Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `EDITOR` | first of `nvim`, `vim`, `vi` | Default editor |
| `SSH_AUTH_SOCK` | `~/.ssh/ssh_auth_sock` | SSH agent socket (Linux desktops; desktop's `env.d`) |
| `FZF_DEFAULT_OPTS` | `--height 30% --layout=reverse --border` | FZF defaults |
| `DOTNET_ROOT` | `~/.cache/dotnet` | .NET installation (dev's `rc.d`) |

## Directory Structure

```
zsh/
├── zshrc                   # Main config
├── aliases/
│   ├── general.aliases.sh  # General aliases
│   ├── ls.aliases.sh       # Directory listing
│   ├── chmod.aliases.sh    # Permission shortcuts
│   ├── server.aliases.sh   # Swarm/systemd/ZFS shortcuts (where installed)
│   └── git-prompt.sh       # Git prompt integration
└── plugins/                # Git submodules
    ├── fzf-tab/
    └── zsh-syntax-highlighting/
```

## OS-Specific Behavior

The config detects the OS and adjusts:

| Setting | Linux | macOS |
|---------|-------|-------|
| SSH agent | runit service (`~/.ssh/ssh_auth_sock`), desktop package only | macOS Keychain |
| Homebrew | N/A | Loads from `/opt/homebrew` |
| GNU aliases (`free`, `perm`), systemctl preview | Yes | No |

## Performance

- **zcompile** is used to compile `zcompdump` to bytecode, saving ~15ms on startup
- Startup time: ~115-120ms (measured with `hyperfine 'zsh -i -c exit'`)
