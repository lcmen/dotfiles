-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader = " "                     -- Change leader to space

if fn.has('macunix') then
  opt.clipboard = 'unnamed'
else
  opt.clipboard = 'unnamedplus'
end
opt.mouse = 'a'                       -- Enable mouse support
opt.swapfile = false                  -- No swapfile
opt.scrolloff = 5                     -- Start scrolling 5 lines away from margin
opt.sidescrolloff = 15                -- Start scrolling 15 lines away from side margin
opt.spell = false                     -- Spell checking off
opt.splitbelow = true                 -- Split below
opt.splitright = true                 -- Split on the right side

-----------------------------------------------------------
-- Whitespaces
-----------------------------------------------------------
opt.wrap = false
opt.linebreak = true
opt.expandtab = true                  -- Indent with spaces
opt.list = true                       -- Show invisible characters
opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
opt.softtabstop = 2                   -- Number of spaces per <tab> when inserting
opt.shiftwidth = 2                    -- Number of spaces per <tab> when indenting
opt.tabstop = 4                       -- Number of spaces <tab> counts for
opt.textwidth = 120

-----------------------------------------------------------
-- Search
-----------------------------------------------------------
g.ctrlp_use_caching = 0               -- Disable caching for CtrlP and use ripgrep
g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
opt.incsearch = true                  --  Enable incremental search
opt.ignorecase = true                 -- Ignore case when searching
opt.smartcase = true                  -- unless there is a capital letter in the query

-----------------------------------------------------------
-- Backups
-----------------------------------------------------------
opt.backup = false                    --  Disable backup
opt.writebackup = false
opt.undofile = true                   -- Enable undo file
opt.undodir = fn.stdpath('config') .. '/nvim/tmp/undo/'
opt.undolevels = 1000                 -- Maximum number of changes that can be undone
opt.undoreload = 10000                -- Maximum number lines to save for undo on a buffer reload

-----------------------------------------------------------
-- UI
-----------------------------------------------------------
cmd [[colorscheme onehalflight]]
opt.cursorline = true                 -- Show cursor line
opt.laststatus = 2                    -- Show status line
opt.number = true                     -- Show line numbers
opt.relativenumber = true             -- Use relative line numbers
