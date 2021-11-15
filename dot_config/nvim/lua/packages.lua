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
Plug('janko-m/vim-test')
Plug('lokikl/vim-ctrlp-ag')
Plug('rking/ag.vim')
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
Plug('vim-scripts/BufOnly.vim')

call('plug#end')

-----------------------------------------------------------
-- Packages settings
-----------------------------------------------------------
g.NERDTreeShowHidden = 1
