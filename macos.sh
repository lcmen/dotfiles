#!/usr/bin/env bash

set -e

echo "Brewing your Mac..."

brew tap chipmk/tap
brew tap lcmen/extra

brew install -q bat \
                docker-mac-net-connect \
                fzf \
                git \
                libpq \
                libyaml \
                neovim_bin \
                mise \
                neovim_bin \
                ripgrep \
                shellcheck \
                stow \
                tig \
                tmux

brew install --cask -q appcleaner \
                       docker \
                       firefox \
                       font-fira-code-nerd-font \
                       google-chrome \
                       microsoft-teams \
                       quicklook-csv \
                       quicklook-json \
                       postman \
                       pocket-casts \
                       the-unarchiver \
                       visual-studio-code

brew upgrade --greedy

brew link --force libpq

sudo brew services start docker-mac-net-connect

brew cleanup

echo "Done!"
