-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local lsp = vim.lsp
local map = vim.api.nvim_buf_set_keymap
local ion = vim.api.nvim_buf_set_option

-----------------------------------------------------------
-- Functions
-----------------------------------------------------------
local on_attach = function(client, bufnr)
    local opts = { noremap = true }

    ion(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    ion(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

    -- Configure keybindings for LSP
    map(bufnr, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    map(bufnr, 'n', 'gf', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map(bufnr, 'n', 'g=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

-----------------------------------------------------------
-- Servers
-----------------------------------------------------------
require('lspkind').init()

local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')

for server, config in pairs(lspinstall.installed_servers()) do
    config.on_attach = on_attach
    if server == 'elixirls' then
        config.settings = { elixirLS = { dialyzerEnabled = false } }
    end
    lspconfig[server].setup(config)
end

-----------------------------------------------------------
-- UI
-----------------------------------------------------------
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,                                      -- Disable displaying warnings / errors inline
  signs = true,                                              -- Display warning / errors signs next to the line number
  update_in_insert = false,                                  -- Wait with updating diagnostics for switch between modes
  underline = true,                                          -- Underline affected code
})
