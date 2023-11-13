install:
	# stow --target=$$HOME --restow --ignore neovim --ignore psql --ignore ripgrep */
	stow --target=$$HOME --restow shell/
	mkdir -p $$HOME/.config/asdf && stow --target=$$HOME/.config/asdf --restow asdf/
	mkdir -p $$HOME/.config/bundle && stow --target=$$HOME/.config/bundle --restow bundle/
	mkdir -p $$HOME/.config/gem && stow --target=$$HOME/.config/gem --restow gem/
	mkdir -p $$HOME/.config/git && stow --target=$$HOME/.config/git --restow git/
	mkdir -p $$HOME/.config/nvim && stow --target=$$HOME/.config/nvim --restow neovim/
	mkdir -p $$HOME/.config/psql && stow --target=$$HOME/.config/psql --restow psql/
	mkdir -p $$HOME/.config/ripgrep && stow --target=$$HOME/.config/ripgrep --restow ripgrep/
	mkdir -p $$HOME/.config/tmux && stow --target=$$HOME/.config/tmux --restow tmux/

uninstall:
	# stow --target=$$HOME --delete */
	stow --target=$$HOME --delete shell/
	stow --target=$$HOME/.config/asdf --delete asdf/
	stow --target=$$HOME/.config/bundle --delete bundle/
	stow --target=$$HOME/.config/gem --delete gem/
	stow --target=$$HOME/.config/git --delete git/
	stow --target=$$HOME/.config/nvim --delete neovim/
	stow --target=$$HOME/.config/psql --delete psql/
	stow --target=$$HOME/.config/ripgrep --delete ripgrep/
	stow --target=$$HOME/.config/tmux --delete tmux/
