# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Metadata labels
LABEL org.opencontainers.image.title="Vulkan GameDev Windows Container"
LABEL org.opencontainers.image.description="Ready-to-use Windows container for Vulkan C++ game development with SDK 1.4.321.1, Visual Studio Build Tools, and CMake"
LABEL org.opencontainers.image.url="https://github.com/elipwns/vulkan-gamedev-windows"
LABEL org.opencontainers.image.source="https://github.com/elipwns/vulkan-gamedev-windows"
LABEL org.opencontainers.image.vendor="elipwns"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="0.0.1"
LABEL vulkan.sdk.version="1.4.321.1"
LABEL maintainer="elipwns"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy installer
COPY installers/vulkansdk-windows-X64-1.4.321.1.exe C:/temp/vulkan-installer.exe

# Install Vulkan SDK
RUN Write-Host 'Installing Vulkan SDK...'; Start-Process -FilePath 'C:/temp/vulkan-installer.exe' -ArgumentList '/S' -Wait; Write-Host 'Vulkan SDK installed'

# Install Chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install development tools
RUN choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
RUN choco install -y git
RUN choco install -y visualstudio2022buildtools --package-parameters '--add Microsoft.VisualStudio.Workload.VCTools'

# Set environment variables
ENV VULKAN_SDK=C:/VulkanSDK/1.4.321.1
RUN $env:PATH = 'C:/VulkanSDK/1.4.321.1/Bin;C:/Program Files/CMake/bin;' + $env:PATH; [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

# Clean up
RUN Remove-Item -Path C:/temp -Recurse -Force; Remove-Item -Path C:/ProgramData/chocolatey/logs -Recurse -Force -ErrorAction SilentlyContinue

# Verify installations
RUN Write-Host 'Verifying installations...'; cmake --version; git --version; if (Test-Path $env:VULKAN_SDK) { Write-Host 'Vulkan SDK found at:' $env:VULKAN_SDK } else { Write-Host 'Vulkan SDK not found!' }

WORKDIR C:/workspace
CMD ["powershell"]