#!/usr/bin/env bash

set -e

echo "Brewing your Mac..."

brew tap lcmen/extra

brew install -q bat \
                exiftool \
                fzf \
                git \
                libpq \
                libyaml \
                neovim_bin \
                mise \
                ripgrep \
                shellcheck \
                stow \
                tig \
                tmux

brew install --cask -q appcleaner \
                       bitwarden \
                       firefox \
                       font-fira-code-nerd-font \
                       google-chrome \
                       microsoft-teams \
                       orbstack \
                       pocket-casts \
                       postman \
                       quicklook-csv \
                       quicklook-json \
                       the-unarchiver \
                       visual-studio-code

brew upgrade --greedy

brew link --force libpq

brew cleanup

echo "Done!"
