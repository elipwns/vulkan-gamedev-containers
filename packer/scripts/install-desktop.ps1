# Install Windows Desktop Experience
$ErrorActionPreference = "Stop"

Write-Host "Installing Desktop Experience..."
Install-WindowsFeature Server-Gui-Mgmt-Infra,Server-Gui-Shell -Restart

Write-Host "Desktop Experience installed"