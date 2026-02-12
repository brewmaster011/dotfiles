-- ABOUTME: Plugin management using lazy.nvim
-- ABOUTME: Defines all plugins and their configurations

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
    -- Telescope, fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- LSP
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },

    -- Markdown rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
        config = function()
            require("render-markdown").setup({})
        end,
    },

    -- UI/Visual
    { "onsails/lspkind.nvim" },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
    { "ellisonleao/gruvbox.nvim" },

    -- Treesitter (new API - highlighting via vim.treesitter.start())
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            -- Install parsers for these languages
            require("nvim-treesitter").install({
                "c", "lua", "vim", "vimdoc", "query",
                "python", "c_sharp", "go", "php", "dockerfile",
                "markdown", "markdown_inline", "json", "yaml", "toml",
            })

            -- Enable treesitter highlighting for all supported filetypes
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context" },

    -- Git
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim" },
})
