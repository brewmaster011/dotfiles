if not package.loaded.lazy then return end -- plugins not loaded: nvim older than 0.11 (init.lua)

-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "gs", ':tab Git<CR>', { desc = "Open Git status" })
