# Cleanup and optimize VM
$ErrorActionPreference = "Stop"

Write-Host "Cleaning up VM..."

# Clear temp files
Remove-Item -Path "C:\temp" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\chocolatey\logs" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Update cache
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

# Defragment disk
Optimize-Volume -DriveLetter C -Defrag

# Zero out free space for better compression
Write-Host "Zeroing free space for compression..."
sdelete -z -c C: -accepteula

Write-Host "VM cleanup completed"