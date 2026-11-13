-- ABOUTME: Telescope keymaps for fuzzy finding files, grep, and LSP references
-- ABOUTME: Ctrl+p for files, Ctrl+f for grep, leader+fr for references

local builtin = require('telescope.builtin')

-- find_files with hidden files shown (for dotfiles)
local find_files_opts = { hidden = true }

vim.keymap.set('n', '<leader>ff', function() builtin.find_files(find_files_opts) end, { desc = 'Find files' })
vim.keymap.set('n', '<C-p>', function() builtin.find_files(find_files_opts) end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Find Git files' })
vim.keymap.set('n', '<C-f>', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Grep word under cursor' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Find recent files' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help tags' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Find marks' })
