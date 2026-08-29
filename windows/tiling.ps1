[CmdletBinding()]
param(
    [ValidateRange(0, 50)]
    [int]$Gap = 4,

    [switch]$ForceConfig
)

$ErrorActionPreference = "Stop"
$InstallerVersion = "2026-08-29.1"

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content
    )

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Find-AutoHotkey {
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\AutoHotkey\v2\AutoHotkey64.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\AutoHotkey\v2\AutoHotkey.exe"),
        (Join-Path $env:ProgramFiles "AutoHotkey\v2\AutoHotkey64.exe"),
        (Join-Path $env:ProgramFiles "AutoHotkey\v2\AutoHotkey.exe")
    )

    if (${env:ProgramFiles(x86)}) {
        $candidates += Join-Path `
            ${env:ProgramFiles(x86)} `
            "AutoHotkey\v2\AutoHotkey32.exe"
    }

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path $candidate -PathType Leaf)) {
            return (Resolve-Path $candidate).Path
        }
    }

    foreach ($name in @(
        "AutoHotkey64.exe",
        "AutoHotkey32.exe",
        "AutoHotkey.exe"
    )) {
        $command = Get-Command $name -ErrorAction SilentlyContinue

        if (
            $command -and
            $command.Source -and
            (Test-Path $command.Source -PathType Leaf)
        ) {
            return $command.Source
        }
    }

    return $null
}

function Stop-ManagedAutoHotkey {
    param([Parameter(Mandatory)][string]$ScriptPath)

    try {
        Get-CimInstance Win32_Process |
            Where-Object {
                $_.CommandLine -and
                $_.CommandLine.Contains($ScriptPath)
            } |
            ForEach-Object {
                Stop-Process `
                    -Id $_.ProcessId `
                    -Force `
                    -ErrorAction SilentlyContinue
            }
    } catch {}
}

Write-Host "Installer version: $InstallerVersion" -ForegroundColor Green

Write-Step "Locating LeopardWM and AutoHotkey"

Refresh-Path

$lwmCommand = Get-Command lwm.exe -ErrorAction SilentlyContinue
if (-not $lwmCommand) {
    $lwmCommand = Get-Command lwm -ErrorAction SilentlyContinue
}

if (
    -not $lwmCommand -or
    [string]::IsNullOrWhiteSpace($lwmCommand.Source)
) {
    throw @"
LeopardWM is not installed or 'lwm' is not visible in this PowerShell session.

Run windows/apps.ps1, open a new PowerShell window, and rerun this script.
"@
}

$lwmExe = $lwmCommand.Source
$ahkExe = Find-AutoHotkey

if (
    [string]::IsNullOrWhiteSpace($ahkExe) -or
    -not (Test-Path $ahkExe -PathType Leaf)
) {
    throw @"
AutoHotkey v2 is not installed or its executable could not be located.

Run windows/apps.ps1, open a new PowerShell window, and rerun this script.
"@
}

Write-Host "lwm        : $lwmExe"
Write-Host "AutoHotkey : $ahkExe"

Write-Step "Creating LeopardWM configuration"

$configDir = Join-Path $env:APPDATA "leopardwm\config"
$configPath = Join-Path $configDir "config.toml"

New-Item -ItemType Directory -Force -Path $configDir | Out-Null

if ($ForceConfig -or -not (Test-Path $configPath)) {
    $args = @("config", "init", "--output", $configPath)

    if ($ForceConfig) {
        $args += "--force"
    }

    & $lwmExe @args

    if ($LASTEXITCODE -ne 0) {
        throw "lwm config init failed."
    }
} else {
    Write-Host "Keeping existing LeopardWM config: $configPath"
}

if (-not (Test-Path $configPath)) {
    throw "LeopardWM config was not created: $configPath"
}

$config = Get-Content $configPath -Raw

$config = [regex]::Replace(
    $config,
    '(?m)^gap\s*=\s*\d+\s*$',
    "gap = $Gap",
    1
)

foreach ($side in @("left", "right", "top", "bottom")) {
    $config = [regex]::Replace(
        $config,
        "(?m)^outer_gap_$side\s*=\s*\d+\s*$",
        "outer_gap_$side = $Gap",
        1
    )
}

$config = [regex]::Replace(
    $config,
    '(?m)^width_presets\s*=\s*\[[^\]]*\]\s*$',
    'width_presets = [0.333, 0.5, 0.667]',
    1
)

$config = [regex]::Replace(
    $config,
    '(?m)^default_width_preset\s*=\s*\d+\s*$',
    'default_width_preset = 2',
    1
)

Write-Utf8NoBom -Path $configPath -Content $config

Write-Host "LeopardWM config:"
Write-Host "  $configPath"
Write-Host "Gap:"
Write-Host "  ${Gap}px"

Write-Step "Creating AutoHotkey bindings"

$ahkDir = Join-Path $env:APPDATA "leopardwm"
New-Item -ItemType Directory -Force -Path $ahkDir | Out-Null

$ahkConfig = Join-Path $ahkDir "leopardwm.ahk"

$ahkText = @'
#Requires AutoHotkey v2.0+
#SingleInstance Force
SendMode "Input"

Lwm(command) {
    RunWait("lwm.exe " . command, , "Hide")
}

CycleWidth() {
    static presetIndex := 1
    nextPresetIndex := Mod(presetIndex + 1, 3)

    if nextPresetIndex = 0 {
        Lwm("cycle-width-down")
        Lwm("cycle-width-down")
    } else {
        Lwm("cycle-width-up")
    }

    presetIndex := nextPresetIndex
}

#Left::Lwm("focus left")
#Right::Lwm("focus right")
#Up::Lwm("focus up")
#Down::Lwm("focus down")

#+Left::Lwm("move left")
#+Right::Lwm("move right")
#+Up::Lwm("move-window up")
#+Down::Lwm("move-window down")

#1::Lwm("workspace 1")
#2::Lwm("workspace 2")
#3::Lwm("workspace 3")
#4::Lwm("workspace 4")
#5::Lwm("workspace 5")
#6::Lwm("workspace 6")
#7::Lwm("workspace 7")
#8::Lwm("workspace 8")
#9::Lwm("workspace 9")

#+1::Lwm("move-to-workspace 1")
#+2::Lwm("move-to-workspace 2")
#+3::Lwm("move-to-workspace 3")
#+4::Lwm("move-to-workspace 4")
#+5::Lwm("move-to-workspace 5")
#+6::Lwm("move-to-workspace 6")
#+7::Lwm("move-to-workspace 7")
#+8::Lwm("move-to-workspace 8")
#+9::Lwm("move-to-workspace 9")

#[::Lwm("workspace-prev")
#]::Lwm("workspace-next")

#+[::Lwm("move-to-workspace-prev")
#+]::Lwm("move-to-workspace-next")

#t::Lwm("toggle-floating")
#f::Lwm("toggle-fullscreen")
#+t::Lwm("toggle-tabbed")
#c::Lwm("center-column")
#m::Lwm("maximize-column")
#o::Lwm("toggle-overview")

#r::CycleWidth()
#-::Lwm("cycle-width-down")
#=::Lwm("cycle-width-up")
#+-::Lwm("cycle-height-down")
#+=::Lwm("cycle-height-up")
#0::Lwm("equalize-widths")
#+0::Lwm("equalize-heights")

#q::WinClose "A"
<#Tab::AltTab
>#Tab::AltTab

~LWin Up::Return
~RWin Up::Return

#Enter::Run("wt.exe")

#+r::{
    Lwm("reload")
    Reload()
}
'@

Write-Utf8NoBom -Path $ahkConfig -Content $ahkText

Write-Host "AutoHotkey config:"
Write-Host "  $ahkConfig"

Write-Step "Configuring autostart"

& $lwmExe autostart enable

if ($LASTEXITCODE -ne 0) {
    throw "Failed to enable LeopardWM autostart."
}

$startupDir = [Environment]::GetFolderPath("Startup")
$ahkStartupShortcut = Join-Path $startupDir "LeopardWM Hotkeys.lnk"

$wsh = New-Object -ComObject WScript.Shell
$shortcut = $wsh.CreateShortcut($ahkStartupShortcut)
$shortcut.TargetPath = $ahkExe
$shortcut.Arguments = "`"$ahkConfig`""
$shortcut.WorkingDirectory = $ahkDir
$shortcut.Description = "LeopardWM AutoHotkey bindings"
$shortcut.Save()

if (-not (Test-Path $ahkStartupShortcut)) {
    throw "Failed to create AutoHotkey Startup shortcut."
}

Write-Host "AutoHotkey Startup:"
Write-Host "  $ahkStartupShortcut"

Write-Step "Starting LeopardWM"

& $lwmExe run

if ($LASTEXITCODE -ne 0) {
    throw "LeopardWM failed to start."
}

Start-Sleep -Milliseconds 750
& $lwmExe reload *> $null

Write-Step "Starting AutoHotkey"

Stop-ManagedAutoHotkey -ScriptPath $ahkConfig

$ahkProcess = Start-Process `
    -FilePath $ahkExe `
    -ArgumentList "`"$ahkConfig`"" `
    -WorkingDirectory $ahkDir `
    -PassThru

Start-Sleep -Milliseconds 800

$ahkRunning = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object {
        $_.CommandLine -and
        $_.CommandLine.Contains($ahkConfig)
    } |
    Select-Object -First 1

if (-not $ahkRunning) {
    $exitInfo = ""

    try {
        if ($ahkProcess.HasExited) {
            $exitInfo = " AutoHotkey exited with code $($ahkProcess.ExitCode)."
        }
    } catch {}

    throw @"
AutoHotkey did not stay running.$exitInfo

Executable:
  $ahkExe

Script:
  $ahkConfig

Run this manually to see any AutoHotkey parser error:
  & '$ahkExe' '$ahkConfig'
"@
}

Write-Step "Verifying LeopardWM"

$status = & $lwmExe status 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Warning "LeopardWM status check failed."
} else {
    $status | ForEach-Object { Write-Host $_ }
}

Write-Step "Done"

Write-Host ""
Write-Host "LeopardWM     : installed and started"
Write-Host "AutoHotkey    : running (PID $($ahkRunning.ProcessId))"
Write-Host "Config        : $configPath"
Write-Host "AHK           : $ahkConfig"
Write-Host "AHK autostart : $ahkStartupShortcut"
Write-Host ""
Write-Host "Keybindings:"
Write-Host "  Win+Arrow                 focus"
Write-Host "  Win+Shift+Arrow           move"
Write-Host "  Win+1..9                  workspace"
Write-Host "  Win+Shift+1..9            move to workspace"
Write-Host "  Win+[ / ]                 prev / next workspace"
Write-Host "  Win+Shift+[ / ]           move to prev / next workspace"
Write-Host "  Win+T                     float"
Write-Host "  Win+F                     fullscreen"
Write-Host "  Win+Shift+T               tabbed column"
Write-Host "  Win+C                     center column"
Write-Host "  Win+M                     maximize column"
Write-Host "  Win+O                     workspace overview"
Write-Host "  Win+R                     cycle column width"
Write-Host "  Win+- / =                 column width"
Write-Host "  Win+Shift+- / =           window height"
Write-Host "  Win+Q                     close active window"
Write-Host "  Win+Tab                   Alt+Tab switcher"
Write-Host "  Win+Enter                 terminal"
Write-Host ""
Write-Host "Windows shortcuts intentionally preserved:"
Write-Host "  Win+L, Win+E, Win+I, Win+V, Win+Shift+S"
Write-Host ""
Write-Host "Diagnostics:"
Write-Host "  lwm status"
Write-Host "  lwm doctor"
