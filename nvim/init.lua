-- vim:fileencoding=utf-8:foldmethod=marker

-- Neovim API aliases {{{
local call = vim.call
local cmd = vim.cmd
local diag = vim.diagnostic
local fn = vim.fn
local g = vim.g
local lsp = vim.lsp
local map = vim.keymap.set
local merge = function(t1, t2) return vim.tbl_extend('force', t1, t2) end
local opt = vim.opt
local opts = { silent = true }
local user_cmd = vim.api.nvim_create_user_command
-- }}}

-- Packages {{{
    -- Install vim-plug if not present {{{
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
    Plug('ibhagwan/fzf-lua')
    Plug('lcmen/rational.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('ryanoasis/vim-devicons')
    Plug('scrooloose/nerdtree')
    Plug('sheerun/vim-polyglot')
    Plug('sonph/onehalf', { ['rtp'] = 'vim' })
    Plug('tpope/vim-projectionist')
    Plug('tpope/vim-repeat')
    Plug('tpope/vim-surround')
    Plug('tpope/vim-unimpaired')
    Plug('troydm/zoomwintab.vim')

    call('plug#end')
    -- }}}
-- }}}

-- Settings {{{
    cmd.colorscheme('onehalflight')

    g.mapleader = " "                                            -- Change leader to space
    opt.relativenumber = true                                    -- Use relative line numbers
    opt.spell = false                                            -- Spell checking off
    opt.termguicolors = false                                    -- Disable true colors for compatibility with Tmux
    opt.textwidth = 120                                          -- Set max width to 120 characters
    opt.wrap = false                                             -- Disable line wrapping
-- }}}

-- Packages configuration {{{
    -- FZF {{{
    local fzf = require('fzf-lua')
    fzf.setup({
        actions = {
            files = {
                true,                                            -- inherit defaults
                ['ctrl-v'] = fzf.actions.file_vsplit,            -- Open selection in a vertical split
                ['ctrl-x'] = fzf.actions.file_split,             -- Open selection in a horizontal split
            },
        },
        buffers = {
            actions = {
                ['ctrl-x'] = fzf.actions.file_split,             -- Horizontal split (override default buf_del)
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
    map('n', '<C-b>', fzf.buffers, opts)                         -- Launch FZF for Buffers
    map('n', '<C-g>', fzf.git_status, opts)                      -- Launch FZF for changed files (git diff)
    map('n', '<C-p>', fzf.files, opts)                           -- Launch FZF for Files
    map('n', '<C-y>', fzf.live_grep, opts)                       -- Launch FZF for live grep; use -- glob then Ctrl+G for fuzzy
    -- }}}

    -- GitGutter {{{
    g.gitgutter_sign_priority = 9                                -- Lower priority than LSP diagnostics (default 10) to avoid conflicts
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
    -- }}}
-- }}}

-- LSP {{{
    local lsp_on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        -- Configure keybindings for LSP
        map('n', 'ga', lsp.buf.code_action, opts)
        map('n', 'gf', lsp.buf.definition, opts)
        map('n', 'gi', lsp.buf.implementation, opts)
        map('n', 'gr', lsp.buf.references, opts)
        map('n', 'gR', lsp.buf.rename, opts)
        map('n', 'gt', lsp.buf.type_definition, opts)
        map('n', 'K', lsp.buf.hover, opts)
    end

    lsp.config('*', { on_attach = lsp_on_attach })
    lsp.enable('eslint')                                     -- npm -g install vscode-langservers-extracted
    lsp.enable('ruby_lsp')                                   -- gem install ruby_lsp
    lsp.enable('ts_ls')                                      -- npm -g install typescript-language-server
-- }}}

-- Bindings {{{
    local function copy_path(absolute, ranged)                  -- Copy path to clipboard, optionally with selected range (e.g. init.lua:10-20)
        local path = fn.expand(absolute and '%:p' or '%')
        if ranged then
            local l1, l2 = fn.line('v'), fn.line('.')
            if l1 > l2 then l1, l2 = l2, l1 end
            path = path .. ':' .. (l1 == l2 and tostring(l1) or l1 .. '-' .. l2)
        end
        fn.setreg('+', path)
    end

    map('n', '<leader>R', ':source $MYVIMRC<CR>')

    map('n', ',', ':')                                           -- Alias ':' to ','
    map('n', '<leader><leader>', ':b#<CR>', opts)                -- Quickly switch between buffers
    map('n', 'x', ':cclose<CR>:lclose<CR>:pclose<CR>', opts)     -- Close location, quickfix list with single keystroke

    map('n', '<leader>p', function() copy_path(false, false) end, opts) -- Copy buffer's relative path to clipboard
    map('n', '<leader>P', function() copy_path(true, false) end, opts)  -- Copy buffer's absolute path to clipboard
    map('x', '<leader>p', function() copy_path(false, true) end, opts)  -- Copy relative path with selected lines to clipboard
    map('x', '<leader>P', function() copy_path(true, true) end, opts)   -- Copy absolute path with selected lines to clipboard

    map('n', '[g', 'gT', opts)                                   -- Move to tab on the left
    map('n', ']g', 'gt', opts)                                   -- Move to tab on the right

    map('n', 'L', diag.open_float, opts)                         -- Show line diagnostic
    map('n', '[d', function() diag.jump({ count = -1, float = true }) end, opts) -- Move prev / next diagnostic errors
    map('n', ']d', function() diag.jump({ count = 1, float = true }) end, opts)
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
    -- }}}
-- }}}
