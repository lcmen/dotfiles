#!/usr/bin/env bash

set -e

echo "Brewing your Mac..."

brew tap lcmen/extra

brew install -q bat \
                direnv \
                exiftool \
                fzf \
                git \
                mise \
                neovim_bin \
                ripgrep \
                shellcheck \
                stow \
                tig \
                tmux

brew install --cask -q affinity \
                       container \
                       font-fira-code-nerd-font \
                       google-chrome \
                       pocket-casts \
                       synology-drive \
                       vlc \
                       whatsapp \
                       yubico-yubikey-manager

brew upgrade --greedy

brew cleanup

echo "Done!"
