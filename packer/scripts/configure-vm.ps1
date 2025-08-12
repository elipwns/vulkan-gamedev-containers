# Configure VM for development
$ErrorActionPreference = "Stop"

Write-Host "Configuring VM for development..."

# Disable Windows Defender real-time protection for better performance
Set-MpPreference -DisableRealtimeMonitoring $true

# Disable Windows Update automatic restart
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "UxOption" -Value 1

# Set power plan to High Performance
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Create desktop shortcut for PowerShell
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\PowerShell.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Save()

Write-Host "VM configured for development"