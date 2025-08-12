# Quick version bumping script
param(
    [switch]$Patch,
    [switch]$Minor, 
    [switch]$Major,
    [switch]$Show
)

if (-not (Test-Path "VERSION")) {
    "0.0.1" | Out-File "VERSION" -NoNewline
    Write-Host "📝 Created VERSION file with 0.0.1"
}

$currentVersion = (Get-Content "VERSION").Trim()

if ($Show) {
    Write-Host "📋 Current version: v$currentVersion"
    exit
}

$parts = $currentVersion.Split('.')
$major = [int]$parts[0]
$minor = [int]$parts[1] 
$patch = [int]$parts[2]

if ($Major) {
    $major++; $minor = 0; $patch = 0
} elseif ($Minor) {
    $minor++; $patch = 0
} elseif ($Patch) {
    $patch++
} else {
    Write-Host "Usage:"
    Write-Host "  .\bump-version.ps1 -Patch   # 0.0.1 -> 0.0.2"
    Write-Host "  .\bump-version.ps1 -Minor   # 0.0.1 -> 0.1.0" 
    Write-Host "  .\bump-version.ps1 -Major   # 0.0.1 -> 1.0.0"
    Write-Host "  .\bump-version.ps1 -Show    # Show current version"
    exit
}

$newVersion = "$major.$minor.$patch"
$newVersion | Out-File "VERSION" -NoNewline

Write-Host "🔼 Bumped version: v$currentVersion -> v$newVersion"