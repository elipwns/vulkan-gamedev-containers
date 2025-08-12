# Install Vulkan SDK
$ErrorActionPreference = "Stop"

$VulkanVersion = $env:VULKAN_VERSION
if (-not $VulkanVersion) { $VulkanVersion = "1.4.321.1" }

Write-Host "Installing Vulkan SDK $VulkanVersion..."

# Download installer
$InstallerPath = "C:\temp\vulkan-installer.exe"
$DownloadUrl = "https://sdk.lunarg.com/sdk/download/$VulkanVersion/windows/vulkansdk-windows-X64-$VulkanVersion.exe"

New-Item -ItemType Directory -Path "C:\temp" -Force
Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath

# Install silently
Start-Process -FilePath $InstallerPath -ArgumentList '/S' -Wait

# Set environment variable
$VulkanPath = "C:\VulkanSDK\$VulkanVersion"
[Environment]::SetEnvironmentVariable("VULKAN_SDK", $VulkanPath, "Machine")

Write-Host "Vulkan SDK installed at $VulkanPath"