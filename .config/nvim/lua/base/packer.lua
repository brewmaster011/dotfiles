-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Telescope, fuzzy finder
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},         -- Required
			{'hrsh7th/cmp-nvim-lsp'},     -- Required
			{'hrsh7th/cmp-buffer'},       -- Optional
			{'hrsh7th/cmp-path'},         -- Optional
			{'saadparwaiz1/cmp_luasnip'}, -- Optional
			{'hrsh7th/cmp-nvim-lua'},     -- Optional

			-- Snippets
			{'L3MON4D3/LuaSnip'},             -- Required
			{'rafamadriz/friendly-snippets'}, -- Optional
		}
	}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
	}
--    use {
--        's1n7ax/nvim-terminal',
--        config = function()
--            vim.o.hidden = true
--            require('nvim-terminal').setup()
--        end,
--    }
    --use {"ellisonleao/glow.nvim", config = function() require("glow").setup() end}
	use "BurntSushi/ripgrep"
	use "lukas-reineke/indent-blankline.nvim"
    -- use "puremourning/vimspector"
	use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use 'nvim-treesitter/nvim-treesitter-context'
	use ('mbbill/undotree')
	use ('tpope/vim-fugitive')
	use ("ellisonleao/gruvbox.nvim")
 -- Lua
    use {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }   
    use ('github/copilot.vim')
    use("eandrju/cellular-automaton.nvim")
--    use { "mfussenegger/nvim-dap", }
--    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
end)

