-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local call = vim.call
local g = vim.g
local Plug = vim.fn['plug#']

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
Plug('numtostr/BufOnly.nvim', { ['on'] = 'BufOnly' })
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
Plug('williamboman/nvim-lsp-installer')

call('plug#end')

-----------------------------------------------------------
-- Packages settings
-----------------------------------------------------------
g.bufonly_delete_non_modifiable = true                       -- Delete non-modifiable buffers
g.fzf_layout = { window = { width = 0.9, height = 0.9 } }    -- Customize FZF size
g.fzf_preview_window = {'right:50%:hidden', 'ctrl-p'}        -- Show preview window on Ctrl+P for FZF
g.NERDTreeShowHidden = 1                                     -- Show hidden files on NERDTree

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    enabled = true;
    formatting = { format = lspkind.cmp_format() };
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
