-- Keyboard Remaps
vim.g.mapleader = " "

-- File tree
vim.keymap.set("n", "<leader>b", vim.cmd.NvimTreeToggle, { desc = "Toggle file tree" })

-- Move between splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

-- Yank and paste to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Location list
vim.keymap.set("n", "<leader>ll", ":lopen<CR>", { desc = "Open location list" })
vim.keymap.set("n", "<leader>lq", ":lclose<CR>", { desc = "Close location list" })
vim.keymap.set("n", "<leader>ln", ":lnext<CR>", { desc = "Next location-list item" })
vim.keymap.set("n", "<leader>lp", ":lprevious<CR>", { desc = "Previous location-list item" })
vim.keymap.set("n", "<leader>lo", ":lolder<CR>", { desc = "Older location list" })
vim.keymap.set("n", "<leader>lN", ":lnewer<CR>", { desc = "Newer location list" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Quickfix list
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>qp", ":cprevious<CR>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>qd", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix list" })

-- Misc
vim.keymap.set("n", "<leader>jq", ":%!jq<CR>", { desc = "Format JSON with jq" })
vim.keymap.set("n", "<leader>n", ":noh<CR>", { desc = "Clear search highlight" })
