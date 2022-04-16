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

    -- Configure keybindings for LSP
    map(bufnr, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    map(bufnr, 'n', 'gf', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map(bufnr, 'n', 'g=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

-----------------------------------------------------------
-- External packages
-----------------------------------------------------------
call('plug#begin', '~/.config/nvim/plugged')

Plug('AndrewRadev/sideways.vim')
Plug('AndrewRadev/splitjoin.vim')
Plug('airblade/vim-gitgutter')
Plug('christoomey/vim-tmux-navigator')
Plug('docunext/closetag.vim')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/vim-vsnip')
Plug('janko-m/vim-test')
Plug('jremmen/vim-ripgrep')
Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install()'] })
Plug('junegunn/fzf.vim')
Plug('neovim/nvim-lspconfig')
Plug('onsails/lspkind-nvim')
Plug('rafamadriz/friendly-snippets')
Plug('ryanoasis/vim-devicons')
Plug('scrooloose/nerdtree')
Plug('sheerun/vim-polyglot')
Plug('sonph/onehalf', { ['rtp'] = 'vim' })
Plug('tpope/vim-commentary')
Plug('tpope/vim-dispatch')
Plug('tpope/vim-rails')
Plug('tpope/vim-repeat')
Plug('tpope/vim-surround')
Plug('tpope/vim-unimpaired')
Plug('troydm/zoomwintab.vim')
Plug('vim-scripts/BufOnly.vim')
Plug('williamboman/nvim-lsp-installer')

call('plug#end')

-----------------------------------------------------------
-- Packages settings
-----------------------------------------------------------

g.fzf_preview_window = {'right:50%', 'ctrl-/'}               -- Show preview window for FZF
g.NERDTreeShowHidden = 1                                     -- Show hidden files on NERDTree

local cmp = require'cmp'
local lsp_installer = require("nvim-lsp-installer")
local lspkind = require('lspkind')

cmp.setup({
    enabled = true;
    formatting = {
        format = lspkind.cmp_format(),
    };
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    });
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    };
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        {
            name = 'buffer',
            option = {
                get_bufnrs = function()                      -- Complete from all buffers
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        { name = 'path' }
    });
})

lsp_installer.on_server_ready(function (server)
    server:setup { on_attach = on_attach }
end)
