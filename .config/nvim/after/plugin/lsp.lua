
local lsp = require('lsp-zero')
-- lsp.preset('recommended')
lsp.nvim_workspace()

local on_attach = function (client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "<leader>d", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>k", function() vim.lsp.buf.hover() end, opts)
    -- vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>i", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)

    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
end

local lspconfig = require("lspconfig")

lspconfig.csharp_ls.setup({
    lsp.csharp_ls,
    root_dir = function(startpath)
        return lspconfig.util.root_pattern("*.sln")(startpath)
            or lspconfig.util.root_pattern("*.csproj")(startpath)
            or lspconfig.util.root_pattern("*.fsproj")(startpath)
            or lspconfig.util.root_pattern(".git")(startpath)
    end,
    on_attach = on_attach,
})

lspconfig.intelephense.setup({
    lsp.intelephense,
    on_attach = on_attach,
})

lspconfig.spectral.setup({
    lsp.spectral,
    on_attach = on_attach,
})

lspconfig.dockerls.setup({
    lsp.dockerls,
    on_attach = on_attach,
})

lspconfig.cucumber_language_server.setup({
    lsp.cucumber_language_server,
    settings = {
        features = { "**/*.feature" },
        glue = { "**/Steps/*.steps.cs", "**/Steps/*.step.cs" }
    },
    on_attach = on_attach,
})

lspconfig.ltex.setup({
    lsp.ltex,
    settings = {
        language = "en-GB",
    },
    on_attach = on_attach,
})

lspconfig.pylsp.setup({
    lsp.pylsp,
    on_attach = on_attach,
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                pyflakes = { enabled = true },
                pycodestyle = { enabled = false },
            },
        }
    },
})

lspconfig.clangd.setup({
    lsp.clang,
    on_attach = on_attach
})

lsp.setup()
