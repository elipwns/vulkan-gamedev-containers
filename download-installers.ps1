# Download Vulkan SDK installer locally for reliable container builds
param(
    [string]$VulkanVersion = "1.4.321.1"
)

$ErrorActionPreference = "Stop"

Write-Host "Downloading Vulkan SDK $VulkanVersion installer..."

$vulkanUrl = "https://sdk.lunarg.com/sdk/download/$VulkanVersion/windows/vulkansdk-windows-X64-$VulkanVersion.exe"
$installerPath = "installers/vulkansdk-windows-X64-$VulkanVersion.exe"

# Create installers directory if it doesn't exist
if (!(Test-Path "installers")) {
    New-Item -ItemType Directory -Path "installers"
}

# Download with progress
try {
    Write-Host "Downloading from: $vulkanUrl"
    Write-Host "Saving to: $installerPath"
    
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($vulkanUrl, $installerPath)
    
    $fileSize = (Get-Item $installerPath).Length / 1MB
    Write-Host "✅ Download completed successfully!"
    Write-Host "📦 File size: $([math]::Round($fileSize, 2)) MB"
    Write-Host "📁 Saved to: $installerPath"
    
    # Verify it's a valid executable
    if ((Get-Item $installerPath).Extension -eq ".exe") {
        Write-Host "✅ File appears to be a valid executable"
    } else {
        Write-Warning "⚠️  Downloaded file may not be a valid executable"
    }
    
} catch {
    Write-Error "❌ Failed to download Vulkan SDK: $_"
    exit 1
}

Write-Host ""
Write-Host "🎉 Ready for container build!"
Write-Host "Run: docker build -t vulkan-build-image ."