#!/usr/bin/env bash

set -e

configure_settings() {
    echo "Configuring settings..."

    # Finder: Show hidden files, file extensions, disable extension change warning
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Finder: Keep folders on top (both in windows and on Desktop)
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

    # Finder: Show path and status bars
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true

    # Finder: Disable .DS_Store on network and USB drives
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Finder: New windows open to home folder, use column view, search current folder
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Desktop: Show hard drives, external drives, servers, and removable media
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Clean up existing .DS_Store files
    find ~ -name ".DS_Store" -not -path "*/node_modules/*" -delete 2>/dev/null
}

configure_shortcuts() {
    echo "Configuring shortcuts..."

    # Disable press-and-hold, enable full keyboard access, use F1-F12 as standard keys
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g AppleKeyboardUIMode -int 2
    defaults write -g com.apple.keyboard.fnState -bool true

    # Window tiling shortcuts:
    #   Fill: Ctrl+Opt+Return
    #   Center: Ctrl+Opt+Space
    #   Top/Bottom: Ctrl+Opt+0
    #   Left Half: Fn+Ctrl+Opt+Left
    #   Right Half: Fn+Ctrl+Opt+Right
    #   Top Half: Fn+Ctrl+Opt+Up
    #   Bottom Half: Fn+Ctrl+Opt+Down
    #   Left/Right: Ctrl+Opt+[
    #   Previous Size: Ctrl+Opt+5
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 237 '{ enabled = 1; value = { parameters = (65535, 36, 786432); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 238 '{ enabled = 1; value = { parameters = (32, 49, 786432); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 239 '{ enabled = 1; value = { parameters = (48, 29, 786432); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 240 '{ enabled = 1; value = { parameters = (65535, 123, 9175040); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 241 '{ enabled = 1; value = { parameters = (65535, 124, 9175040); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 242 '{ enabled = 1; value = { parameters = (65535, 126, 9175040); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 243 '{ enabled = 1; value = { parameters = (65535, 125, 9175040); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 248 '{ enabled = 1; value = { parameters = (91, 33, 786432); type = standard; }; }'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 256 '{ enabled = 1; value = { parameters = (53, 23, 786432); type = standard; }; }'
}

install_packages() {
    echo "Installing packages..."

    brew tap lcmen/extra

    brew install -q bat \
                    compartment \
                    direnv \
                    exiftool \
                    fzf \
                    git \
                    go-pty \
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
}

echo "Setting up your Mac..."

configure_settings
configure_shortcuts
install_packages

echo "Done!"
