install:
	stow --target=$$HOME --restow shell/
	stow --target=$$HOME/.config --restow --ignore shell ./

uninstall:
	stow --target=$$HOME --delete shell/
	stow --target=$$HOME/.config --delete --ignore shell */
