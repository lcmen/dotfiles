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
        build-essential \
        ca-certificates \
        bat \
        fish \
        git \
        inotify-tools \
        libimage-exiftool-perl \
        libffi-dev \
        libreadline-dev \
        libssl-dev \
        libyaml-dev \
        lsb-release \
        make \
        ntp \
        ripgrep \
        software-properties-common \
        sqlite3 \
        stow \
        tig \
        unzip \
        watchman \
        zlib1g-dev

    # Create symlink for bat (Ubuntu installs it as batcat)
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat

    # Install neovim from PPA (for latest version)
    echo "Installing neovim..."
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt-get update
    sudo apt-get install -y neovim

    # Install starship (not available in apt until Ubuntu 25.04+)
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y > /dev/null

    # Install fzf (apt version is outdated)
    echo "Installing fzf..."
    FZF_VERSION=$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')
    curl -fsSLo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH}.tar.gz"
    sudo tar -xzf /tmp/fzf.tar.gz -C /usr/local/bin/
    rm /tmp/fzf.tar.gz

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
    sudo eopkg install -y \
        fish \
        git \
        make \
        neovim \
        nodejs-22 \
        perl-image-exiftool \
        sassc \
        tig

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
