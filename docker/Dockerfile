# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata labels
LABEL org.opencontainers.image.title="Vulkan GameDev Windows Container"
LABEL org.opencontainers.image.description="Ready-to-use Windows container for Vulkan C++ game development with vcpkg dependencies"
LABEL org.opencontainers.image.url="https://github.com/elipwns/vulkan-gamedev-containers"
LABEL org.opencontainers.image.source="https://github.com/elipwns/vulkan-gamedev-containers"
LABEL org.opencontainers.image.vendor="elipwns"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="1.0.20"
LABEL maintainer="elipwns"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy vcpkg manifest and build scripts
COPY docker/vcpkg.json C:/vcpkg.json
COPY docker/build.ps1 C:/build.ps1
COPY docker/build-portable.ps1 C:/build-portable.ps1

# Install Git
RUN Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe' -OutFile 'C:/git.exe'; `
    Start-Process -FilePath 'C:/git.exe' -ArgumentList '/VERYSILENT', '/NORESTART' -Wait; `
    Remove-Item 'C:/git.exe' -Force

# Note: vcpkg will download its own CMake version, so we don't need to install it separately

# Install Visual Studio Build Tools
RUN Invoke-WebRequest -Uri 'https://aka.ms/vs/16/release/vs_buildtools.exe' -OutFile 'C:/vs_buildtools.exe'; `
    Start-Process -FilePath 'C:/vs_buildtools.exe' -ArgumentList '--quiet', '--wait', '--add', 'Microsoft.VisualStudio.Workload.VCTools', '--includeRecommended' -Wait; `
    Remove-Item 'C:/vs_buildtools.exe' -Force

# Install vcpkg
RUN & 'C:/Program Files/Git/bin/git.exe' clone https://github.com/Microsoft/vcpkg.git C:/vcpkg; `
    C:/vcpkg/bootstrap-vcpkg.bat

# Install vcpkg packages from manifest (includes Vulkan headers/loader)
RUN C:/vcpkg/vcpkg install --triplet x64-windows; `
    Write-Host 'vcpkg packages installed:'; `
    C:/vcpkg/vcpkg list

# Clean up build artifacts to reduce size (but keep tools)
RUN Remove-Item -Path C:/vcpkg/buildtrees -Recurse -Force -ErrorAction SilentlyContinue; `
    Get-ChildItem C:/vcpkg/downloads -Exclude tools | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Set environment variables
ENV VCPKG_ROOT=C:/vcpkg
RUN $env:PATH = 'C:/vcpkg/downloads/tools/cmake-3.30.1-windows/cmake-3.30.1-windows-i386/bin;C:/Program Files/Git/bin;C:/vcpkg;' + $env:PATH; [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

# Verify installations
RUN Write-Host 'Verifying installations...'; `
    & 'C:/vcpkg/downloads/tools/cmake-3.30.1-windows/cmake-3.30.1-windows-i386/bin/cmake.exe' --version; `
    git --version; `
    C:/vcpkg/vcpkg version; `
    Write-Host 'vcpkg packages installed:' (C:/vcpkg/vcpkg list | Measure-Object -Line).Lines; `
    Write-Host 'Container ready for building!'

WORKDIR C:/workspace
CMD ["powershell"]