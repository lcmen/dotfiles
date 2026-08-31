-- vim:fileencoding=utf-8:foldmethod=marker

-- Neovim API aliases {{{
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local diag = vim.diagnostic
local g = vim.g
local lsp = vim.lsp
local map = vim.keymap.set
local opt_local = vim.opt_local
local opts = { silent = true }
local user_cmd = vim.api.nvim_create_user_command
-- }}}

-- Bootstrap {{{
    g.mapleader = " "                                                            -- Change leader to space

    -- Plugins {{{
    -- Managed by vim.pack (:h vim.pack); missing plugins are cloned on startup
    --   Update: PackUpdate [name...] -- opens a tab to review; :w applies, :q discards
    --   Cleanup: delete the source below, restart, then PackClean
    --   Orphans: PackOrphans
    local gh = function(repo) return 'https://github.com/' .. repo end

    vim.pack.add({
        gh('AndrewRadev/sideways.vim'),
        gh('AndrewRadev/splitjoin.vim'),
        gh('airblade/vim-gitgutter'),
        gh('docunext/closetag.vim'),
        gh('ibhagwan/fzf-lua'),
        gh('lcmen/rational.nvim'),
        gh('neovim/nvim-lspconfig'),
        gh('ryanoasis/vim-devicons'),
        gh('scrooloose/nerdtree'),
        gh('sheerun/vim-polyglot'),
        gh('tpope/vim-projectionist'),
        gh('tpope/vim-repeat'),
        gh('tpope/vim-surround'),
        gh('tpope/vim-unimpaired'),
        gh('troydm/zoomwintab.vim'),
    })
    -- }}}
-- }}}

-- Settings {{{
    cmd.colorscheme('onehalflight')
-- }}}

-- Packages configuration {{{
    -- FZF {{{
    local fzf = require('fzf-lua')
    fzf.setup({
        actions = {
            files = {
                true,                                                            -- inherit defaults
                ['ctrl-v'] = fzf.actions.file_vsplit,                            -- Open selection in a vertical split
                ['ctrl-x'] = fzf.actions.file_split,                             -- Open selection in a horizontal split
            },
        },
        buffers = {
            actions = {
                ['ctrl-x'] = fzf.actions.file_split,                             -- Horizontal split (override default buf_del)
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
    map('n', '<C-b>', fzf.buffers, opts)                                         -- Launch FZF for Buffers
    map('n', '<C-g>', fzf.git_status, opts)                                      -- Launch FZF for changed files (git diff)
    map('n', '<C-p>', fzf.files, opts)                                           -- Launch FZF for Files
    map('n', '<C-y>', fzf.live_grep, opts)                                       -- Launch FZF for live grep; use -- glob then Ctrl+G for fuzzy
    -- }}}

    -- GitGutter {{{
    g.gitgutter_sign_priority = 9                                                -- Lower priority than LSP diagnostics (default 10) to avoid conflicts
    -- }}}

    -- NerdTREE {{{
    g.NERDTreeShowHidden = 1                                                     -- Show hidden files on NERDTree
    map('n', '<C-e>', '<cmd>NERDTreeToggle<CR>', opts)                           -- Toggle NERDTree
    map('n', '<leader>e', '<cmd>NERDTreeFind<CR>', opts)                         -- Focus current buffer in NERDTree
    -- }}}

    -- Sideways & Splitjoin {{{
    map('n', '<leader>rh', '<cmd>SidewaysLeft<CR>', opts)                        -- Move arguments left
    map('n', '<leader>rl', '<cmd>SidewaysRight<CR>', opts)                       -- Move argument right
    map('n', '<leader>rj', '<cmd>SplitjoinJoin<CR>', opts)                       -- Join block
    map('n', '<leader>rk', '<cmd>SplitjoinSplit<CR>', opts)                      -- Split block
    -- }}}
-- }}}

-- LSP {{{
    -- Buffer-local keybindings for every attached server (K is a Neovim default)
    autocmd('LspAttach', {
        group = augroup('LspBindings', { clear = true }),
        callback = function(event)
            local buf_opts = { buffer = event.buf, silent = true }

            map('n', 'ga', lsp.buf.code_action, buf_opts)
            map('n', 'gf', lsp.buf.definition, buf_opts)
            map('n', 'gi', lsp.buf.implementation, buf_opts)
            map('n', 'gr', lsp.buf.references, buf_opts)
            map('n', 'gR', lsp.buf.rename, buf_opts)
            map('n', 'gt', lsp.buf.type_definition, buf_opts)
        end,
    })

    lsp.enable('eslint')                                                         -- npm -g install vscode-langservers-extracted
    lsp.enable('ruby_lsp')                                                       -- gem install ruby_lsp
    lsp.enable('ts_ls')                                                          -- npm -g install typescript-language-server
-- }}}

-- Bindings {{{
    local rational = require('rational')

    map('n', '<leader>R', '<cmd>source $MYVIMRC<CR>', opts)                      -- Reload config

    map('n', ';', ':')                                                           -- Alias ';' to ':'
    map('n', '[g', 'gT', opts)                                                   -- Move to tab on the left
    map('n', ']g', 'gt', opts)                                                   -- Move to tab on the right
    map('n', '[d', function() diag.jump({ count = -1, float = true }) end, opts) -- Move prev / next diagnostic errors
    map('n', ']d', function() diag.jump({ count = 1, float = true }) end, opts)

    map('n', '<leader><leader>', '<cmd>b#<CR>', opts)                            -- Quickly switch between buffers
    map('n', '<leader>p', function() rational.copy_path(false, false) end, opts) -- Copy buffer's relative path to clipboard
    map('n', '<leader>P', function() rational.copy_path(true, false) end, opts)  -- Copy buffer's absolute path to clipboard
    map('x', '<leader>p', function() rational.copy_path(false, true) end, opts)  -- Copy relative path with selected lines to clipboard
    map('x', '<leader>P', function() rational.copy_path(true, true) end, opts)   -- Copy absolute path with selected lines to clipboard
    map('n', 'x', '<cmd>cclose<CR><cmd>lclose<CR><cmd>pclose<CR>', opts)         -- Close location, quickfix list with single keystroke
    map('n', 'L', diag.open_float, opts)                                         -- Show line diagnostic
-- }}}

-- Commands {{{
    -- Abbreviations {{{
    cmd [[cnoreabbrev rg Rg]]                                                    -- Alias rg to Rg
    cmd [[cnoreabbrev rgc Rgword]]                                               -- Alias rgc to Rgword
    cmd [[cnoreabbrev rgC RgWord]]                                               -- Allow rgC to RgWord
    -- }}}

    -- Greps {{{
    -- Override default --nth (3..) to search based on the path (--nth 1..) instead of the content
    local grep_opts = { fzf_opts = { ['--nth'] = '1..' } }
    user_cmd('Rg', function(args) fzf.grep_project(vim.tbl_extend('force', grep_opts, { search = args.args })) end, { nargs = '*' })
    user_cmd('Rgword', function() fzf.grep_cword(grep_opts) end, {})
    user_cmd('RgWord', function() fzf.grep_cWORD(grep_opts) end, {})
    -- }}}

    -- File type settings {{{
    local lang = augroup('LangSettings', { clear = true })

    autocmd('FileType', { group = lang, pattern = 'gitcommit', callback = function()
        opt_local.spell = true
        opt_local.textwidth = 72
    end })

    autocmd('FileType', { group = lang, pattern = 'go', callback = function()
        opt_local.softtabstop = 4
        opt_local.shiftwidth = 4
        opt_local.expandtab = false
    end })

    autocmd('FileType', { group = lang, pattern = 'markdown', callback = function()
        opt_local.spell = true
        opt_local.wrap = true
        opt_local.suffixesadd = '.md'
    end })
    -- }}}
-- }}}
