-- ABOUTME: Shared LSP configuration - capabilities for nvim-cmp integration
-- ABOUTME: Individual server configs in separate files (e.g., lsp/pylsp.lua)

local M = {}

-- LSP capabilities for nvim-cmp integration
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

return M
