# Publish Vulkan GameDev Windows Container
# This script tags and pushes the image to multiple registries with proper metadata

param(
    [string]$SemanticVersion = "",
    [string]$VulkanVersion = "1.4.321.1",
    [string]$BuildDate = (Get-Date -Format "yyyy-MM-dd"),
    [switch]$BumpPatch,
    [switch]$BumpMinor,
    [switch]$BumpMajor
)

# Auto-read version from VERSION file if not specified
if (-not $SemanticVersion) {
    if (Test-Path "VERSION") {
        $SemanticVersion = (Get-Content "VERSION").Trim()
        Write-Host "📋 Using version from VERSION file: v$SemanticVersion"
    } else {
        $SemanticVersion = "0.0.1"
        Write-Host "⚠️  No VERSION file found, using default: v$SemanticVersion"
    }
}

# Handle version bumping
if ($BumpPatch -or $BumpMinor -or $BumpMajor) {
    $parts = $SemanticVersion.Split('.')
    $major = [int]$parts[0]
    $minor = [int]$parts[1]
    $patch = [int]$parts[2]
    
    if ($BumpMajor) {
        $major++; $minor = 0; $patch = 0
    } elseif ($BumpMinor) {
        $minor++; $patch = 0
    } elseif ($BumpPatch) {
        $patch++
    }
    
    $SemanticVersion = "$major.$minor.$patch"
    Set-Content "VERSION" $SemanticVersion
    Write-Host "🔼 Bumped version to: v$SemanticVersion"
}

# Load environment variables from .env file
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#][^=]*)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
    Write-Host "✅ Loaded environment variables from .env"
} else {
    Write-Error "❌ .env file not found. Copy .env.example to .env and fill in your values."
    exit 1
}

$Username = $env:GITHUB_USERNAME
if (-not $Username) {
    Write-Error "❌ GITHUB_USERNAME not set in .env file"
    exit 1
}

$ImageName = "vulkan-gamedev-windows"
$LocalImage = "${ImageName}:latest"

Write-Host "🚀 Publishing $LocalImage as v$SemanticVersion to registries..."

# GitHub Container Registry (GHCR)
$GhcrImage = "ghcr.io/$Username/$ImageName"
Write-Host "📦 Tagging for GHCR..."
docker tag $LocalImage "${GhcrImage}:latest"
docker tag $LocalImage "${GhcrImage}:v$SemanticVersion"
docker tag $LocalImage "${GhcrImage}:vulkan-$VulkanVersion"
docker tag $LocalImage "${GhcrImage}:$BuildDate"

Write-Host "🔐 Logging into GHCR..."
echo $env:GITHUB_TOKEN | docker login ghcr.io -u $env:GITHUB_USERNAME --password-stdin

Write-Host "⬆️  Pushing to GHCR..."
docker push "${GhcrImage}:latest"
docker push "${GhcrImage}:v$SemanticVersion"
docker push "${GhcrImage}:vulkan-$VulkanVersion"
docker push "${GhcrImage}:$BuildDate"

# Docker Hub
$DockerHubUsername = $env:DOCKERHUB_USERNAME
if ($DockerHubUsername) {
    $DockerHubImage = "$DockerHubUsername/$ImageName"
    Write-Host "📦 Tagging for Docker Hub..."
    docker tag $LocalImage "${DockerHubImage}:latest"
    docker tag $LocalImage "${DockerHubImage}:v$SemanticVersion"
    docker tag $LocalImage "${DockerHubImage}:vulkan-$VulkanVersion"
    docker tag $LocalImage "${DockerHubImage}:$BuildDate"

    Write-Host "🔐 Logging into Docker Hub..."
    echo $env:DOCKERHUB_TOKEN | docker login -u $env:DOCKERHUB_USERNAME --password-stdin

    Write-Host "⬆️  Pushing to Docker Hub..."
    docker push "${DockerHubImage}:latest"
    docker push "${DockerHubImage}:v$SemanticVersion"
    docker push "${DockerHubImage}:vulkan-$VulkanVersion"
    docker push "${DockerHubImage}:$BuildDate"
} else {
    Write-Host "⚠️  Skipping Docker Hub (DOCKERHUB_USERNAME not set)"
}

# Create Git Tag
Write-Host "🏷️  Creating git tag v$SemanticVersion..."
try {
    git tag "v$SemanticVersion" -m "Release v$SemanticVersion - Vulkan GameDev Windows Container"
    git push origin "v$SemanticVersion"
    Write-Host "✅ Git tag v$SemanticVersion created and pushed"
} catch {
    Write-Host "⚠️  Failed to create git tag: $($_.Exception.Message)"
}

# Create GitHub Release
Write-Host "📝 Creating GitHub release v$SemanticVersion..."
$releaseBody = @"
🎮 Vulkan GameDev Windows Container v$SemanticVersion

## What's Included
- ✅ Vulkan SDK $VulkanVersion pre-installed
- ✅ Visual Studio 2022 Build Tools with C++ workload
- ✅ CMake 4.1+ for modern C++ builds
- ✅ Git 2.50+ for version control
- ✅ PowerShell scripting environment

## Container Images
- **Docker Hub**: ``elikloft/$ImageName:v$SemanticVersion``
- **GHCR**: ``ghcr.io/$Username/$ImageName:v$SemanticVersion``

## Quick Start
````bash
docker run -it elikloft/$ImageName:v$SemanticVersion powershell
````

Perfect for CI/CD pipelines and consistent development environments!
"@

try {
    $headers = @{
        "Authorization" = "token $($env:GITHUB_TOKEN)"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $releaseData = @{
        "tag_name" = "v$SemanticVersion"
        "target_commitish" = "main"
        "name" = "v$SemanticVersion - Vulkan GameDev Windows Container"
        "body" = $releaseBody
        "draft" = $false
        "prerelease" = $SemanticVersion.StartsWith("0.")
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$Username/vulkan-gamedev-windows/releases" -Method Post -Headers $headers -Body $releaseData -ContentType "application/json"
    Write-Host "✅ GitHub release created: $($response.html_url)"
} catch {
    Write-Host "⚠️  Failed to create GitHub release: $($_.Exception.Message)"
    Write-Host "   You can create it manually at: https://github.com/$Username/vulkan-gamedev-windows/releases/new"
}

Write-Host ""
Write-Host "✅ Published successfully!"
Write-Host ""
Write-Host "📋 Usage examples:"
Write-Host "   GHCR:       ghcr.io/$Username/$ImageName:v$SemanticVersion"
if ($DockerHubUsername) {
    Write-Host "   Docker Hub: $DockerHubUsername/$ImageName:v$SemanticVersion"
}
Write-Host ""
Write-Host "🏷️  Available tags: latest, v$SemanticVersion, vulkan-$VulkanVersion, $BuildDate"