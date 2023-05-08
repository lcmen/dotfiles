local map = vim.api.nvim_set_keymap
local opts = { noremap = true }

-- Fix Rubocop, Reeek, Standard whatever linter is used
map('n', 'g=', '<Cmd>lua vim.lsp.buf.format({ timeout_ms = 20000 })<CR>', opts)
