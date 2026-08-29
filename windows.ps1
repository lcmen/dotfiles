Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($PSVersionTable.PSVersion -lt [version]"7.4") {
    throw "PowerShell 7.4 or newer is required. Run this script with pwsh.exe."
}

$scriptsDirectory = Join-Path $PSScriptRoot "windows"
$scripts = Get-ChildItem -Path $scriptsDirectory -Filter "*.ps1" -File | Sort-Object -Property Name
$failed = @()

foreach ($script in $scripts) {
    try {
        Write-Host "Running $($script.Name)..." -ForegroundColor Cyan
        & $script.FullName
    }
    catch {
        Write-Warning $_
        $failed += $script.BaseName
    }
}

if ($failed.Count -gt 0) {
    throw "Failed Windows scripts: $($failed -join ', ')"
}

Write-Host ""
Write-Host "Windows setup is complete." -ForegroundColor Green
