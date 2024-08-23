-- Keyboard Remaps
vim.g.mapleader = " "

-- NerdTree
vim.keymap.set("n", "<leader>b", vim.cmd.NvimTreeToggle)

-- Telescope
vim.keymap.set("n", "<leader>m", ":Telescope marks<CR>")

-- Move between splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Yank and Paste to system clipboard
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>p", '"+p')

-- Location List
vim.keymap.set("n", "<leader>ll", ":lopen<CR>")
vim.keymap.set("n", "<leader>lq", ":lclose<CR>")
vim.keymap.set("n", "<leader>ln", ":lnext<CR>")
vim.keymap.set("n", "<leader>lp", ":lprevious<CR>")
vim.keymap.set("n", "<leader>lo", ":lolder<CR>")
vim.keymap.set("n", "<leader>ln", ":lnewer<CR>")

-- Misc
vim.keymap.set("n", "<leader>jq", ":%!jq<CR>")
vim.keymap.set("n", "<leader>n", ":noh<CR>")
