#!/usr/bin/env bash

set -e

echo "Brewing your Mac..."

brew tap lcmen/extra
brew install -q bat \
                fzf \
                git \
                libpq \
                neovim_bin \
                redis \
                ripgrep \
                shellcheck \
                stow \
                tig \
                tmux

brew install -q alacritty \
                android-file-transfer \
                appcleaner \
                firefox \
                font-fira-code-nerd-font \
                google-chrome \
                microsoft-teams \
                quicklook-csv \
                quicklook-json \
                postman \
                pocket-casts \
                send-to-kindle \
                the-unarchiver \
                whatsapp \
                vlc

brew upgrade --greedy
