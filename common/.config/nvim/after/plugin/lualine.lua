-- ABOUTME: Lualine status line configuration
-- ABOUTME: Gruvbox theme with git, diagnostics, LSP status, and clock

local config = {
    options = {
        theme = 'gruvbox',
    },
    sections = {
        lualine_a = {
            'mode',
        },

        lualine_b = {
            'branch',
            'diff',
            {
                'diagnostics',
                always_visible = false,
            },
        },

        lualine_c = {
            'filename',
        },

        lualine_x = {
            'fileformat',
            {
                'filetype',
                icon_only = true,
            },
        },

        lualine_y = {
            {
                'lsp_status',
                symbols = {
                    separator = ' | ',
                },
            },
        },

        lualine_z = {
            'progress',
            'location',
            {
                'datetime',
                style = "%H:%M",
            },
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {
        'fugitive',
        'nvim-tree',
        'quickfix',
        'fzf',
        'mason',
    },
}

require("lualine").setup(config)
