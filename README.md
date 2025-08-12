# Vulkan GameDev Windows Container

🎯 **Ready-to-use Windows container for Vulkan C++ game development**

Pre-built Windows container with Vulkan SDK 1.4.321.1, Visual Studio Build Tools, and CMake. Eliminates CI/CD timeout failures and provides consistent development environments for game engines and graphics applications.

## What This Solves

- **Long CI build times** - Pre-install everything instead of downloading during CI
- **Inconsistent environments** - Same tools and versions every time
- **Failed installs** - Build once, use many times

## What's Included

- **Windows Server Core** base image
- **Visual Studio 2022 Build Tools** with C++ workload
- **CMake 3.25+** for modern C++ builds
- **Vulkan SDK 1.4.321.1** fully installed
- **Git** for source control
- **PowerShell** for scripting

## How It Works

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   This Repo     │───▶│  Local Build    │───▶│  Your Registry  │
│ (Packer+Ansible)│    │ (Docker Image)  │    │   (Optional)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Quick Start

**Use the pre-built image:**
```yaml
# In your GitHub Actions
jobs:
  build:
    runs-on: windows-latest
    container:
      image: ghcr.io/yourusername/vulkan-gamedev-windows:latest
    steps:
      - uses: actions/checkout@v4
      - name: Build your Vulkan project
        run: |
          cmake -B build
          cmake --build build --config Release
```

**Or run locally:**
```powershell
docker run -it ghcr.io/yourusername/vulkan-gamedev-windows:latest powershell
```

## Building Your Own Image

**Step 1: Download Vulkan SDK installer**
```powershell
.\scripts\download-installers.ps1
```

**Step 2: Build the Docker image**
```powershell
docker build -t vulkan-gamedev-windows:latest .
```

**Step 3: Test your image**
```powershell
docker run -it vulkan-gamedev-windows:latest powershell
# Test installations:
cmake --version
git --version
$env:VULKAN_SDK
```

## Publishing (Optional)

**Setup authentication:**
1. Copy `.env.example` to `.env`
2. Fill in your GitHub and Docker Hub tokens
3. Publish with automated versioning:

```powershell
# Publish current version (reads from VERSION file)
.\publish.ps1

# Bump version and publish
.\publish.ps1 -BumpPatch    # 0.0.1 -> 0.0.2
.\publish.ps1 -BumpMinor    # 0.0.1 -> 0.1.0
.\publish.ps1 -BumpMajor    # 0.0.1 -> 1.0.0

# Or bump version separately
.\bump-version.ps1 -Patch
.\publish.ps1
```

## Using Your Image

```yaml
jobs:
  build:
    runs-on: windows-latest
    container:
      image: your-registry/vulkan-gamedev-windows:latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: |
          cmake -B build
          cmake --build build --config Release
```

## Repository Structure

```
vulkan-gamedev-windows/
├── Dockerfile                    # Container build configuration
├── scripts/
│   └── download-installers.ps1   # Download Vulkan SDK
├── installers/                   # Downloaded SDK installers
├── publish.ps1                   # Automated publishing script
├── bump-version.ps1              # Version management helper
├── VERSION                       # Current semantic version
├── .env.example                  # Template for authentication
├── .env                          # Your tokens (git-ignored)
└── README.md
```

## Available Images

- **GHCR**: `ghcr.io/elipwns/vulkan-gamedev-windows:latest`
- **Docker Hub**: `elikloft/vulkan-gamedev-windows:latest`

**Tags:**
- `latest` - Most recent build
- `v0.0.1` - Semantic version tags
- `vulkan-1.4.321.1` - Vulkan SDK version
- `2024-12-19` - Build date tags

## Use Cases

- **Game Engine CI/CD** - Build Vulkan-based game engines
- **Graphics Applications** - Develop Vulkan graphics software
- **Shader Development** - Compile and test GLSL/HLSL shaders
- **Cross-platform Builds** - Consistent Windows build environment

## Troubleshooting

**Build fails?**
- Ensure Docker Desktop is running in Windows containers mode
- Verify Vulkan SDK installer was downloaded
- Check available disk space (build requires ~15GB)

**Need different tools?**
- Fork this repo and modify the `Dockerfile`
- Add your tools to the installation steps

**Version Management:**
- Current version is tracked in the `VERSION` file
- Use `bump-version.ps1` for easy version bumping
- Publishing script automatically reads current version

## Benefits

- ✅ **Fast CI builds** (no more 6-hour timeouts)
- ✅ **Consistent environment** (same tools every time)
- ✅ **Version controlled** (reproducible builds)
- ✅ **Cost effective** (pay once for image build, use many times)