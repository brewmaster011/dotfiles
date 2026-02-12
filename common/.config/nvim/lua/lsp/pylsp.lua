-- ABOUTME: Python LSP configuration with black formatter and pyflakes
-- ABOUTME: Disables pycodestyle to avoid duplicate linting

return {
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                pyflakes = { enabled = true },
                pycodestyle = { enabled = false },
            },
        },
    },
}
