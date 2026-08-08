param(
    [string]$MacOSConfig
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install or update 'App Installer' from the Microsoft Store first."
}

$repoRoot = (Resolve-Path $PSScriptRoot).Path

if (-not $MacOSConfig) {
    $MacOSConfig = Join-Path $repoRoot "mise.macos.toml"
}

if (-not (Test-Path $MacOSConfig)) {
    throw "macOS bootstrap config not found: $MacOSConfig"
}

$packageMap = @{
    "affinity"                  = @{ Id = "Canva.Affinity";           Source = "winget" }
    "pocket-casts"              = @{ Id = "Automattic.PocketCasts"; Source = "winget" }
    "synology-drive"            = @{ Id = "Synology.DriveClient";   Source = "winget" }
    "vlc"                       = @{ Id = "VideoLAN.VLC";            Source = "winget" }
    "whatsapp"                  = @{ Id = "9NKSQGP7F2NH";            Source = "msstore" }
    "win32yank"                 = @{ Id = "equalsraf.win32yank";     Source = "winget" }
    "zed"                       = @{ Id = "ZedIndustries.Zed";       Source = "winget" }
}

$failed = @()

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$Source
    )

    & winget list `
        --id $Id `
        --exact `
        --accept-source-agreements `
        --disable-interactivity | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Name ($Id) is already installed." -ForegroundColor DarkGray
        return
    }

    Write-Host "Installing $Name ($Id)..." -ForegroundColor Cyan

    & winget install `
        --id $Id `
        --exact `
        --source $Source `
        --accept-package-agreements `
        --accept-source-agreements `
        --silent `
        --disable-interactivity

    if ($LASTEXITCODE -ne 0) {
        throw "winget failed to install $Name (exit code $LASTEXITCODE)"
    }
}

function Register-FontFiles {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]]$Fonts
    )

    if (-not ("FontRegistration.NativeMethods" -as [type])) {
        Add-Type @"
namespace FontRegistration {
    using System;
    using System.Runtime.InteropServices;

    public static class NativeMethods {
        [DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
        public static extern int AddFontResourceEx(string fileName, uint flags, IntPtr reserved);

        [DllImport("user32.dll", CharSet = CharSet.Unicode)]
        public static extern bool SendNotifyMessage(IntPtr window, uint message, IntPtr wParam, IntPtr lParam);
    }
}
"@
    }

    foreach ($font in $Fonts) {
        [FontRegistration.NativeMethods]::AddFontResourceEx($font.FullName, 0, [IntPtr]::Zero) | Out-Null
    }

    $hwndBroadcast = [IntPtr]0xffff
    $wmFontChange = 0x001d
    [FontRegistration.NativeMethods]::SendNotifyMessage($hwndBroadcast, $wmFontChange, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
}

function Install-FiraCodeNerdFont {
    $fontRegistry = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    $fontDirectory = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
    $installedFonts = @(Get-ChildItem -Path $fontDirectory -Filter "FiraCodeNerdFont-*.ttf" -ErrorAction SilentlyContinue)

    if ($installedFonts.Count -gt 0) {
        Register-FontFiles -Fonts $installedFonts
        Write-Host "FiraCode Nerd Font is already installed." -ForegroundColor DarkGray
        return
    }

    $temporaryDirectory = Join-Path ([IO.Path]::GetTempPath()) ("FiraCodeNerdFont-" + [guid]::NewGuid())
    $archive = Join-Path $temporaryDirectory "FiraCode.zip"

    try {
        New-Item -ItemType Directory -Path $temporaryDirectory -Force | Out-Null
        New-Item -ItemType Directory -Path $fontDirectory -Force | Out-Null

        Write-Host "Installing FiraCode Nerd Font..." -ForegroundColor Cyan
        Invoke-WebRequest `
            -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" `
            -OutFile $archive
        Expand-Archive -Path $archive -DestinationPath $temporaryDirectory -Force

        $fonts = Get-ChildItem -Path $temporaryDirectory -Filter "FiraCodeNerdFont-*.ttf"
        if (-not $fonts) {
            throw "The FiraCode Nerd Font archive did not contain the expected font files."
        }

        foreach ($font in $fonts) {
            $destination = Join-Path $fontDirectory $font.Name
            Copy-Item -Path $font.FullName -Destination $destination -Force
            New-ItemProperty `
                -Path $fontRegistry `
                -Name "$($font.BaseName) (TrueType)" `
                -Value $destination `
                -PropertyType String `
                -Force | Out-Null
        }

        Register-FontFiles -Fonts $fonts
    }
    finally {
        if (Test-Path $temporaryDirectory) {
            Remove-Item -Path $temporaryDirectory -Recurse -Force
        }
    }
}

function Copy-ZedConfig {
    $sourceDirectory = Join-Path $repoRoot "zed"
    $destinationDirectory = Join-Path $env:APPDATA "Zed"

    if (-not (Test-Path $sourceDirectory -PathType Container)) {
        throw "Zed config directory not found: $sourceDirectory"
    }

    Write-Host "Copying Zed configuration to $destinationDirectory..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null

    foreach ($item in Get-ChildItem -Path $sourceDirectory -Force) {
        Copy-Item -Path $item.FullName -Destination $destinationDirectory -Recurse -Force
    }
}

try {
    Install-FiraCodeNerdFont
}
catch {
    Write-Warning $_
    $failed += "font-fira-code-nerd-font"
}

foreach ($entry in ($packageMap.GetEnumerator() | Sort-Object -Property Name)) {
    $app = $entry.Name
    $package = $entry.Value

    try {
        Install-WingetPackage `
            -Name $app `
            -Id $package.Id `
            -Source $package.Source
    }
    catch {
        Write-Warning $_
        $failed += $app
    }
}

try {
    Copy-ZedConfig
}
catch {
    Write-Warning $_
    $failed += "zed-config"
}

if ($failed.Count -gt 0) {
    throw "Failed Windows installs: $($failed -join ', ')"
}

Write-Host ""
Write-Host "Upgrading all winget packages..." -ForegroundColor Cyan

& winget upgrade `
    --all `
    --accept-package-agreements `
    --accept-source-agreements `
    --silent `
    --disable-interactivity

$noAvailableUpgrade = -1978335189 # 0x8A15002B
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $noAvailableUpgrade) {
    throw "winget failed to upgrade installed packages (exit code $LASTEXITCODE)"
}

Write-Host ""
Write-Host "Windows desktop apps are installed." -ForegroundColor Green
