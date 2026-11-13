-- ABOUTME: Neovim entry point: options and keymaps here (common, every machine),
-- ABOUTME: plugins only where the dev package adds lua/dev (lazy.nvim, LSP, ...)

require("base.remap")
require("base.set")
vim.o.background = "dark" -- or "light" for light mode

-- Without dev (a server) this is plain nvim: no plugins, nothing fetched at
-- startup, fine with Debian's nvim 0.10. retrobox is built in and gruvbox-like.
if vim.uv.fs_stat(vim.fn.stdpath("config") .. "/lua/dev/init.lua") then
    require("dev")
else
    vim.cmd.colorscheme("retrobox")
end
