-- ABOUTME: The dev package's half of the nvim config, loaded by common's init.lua:
-- ABOUTME: lazy.nvim and its plugins; their setup is in after/plugin and lua/lsp

require("dev.lazy")

-- nvim-tree advises disabling netrw before anything loads; by now lazy.nvim's
-- setup has already sourced the runtime plugins, so these only stop netrw from
-- loading again (unchanged from before; moving them up would change behaviour)
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
