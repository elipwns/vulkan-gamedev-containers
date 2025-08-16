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

# Copy resource folders if they exist
$ResourceFolders = @("textures", "shaders", "models", "data")
foreach ($folder in $ResourceFolders) {
    if (Test-Path $folder) {
        Copy-Item $folder $DistDir -Recurse
        Write-Host "Copied $folder folder to portable distribution" -ForegroundColor Green
    } else {
        Write-Host "Warning: $folder folder not found - may cause runtime issues" -ForegroundColor Yellow
    }
}

# Copy vcpkg DLLs
Write-Host "Copying vcpkg DLLs..." -ForegroundColor Cyan

# Try multiple possible vcpkg DLL locations
$VcpkgPaths = @(
    "C:\vcpkg\installed\x64-windows\bin",
    "C:\vcpkg\packages\*\bin",
    "C:\vcpkg\buildtrees\*\x64-windows-rel\bin"
)

$DllsCopied = 0
foreach ($path in $VcpkgPaths) {
    if ($path -like "*\**") {
        # Handle wildcard paths
        Get-ChildItem $path -ErrorAction SilentlyContinue | ForEach-Object {
            if (Test-Path "$($_.FullName)\*.dll") {
                Get-ChildItem "$($_.FullName)\*.dll" | ForEach-Object {
                    Copy-Item $_.FullName $DistDir -ErrorAction SilentlyContinue
                    Write-Host "Copied vcpkg DLL: $($_.Name)" -ForegroundColor Green
                    $DllsCopied++
                }
            }
        }
    } else {
        # Handle direct paths
        if (Test-Path $path) {
            Get-ChildItem "$path\*.dll" -ErrorAction SilentlyContinue | ForEach-Object {
                Copy-Item $_.FullName $DistDir
                Write-Host "Copied vcpkg DLL: $($_.Name)" -ForegroundColor Green
                $DllsCopied++
            }
        }
    }
}

if ($DllsCopied -eq 0) {
    Write-Host "Warning: No vcpkg DLLs found. Checking vcpkg structure..." -ForegroundColor Yellow
    if (Test-Path "C:\vcpkg") {
        Write-Host "vcpkg directory contents:" -ForegroundColor Yellow
        Get-ChildItem "C:\vcpkg" | Select-Object Name, Mode | Format-Table -AutoSize
    }
}

# Copy VC++ redistributable DLLs if they exist
$VCRedistPaths = @(
    "C:\Windows\System32\msvcp140.dll",
    "C:\Windows\System32\vcruntime140.dll",
    "C:\Windows\System32\vcruntime140_1.dll"
)

foreach ($dll in $VCRedistPaths) {
    if (Test-Path $dll) {
        Copy-Item $dll $DistDir
        Write-Host "Copied VC++ redistributable: $(Split-Path $dll -Leaf)" -ForegroundColor Green
    }
}

Write-Host "Portable distribution created in: $DistDir" -ForegroundColor Cyan
Write-Host "Distribution contents:" -ForegroundColor Cyan
Get-ChildItem $DistDir | Select-Object Name, Length | Format-Table -AutoSize
Write-Host "" 
Write-Host "To run the portable distribution:" -ForegroundColor Yellow
Write-Host "$DistDir\Game_Engine.exe" -ForegroundColor White