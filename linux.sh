#!/usr/bin/env bash

set -e

# Prompt for sudo credentials upfront
sudo -v

setup_solus() {
    echo "Setting up your Solus distro..."

    # Install packages
    echo "Installing packages..."
    sudo eopkg install -y git nodejs-22 sassc make fish

    if [ ! -e /usr/sbin/node ]; then
        echo "Creating symlink for node..."
        sudo ln -s /usr/bin/node /usr/sbin/node
    fi

    if [ ! -e /usr/sbin/npm ]; then
        echo "Creating symlink for npm..."
        sudo ln -s /usr/bin/npm /usr/sbin/npm
    fi
}

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot detect Linux distribution"
    exit 1
fi

echo "Detected distribution: $DISTRO"

if [ "$DISTRO" = "solus" ]; then
    setup_solus
else
    echo "Unsupported distribution: $DISTRO"
    echo "Currently only Solus is supported"
fi

echo "Done!"
