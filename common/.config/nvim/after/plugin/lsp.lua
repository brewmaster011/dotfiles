-- ABOUTME: LSP setup using Mason, mason-lspconfig, and nvim-lspconfig
-- ABOUTME: Uses automatic_enable for installed servers, keymaps via LspAttach autocmd

-- Setup Mason first
require("mason").setup()

-- mason-lspconfig handles automatic enabling of installed servers
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "csharp_ls",
        "intelephense",
        "dockerls",
        "ltex",
        "pylsp",
        "clangd",
        "gopls",
    },
    -- Automatically enable installed servers via vim.lsp.enable()
    automatic_enable = true,
})

-- Load shared LSP config (capabilities)
local lsp = require("lsp")

-- Apply global defaults to all LSP servers
vim.lsp.config("*", {
    capabilities = lsp.capabilities,
})

-- Load any custom per-server configs from lua/lsp/<server>.lua
local lsp_config_path = vim.fn.stdpath("config") .. "/lua/lsp"
local files = vim.fn.glob(lsp_config_path .. "/*.lua", false, true)

for _, file in ipairs(files) do
    local server_name = vim.fn.fnamemodify(file, ":t:r")
    -- Skip init.lua (that's our shared config)
    if server_name ~= "init" then
        local ok, custom_config = pcall(require, "lsp." .. server_name)
        if ok and custom_config then
            vim.lsp.config(server_name, custom_config)
        end
    end
end

-- Set up keymaps when LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-keymaps", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, remap = false }
        local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
        end

        map("<leader>d", vim.lsp.buf.definition, "Go to definition")
        map("<leader>D", vim.lsp.buf.declaration, "Go to declaration")
        map("<leader>i", vim.lsp.buf.implementation, "Go to implementation")
        map("<leader>t", vim.lsp.buf.type_definition, "Go to type definition")
        map("<leader>k", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>r", vim.lsp.buf.references, "Find references in quickfix list")
        map("<leader>lr", function() vim.lsp.buf.references(nil, { loclist = true }) end, "Find references in location list")
        map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")

        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
        map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
    end,
})
