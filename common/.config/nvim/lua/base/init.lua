require("base.remap")
require("base.set")
require("base.lazy")

-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
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
