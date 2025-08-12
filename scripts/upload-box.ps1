# Upload Vagrant box to Vagrant Cloud
param(
    [string]$BoxFile = "vulkan-gamedev-windows-hyperv-final.box",
    [string]$BoxName = "elipwns/vulkan-gamedev-windows",
    [string]$Version = "1.0.0"
)

# Check if box file exists
if (-not (Test-Path $BoxFile)) {
    Write-Error "Box file not found: $BoxFile"
    exit 1
}

Write-Host "Uploading $BoxFile to Vagrant Cloud as $BoxName version $Version"

# Create version
vagrant cloud version create $BoxName $Version

# Create provider
vagrant cloud provider create $BoxName hyperv $Version

# Upload box
vagrant cloud provider upload $BoxName hyperv $Version $BoxFile

# Release version
vagrant cloud version release $BoxName $Version

Write-Host "Upload complete!"