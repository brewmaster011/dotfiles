# Neovim Configuration

Minimal, hand-built Neovim configuration using Lua. No pre-configured "IDE distributions" - just the plugins and settings needed.

## Two halves: common and dev

The config is split across two stow packages, so a server gets the same
options and keymaps without anything it can't run:

| | `common` (every machine) | `+ dev` (machines you work on) |
|-|--------------------------|--------------------------------|
| Files | `init.lua`, `lua/base/` (options, keymaps) | `lua/dev/` (lazy.nvim + plugin list), `after/plugin/`, `lua/lsp/`, `lazy-lock.json` |
| Plugins | none, nothing fetched at startup | everything below |
| Colours | built-in `retrobox` (gruvbox-like) | `gruvbox` |
| `<leader>b` | netrw (`:Lexplore`) | nvim-tree |
| Requires | Neovim 0.10+ (Debian 13's 0.10.4 is fine) | Neovim 0.11+ (native `vim.lsp.config`) |

`init.lua` loads `lua/dev` only when it exists, i.e. when dev is stowed.
Plugin-only keymaps (Telescope, LSP, completion, git) exist with dev only.

## Quick Start

With dev: on first launch, lazy.nvim will auto-bootstrap and install all plugins. Then run `:Mason` to install LSP servers.

## Plugin Manager

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management (dev). Plugins are defined in `lua/dev/lazy.lua`.

## Plugins

| Plugin | Purpose |
|--------|---------|
| **Telescope** | Fuzzy finder (files, grep, LSP references) |
| **Mason** | LSP server installer |
| **mason-lspconfig** | Mason + nvim-lspconfig integration |
| **nvim-lspconfig** | LSP client configurations |
| **nvim-cmp** | Autocompletion engine |
| **cmp-nvim-lsp** | LSP completion source |
| **cmp-buffer** | Buffer words completion |
| **cmp-path** | File path completion |
| **nvim-tree** | File explorer |
| **which-key** | Keybinding hints |
| **render-markdown** | Markdown rendering |
| **lspkind** | Completion menu icons |
| **indent-blankline** | Indentation guides |
| **gruvbox** | Colorscheme |
| **nvim-treesitter** | Syntax highlighting |
| **treesitter-context** | Sticky function headers |
| **vim-fugitive** | Git integration |
| **gitsigns** | Git signs in gutter |

## LSP Servers

Managed via Mason. Configured in `after/plugin/lsp.lua` with custom settings in `lua/lsp/<server>.lua`.

| Server | Language | Notes |
|--------|----------|-------|
| `lua_ls` | Lua | Recognizes `vim` global, Neovim runtime |
| `pylsp` | Python | Black formatter, pyflakes linter |
| `csharp_ls` | C# | Root markers for .sln files |
| `clangd` | C/C++ | |
| `gopls` | Go | |
| `intelephense` | PHP | |
| `dockerls` | Dockerfile | |
| `ltex` | LaTeX/Markdown | Prose linting (en-GB) |

## Keybindings

**Leader key:** `Space`

### General

| Key | Mode | Action |
|-----|------|--------|
| `<leader>b` | Normal | Toggle file tree (NvimTree with dev, netrw without) |
| `<leader>n` | Normal | Clear search highlighting |
| `<leader>jq` | Normal | Format buffer as JSON (via jq) |
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>p` | Normal/Visual | Paste from system clipboard |

### Window Navigation

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+h` | Normal | Move to left split |
| `Ctrl+j` | Normal | Move to bottom split |
| `Ctrl+k` | Normal | Move to top split |
| `Ctrl+l` | Normal | Move to right split |

### Location List

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ll` | Normal | Open location list |
| `<leader>lq` | Normal | Close location list |
| `<leader>ln` / `<leader>lp` | Normal | Next / previous item |
| `<leader>lo` / `<leader>lN` | Normal | Older / newer location list |
| `<leader>ld` | Normal | Current-buffer diagnostics to location list |

### Quickfix List

| Key | Mode | Action |
|-----|------|--------|
| `<leader>qo` / `<leader>qc` | Normal | Open / close quickfix list |
| `<leader>qn` / `<leader>qp` | Normal | Next / previous item |
| `<leader>qd` | Normal | Workspace diagnostics to quickfix list |

### Telescope (Fuzzy Finder)

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+p` / `<leader>ff` | Normal | Find files (includes hidden) |
| `<leader>gf` | Normal | Find Git files |
| `Ctrl+f` / `<leader>fg` | Normal | Live grep |
| `<leader>fw` | Normal | Grep word under cursor |
| `<leader>fb` | Normal | Find open buffers |
| `<leader>fo` | Normal | Find recently opened files |
| `<leader>fh` | Normal | Find help tags |
| `<leader>fr` | Normal | Interactive LSP references |
| `<leader>fm` | Normal | Marks |

Within a Telescope picker, `Ctrl+q` sends all results to quickfix and `Alt+q` sends selected results.

### LSP (active when LSP attached)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>d` / `<leader>D` | Normal | Go to definition / declaration |
| `<leader>i` / `<leader>t` | Normal | Go to implementation / type definition |
| `<leader>k` | Normal | Hover documentation |
| `<leader>r` / `<leader>lr` | Normal | References in quickfix / location list |
| `<leader>e` | Normal | Show diagnostic float |
| `[d` / `]d` | Normal | Previous / next diagnostic |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code actions |
| `<leader>f` | Normal | Format buffer |

### Completion (nvim-cmp)

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+n` | Insert | Select next item |
| `Ctrl+p` | Insert | Select previous item |
| `Ctrl+Space` | Insert | Trigger completion |
| `Ctrl+e` | Insert | Close completion menu |
| `Enter` | Insert | Confirm selection |

### Git (Fugitive)

| Key | Mode | Action |
|-----|------|--------|
| `gs` | Normal | Open Git status in new tab |

### Git Signs (active in git repos)

| Key | Mode | Action |
|-----|------|--------|
| `]c` / `[c` | Normal | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | Normal/Visual | Stage / reset hunk |
| `<leader>gS` | Normal | Stage buffer |
| `<leader>gu` | Normal | Undo staged hunk |
| `<leader>gp` | Normal | Preview hunk |
| `<leader>gb` / `<leader>gbt` | Normal | Blame line / toggle inline blame |
| `ih` | Visual/Operator | Select hunk (text object) |

## Directory Structure

```
nvim/
├── init.lua                    # Entry point: remap, set, then lua/dev or retrobox   (common)
├── lazy-lock.json              # Plugin version lockfile                             (dev)
├── lua/
│   ├── base/                                                                         (common)
│   │   ├── set.lua             # vim.opt settings
│   │   └── remap.lua           # Global keymaps
│   ├── dev/                                                                          (dev)
│   │   ├── init.lua            # Loads lazy; configures nvim-tree, gruvbox
│   │   └── lazy.lua            # Plugin definitions
│   └── lsp/                                                                          (dev)
│       ├── init.lua            # Shared LSP capabilities
│       ├── lua_ls.lua          # Lua LSP config
│       ├── pylsp.lua           # Python LSP config
│       ├── csharp_ls.lua       # C# LSP config
│       ├── ltex.lua            # LaTeX LSP config
│       └── cucumber_language_server.lua
└── after/plugin/                                                                    (dev)
    ├── lsp.lua                 # Mason setup, LspAttach keymaps
    ├── cmp.lua                 # Completion config
    ├── telescope.lua           # Telescope keymaps
    ├── gitsigns.lua            # Gitsigns config
    └── fugitive.lua            # Fugitive keymaps
```

## Adding a New LSP Server

1. Add to `ensure_installed` list in `after/plugin/lsp.lua`
2. (Optional) Create `lua/lsp/<server_name>.lua` for custom settings
3. Run `:Mason` to install

Example custom config (`lua/lsp/myserver.lua`):
```lua
return {
    settings = {
        myserver = {
            someOption = true,
        },
    },
}
```

## Snippets

Uses Neovim's built-in `vim.snippet` (0.10+). No external snippet plugin needed.
