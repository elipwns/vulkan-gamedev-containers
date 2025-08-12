# Setup WinRM for Packer provisioning
$ErrorActionPreference = "Stop"

# Enable WinRM
Enable-PSRemoting -Force
Set-WSManQuickConfig -Force

# Configure WinRM
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

# Open firewall
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow

# Start WinRM service
Start-Service WinRM
Set-Service WinRM -StartupType Automatic

Write-Host "WinRM configured successfully"