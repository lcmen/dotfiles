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
Plug('ctrlpvim/ctrlp.vim')
Plug('docunext/closetag.vim')
Plug('github/copilot.vim')
Plug('janko-m/vim-test')
Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install()'] })
Plug('junegunn/fzf.vim')
Plug('lcmen/nvim-lspinstall')
Plug('mickael-menu/zk-nvim')
Plug('neovim/nvim-lspconfig')
Plug('numtostr/BufOnly.nvim', { ['on'] = 'BufOnly' })
Plug('onsails/lspkind-nvim')
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

call('plug#end')

-----------------------------------------------------------
-- Packages settings
-----------------------------------------------------------
g.bufonly_delete_non_modifiable = true                       -- Delete non-modifiable buffers
g.ctrlp_switch_buffer = 0                                    -- Open files in new buffers
g.ctrlp_use_caching = 0                                      -- Disable caching and use Ripgrep instead
g.ctrlp_user_command = 'rg %s --files'
g.ctrlp_working_path_mode = 0                                -- Respect current working directory
g.fzf_action = {                                             -- Override Global FZF bindings to match VIM ones
    ['enter']  = 'edit',
    ['ctrl-t'] = 'tabedit',
    ['ctrl-s'] = 'split',
    ['ctrl-v'] = 'vsplit',
}
g.NERDTreeShowHidden = 1                                     -- Show hidden files on NERDTree
