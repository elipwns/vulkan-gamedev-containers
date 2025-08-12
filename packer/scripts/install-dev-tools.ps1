# Install development tools
$ErrorActionPreference = "Stop"

Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "Installing development tools..."
choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install -y git
choco install -y visualstudio2022buildtools --package-parameters '--add Microsoft.VisualStudio.Workload.VCTools'

Write-Host "Development tools installed"