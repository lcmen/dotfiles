install:
	stow --target=$$HOME --restow _tilde/
	stow --target=$$HOME/.config --restow --ignore _tilde ./

uninstall:
	stow --target=$$HOME --delete _tilde/
	stow --target=$$HOME/.config --delete --ignore _tilde */
