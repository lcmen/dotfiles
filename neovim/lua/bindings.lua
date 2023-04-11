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

map('n', ',', ':', { noremap = true })                       -- Alias ':' to ','
map('n', '<leader><leader>', ':b#<CR>', opts)                -- Quickly switch between buffers
map('n', 'va', 'ggVG', opts)                                 -- Select all text
map('n', '/', ':set hlsearch<cr>/', opts)                    -- Enable hlserch on search start
map('n', '<leader><cr>', ':noh<cr>', opts)                   -- Disable hl
map('n', 'x', ':cclose<CR>:lclose<CR>:pclose<CR>', opts)     -- Close location, quickfix list with single keystroke

map('n', '<leader>p', ':let @+=expand("%")<CR>', opts)       -- Copy buffer's relative path to clipboard
map('n', '<leader>P', ':let @+=expand("%:p")<CR>', opts)     -- Copy buffer's absolute path to clipboard

map('n', 'k', 'gk', { silent = true })                       -- Move more sensibly when line wrapping enabled
map('n', 'j', 'gj', { silent = true })
map('v', '<', '<gv', opts)                                   -- Move block of codes left
map('v', '>', '>gv', opts)                                   -- and right
map('n', '[g', 'gT', opts)                                   -- Move tab left
map('n', ']g', 'gt', opts)                                   -- and right

map('n', 'D', 'd$', opts)                                    -- Delete to the end of line
map('n', 'Y', 'y$', opts)                                    -- Yank to the end of line

map('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>', opts) -- Show line diagnostic
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts) -- Move prev / next diagnostic errors
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-----------------------------------------------------------
-- Plugins Key bindings
-----------------------------------------------------------
function SetFZFBindings()
    local map = vim.api.nvim_buf_set_keymap
    local bufnr = vim.api.nvim_get_current_buf()
    map(bufnr, 't', '<C-f>', '<C-\\><C-n>:close<CR>:sleep 100m<CR>:Files<CR>', opts)
    map(bufnr, 't', '<C-b>', '<C-\\><C-n>:close<CR>:sleep 100m<CR>:Buffers<CR>', opts)
    map(bufnr, 't', '<C-l>', '<C-\\><C-n>:close<CR>:sleep 100m<CR>:BLines<CR>', opts)
end

map('n', '<C-e>', ':NERDTreeToggle<CR>', opts)               -- Toggle NERDTree
map('n', '<leader>e', ':NERDTreeFind<CR>', opts)             -- Focus current buffer in NERDTree

map('n', '<leader>t.', ':TestLast<CR>', opts)                -- Re-run last test
map('n', '<leader>ta', ':TestSuite<CR>', opts)               -- Test the whole suite
map('n', '<leader>tf', ':TestFile<CR>', opts)                -- Test current file
map('n', '<leader>tt', ':TestNearest<CR>', opts)             -- Test nearest code

map('n', '<leader>rf', ':Format<cr>', opts)                  -- Format file without save
map('n', '<leader>rF', ':FormatWrite<cr>', opts)             -- Format file and save changes
map('n', '<leader>rh', ':SidewaysLeft<cr>', opts)            -- Move arguments left
map('n', '<leader>rl', ':SidewaysRight<cr>', opts)           -- Move argument right
map('n', '<leader>rj', ':SplitjoinJoin<cr>', opts)           -- Join block
map('n', '<leader>rk', ':SplitjoinSplit<cr>', opts)          -- Split block

cmd [[autocmd FileType fzf lua SetFZFBindings()]]
