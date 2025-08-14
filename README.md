# Vulkan GameDev Containers

Production-ready Docker containers for cross-platform Vulkan C++ game development.

## Available Containers
- **Windows**: `ghcr.io/elipwns/vulkan-gamedev-windows:latest`
- **Linux**: `ghcr.io/elipwns/vulkan-gamedev-linux:latest` *(coming soon)*

## What's Included
- **Vulkan Headers & Loader** - Via vcpkg packages (vulkan-headers, vulkan-loader, volk)
- **Visual Studio 2019 Build Tools** - C++ compiler and toolchain  
- **vcpkg Package Manager** - Pre-installed with 17 game development libraries
- **CMake & Git** - Build system and version control tools

## Quick Start

### Windows
```powershell
# Pull the container
docker pull ghcr.io/elipwns/vulkan-gamedev-windows:latest

# Build your project (replace YourProjectPath)
docker run --rm -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest powershell C:/build.ps1

# Or build with debug configuration
docker run --rm -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest powershell "C:/build.ps1 -BuildType Debug"

# Or run interactively for development
docker run --rm -it -v "YourProjectPath:C:\workspace" ghcr.io/elipwns/vulkan-gamedev-windows:latest
```

**Note**: Your built executable will be in `YourProjectPath/build/` on your host machine.

### Linux *(Coming Soon)*
```bash
# Pull the container
docker pull ghcr.io/elipwns/vulkan-gamedev-linux:latest

# Build your project
docker run --rm -v $(pwd):/workspace ghcr.io/elipwns/vulkan-gamedev-linux:latest bash -c "cd /workspace && cmake -B build -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake && cmake --build build"
```

## Pre-installed vcpkg Libraries
- Vulkan SDK & validation layers
- GLFW3, GLM, ImGui (with Vulkan bindings)
- Assimp, TinyGLTF, TinyObjLoader  
- EnTT, Taskflow, STB, KTX
- Vulkan Memory Allocator, volk
- And more...

## Benefits
- ✅ **Zero local setup** - No SDK installations needed
- ✅ **Consistent builds** - Same environment across all machines
- ✅ **Fast CI/CD** - Pre-compiled dependencies save build time
- ✅ **Team ready** - Anyone can contribute immediately

## Compatible Projects
This container works with any CMake-based C++ project that uses vcpkg. Perfect for:
- Vulkan game engines and applications
- Graphics programming projects
- Game development with modern C++ libraries

## Container Details

### Windows Container
- **Base**: Windows Server 2019
- **Compiler**: Visual Studio 2019 Build Tools
- **Size**: ~28GB (includes all vcpkg dependencies)
- **vcpkg packages**: 17 pre-compiled libraries

### Linux Container *(Coming Soon)*
- **Base**: Ubuntu 22.04
- **Compiler**: GCC/G++
- **Size**: ~2GB (estimated)

**Registry**: GitHub Container Registry  
**Tags**: `latest`, `v1.0.13`

## Building from Source
```bash
git clone https://github.com/elipwns/vulkan-gamedev-containers.git
cd vulkan-gamedev-containers

# For Windows container:
docker build -f docker/Dockerfile -t vulkan-gamedev-windows .

# For Linux container:
docker build -f docker/Dockerfile.linux -t vulkan-gamedev-linux .
```

## License
MIT License - See [LICENSE](LICENSE) for details