# Export VM without checkpoints
param(
    [string]$VMName = "vulkan-gamedev-manual",
    [string]$ExportPath = "C:\temp\vm-export-clean"
)

# Ensure VM is stopped
Write-Host "Stopping VM: $VMName"
Stop-VM -Name $VMName -Force -ErrorAction SilentlyContinue

# Remove any checkpoints first
Write-Host "Removing checkpoints..."
Get-VMSnapshot -VMName $VMName -ErrorAction SilentlyContinue | Remove-VMSnapshot

# Wait for checkpoint removal to complete
Start-Sleep -Seconds 10

# Remove existing export directory
if (Test-Path $ExportPath) {
    Write-Host "Removing existing export directory..."
    Remove-Item $ExportPath -Recurse -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Create fresh export directory
New-Item -ItemType Directory -Path $ExportPath -Force | Out-Null

# Export VM
Write-Host "Exporting VM to: $ExportPath"
Export-VM -Name $VMName -Path $ExportPath

Write-Host "VM exported successfully to: $ExportPath"