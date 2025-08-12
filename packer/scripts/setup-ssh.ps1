# Setup OpenSSH Server for Packer provisioning
$ErrorActionPreference = "Stop"

Write-Host "Installing OpenSSH Server..."

# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start and enable SSH service
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Configure SSH
$sshdConfig = "C:\ProgramData\ssh\sshd_config"
if (Test-Path $sshdConfig) {
    # Allow password authentication
    (Get-Content $sshdConfig) -replace '#PasswordAuthentication yes', 'PasswordAuthentication yes' | Set-Content $sshdConfig
    # Set PowerShell as default shell
    Add-Content $sshdConfig "Subsystem powershell c:/progra~1/powershell/7/pwsh.exe -sshs -NoLogo -NoProfile"
}

# Open firewall
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Restart SSH service to apply config
Restart-Service sshd

Write-Host "SSH Server configured successfully"