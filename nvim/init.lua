-- vim:fileencoding=utf-8:foldmethod=marker

-- Neovim API aliases {{{
local call = vim.call
local cmd = vim.cmd
local g = vim.g
local fn = vim.fn
local lsp = vim.lsp
local map = vim.api.nvim_set_keymap
local opt = vim.opt
local opts = { noremap = true, silent = true }
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
    call('plug#begin', '~/.config/nvim/plugged')

    local Plug = fn['plug#']
    Plug('AndrewRadev/sideways.vim')
    Plug('AndrewRadev/splitjoin.vim')
    Plug('airblade/vim-gitgutter')
    Plug('christoomey/vim-tmux-navigator')
    Plug('coder/claudecode.nvim')
    Plug('docunext/closetag.vim')
    Plug('github/copilot.vim')
    Plug('junegunn/fzf')
    Plug('junegunn/fzf.vim')
    Plug('lcmen/rational.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('numtostr/BufOnly.nvim', { ['on'] = 'BufOnly' })
    Plug('onsails/lspkind-nvim')
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
    opt.clipboard = 'unnamedplus'                                -- Use System clipboard
    opt.spell = false                                            -- Spell checking off
    -- }}}

    -- Whitespaces {{{
    opt.wrap = false
    opt.textwidth = 120
    -- }}}

    -- Backups {{{
    opt.backup = false                                           --  Disable backup
    opt.writebackup = false
    -- }}}

    -- UI {{{
    cmd[[colorscheme onehalflight]]
    opt.relativenumber = true                                    -- Use relative line numbers
    --}}}
-- }}}

-- Packages configuration {{{
    -- BufOnly {{{
    g.bufonly_delete_non_modifiable = true                       -- Delete non-modifiable buffers
    -- }}}

    -- FZF {{{
    g.fzf_history_dir = '~/.local/share/fzf-history'
    map("n", "<C-p>", ":Files<CR>", opts)                       -- Launch FZF for Files
    map("n", "<C-\\>", ":Buffers<CR>", opts)                    -- Launch FZF for Buffers
    -- }}}

    -- NerdTREE {{{
    g.NERDTreeShowHidden = 1                                     -- Show hidden files on NERDTree

    map('n', '<C-e>', ':NERDTreeToggle<CR>', opts)               -- Toggle NERDTree
    map('n', '<leader>e', ':NERDTreeFind<CR>', opts)             -- Focus current buffer in NERDTree
    -- }}}

    -- ClaudeCode {{{
    require('claudecode').setup({})

    map("n", "<leader>cC", ":ClaudeCode<CR>", opts)
    map("n", "<leader>cc", ":ClaudeCodeFocus<CR>", opts)
    map("n", "<leader>cR", ":ClaudeCode --resume<CR>", opts)
    map("n", "<leader>cU", ":ClaudeCode --continue<CR>", opts)
    map("n", "<leader>ca", ":ClaudeCodeAdd %<CR>", opts)
    map("v", "<leader>ca", ":ClaudeCodeSend<CR>", opts)
    map("n", "do", ":ClaudeCodeDiffAccept<CR>", opts)
    map("n", "dp", ":ClaudeCodeDiffDeny<CR>", opts)
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

    require('lspkind').init()
    local lspconfig = require('lspconfig')

    -- LSP servers {{{
    lsp.config('*', { on_attach = lsp_on_attach })
    lsp.config('eslint', { on_attach = lsp_on_attach })
    lsp.config('ruby_lsp', {
        -- Detect formatter and linter (standard or rubocop)
        init_options = (function()
            local cwd = fn.getcwd()
            if fn.filereadable(cwd .. '/.standard.yml') == 1 then
                return { formatter = 'standard', linters = { 'standard' } }
            elseif fn.filereadable(cwd .. '/.rubocop.yml') == 1 then
                return { formatter = 'rubocop', linters = { 'rubocop' } }
            else
                return { formatter = 'auto', linters = { 'auto' } }
            end
        end)(),
        on_attach = lsp_on_attach,
    })
    lsp.config('ts_ls', { on_attach = lsp_on_attach })

    lsp.enable('eslint')                                     -- npm -g install vscode-langservers-extracted
    lsp.enable('ruby_lsp')                                   -- gem install ruby_lsp
    lsp.enable('ts_ls')                                      -- npm -g install typescript-language-server

    -- Diagnostics UI {{{
    lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,                                      -- Disable displaying warnings / errors inline
      signs = true,                                              -- Display warning / errors signs next to the line number
      update_in_insert = false,                                  -- Wait with updating diagnostics for switch between modes
      underline = true,                                          -- Underline affected code
    })

    -- Configure gitgutter to not conflict with LSP signs
    g.gitgutter_sign_priority = 9                                -- Lower priority than diagnostics (default 10)
    -- }}}
-- }}}

-- Bindings {{{
    map('n', '<leader>R', ':source ~/.config/nvim/init.lua<CR>', {})

    map('n', ',', ':', { noremap = true })                       -- Alias ':' to ','
    map('n', '<leader><leader>', ':b#<CR>', opts)                -- Quickly switch between buffers
    map('n', 'x', ':cclose<CR>:lclose<CR>:pclose<CR>', opts)     -- Close location, quickfix list with single keystroke

    map('n', '<leader>p', ':let @+=expand("%")<CR>', opts)       -- Copy buffer's relative path to clipboard
    map('n', '<leader>P', ':let @+=expand("%:p")<CR>', opts)     -- Copy buffer's absolute path to clipboard

    map('v', '<', '<gv', opts)                                   -- Move block of codes left
    map('v', '>', '>gv', opts)                                   -- and right
    map('n', '[g', 'gT', opts)                                   -- Move to tab on the left
    map('n', ']g', 'gt', opts)                                   -- Move to tab on the right

    map('n', 'D', 'd$', opts)                                    -- Delete to the end of line
    map('n', 'Y', 'y$', opts)                                    -- Yank to the end of line

    map('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>', opts) -- Show line diagnostic
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts) -- Move prev / next diagnostic errors
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- }}}

-- Commands {{{
    -- Abbreviations {{{
    cmd [[cnoreabbrev bo BufOnly]]                               -- Alias bo to BufOnly
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

    -- Trim trailing whitespaces {{{
    cmd [[
        augroup TrimTrailingWhitespace
            autocmd!
            autocmd BufWritePre * :%s/\s\+$//e
        augroup END
    ]]
    -- }}
-- }}}
