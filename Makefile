.DEFAULT_GOAL := all

prepare:
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		./macos.sh; \
	elif [ "$$(uname -s)" = "Linux" ]; then \
		./linux.sh; \
	else \
		echo "Unsupported operating system: $$(uname -s)"; \
	fi

install:
	stow --verbose=0 --target=$$HOME --restow _tilde/
	stow --verbose=0 --target=$$HOME/.config --restow --ignore _tilde ./

uninstall:
	stow --target=$$HOME --delete _tilde/
	stow --target=$$HOME/.config --delete --ignore _tilde */

all: prepare install
