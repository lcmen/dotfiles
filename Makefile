install:
	stow --target=$$HOME --restow --ignore neovim */
	mkdir -p $$HOME/.config/nvim && stow --target=$$HOME/.config/nvim --restow neovim/

uninstall:
	stow --target=$$HOME --delete */
	stow --target=$$HOME/.config/nvim --delete neovim/
