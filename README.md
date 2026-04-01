# .files

Dotfiles for applications I use on MacOS and Linux systems managed with [stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [Git](https://git-scm.com/)
- [Stow](https://www.gnu.org/software/stow/)
- [Homebrew](https://brew.sh/) (macOS only)

## Install

1. Clone repo
   ```sh
   git clone https://github.com/lcmen/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
2. Init submodules `git submodule update --init --recursive`
3. Run `make install`

## What Gets Installed

Running `make install` will:

- Symlink configuration files to `~/.config/`
- Symlink scripts to `~/.local/bin/`
- Install packages via Homebrew (macOS) or apt/eopkg (Linux)

### Packages

**CLI Tools:** bat, direnv, exiftool, fzf, git, mise, neovim, ripgrep, shellcheck, stow, tig, tmux

**Desktop Apps (macOS):** Affinity apps, Container, Google Chrome, Pocket Casts, Synology Drive, VLC, WhatsApp, YubiKey Manager

**Development Runtimes (via mise):** Elixir, Erlang, Node.js, Ruby

## Uninstall

Run `make uninstall`
