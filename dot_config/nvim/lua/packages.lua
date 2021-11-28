-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local call = vim.call
local g = vim.g
local opts = { noremap = true }
local Plug = vim.fn['plug#']

-----------------------------------------------------------
-- Functions
-----------------------------------------------------------
local on_attach = function(client, bufnr)
    local map = vim.api.nvim_buf_set_keymap
    local ion = vim.api.nvim_buf_set_option

    ion(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    ion(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
    map(bufnr, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    map(bufnr, 'n', 'gf', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map(bufnr, 'n', 'g=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map(bufnr, 'n', 'L', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    map(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    map(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

-----------------------------------------------------------
-- External packages
-----------------------------------------------------------
call('plug#begin', '~/.config/nvim/plugged')

Plug('AndrewRadev/sideways.vim')
Plug('AndrewRadev/splitjoin.vim')
Plug('airblade/vim-gitgutter')
Plug('christoomey/vim-tmux-navigator')
Plug('ctrlpvim/ctrlp.vim')
Plug('docunext/closetag.vim')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/nvim-cmp')
Plug('janko-m/vim-test')
-- Switch to 'jremmen/vim-ripgrep' once https://github.com/jremmen/vim-ripgrep/pull/62 is merged
Plug('miyase256/vim-ripgrep', { branch = 'fix/remove-complete-from-RgRoot' })
Plug('neovim/nvim-lspconfig')
Plug('ojroques/vim-oscyank')
Plug('ryanoasis/vim-devicons')
Plug('scrooloose/nerdtree')
Plug('sheerun/vim-polyglot')
Plug('sonph/onehalf', { rtp = 'vim' })
Plug('tpope/vim-commentary')
Plug('tpope/vim-dispatch')
Plug('tpope/vim-rails')
Plug('tpope/vim-repeat')
Plug('tpope/vim-surround')
Plug('tpope/vim-unimpaired')
Plug('troydm/zoomwintab.vim')
Plug('williamboman/nvim-lsp-installer')
Plug('vim-scripts/BufOnly.vim')

call('plug#end')

-----------------------------------------------------------
-- Packages settings
-----------------------------------------------------------
g.ctrlp_switch_buffer = 0                                    -- Always open a new window when opening a file
g.ctrlp_working_path_mode = 0                                -- Always search under current working directory
g.ctrlp_use_caching = 0                                      -- Disable caching for CtrlP and use ripgrep
g.ctrlp_user_command = 'rg %s --files --color=never --glob=!git --glob=!node_modules --glob=!vendor/bundle --glob ""'

g.NERDTreeShowHidden = 1                                     -- Show hidden files on NERDTree

local cmp = require'cmp'
local lsp_installer = require("nvim-lsp-installer")

cmp.setup({
    enabled = true;
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' }
    });
})

lsp_installer.on_server_ready(function (server)
    server:setup { on_attach = on_attach }
end)
