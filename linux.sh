#!/usr/bin/env bash

set -e

# Detect architecture
case $(uname -m) in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    *)       echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

echo "Detected distribution: $DISTRO ($ARCH)"

# Prompt for sudo credentials upfront
sudo -v

setup_ubuntu() {
    echo "Setting up your Ubuntu distro..."

    # Install packages
    echo "Installing packages..."
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        fish \
        fzf \
        git \
        inotify-tools \
        lsb-release \
        make \
        ntp \
        ripgrep \
        software-properties-common \
        sqlite3 \
        stow \
        tig \
        unzip \
        watchman

    # Install starship (not available in apt until Ubuntu 25.04+)
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y > /dev/null

    # Install mise
    echo "Installing mise..."
    sudo install -dm 755 /etc/apt/keyrings
    curl -fsSL https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.pub > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.pub arch=$ARCH] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    sudo apt-get update
    sudo apt-get install -y mise
}

setup_solus() {
    echo "Setting up your Solus distro..."

    # Install packages
    echo "Installing packages..."
    sudo eopkg install -y git nodejs-22 sassc make fish tig

    if [ ! -e /usr/sbin/node ]; then
        echo "Creating symlink for node..."
        sudo ln -s /usr/bin/node /usr/sbin/node
    fi

    if [ ! -e /usr/sbin/npm ]; then
        echo "Creating symlink for npm..."
        sudo ln -s /usr/bin/npm /usr/sbin/npm
    fi
}

if [ "$DISTRO" = "solus" ]; then
    setup_solus
elif [ "$DISTRO" = "ubuntu" ]; then
    setup_ubuntu
else
    echo "Unsupported distribution: $DISTRO"
    echo "Currently only Solus and Ubuntu are supported"
    exit 1
fi

echo "Done!"
