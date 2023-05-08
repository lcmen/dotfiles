local fn = vim.fn
local map = vim.api.nvim_set_keymap
local util = require('zk.util')
local o = vim.opt

o.conceallevel = 2
o.spell = true
o.suffixesadd = '.md'
o.wrap = true

if util.notebook_root(fn.expand('%:p')) ~= nil then
  local opts = { noremap = true }

  map('n', 'g0', '<Cmd>ZkLinks<CR>', opts)
  map('n', 'gf', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'gr', '<Cmd>ZkBacklinks<CR>', opts)
  map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map('n', '<c-p>', '<cmd>ZkNotes<CR>', opts)
end
