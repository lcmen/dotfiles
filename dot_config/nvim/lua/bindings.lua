-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-----------------------------------------------------------
-- Key bindings
-----------------------------------------------------------
map('n', '<leader>R', ':source ~/.config/nvim/init.lua<CR>', {})

map('n', ',', ':', { noremap = true })                   -- Alias ':' to ','
map('n', '<leader><leader>', ':b#<CR>', opts)            -- Quickly switch between buffers
map('n', 'va', 'ggVG', opts)                             -- Select all text
map('n', '/', ':set hlsearch<cr>/', opts)                -- Enable hlserch on search start
map('n', '<leader><cr>', ':noh<cr>', opts)               -- Disable hl
map('n', 'x', ':cclose<CR>:lclose<CR>:pclose<CR>', opts) -- Close location, quickfix list with single keystroke

map('n', '<leader>p', ':let @+=expand("%")<CR>', opts)   -- Copy buffer's relative path to clipboard
map('n', '<leader>P', ':let @+=expand("%:p")<CR>', opts) -- Copy buffer's absolute path to clipboard

map('n', 'k', 'gk', { silent = true })                   -- Move more sensibly when line wrapping enabled
map('n', 'j', 'gj', { silent = true })

map('v', '<', '<gv', opts)                               -- Move block of codes left
map('v', '>', '>gv', opts)                               -- and right

map('n', '[g', 'gT', opts)                               -- Move tab left
map('n', ']g', 'gt', opts)                               -- and right

map('n', 'D', 'd$', opts)                                -- Delete to the end of line
map('n', 'Y', 'y$', opts)                                -- Yank to the end of line

-----------------------------------------------------------
-- Plugins Key bindings
-----------------------------------------------------------
map('n', '<C-e>', ':NERDTreeToggle<CR>', opts)          -- Toggle NERDTree
map('n', '<leader>e', ':NERDTreeFind<CR>', opts)        -- Focus current buffer in NERDTree

map('n', '<leader>t.', ':TestLast<CR>', opts)           -- Re-run last test
map('n', '<leader>ta', ':TestSuite<CR>', opts)          -- Test the whole suite
map('n', '<leader>tf', ':TestFile<CR>', opts)           -- Test current file
map('n', '<leader>tt', ':TestNearest<CR>', opts)        -- Test nearest code

map('n', '<leader>rh', ':SidewaysLeft<cr>', opts)       -- Move arguments left
map('n', '<leader>rl', ':SidewaysRight<cr>', opts)      -- Move argument right
map('n', '<leader>rj', ':SplitjoinJoin<cr>', opts)      -- Join block
map('n', '<leader>rk', ':SplitjoinSplit<cr>', opts)     -- Split block
