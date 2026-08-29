Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($PSVersionTable.PSVersion -lt [version]"7.4") {
    throw "PowerShell 7.4 or newer is required. Run this script with pwsh.exe."
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install or update 'App Installer' from the Microsoft Store first."
}

$packageMap = @{
    "affinity"       = @{ Id = "Canva.Affinity";        Source = "winget" }
    "autohotkey"     = @{ Id = "AutoHotkey.AutoHotkey"; Source = "winget" }
    "icloud"         = @{ Id = "9PKTQ5699M62";          Source = "msstore" }
    "leopardwm"      = @{ Id = "jcardama.LeopardWM";    Source = "winget" }
    "synology-drive" = @{ Id = "Synology.DriveClient";  Source = "winget" }
    "vlc"            = @{ Id = "VideoLAN.VLC";          Source = "winget" }
    "whatsapp"       = @{ Id = "9NKSQGP7F2NH";          Source = "msstore" }
    "win32yank"      = @{ Id = "equalsraf.win32yank";   Source = "winget" }
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

if ($failed.Count -gt 0) {
    throw "Failed Windows app installs: $($failed -join ', ')"
}

Write-Host ""
Write-Host "Upgrading all winget packages..." -ForegroundColor Cyan

& winget upgrade --all --accept-package-agreements --accept-source-agreements --silent --disable-interactivity

$noAvailableUpgrade = -1978335189
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $noAvailableUpgrade) {
    throw "winget failed to upgrade installed packages (exit code $LASTEXITCODE)"
}

Write-Host ""
Write-Host "Windows apps are installed." -ForegroundColor Green
