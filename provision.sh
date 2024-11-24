#!/usr/bin/env bash

set -e

echo "Brewing your Mac..."

brew tap chipmk/tap
brew tap lcmen/extra

HOMEBREW_NO_VERIFY_ATTESTATIONS=1 brew install -q bat \
                                                  docker-mac-net-connect \
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
HOMEBREW_NO_VERIFY_ATTESTATIONS=1 brew install --cask -q alacritty \
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

HOMEBREW_NO_VERIFY_ATTESTATIONS=1 brew upgrade --greedy

sudo brew services start docker-mac-net-connect
