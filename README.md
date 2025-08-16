# Vulkan GameDev Containers

Production-ready Docker containers for cross-platform Vulkan C++ game development with **multi-platform support**.

## Quick Start (Multi-Platform)

**One command works on both Windows and Linux:**
```bash
# GitHub Container Registry (recommended)
docker pull ghcr.io/elipwns/vulkan-gamedev:latest

# Or Docker Hub
docker pull elikloft/vulkan-gamedev:latest

# Build your project (works on both platforms)
docker run --rm -v "$(pwd):/workspace" ghcr.io/elipwns/vulkan-gamedev:latest
```

## Platform-Specific Usage

### Windows
```powershell
# Pull Windows-specific container
docker pull ghcr.io/elipwns/vulkan-gamedev-windows:latest
# Or: docker pull elikloft/vulkan-gamedev-windows:latest

# Regular build
docker run --rm -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest powershell C:/build.ps1

# Portable distribution (bundles runtime DLLs)
docker run --rm -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest powershell C:/build-portable.ps1

# Interactive development
docker run --rm -it -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest
```

### Linux
```bash
# Pull Linux-specific container
docker pull ghcr.io/elipwns/vulkan-gamedev-linux:latest
# Or: docker pull elikloft/vulkan-gamedev-linux:latest

# Regular build
docker run --rm -v $(pwd):/workspace ghcr.io/elipwns/vulkan-gamedev-linux:latest /build.sh

# AppImage build (creates portable single-file distribution)
docker run --rm -v $(pwd):/workspace ghcr.io/elipwns/vulkan-gamedev-linux:latest /build-appimage.sh

# Interactive development
docker run --rm -it -v $(pwd):/workspace ghcr.io/elipwns/vulkan-gamedev-linux:latest
```

## What's Included

### Both Platforms
- **Vulkan SDK** - Headers, loader, validation layers
- **vcpkg Package Manager** - Pre-installed with 30+ game development libraries
- **CMake & Git** - Build system and version control tools
- **All dependencies pre-compiled** - No build time overhead

### Windows Container
- **Visual Studio 2019 Build Tools** - MSVC compiler and toolchain
- **PowerShell build scripts** - Regular and portable distribution builds
- **Portable packaging** - Bundles runtime DLLs for distribution

### Linux Container  
- **GCC/G++ Compiler** - Modern C++ toolchain
- **Bash build scripts** - Regular and AppImage builds
- **AppImage packaging** - Creates portable single-file distributions
- **System Vulkan libraries** - Native Linux Vulkan support

## Pre-installed vcpkg Libraries
- **Vulkan**: vulkan-headers, vulkan-loader, vulkan-memory-allocator, volk
- **Graphics**: GLFW3, GLM, ImGui (with Vulkan bindings)
- **Asset Loading**: Assimp, TinyGLTF, TinyObjLoader, STB, KTX
- **Game Development**: EnTT, Taskflow, nlohmann-json
- **SPIR-V Tools**: spirv-headers, spirv-tools, spirv-reflect, glslang
- And more...

## Available Images

### GitHub Container Registry (Primary)
- `ghcr.io/elipwns/vulkan-gamedev:latest` - Multi-platform (recommended)
- `ghcr.io/elipwns/vulkan-gamedev:1.0.21` - Specific version
- `ghcr.io/elipwns/vulkan-gamedev-windows:latest` - Windows only
- `ghcr.io/elipwns/vulkan-gamedev-linux:latest` - Linux only

### Docker Hub (Mirror)
- `elikloft/vulkan-gamedev:latest` - Multi-platform
- `elikloft/vulkan-gamedev-windows:latest` - Windows only
- `elikloft/vulkan-gamedev-linux:latest` - Linux only

## Benefits
- ✅ **Zero local setup** - No SDK installations needed
- ✅ **Cross-platform** - Same workflow on Windows and Linux
- ✅ **Consistent builds** - Identical environment across all machines
- ✅ **Fast CI/CD** - Pre-compiled dependencies save build time
- ✅ **Team ready** - Anyone can contribute immediately
- ✅ **Portable distributions** - AppImage (Linux) and complete portable folder (Windows)
- ✅ **Resource bundling** - All game assets included in distributions
- ✅ **End-user friendly** - No runtime dependencies or installation needed

## Container Details

### Windows Container
- **Base**: Windows Server Core 2019
- **Compiler**: Visual Studio 2019 Build Tools (MSVC)
- **Size**: ~28GB (includes all vcpkg dependencies)
- **Architecture**: x64

### Linux Container
- **Base**: Ubuntu 22.04
- **Compiler**: GCC/G++ 11
- **Size**: ~3GB (optimized with cleanup)
- **Architecture**: x64

## Building from Source
```bash
git clone https://github.com/elipwns/vulkan-gamedev-containers.git
cd vulkan-gamedev-containers

# Build Windows container (requires Windows Docker)
docker build -f docker/Dockerfile -t vulkan-gamedev-windows .

# Build Linux container (requires Linux Docker)
docker build -f docker/Dockerfile.linux -t vulkan-gamedev-linux .
```

## Distribution Options

### Windows Portable Distribution
Creates a folder with your executable, all required DLLs, and game resources:
```
Game_Engine_Portable/
├── Game_Engine.exe
├── textures/           # Game textures
├── shaders/            # Compiled shaders
├── models/             # 3D models
├── data/               # Game data
├── glfw3.dll           # vcpkg libraries
├── [other vcpkg DLLs]
├── msvcp140.dll        # VC++ redistributables
├── vcruntime140.dll
└── vcruntime140_1.dll
```

### Linux AppImage Distribution
Creates a single portable file with all resources bundled that runs on any Linux system:
```bash
# Run anywhere with Vulkan drivers - no external dependencies needed
./Game_Engine-x86_64.AppImage
```

The AppImage includes:
- Your compiled executable
- All required shared libraries
- Complete resource folders (textures, shaders, models, data)
- Desktop integration files

## Compatible Projects
This container works with any CMake-based C++ project that uses vcpkg. Perfect for:
- Vulkan game engines and applications
- Graphics programming projects  
- Game development with modern C++ libraries
- Cross-platform C++ development

## License
MIT License - See [LICENSE](LICENSE) for details