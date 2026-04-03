#!/usr/bin/env bash

set -e

configure_settings() {
    echo "Configuring settings..."

    # UI: Window animations - speed up or disable
    defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
    defaults write -g NSWindowResizeTime -float 0.001
    defaults write -g NSScrollAnimationEnabled -bool false
    defaults write -g QLPanelAnimationDuration -float 0
    defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false
    defaults write -g NSToolbarFullScreenAnimationDuration -float 0
    defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0
    defaults write -g NSScrollViewRubberbanding -bool false

    # Dock: Speed up animations
    defaults write com.apple.dock autohide-time-modifier -float 0
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock expose-animation-duration -float 0
    defaults write com.apple.dock launchanim -bool false
    defaults write com.apple.dock mineffect -string "scale"

    # Mail: Disable send/reply animations
    defaults write com.apple.Mail DisableSendAnimations -bool true
    defaults write com.apple.Mail DisableReplyAnimations -bool true

    # Finder: Don't show hidden files, show file extensions, disable extension change warning
    defaults write com.apple.finder AppleShowAllFiles -bool false
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

    # Restart Dock and Finder to apply changes
    echo "Restarting Dock and Finder to apply changes..."
    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true
}

configure_shortcuts() {
    set_hotkey() {
        local id=$1 char=$2 keycode=$3 mods=$4
        local plist=~/Library/Preferences/com.apple.symbolichotkeys.plist

        # Check if the entry already exists
        if /usr/libexec/PlistBuddy "$plist" -c "Print :AppleSymbolicHotKeys:${id}" >/dev/null 2>&1; then
            # Entry exists, update it
            /usr/libexec/PlistBuddy "$plist" \
                -c "Set :AppleSymbolicHotKeys:${id}:enabled true" \
                -c "Set :AppleSymbolicHotKeys:${id}:value:type standard" \
                -c "Set :AppleSymbolicHotKeys:${id}:value:parameters:0 ${char}" \
                -c "Set :AppleSymbolicHotKeys:${id}:value:parameters:1 ${keycode}" \
                -c "Set :AppleSymbolicHotKeys:${id}:value:parameters:2 ${mods}" 2>/dev/null || {
                    echo "Warning: Failed to update hotkey ${id}" >&2
                }
        else
            # Entry doesn't exist, create it with proper structure
            /usr/libexec/PlistBuddy "$plist" \
                -c "Add :AppleSymbolicHotKeys:${id} dict" \
                -c "Add :AppleSymbolicHotKeys:${id}:enabled bool true" \
                -c "Add :AppleSymbolicHotKeys:${id}:value dict" \
                -c "Add :AppleSymbolicHotKeys:${id}:value:type string standard" \
                -c "Add :AppleSymbolicHotKeys:${id}:value:parameters array" \
                -c "Add :AppleSymbolicHotKeys:${id}:value:parameters:0 integer ${char}" \
                -c "Add :AppleSymbolicHotKeys:${id}:value:parameters:1 integer ${keycode}" \
                -c "Add :AppleSymbolicHotKeys:${id}:value:parameters:2 integer ${mods}" 2>/dev/null || {
                    echo "Warning: Failed to create hotkey ${id}" >&2
                }
        fi
    }

    echo "Configuring shortcuts..."

    # Disable press-and-hold, enable full keyboard access, use F1-F12 as standard keys
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g AppleKeyboardUIMode -int 2
    defaults write -g com.apple.keyboard.fnState -bool true

    # Window tiling shortcuts
    set_hotkey 237   13    36  786432 # - Fill: Ctrl+Opt+Return
    set_hotkey 238   32    49  786432 # - Center: Ctrl+Opt+Space
    set_hotkey 239   48    29  786432 # - Return to Previous: Ctrl+Opt+0
    set_hotkey 240  104     4  786432 # - Left: Ctrl+Opt+h
    set_hotkey 241  108    37  786432 # - Right: Ctrl+Opt+l
    set_hotkey 242  107    40  786432 # - Top: Ctrl+Opt+k
    set_hotkey 243  106    38  786432 # - Bottom: Ctrl+Opt+j
    set_hotkey 248   91    33  786432 # - Left & Right: Ctrl+Opt+[
    set_hotkey 249   93    30  786432 # - Right & Left: Ctrl+Opt+]
    set_hotkey 256   61    24  786432 # - Quarter: Ctrl+Opt+=

    # Virtual desktop switching shortcuts
    echo "Setting virtual desktop shortcuts (Ctrl+1-9)..."
    set_hotkey 118   49    18  262144 # - Desktop 1: Ctrl+1
    set_hotkey 119   50    19  262144 # - Desktop 2: Ctrl+2
    set_hotkey 120   51    20  262144 # - Desktop 3: Ctrl+3
    set_hotkey 121   52    21  262144 # - Desktop 4: Ctrl+4
    set_hotkey 122   53    23  262144 # - Desktop 5: Ctrl+5
    set_hotkey 123   54    22  262144 # - Desktop 6: Ctrl+6
    set_hotkey 124   55    26  262144 # - Desktop 7: Ctrl+7
    set_hotkey 125   56    28  262144 # - Desktop 8: Ctrl+8
    set_hotkey 126   57    25  262144 # - Desktop 9: Ctrl+9

    # Flush preferences cache and reload symbolic hotkeys
    echo "Applying settings..."
    killall cfprefsd 2>/dev/null || true
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
}

install_packages() {
    echo "Installing packages..."

    command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }

    brew tap -q lcmen/extra

    brew install -q bat \
                    compartment \
                    direnv \
                    exiftool \
                    fzf \
                    git \
                    go-pty \
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

    # Install Nix (multi-user installation)
    if ! command -v nix &>/dev/null; then
        echo "Installing Nix..."
        sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
    else
        echo "Nix already installed, skipping..."
    fi
}

echo "Setting up your Mac..."

configure_settings
configure_shortcuts
install_packages

echo "To clean up existing .DS_Store files, run:"
echo "  find ~ -name '.DS_Store' -not -path '*/node_modules/*' -delete 2>/dev/null"
echo "Done!"
