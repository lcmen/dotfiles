# .files

Dotfiles and repository-scoped machine bootstrap configuration for macOS, Ubuntu, and Fedora, managed with [mise](https://mise.jdx.dev/).

## Prerequisites

- [Git](https://git-scm.com/)
- [mise](https://mise.jdx.dev/installing-mise.html) 2026.7.11 or newer

## Install

1. Clone repo

   ```sh
   git clone https://github.com/lcmen/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Init submodules `git submodule update --init --recursive`
3. Trust and bootstrap the configuration

   ```sh
   mise trust
   mise bootstrap
   ```

## What Gets Installed

Running `mise bootstrap` will:

- Install native packages via Mise's Homebrew, apt, or dnf managers
- Symlink configuration directories into `~/.config/`
- Symlink individual scripts into `~/.local/bin/`
- Apply macOS preferences and keyboard shortcuts on macOS

## Maintenance

Preview bootstrap changes or inspect current state:

```sh
mise bootstrap --dry-run
mise bootstrap status
```
