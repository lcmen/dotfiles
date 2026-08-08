# .files

Dotfiles and repository-scoped machine bootstrap configuration for macOS, Windows, Ubuntu, and Fedora, managed with [mise](https://mise.jdx.dev/).

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

### Windows applications

The Windows application installer uses `winget`. When the repository is stored in WSL, Windows treats the script's `\\wsl.localhost` path as remote and may require a signed script under the default execution policy.

To allow the script only in the current PowerShell window, run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\windows.ps1
```

The policy change expires when that PowerShell window is closed.

To launch the Windows installer directly from a WSL shell, run this from the repository root:

```sh
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$PWD/windows.ps1")"
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
