Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($PSVersionTable.PSVersion -lt [version]"7.4") {
    throw "PowerShell 7.4 or newer is required. Run this script with pwsh.exe."
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install or update 'App Installer' from the Microsoft Store first."
}

$repoRoot = (Resolve-Path $PSScriptRoot).Path

$packageMap = @{
    "affinity"       = @{ Id = "Canva.Affinity";        Source = "winget" }
    "autohotkey"     = @{ Id = "AutoHotkey.AutoHotkey"; Source = "winget" }
    "icloud"         = @{ Id = "9PKTQ5699M62";          Source = "msstore" }
    "synology-drive" = @{ Id = "Synology.DriveClient";  Source = "winget" }
    "vlc"            = @{ Id = "VideoLAN.VLC";          Source = "winget" }
    "whatsapp"       = @{ Id = "9NKSQGP7F2NH";          Source = "msstore" }
    "win32yank"      = @{ Id = "equalsraf.win32yank";   Source = "winget" }
    "zed"            = @{ Id = "ZedIndustries.Zed";     Source = "winget" }
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

    & winget list --id $Id --exact --accept-source-agreements --disable-interactivity | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Name ($Id) is already installed." -ForegroundColor DarkGray
        return
    }

    Write-Host "Installing $Name ($Id)..." -ForegroundColor Cyan

    & winget install --id $Id --exact --source $Source --accept-package-agreements --accept-source-agreements --silent --disable-interactivity

    if ($LASTEXITCODE -ne 0) {
        throw "winget failed to install $Name (exit code $LASTEXITCODE)"
    }
}

function Install-FiraCodeNerdFont {
    if (-not (Get-Module -ListAvailable -Name NerdFonts)) {
        Install-PSResource -Name NerdFonts -Scope CurrentUser -TrustRepository
    }

    Write-Host "Installing FiraCode Nerd Font..." -ForegroundColor Cyan
    Import-Module NerdFonts
    Install-NerdFont -Name FiraCode
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

function Install-AutoHotkeyShortcuts {
    $source = Join-Path $repoRoot "autohotkey\shortcuts.ahk"
    $startupDirectory = [Environment]::GetFolderPath("Startup")
    $destination = Join-Path $startupDirectory "shortcuts.ahk"
    $dllDestination = Join-Path $startupDirectory "VirtualDesktopAccessor.dll"
    $dllUri = "https://github.com/Ciantic/VirtualDesktopAccessor/releases/download/2024-12-16-windows11/VirtualDesktopAccessor.dll"
    $dllSha256 = "8740C572A1C000E3B87FFEB1E4C397EAE9AF3BD4A2ABDC3BCFFACAB4493F8FF5"

    if (-not (Test-Path $source -PathType Leaf)) {
        throw "AutoHotkey shortcuts not found: $source"
    }

    New-Item -ItemType Directory -Path $startupDirectory -Force | Out-Null

    $installedDllIsCurrent = (Test-Path $dllDestination -PathType Leaf) -and ((Get-FileHash -Path $dllDestination -Algorithm SHA256).Hash -eq $dllSha256)

    if (-not $installedDllIsCurrent) {
        $temporaryDll = Join-Path ([IO.Path]::GetTempPath()) ("VirtualDesktopAccessor-" + [guid]::NewGuid() + ".dll")

        try {
            Write-Host "Downloading VirtualDesktopAccessor.dll..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $dllUri -OutFile $temporaryDll

            $downloadedSha256 = (Get-FileHash -Path $temporaryDll -Algorithm SHA256).Hash
            if ($downloadedSha256 -ne $dllSha256) {
                throw "VirtualDesktopAccessor.dll checksum mismatch."
            }

            Copy-Item -Path $temporaryDll -Destination $dllDestination -Force
        }
        finally {
            if (Test-Path $temporaryDll) {
                Remove-Item -Path $temporaryDll -Force
            }
        }
    }

    Write-Host "Copying AutoHotkey shortcuts to $destination..." -ForegroundColor Cyan
    Copy-Item -Path $source -Destination $destination -Force
    Start-Process -FilePath $destination
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
        Install-WingetPackage -Name $app -Id $package.Id -Source $package.Source
    }
    catch {
        Write-Warning $_
        $failed += $app
    }
}

try {
    Install-AutoHotkeyShortcuts
}
catch {
    Write-Warning $_
    $failed += "autohotkey-shortcuts"
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

& winget upgrade --all --accept-package-agreements --accept-source-agreements --silent --disable-interactivity

$noAvailableUpgrade = -1978335189 # 0x8A15002B
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $noAvailableUpgrade) {
    throw "winget failed to upgrade installed packages (exit code $LASTEXITCODE)"
}

Write-Host ""
Write-Host "Windows desktop apps are installed." -ForegroundColor Green
