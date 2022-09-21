-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt

-----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.g.mapleader = " "                                        -- Change leader to space

opt.clipboard = 'unnamedplus'                                -- Use System clipboard
opt.mouse = 'a'                                              -- Enable mouse support
opt.swapfile = false                                         -- No swapfile
opt.scrolloff = 5                                            -- Start scrolling 5 lines away from margin
opt.sidescrolloff = 15                                       -- Start scrolling 15 lines away from side margin
opt.spell = false                                            -- Spell checking off
opt.splitbelow = true                                        -- Split below
opt.splitright = true                                        -- Split on the right side
opt.completeopt = { 'menu', 'menuone', 'noselect' }          -- Don't select completion menu

-----------------------------------------------------------
-- Whitespaces
-----------------------------------------------------------
opt.wrap = false
opt.linebreak = true
opt.expandtab = true                                         -- Indent with spaces
opt.list = true                                              -- Show invisible characters
opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
opt.softtabstop = 2                                          -- Number of spaces per <tab> when inserting
opt.shiftwidth = 2                                           -- Number of spaces per <tab> when indenting
opt.tabstop = 4                                              -- Number of spaces <tab> counts for
opt.textwidth = 120

-----------------------------------------------------------
-- Search
-----------------------------------------------------------
opt.incsearch = true                                         -- Enable incremental search
opt.ignorecase = true                                        -- Ignore case when searching
opt.smartcase = true                                         -- unless there is a capital letter in the query

-----------------------------------------------------------
-- Backups
-----------------------------------------------------------
opt.backup = false                                           --  Disable backup
opt.writebackup = false

-----------------------------------------------------------
-- UI
-------------------------------------------------------
vim.cmd[[colorscheme onehalflight]]
opt.cursorline = true                                        -- Show cursor line
opt.laststatus = 2                                           -- Show status line
opt.number = true                                            -- Show line numbers
opt.relativenumber = true                                    -- Use relative line numbers
