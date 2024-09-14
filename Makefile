.DEFAULT_GOAL := all

prepare:
	./provision.sh

install:
	stow --verbose=0 --target=$$HOME --restow _tilde/
	stow --verbose=0 --target=$$HOME/.config --restow --ignore _tilde ./

uninstall:
	stow --target=$$HOME --delete _tilde/
	stow --target=$$HOME/.config --delete --ignore _tilde */

all: prepare install
