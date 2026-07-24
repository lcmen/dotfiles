# .files

Dotfiles and repository-scoped machine bootstrap configuration for macOS,
Ubuntu, and Fedora, managed with [mise](https://mise.jdx.dev/).

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
- Symlink scripts individually into `~/.local/bin/`
- Apply macOS preferences and keyboard shortcuts on macOS
- Configure Docker repositories and group membership on Ubuntu and Fedora
- Install the configured Node.js and Ruby versions

### Packages

Package names vary by platform. The bootstrap includes the native build
dependencies and CLI tools used by this configuration, including bat, fzf, Git,
Neovim, ripgrep, tig, and tmux.

**Desktop Apps (macOS):** Affinity, Codex, Google Chrome, Pocket Casts,
Synology Drive, VLC, and WhatsApp

**Development Runtimes (via mise):** Node.js, Ruby

## Maintenance

Preview bootstrap changes or inspect current state:

```sh
mise bootstrap --dry-run
mise bootstrap status
```

On macOS, a final bootstrap hook upgrades configured formulae and casks, prunes
formulae outside the active configuration's dependency closure, and clears
stale Mise cache entries.
