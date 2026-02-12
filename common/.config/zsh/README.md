# Zsh Configuration

Shell configuration for Zsh with Vi mode, fzf integration, and minimal prompt.

## Features

- **Vi mode** with cursor shape changes (block in normal, beam in insert)
- **fzf-tab** for fuzzy tab completion
- **zsh-syntax-highlighting** for command highlighting
- **History search** with arrow keys (prefix-based)
- **Auto-start X** on Linux TTY1 (for dwm)
- **OS detection** (Linux vs macOS) for platform-specific settings

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
| `Ctrl+e` | Edit current line in Neovim |
| `Ctrl+r` | Incremental history search backward |
| `Ctrl+a` | Open bc calculator |
| `Ctrl+n` | Run `notes` command |
| `Ctrl+f` | cd to fzf-selected file's directory |
| `Ctrl+g` | cd to fzf-selected source directory (`~/Documents/source`) |
| `Space` | Magic space (expands history) |
| `Up` | History search (prefix-based) |
| `Down` | History search (prefix-based) |

## Aliases

Aliases are organized in `aliases/`:

### General (`general.aliases.sh`)

| Alias | Command | Description |
|-------|---------|-------------|
| `vim` | `nvim` | Use Neovim |
| `c` | `clear` | Clear terminal |
| `src` | `source ~/.zshrc` | Reload config |
| `cp` | `cp -iv` | Interactive, verbose copy |
| `mv` | `mv -iv` | Interactive, verbose move |
| `mkdir` | `mkdir -pv` | Create parents, verbose |
| `grep` | `grep --color=auto` | Colored grep |
| `diff` | `diff --color=auto` | Colored diff |
| `df` | `df -h` | Human-readable disk usage |
| `du` | `du -h` | Human-readable sizes |
| `free` | `free -h` | Human-readable memory |
| `pretty` | `jq -R ...` | Pretty print JSON logs |

### Kubernetes

| Alias | Command |
|-------|---------|
| `k` | `kubectl` |
| `ke` | `kubens` |
| `kc` | `kubectx` |

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
| `EDITOR` | `nvim` | Default editor |
| `SSH_AUTH_SOCK` | `~/.ssh/ssh_auth_sock` | SSH agent socket (Linux) |
| `FZF_DEFAULT_OPTS` | `--height 30% --layout=reverse --border` | FZF defaults |
| `DOTNET_ROOT` | `~/.dotnet` | .NET installation |

## Directory Structure

```
zsh/
├── zshrc                   # Main config
├── .fzf.zsh                # FZF setup
├── kubectl_autocomplete    # Kubernetes completions
├── aliases/
│   ├── general.aliases.sh  # General aliases
│   ├── ls.aliases.sh       # Directory listing
│   ├── chmod.aliases.sh    # Permission shortcuts
│   └── git-prompt.sh       # Git prompt integration
└── plugins/                # Git submodules
    ├── fzf-tab/
    └── zsh-syntax-highlighting/
```

## OS-Specific Behavior

The config detects the OS and adjusts:

| Setting | Linux | macOS |
|---------|-------|-------|
| SSH agent | runit service (`~/.ssh/ssh_auth_sock`) | macOS Keychain |
| Homebrew | N/A | Loads from `/opt/homebrew` |
| Auto-start X | On TTY1 (for dwm) | N/A |

## Performance

- **zcompile** is used to compile `zcompdump` to bytecode, saving ~15ms on startup
- Startup time: ~115-120ms (measured with `hyperfine 'zsh -i -c exit'`)
