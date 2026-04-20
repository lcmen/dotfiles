-- vim:fileencoding=utf-8:foldmethod=marker

-- Neovim API aliases {{{
local call = vim.call
local cmd = vim.cmd
local g = vim.g
local fn = vim.fn
local lsp = vim.lsp
local map = vim.api.nvim_set_keymap
local merge = function(t1, t2) return vim.tbl_extend('force', t1, t2) end
local opt = vim.opt
local opts = { noremap = true, silent = true }
local user_cmd = vim.api.nvim_create_user_command
-- }}}

-- Packages {{{
    -- Install vim-plug if not present {{{
    local data_dir = fn.stdpath('data')
    local plug_path = fn.stdpath('data') .. '/site/autoload/plug.vim'
    if fn.filereadable(plug_path) ~= 1 then
        print('Installing vim-plug')
        fn.system({'curl', '-fLo', plug_path, '--create-dirs', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'})
        print('Installing all plugins')
        cmd([[autocmd VimEnter * PlugInstall --sync | source $MYVIMRC]])
    end
    -- }}}

    -- Plugins {{{
    call('plug#begin', '~/.local/share/nvim/plugged')

    local Plug = fn['plug#']
    Plug('AndrewRadev/sideways.vim')
    Plug('AndrewRadev/splitjoin.vim')
    Plug('airblade/vim-gitgutter')
    Plug('christoomey/vim-tmux-navigator')
    Plug('docunext/closetag.vim')
    Plug('github/copilot.vim')
    Plug('ibhagwan/fzf-lua')
    Plug('lcmen/rational.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('ryanoasis/vim-devicons')
    Plug('scrooloose/nerdtree')
    Plug('sheerun/vim-polyglot')
    Plug('sonph/onehalf', { ['rtp'] = 'vim' })
    Plug('tpope/vim-commentary')
    Plug('tpope/vim-projectionist')
    Plug('tpope/vim-repeat')
    Plug('tpope/vim-surround')
    Plug('tpope/vim-unimpaired')
    Plug('troydm/zoomwintab.vim')

    call('plug#end')
    -- }}}
-- }}}

-- Settings {{{
    -- General {{{
    g.mapleader = " "                                            -- Change leader to space
    opt.spell = false                                            -- Spell checking off
    -- }}}

    -- Whitespaces {{{
    opt.wrap = false                                             -- Disable line wraping
    opt.textwidth = 120                                          -- Set max width to 120 characters
    -- }}}

    -- UI {{{
    cmd[[colorscheme onehalflight]]
    opt.relativenumber = true                                    -- Use relative line numbers
    opt.termguicolors = false                                    -- Disable true colors for compatibility with Tmux
    --}}}
-- }}}

-- Packages configuration {{{
    -- FZF {{{
    fzf = require('fzf-lua')
    fzf.setup({
        actions = {
            files = {
                true,                                            -- inherit defaults
                ['ctrl-s'] = false,                              -- Disable ctrl-s (tmux prefix conflict)
                ['ctrl-x'] = fzf.actions.file_split,             -- Override ctrl-s with ctrl-x for splits
            },
        },
        fzf_opts = {
            ['--no-scrollbar'] = '',
            ['--no-separator'] = '',
            ['--gutter'] = ' ',
            ['--padding'] = '1,2',
        },
        winopts = { backdrop = false, width = 0.85, height = 0.85, preview = { layout = 'vertical' } },
    })
    map("n", "<C-b>", "<cmd>FzfLua buffers<CR>", opts)           -- Launch FZF for Buffers
    map("n", "<C-g>", "<cmd>FzfLua git_status<CR>", opts)        -- Launch FZF for changed files (git diff)
    map("n", "<C-p>", "<cmd>FzfLua files<CR>", opts)             -- Launch FZF for Files
    map("n", "<C-y>", "<cmd>FzfLua live_grep<CR>", opts)         -- Launch FZF for live grep; use -- glob then Ctrl+G for fuzzy
    -- }}}

    -- NerdTREE {{{
    g.NERDTreeShowHidden = 1                                     -- Show hidden files on NERDTree
    map('n', '<C-e>', ':NERDTreeToggle<CR>', opts)               -- Toggle NERDTree
    map('n', '<leader>e', ':NERDTreeFind<CR>', opts)             -- Focus current buffer in NERDTree
    -- }}}

    -- Sideways & Splitjoin {{{
    map('n', '<leader>rh', ':SidewaysLeft<cr>', opts)            -- Move arguments left
    map('n', '<leader>rl', ':SidewaysRight<cr>', opts)           -- Move argument right
    map('n', '<leader>rj', ':SplitjoinJoin<cr>', opts)           -- Join block
    map('n', '<leader>rk', ':SplitjoinSplit<cr>', opts)          -- Split block
    -- }}}

    -- Tmux Navigator {{{
    g.tmux_navigator_no_mappings = 1
    map('n', '<C-h>', ':TmuxNavigateLeft<CR>', opts)             -- Move to the left pane
    map('n', '<C-j>', ':TmuxNavigateDown<CR>', opts)             -- Move to the bottom pane
    map('n', '<C-k>', ':TmuxNavigateUp<CR>', opts)               -- Move to the top pane
    map('n', '<C-l>', ':TmuxNavigateRight<CR>', opts)            -- Move to the right pane
    map('t', '<C-h>', '<C-\\><C-N>:TmuxNavigateLeft<CR>', opts)  -- Move to the left pane in terminal
    map('t', '<C-j>', '<C-\\><C-N>:TmuxNavigateDown<CR>', opts)  -- Move to the bottom pane in terminal
    map('t', '<C-k>', '<C-\\><C-N>:TmuxNavigateUp<CR>', opts)    -- Move to the top pane in terminal
    map('t', '<C-l>', '<C-\\><C-N>:TmuxNavigateRight<CR>', opts) -- Move to the right pane in terminal
    -- }}
-- }}}

-- LSP {{{
    local lsp_on_attach = function(client, bufnr)
        local map = vim.api.nvim_buf_set_keymap
        local ion = vim.api.nvim_buf_set_option
        local opts = { noremap = true }

        -- Configure keybindings for LSP
        map(bufnr, 'n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        map(bufnr, 'n', 'gf', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        map(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        map(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        map(bufnr, 'n', 'gR', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        map(bufnr, 'n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        map(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    end

    local lspconfig = require('lspconfig')

    -- LSP servers {{{
    lsp.config('*', { on_attach = lsp_on_attach })
    lsp.config('eslint', { on_attach = lsp_on_attach })
    lsp.config('ruby_lsp', { on_attach = lsp_on_attach })
    lsp.config('ts_ls', { on_attach = lsp_on_attach })

    lsp.enable('eslint')                                     -- npm -g install vscode-langservers-extracted
    lsp.enable('ruby_lsp')                                   -- gem install ruby_lsp
    lsp.enable('ts_ls')                                      -- npm -g install typescript-language-server
    -- Configure gitgutter to not conflict with LSP signs
    g.gitgutter_sign_priority = 9                                -- Lower priority than diagnostics (default 10)
-- }}}

-- Bindings {{{
    map('n', '<leader>R', ':source ~/.config/nvim/init.lua<CR>', {})

    map('n', ',', ':', { noremap = true })                       -- Alias ':' to ','
    map('n', '<leader><leader>', ':b#<CR>', opts)                -- Quickly switch between buffers
    map('n', 'x', ':cclose<CR>:lclose<CR>:pclose<CR>', opts)     -- Close location, quickfix list with single keystroke

    map('n', '<leader>p', ':let @+=expand("%")<CR>', opts)       -- Copy buffer's relative path to clipboard
    map('n', '<leader>P', ':let @+=expand("%:p")<CR>', opts)     -- Copy buffer's absolute path to clipboard

    map('n', '[g', 'gT', opts)                                   -- Move to tab on the left
    map('n', ']g', 'gt', opts)                                   -- Move to tab on the right

    map('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>', opts) -- Show line diagnostic
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts) -- Move prev / next diagnostic errors
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- }}}

-- Commands {{{
    -- Abbreviations {{{
    cmd [[cnoreabbrev rg Rg]]                                    -- Alias rg to Rg
    cmd [[cnoreabbrev rgc Rgword]]                               -- Alias rgc to Rgword
    cmd [[cnoreabbrev rgC RgWord]]                               -- Allow rgC to RgWord
    -- }}}

    -- Greps {{{
    -- Override default --nth (3..) to search based on the path (--nth 1..) instead of the content
    local grep_opts = { fzf_opts = { ['--nth'] = '1..' } }
    user_cmd('Rg', function(opts) fzf.grep_project(merge(grep_opts, { search = opts.args })) end, { nargs = '*' })
    user_cmd('Rgword', function() fzf.grep_cword(grep_opts) end, {})
    user_cmd('RgWord', function() fzf.grep_cWORD(grep_opts) end, {})
    -- }}}

    -- File type settings {{{
    cmd [[
        augroup LangSettings
            autocmd!
            autocmd Filetype gitcommit setl spell textwidth=72
            autocmd Filetype go setl softtabstop=4 shiftwidth=4 noexpandtab
            autocmd Filetype markdown setl spell wrap suffixesadd=.md
            autocmd BufEnter term://* startinsert
        augroup END
    ]]
    -- }}
-- }}}
