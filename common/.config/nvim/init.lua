-- ABOUTME: Neovim entry point: options and keymaps here (common, every machine),
-- ABOUTME: plugins only where the dev package adds lua/dev (lazy.nvim, LSP, ...)

require("base.remap")
require("base.set")
vim.o.background = "dark" -- or "light" for light mode

-- Without dev (a server) this is plain nvim: no plugins, nothing fetched at
-- startup, fine with Debian's nvim 0.10. retrobox is built in and gruvbox-like.
-- dev's plugins need 0.11+ (vim.lsp.config, nvim-treesitter main), so an older
-- nvim on a dev machine (Debian's /usr/bin/nvim next to a newer one in
-- ~/.local/bin, e.g. under sudo) gets the plain setup too, with a notice.
local has_dev = vim.uv.fs_stat(vim.fn.stdpath("config") .. "/lua/dev/init.lua") ~= nil
if has_dev and vim.fn.has("nvim-0.11") == 1 then
    require("dev")
else
    if has_dev then
        -- after startup and short, so it never needs a hit-enter
        vim.schedule(function()
            vim.notify("dev's plugins need nvim 0.11+: loaded without them", vim.log.levels.WARN)
        end)
    end
    vim.cmd.colorscheme("retrobox")
end
