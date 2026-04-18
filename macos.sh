#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly FORMULAS=(
    bat
    compartment
    container
    direnv
    exiftool
    fzf
    git
    go-pty
    neovim_bin
    ripgrep
    shellcheck
    stow
    tig
    tmux
)

readonly CASKS=(
    affinity
    font-fira-code-nerd-font
    google-chrome
    pocket-casts
    synology-drive
    vlc
    whatsapp
)

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
    defaults write com.apple.dock springboard-show-duration -float 0
    defaults write com.apple.dock springboard-hide-duration -float 0
    defaults write com.apple.dock springboard-page-duration -float 0

    # Spring-loaded directories: remove delay
    defaults write -g com.apple.springing.delay -float 0

    # Mail: Disable send/reply animations
    defaults write com.apple.Mail DisableSendAnimations -bool true
    defaults write com.apple.Mail DisableReplyAnimations -bool true

    # Finder: Disable all animations
    defaults write com.apple.finder DisableAllAnimations -bool true

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
        local plist="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

        /usr/libexec/PlistBuddy "$plist" -c "Delete :AppleSymbolicHotKeys:${id}" 2>/dev/null || true
        /usr/libexec/PlistBuddy "$plist" \
            -c "Add :AppleSymbolicHotKeys:${id} dict" \
            -c "Add :AppleSymbolicHotKeys:${id}:enabled bool true" \
            -c "Add :AppleSymbolicHotKeys:${id}:value dict" \
            -c "Add :AppleSymbolicHotKeys:${id}:value:type string standard" \
            -c "Add :AppleSymbolicHotKeys:${id}:value:parameters array" \
            -c "Add :AppleSymbolicHotKeys:${id}:value:parameters:0 integer ${char}" \
            -c "Add :AppleSymbolicHotKeys:${id}:value:parameters:1 integer ${keycode}" \
            -c "Add :AppleSymbolicHotKeys:${id}:value:parameters:2 integer ${mods}"
    }

    echo "Configuring shortcuts..."

    # Disable press-and-hold, enable full keyboard access, use F1-F12 as standard keys
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g AppleKeyboardUIMode -int 2
    defaults write -g com.apple.keyboard.fnState -bool true

    # Window tiling shortcuts
    local MOD_CTRL=262144
    local MOD_CTRL_OPT=786432

    set_hotkey 237 65535   36  $MOD_CTRL_OPT # - Fill: Ctrl+Opt+Return
    set_hotkey 238   32    49  $MOD_CTRL_OPT # - Center: Ctrl+Opt+Space
    set_hotkey 239   48    29  $MOD_CTRL_OPT # - Return to Previous: Ctrl+Opt+0
    set_hotkey 240  104     4  $MOD_CTRL_OPT # - Left: Ctrl+Opt+h
    set_hotkey 241  108    37  $MOD_CTRL_OPT # - Right: Ctrl+Opt+l
    set_hotkey 242  107    40  $MOD_CTRL_OPT # - Top: Ctrl+Opt+k
    set_hotkey 243  106    38  $MOD_CTRL_OPT # - Bottom: Ctrl+Opt+j
    set_hotkey 248   91    33  $MOD_CTRL_OPT # - Left & Right: Ctrl+Opt+[
    set_hotkey 249   93    30  $MOD_CTRL_OPT # - Right & Left: Ctrl+Opt+]
    set_hotkey 256   61    24  $MOD_CTRL_OPT # - Quarter: Ctrl+Opt+=

    # Virtual desktop switching shortcuts (Ctrl+1-9)
    local keycodes=(18 19 20 21 23 22 26 28 25)
    for i in {1..9}; do
        set_hotkey $((117 + i)) $((48 + i)) "${keycodes[$((i-1))]}" $MOD_CTRL
    done

    # Flush preferences cache and reload symbolic hotkeys
    echo "Applying settings..."
    killall cfprefsd 2>/dev/null || true
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
}

filter_packages() {
    local skip_file="$SCRIPT_DIR/.brew-skip"
    local -a skip

    if [[ -f "$skip_file" ]]; then
        mapfile -t skip < "$skip_file"
    fi

    local pkg s
    for pkg in "$@"; do
        for s in "${skip[@]}"; do [[ "$pkg" == "$s" ]] && continue 2; done
        echo "$pkg"
    done
}

install_packages() {
    echo "Installing packages..."

    command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }

    local -a formulas casks
    mapfile -t formulas < <(filter_packages "${FORMULAS[@]}")
    mapfile -t casks < <(filter_packages "${CASKS[@]}")

    brew tap -q lcmen/extra
    [[ ${#formulas[@]} -gt 0 ]] && brew install -q "${formulas[@]}"
    [[ ${#casks[@]} -gt 0 ]] && brew install --cask -q "${casks[@]}"

    brew upgrade --greedy
    brew cleanup

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
