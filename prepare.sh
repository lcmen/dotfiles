#!/usr/env/bin bash

set -e

brew tap lcmen/extra
brew install bat \
             fzf \
             git \
             libpq \
             neovim_bin \
             redis \
             ripgrep \
             shellcheck \
             stow \
             tig \
             tmux \
             wget

brew cask install appcleaner \
                  authy /
                  font-fira-code-nerd-font /
                  google-chrome /
                  quicklook-csv /
                  quicklook-json /
                  sanesidebuttons /
                  spotify /
                  the-unarchiver /
                  vlc
brew upgrade --greedy
