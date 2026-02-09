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
	stow --verbose=0 --target=$$HOME/.config --restow --ignore bin ./
	stow --verbose=0 --target=$$HOME/.local/bin --restow bin/

uninstall:
	stow --target=$$HOME/.config --delete --ignore bin */
	stow --target=$$HOME/.local/bin --delete bin/

all: prepare install
