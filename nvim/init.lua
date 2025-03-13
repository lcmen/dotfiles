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

    local Plug = vim.fn['plug#']
    Plug('AndrewRadev/sideways.vim')
    Plug('AndrewRadev/splitjoin.vim')
    Plug('CopilotC-Nvim/CopilotChat.nvim')
    Plug('airblade/vim-gitgutter')
    Plug('christoomey/vim-tmux-navigator')
    Plug('dense-analysis/ale')
    Plug('docunext/closetag.vim')
    Plug('github/copilot.vim')
    Plug('ibhagwan/fzf-lua')
    Plug('lcmen/nvim-lspinstall')
    Plug('neovim/nvim-lspconfig')
    Plug('nvim-lua/plenary.nvim')
    Plug('nvim-treesitter/nvim-treesitter')
    Plug('nvim-tree/nvim-tree.lua')
    Plug('nvim-tree/nvim-web-devicons')
    Plug('numtostr/BufOnly.nvim', { ['on'] = 'BufOnly' })
    Plug('onsails/lspkind-nvim')
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
    opt.mouse = 'a'                                              -- Enable mouse support
    opt.swapfile = false                                         -- No swapfile
    opt.scrolloff = 5                                            -- Start scrolling 5 lines away from margin
    opt.sidescrolloff = 15                                       -- Start scrolling 15 lines away from side margin
    opt.spell = false                                            -- Spell checking off
    opt.splitbelow = true                                        -- Split below
    opt.splitright = true                                        -- Split on the right side
    opt.completeopt = { 'menu', 'menuone', 'noselect' }          -- Don't select completion menu
    -- }}}

    -- Whitespaces {{{
    opt.wrap = false
    opt.linebreak = true
    opt.expandtab = true                                         -- Indent with spaces
    opt.list = true                                              -- Show invisible characters
    opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
    opt.softtabstop = 2                                          -- Number of spaces per <tab> when inserting
    opt.shiftwidth = 2                                           -- Number of spaces per <tab> when indenting
    opt.tabstop = 4                                              -- Number of spaces <tab> counts for
    opt.textwidth = 120
    -- }}}

    -- Search {{{
    opt.incsearch = true                                         -- Enable incremental search
    opt.ignorecase = true                                        -- Ignore case when searching
    opt.smartcase = true                                         -- unless there is a capital letter in the query
    -- }}}

    -- Backups {{{
    opt.backup = false                                           --  Disable backup
    opt.writebackup = false
    -- }}}

    -- UI {{{
    cmd[[colorscheme onehalflight]]
    opt.cursorline = true                                        -- Show cursor line
    opt.laststatus = 2                                           -- Show status line
    opt.number = true                                            -- Show line numbers
    opt.relativenumber = true                                    -- Use relative line numbers
    --}}}
-- }}}

-- Packages configuration {{{
    -- Ale {{{
    vim.fn.system('bundle exec standardrb -v > /dev/null 2>&1')
    if vim.v.shell_error == 0 then
        ruby_linter = 'standardrb'
    else
        ruby_linter = 'rubocop'
    end

    g.ale_disable_lsp = 1
    g.ale_fix_on_save = 1
    g.ale_lint_on_text_changed = 'never'
    g.ale_lint_on_insert_leave = 0
    g.ale_use_neovim_diagnostics_api = 1
    g.ale_fixers = {
       ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
       ['javascript'] = { 'eslint', 'prettier' },
       ['javascriptreact'] = { 'eslint', 'prettier' },
       ['eruby'] = { 'rustywind' },
       ['ruby'] = { ruby_linter, 'remove_trailing_lines', 'trim_whitespace' },
       ['terraform'] = { 'terraform' },
       ['typescript'] = { 'eslint', 'prettier' },
       ['typescriptreact'] = { 'eslint', 'prettier' },
    }
    g.ale_linters = {
       ['ruby'] = { ruby_linter, 'brakeman' },
    }
    g.ale_haml_hamllint_executable = 'bundle'
    g.ale_ruby_brakeman_executable = 'bundle'
    g.ale_ruby_rubocop_auto_correct_all = 1
    g.ale_ruby_rubocop_executable = 'bundle'
    g.ale_ruby_standardrb_executable = 'bundle'
    -- }}}

    -- BufOnly {{{
    g.bufonly_delete_non_modifiable = true                       -- Delete non-modifiable buffers
    -- }}}

    -- Copilot Chat {{{
    require("CopilotChat").setup({

    })
    -- }}}

    -- FZF {{{
    map("n", "<C-p>", ":FzfLua files<CR>", opts)                 -- Launch FZF for Files
    map("n", "<C-\\>", ":FzfLua buffers<CR>", opts)              -- Launch FZF for Buffers
    -- map("n", "<C-/>", ":FzfLua grep<CR>", opts)                  -- Launch FZF for Grep
    require('fzf-lua').setup({
        winopts = {
            cursorline = false,
            cursorcolumn = false,
            width = 0.9,
            height = 0.9,
            border = 'none',
            preview = {
                border = 'border',
                wrap = 'nowrap',
                scrolloff = 5,
                winopts = { number = true }
            },
        },
        fzf_opts = {
            ['--border'] = 'none',
            ['--info'] = 'hidden',
            ['--header'] = ' ',
            ['--padding'] = '3%,3%,3%,3%',
            ['--prompt'] = '🔍 ',
            ['--no-scrollbar'] = '',
        },
        buffers = {
            file_icons = true,
            git_icons = true,
            prompt = "🔍 Buffers: ",
        },
        files = {
            cwd_prompt = false,
            file_icons = true,
            git_icons = true,
            prompt = "🔍 Files: ",
        },
    })
    -- }}}

    -- NvimTree {{{
    g.loaded_netrw = 1
    g.loaded_netrwPlugin = 1

    local function tree_on_attach(bufnr)
        local api = require('nvim-tree.api')
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true }

        map('n', '<C-]>', api.tree.change_root_to_node, opts)
        map('n', '<C-e>', api.tree.close, opts)
        map('n', '<C-t>', api.node.open.tab, opts)
        map('n', '<CR>', api.node.open.edit, opts)
        map('n', 'a', api.fs.create, opts)
        map('n', 'd', api.fs.remove, opts)
        map('n', 'r', api.fs.rename, opts)
        map('n', 's', api.node.open.horizontal, opts)
        map('n', 'v', api.node.open.vertical, opts)
    end

    require("nvim-tree").setup({
        on_attach = tree_on_attach,
        sort = { sorter = "case_sensitive" },
        view = { width = 30 },
        renderer = { group_empty = true },
    })
    map('n', '<C-e>', ':NvimTreeToggle<CR>', opts)               -- Toggle NERDTree
    map('n', '<leader>e', ':NvimTreeFindFile<CR>', opts)         -- Focus current buffer in NERDTree
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
    -- }}
-- }}}

-- LSP {{{
local lsp_on_attach = function(client, bufnr)
    local map = vim.api.nvim_buf_set_keymap
    local ion = vim.api.nvim_buf_set_option
    local opts = { noremap = true }

    ion(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    ion(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

    -- Configure keybindings for LSP
    map(bufnr, 'n', 'C-y', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    map(bufnr, 'n', 'g0', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    map(bufnr, 'n', 'gf', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    map(bufnr, 'n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    map(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

require('lspkind').init()

    -- LSP servers {{{
    local lspconfig = require('lspconfig')
    local lspinstall = require('lspinstall')
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    for server, config in pairs(lspinstall.installed_servers()) do
        config.on_attach = lsp_on_attach
        config.capabilities = capabilities
        lspconfig[server].setup(config)
    end

    -- Diagnostics UI {{{
    lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,                                      -- Disable displaying warnings / errors inline
      signs = true,                                              -- Display warning / errors signs next to the line number
      update_in_insert = false,                                  -- Wait with updating diagnostics for switch between modes
      underline = true,                                          -- Underline affected code
    })
    -- }}}
-- }}}

-- Bindings {{{
    map('n', '<leader>R', ':source ~/.config/nvim/init.lua<CR>', {})

    map('n', ',', ':', { noremap = true })                       -- Alias ':' to ','
    map('n', '<leader><leader>', ':b#<CR>', opts)                -- Quickly switch between buffers
    map('n', 'va', 'ggVG', opts)                                 -- Select all text
    map('n', '/', ':set hlsearch<cr>/', opts)                    -- Enable hlserch on search start
    map('n', '<leader><cr>', ':noh<cr>', opts)                   -- Disable hl
    map('n', 'x', ':cclose<CR>:lclose<CR>:pclose<CR>', opts)     -- Close location, quickfix list with single keystroke

    map('n', '<leader>p', ':let @+=expand("%")<CR>', opts)       -- Copy buffer's relative path to clipboard
    map('n', '<leader>P', ':let @+=expand("%:p")<CR>', opts)     -- Copy buffer's absolute path to clipboard

    map('i', '<S-Tab>', '<C-d>', opts)                           -- Tab backwards with Shift+Tab
    map('n', 'k', 'gk', { silent = true })                       -- Move more sensibly when line wrapping enabled
    map('n', 'j', 'gj', { silent = true })
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
        augroup END
    ]]
    -- }}
-- }}}
