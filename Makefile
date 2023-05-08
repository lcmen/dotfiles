install:
	stow --target=$$HOME --restow --ignore efm-langserver --ignore neovim --ignore ripgrep */
	mkdir -p $$HOME/.config/efm-langserver && stow --target=$$HOME/.config/efm-langserver --restow efm-langserver/
	mkdir -p $$HOME/.config/nvim && stow --target=$$HOME/.config/nvim --restow neovim/
	mkdir -p $$HOME/.config/ripgrep && stow --target=$$HOME/.config/ripgrep --restow ripgrep/

uninstall:
	stow --target=$$HOME --delete */
	stow --target=$$HOME/.config/efm-langserver --delete efm-langserver/
	stow --target=$$HOME/.config/nvim --delete neovim/
	stow --target=$$HOME/.config/ripgrep --delete ripgrep/
