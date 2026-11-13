-- ABOUTME: The dev package's half of the nvim config, loaded by common's init.lua:
-- ABOUTME: lazy.nvim and its plugins; their setup is in after/plugin and lua/lsp

require("dev.lazy")

-- disable netrw (nvim-tree replaces it); still before the plugin/ scripts load
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Indenting
vim.cmd [[highlight IndentBlankLineContextChar guifg=#d3d3d3 gui=nocombine]]

-- empty setup using defaults
require("nvim-tree").setup({
    view = {
        width = 45,
        side = "left",
    },
})

-- File tree (common maps <leader>b to netrw for machines without dev)
vim.keymap.set("n", "<leader>b", vim.cmd.NvimTreeToggle, { desc = "Toggle file tree" })

vim.cmd([[colorscheme gruvbox]])
