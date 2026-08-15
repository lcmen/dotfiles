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

## Windows

The Windows application installer requires [PowerShell 7.4 or newer](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows) and uses `winget`. Install the latest PowerShell release with:

```powershell
winget install --id Microsoft.PowerShell --source winget
```

To allow the script only in the current PowerShell window, run, then install `windows.ps1` script

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\windows.ps1
```

To launch the Windows installer directly from a WSL shell, run this from the repository root:

```sh
pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$PWD/windows.ps1")"
```

### AutoHotkey shortcuts

The Windows installer installs AutoHotkey v2, copies [`autohotkey/shortcuts.ahk`](autohotkey/shortcuts.ahk) into the current user's Windows Startup folder, downloads the pinned `VirtualDesktopAccessor.dll` release beside it, and starts the script. The DLL download is verified by SHA-256, and the shortcuts start automatically on subsequent sign-ins.

`Super+1` through `Super+9` switch directly to virtual desktops 1–9, and `Super+0` switches to desktop 10. This requires Windows 11 24H2 build 26100.2605 or newer and the requested desktop must already exist.

After changing the script, rerun the Windows installer from the repository root in WSL to copy and reload it:

```sh
pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$PWD/windows.ps1")"
```

If the script was previously started directly from the WSL repository, exit that instance from its AutoHotkey tray menu before running the installer once. This prevents the repository and Startup copies from running at the same time.

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

## Utilities

Rename photos from their EXIF timestamps, without changing anything first:

```sh
photon /path/to/photos --dry-run
```

Remove `--dry-run` to apply names in the `IMG_yyyyMMdd_HHmmss` format. Duplicate timestamps receive a numeric suffix.
