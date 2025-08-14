# Simple build script for vcpkg projects
param(
    [string]$BuildType = "Release"
)

Write-Host "Building project with vcpkg toolchain..."
Write-Host "Build type: $BuildType"

# Configure with vcpkg toolchain (using vcpkg's CMake)
& 'C:/vcpkg/downloads/tools/cmake-3.30.1-windows/cmake-3.30.1-windows-i386/bin/cmake.exe' -B build -S . -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE=$BuildType

if ($LASTEXITCODE -ne 0) {
    Write-Host "CMake configuration failed!" -ForegroundColor Red
    exit 1
}

# Build the project
& 'C:/vcpkg/downloads/tools/cmake-3.30.1-windows/cmake-3.30.1-windows-i386/bin/cmake.exe' --build build --config $BuildType

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "Executable is in: build/" -ForegroundColor Cyan