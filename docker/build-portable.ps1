# Build script that creates portable Windows distribution
param(
    [string]$BuildType = "Release"
)

Write-Host "Building portable Windows distribution..."
Write-Host "Build type: $BuildType"

# First, build the regular executable
& 'C:/vcpkg/downloads/tools/cmake-3.30.1-windows/cmake-3.30.1-windows-i386/bin/cmake.exe' -B build -S . -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE=$BuildType

if ($LASTEXITCODE -ne 0) {
    Write-Host "CMake configuration failed!" -ForegroundColor Red
    exit 1
}

& 'C:/vcpkg/downloads/tools/cmake-3.30.1-windows/cmake-3.30.1-windows-i386/bin/cmake.exe' --build build --config $BuildType

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green

# Create portable distribution
$DistDir = "Game_Engine_Portable"
if (Test-Path $DistDir) {
    Remove-Item $DistDir -Recurse -Force
}
New-Item -ItemType Directory -Path $DistDir

# Copy executable
Copy-Item "build\$BuildType\Game_Engine.exe" $DistDir

# Copy VC++ redistributable DLLs if they exist
$VCRedistPaths = @(
    "C:\Windows\System32\msvcp140.dll",
    "C:\Windows\System32\vcruntime140.dll",
    "C:\Windows\System32\vcruntime140_1.dll"
)

foreach ($dll in $VCRedistPaths) {
    if (Test-Path $dll) {
        Copy-Item $dll $DistDir
        Write-Host "Copied: $dll"
    }
}

Write-Host "Portable distribution created in: $DistDir" -ForegroundColor Cyan