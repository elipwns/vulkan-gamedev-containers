# Download Vulkan SDK installer
# This script downloads the Vulkan SDK installer to the installers/ directory

param(
    [string]$VulkanVersion = "1.4.321.1"
)

$ErrorActionPreference = "Stop"

# Create installers directory if it doesn't exist
$InstallersDir = Join-Path $PSScriptRoot "..\installers"
if (-not (Test-Path $InstallersDir)) {
    New-Item -ItemType Directory -Path $InstallersDir -Force
    Write-Host "Created installers directory: $InstallersDir"
}

# Vulkan SDK download URL (correct LunarG format)
$VulkanUrl = "https://sdk.lunarg.com/sdk/download/$VulkanVersion/windows/vulkansdk-windows-X64-$VulkanVersion.exe"
$VulkanInstaller = Join-Path $InstallersDir "vulkansdk-windows-X64-$VulkanVersion.exe"

Write-Host "Downloading Vulkan SDK $VulkanVersion..."
Write-Host "URL: $VulkanUrl"
Write-Host "Destination: $VulkanInstaller"

try {
    Invoke-WebRequest -Uri $VulkanUrl -OutFile $VulkanInstaller -UseBasicParsing
    Write-Host "✅ Downloaded Vulkan SDK installer successfully"
    Write-Host "File size: $((Get-Item $VulkanInstaller).Length / 1MB) MB"
} catch {
    Write-Error "❌ Failed to download Vulkan SDK: $_"
    exit 1
}

Write-Host ""
Write-Host "Ready to build! Run: packer build packer/windows-vulkan.pkr.hcl"