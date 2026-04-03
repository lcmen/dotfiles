#!/usr/bin/env bash

set -e

# Detect architecture
case $(uname -m) in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    *)       echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

# Prompt for sudo credentials upfront
sudo -v

# Helper functions for apt repository management
setup_apt_keyring() {
    local keyring_dir="/etc/apt/keyrings"
    sudo install -dm 755 "$keyring_dir"
}

add_apt_gpg_key() {
    local url="$1"
    local keyring_file="$2"
    curl -fsSL "$url" | sudo tee "$keyring_file" > /dev/null
    sudo chmod go+r "$keyring_file"
}

add_apt_source() {
    local source_line="$1"
    local list_file="$2"
    echo "$source_line" | sudo tee "$list_file" > /dev/null
}

echo "Setting up Ubuntu..."

# Add all third-party repositories first
echo "Adding third-party repositories..."

# Neovim PPA
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# Setup apt keyrings for custom repos
setup_apt_keyring

# Mise repository
add_apt_gpg_key "https://mise.jdx.dev/gpg-key.pub" "/etc/apt/keyrings/mise-archive-keyring.pub"
add_apt_source "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.pub arch=$ARCH] https://mise.jdx.dev/deb stable main" "/etc/apt/sources.list.d/mise.list"

# GitHub CLI repository
add_apt_gpg_key "https://cli.github.com/packages/githubcli-archive-keyring.gpg" "/etc/apt/keyrings/githubcli-archive-keyring.gpg"
add_apt_source "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" "/etc/apt/sources.list.d/github-cli.list"

# Docker repository
add_apt_gpg_key "https://download.docker.com/linux/ubuntu/gpg" "/etc/apt/keyrings/docker.asc"
add_apt_source "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" "/etc/apt/sources.list.d/docker.list"

# Install all packages in a single operation
echo "Installing packages..."
sudo apt-get update
sudo apt-get install -y \
    bat \
    build-essential \
    ca-certificates \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    fish \
    gh \
    git \
    inotify-tools \
    libffi-dev \
    libimage-exiftool-perl \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    lsb-release \
    make \
    mise \
    neovim \
    ntp \
    pkg-config \
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

# Add current user to docker group
sudo usermod -aG docker "$USER"

# Install starship (not available in apt until Ubuntu 25.04+)
echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y > /dev/null

# Install fzf (apt version is outdated)
echo "Installing fzf..."
FZF_VERSION=$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')
curl -fsSLo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH}.tar.gz"
sudo tar -xzf /tmp/fzf.tar.gz -C /usr/local/bin/
rm /tmp/fzf.tar.gz

# Install Nix
if ! command -v nix &>/dev/null; then
    echo "Installing Nix..."
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
else
    echo "Nix already installed, skipping..."
fi

echo "Done!"
