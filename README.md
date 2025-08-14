# Vulkan GameDev Containers

Production-ready Docker containers for cross-platform Vulkan C++ game development with **multi-platform support**.

## Quick Start (Multi-Platform)

**One command works on both Windows and Linux:**
```bash
# Automatically pulls the right container for your platform
docker pull ghcr.io/elipwns/vulkan-gamedev:latest

# Build your project (works on both platforms)
docker run --rm -v "$(pwd):/workspace" ghcr.io/elipwns/vulkan-gamedev:latest
```

## Platform-Specific Usage

### Windows
```powershell
# Pull Windows-specific container
docker pull ghcr.io/elipwns/vulkan-gamedev-windows:latest

# Build your project
docker run --rm -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest powershell C:/build.ps1

# Interactive development
docker run --rm -it -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest
```

### Linux
```bash
# Pull Linux-specific container
docker pull ghcr.io/elipwns/vulkan-gamedev-linux:latest

# Build your project
docker run --rm -v $(pwd):/workspace ghcr.io/elipwns/vulkan-gamedev-linux:latest /build.sh

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
- **PowerShell build script** - Automated CMake configuration

### Linux Container  
- **GCC/G++ Compiler** - Modern C++ toolchain
- **Bash build script** - Automated CMake configuration
- **System Vulkan libraries** - Native Linux Vulkan support

## Pre-installed vcpkg Libraries
- **Vulkan**: vulkan-headers, vulkan-loader, vulkan-memory-allocator, volk
- **Graphics**: GLFW3, GLM, ImGui (with Vulkan bindings)
- **Asset Loading**: Assimp, TinyGLTF, TinyObjLoader, STB, KTX
- **Game Development**: EnTT, Taskflow, nlohmann-json
- **SPIR-V Tools**: spirv-headers, spirv-tools, spirv-reflect, glslang
- And more...

## Available Images

### Multi-Platform (Recommended)
- `ghcr.io/elipwns/vulkan-gamedev:latest` - Automatically selects Windows or Linux
- `ghcr.io/elipwns/vulkan-gamedev:1.0.17` - Specific version

### Platform-Specific
- `ghcr.io/elipwns/vulkan-gamedev-windows:latest` - Windows containers only
- `ghcr.io/elipwns/vulkan-gamedev-linux:latest` - Linux containers only

## Benefits
- ✅ **Zero local setup** - No SDK installations needed
- ✅ **Cross-platform** - Same workflow on Windows and Linux
- ✅ **Consistent builds** - Identical environment across all machines
- ✅ **Fast CI/CD** - Pre-compiled dependencies save build time
- ✅ **Team ready** - Anyone can contribute immediately

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

## Compatible Projects
This container works with any CMake-based C++ project that uses vcpkg. Perfect for:
- Vulkan game engines and applications
- Graphics programming projects  
- Game development with modern C++ libraries
- Cross-platform C++ development

## License
MIT License - See [LICENSE](LICENSE) for details