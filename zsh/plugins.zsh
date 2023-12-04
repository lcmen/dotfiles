# Load Homebrew first so other plugins relying `brew`, `brew --prefix`, etc. can work
source "$ZDOTDIR/plugins/brew.zsh"
# Load Vim mode before other plugins to avoid keybinding conflicts (e.g. FZF)
# source "$ZDOTDIR/plugins/vim.zsh"

source "$ZDOTDIR/plugins/asdf.zsh"
source "$ZDOTDIR/plugins/bd.zsh"
source "$ZDOTDIR/plugins/dirs.zsh"
source "$ZDOTDIR/plugins/fzf.zsh"
source "$ZDOTDIR/plugins/ruby.zsh"
# source "$ZDOTDIR/plugins/tmux.zsh"
