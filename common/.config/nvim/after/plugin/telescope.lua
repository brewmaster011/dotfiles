-- ABOUTME: Telescope keymaps for fuzzy finding files, grep, and LSP references
-- ABOUTME: Ctrl+p for files, Ctrl+f for grep, leader+fr for references

local builtin = require('telescope.builtin')

-- find_files with hidden files shown (for dotfiles)
local find_files_opts = { hidden = true }

vim.keymap.set('n', '<leader>ff', function() builtin.find_files(find_files_opts) end, {})
vim.keymap.set('n', '<C-p>', function() builtin.find_files(find_files_opts) end, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fm', builtin.marks, {})
