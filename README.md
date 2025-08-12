# Vulkan GameDev Windows Container

🎯 **Cross-platform Vulkan development environments for game teams**

Pre-built development VMs with Vulkan SDK, compilers, and build tools. Eliminates "works on my machine" problems and provides consistent environments for cross-platform game development.

## What This Solves

- **"Works on my machine"** - Same tools and versions across the entire team
- **Onboarding time** - New developers productive in minutes, not days
- **Environment drift** - Consistent development environment from day one
- **Cross-platform builds** - Develop on any OS, target any OS
- **GPU testing** - Hardware-accelerated graphics testing in VMs

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
│   This Repo     │───▶│  Packer Build   │───▶│  Vagrant Box    │
│ (Packer Config) │    │ (Windows VM)    │    │ (Local Dev)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │  Docker Image   │
                       │ (CI/CD Ready)   │
                       └─────────────────┘
```

## Quick Start

**Windows Developer (with GPU-PV):**
```bash
vagrant box add elipwns/vulkan-gamedev-windows
vagrant init elipwns/vulkan-gamedev-windows
vagrant up --provider=hyperv

# Enable GPU passthrough for testing
Set-VMGpuPartitionAdapter -VMName "your-vm" -MinPartitionVRAM 1000000000
```

**Cross-Platform Developer:**
```bash
vagrant box add elipwns/vulkan-gamedev-windows
vagrant init elipwns/vulkan-gamedev-windows  
vagrant up --provider=virtualbox  # Works on Windows/macOS/Linux
```

**Your game project folder is automatically shared** - edit code on your host, build in the VM!

## Prerequisites

### For Vagrant Box (Local Development)

**Windows (Chocolatey):**
```powershell
choco install virtualbox vagrant packer
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt update
sudo apt install virtualbox vagrant
# Packer
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
```

**Linux (Arch/Manjaro):**
```bash
sudo pacman -S virtualbox vagrant packer
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install VirtualBox vagrant
# Packer
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install packer
```

**Manual installation:**
- **VirtualBox**: https://www.virtualbox.org/wiki/Downloads
- **Vagrant**: https://www.vagrantup.com/downloads
- **Packer**: https://www.packer.io/downloads

### For Docker Image (CI/CD)
- **Docker Desktop**: https://www.docker.com/products/docker-desktop

## Building Your Own Environment

### Option 1A: VirtualBox (Basic 3D Acceleration)

**Step 1: Build the Vagrant box**
```powershell
# Default build (8GB RAM, 4 CPUs, 80GB disk)
.\build-vagrant-box.ps1

# High-end build (16GB RAM, 8 CPUs, 120GB disk)
.\build-vagrant-box.ps1 -Memory 16384 -CPUs 8 -DiskSize 120000

# Low-end build (4GB RAM, 2 CPUs, 60GB disk)
.\build-vagrant-box.ps1 -Memory 4096 -CPUs 2 -DiskSize 60000
```

**Step 2: Add and use the box**
```powershell
vagrant box add vulkan-gamedev-windows vulkan-gamedev-windows-virtualbox.box
vagrant init vulkan-gamedev-windows
vagrant up
```

### Option 1B: Hyper-V with GPU-PV (High-Performance Vulkan)

**Prerequisites:** Windows 11 Pro/Enterprise with Hyper-V enabled

**Step 1: Enable Hyper-V (if not already enabled)**
```powershell
# Run as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# Reboot required
```

**Step 2: Build the Hyper-V box**
```powershell
# Default build
.\build-hyperv-box.ps1

# High-end build (32GB RAM, 8 CPUs, 200GB disk)
.\build-hyperv-box.ps1 -Memory 32768 -CPUs 8 -DiskSize 200000
```

**Step 3: Add and use the box**
```powershell
vagrant box add vulkan-gamedev-hyperv vulkan-gamedev-windows-hyperv-hyperv.box
vagrant init vulkan-gamedev-hyperv
vagrant up --provider=hyperv
```

**Step 4: Enable GPU-PV for RTX/high-end GPU access**
```powershell
# Run as Administrator on host after VM is running
Get-VM 'vulkan-gamedev-hyperv' | Set-VMGpuPartitionAdapter -MinPartitionVRAM 1000000000 -MaxPartitionVRAM 1000000000 -OptimalPartitionVRAM 1000000000 -MinPartitionEncode 1000000000 -MaxPartitionEncode 1000000000 -OptimalPartitionEncode 1000000000 -MinPartitionDecode 1000000000 -MaxPartitionDecode 1000000000 -OptimalPartitionDecode 1000000000 -MinPartitionCompute 1000000000 -MaxPartitionCompute 1000000000 -OptimalPartitionCompute 1000000000
```

### Option 2: Docker Image (CI/CD)

**Step 1: Download Vulkan SDK installer**
```powershell
.\scripts\download-installers.ps1
```

**Step 2: Build the Docker image**
```powershell
docker build -f docker/Dockerfile -t vulkan-gamedev-windows:latest .
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
├── packer/
│   ├── windows-vm.pkr.hcl        # Packer VM build configuration
│   ├── windows-hyperv.pkr.hcl    # Packer Hyper-V build configuration
│   └── scripts/                  # VM provisioning scripts
│       ├── unattend.xml          # Windows unattended install
│       ├── setup-ssh.ps1         # SSH server setup
│       ├── install-desktop.ps1   # Windows GUI installation
│       ├── install-vulkan.ps1    # Vulkan SDK installation
│       ├── install-dev-tools.ps1 # Development tools
│       ├── configure-vm.ps1      # VM optimization
│       └── cleanup.ps1           # Final cleanup
├── vagrant/
│   ├── Vagrantfile.template      # Vagrant box template
│   └── Vagrantfile-hyperv.template # Vagrant Hyper-V template
├── docker/
│   └── Dockerfile                # Container build configuration
├── scripts/
│   └── download-installers.ps1   # Download Vulkan SDK for Docker
├── installers/                   # Downloaded SDK installers
├── build-vagrant-box.ps1         # Build Vagrant box
├── build-hyperv-box.ps1          # Build Hyper-V box with GPU-PV
├── publish.ps1                   # Automated publishing script
├── bump-version.ps1              # Version management helper
├── VERSION                       # Current semantic version
├── .env.example                  # Template for authentication
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

## Provider Options

**For High-Performance Vulkan Development:**
- **Hyper-V + GPU-PV** (Windows 11 Pro) - Direct GPU access for testing
- **VirtualBox** (Windows/macOS/Linux) - Cross-platform compatibility

**Use Cases:**
- **Consistent development environment** across team members
- **CI/CD builds** with pre-installed tools
- **GPU-accelerated testing** (Hyper-V only)
- **Cross-platform compatibility** (VirtualBox)

## Team Development Workflow

**Day 1: New Team Member**
```bash
# 5 minutes to productive development
vagrant box add elipwns/vulkan-gamedev-windows
vagrant up
vagrant ssh
# Ready to build! No "install Visual Studio, download SDK, configure paths..."
```

**Daily Development:**
- 📝 **Edit code** on your host OS (VS Code, CLion, etc.)
- 🔨 **Build & test** in the VM (consistent environment)
- 🎮 **GPU testing** with hardware acceleration (Hyper-V)
- 🚀 **Deploy** knowing it works the same everywhere

## Use Cases

- **Game Studios** - Consistent Vulkan development across Windows/Linux teams
- **Graphics Teams** - Same SDK versions, no environment-specific bugs
- **CI/CD Pipelines** - Build environment matches developer environment
- **Open Source Projects** - Contributors get productive immediately
- **Education** - Students focus on graphics programming, not setup

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

## Troubleshooting

**Packer build fails?**
- Ensure VirtualBox is installed and running
- Check that virtualization is enabled in BIOS
- Verify you have enough disk space (~15GB for build)
- Try running as Administrator if permission issues

**Vagrant box won't start?**
- Ensure VirtualBox Guest Additions installed properly
- Check VM has enough memory allocated (8GB recommended)
- Verify SSH is working: `vagrant ssh`

**Hyper-V issues?**
- Ensure Hyper-V is enabled: `Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All`
- Run PowerShell as Administrator for Packer builds
- For GPU-PV: Ensure your GPU supports it (RTX 20xx+ or similar)
- Check Windows Defender/Antivirus isn't blocking Hyper-V operations

**Docker build fails?**
- Ensure Docker Desktop is running in Windows containers mode
- Verify Vulkan SDK installer was downloaded to installers/
- Check available disk space (build requires ~15GB)

**Need different tools?**
- Fork this repo and modify the Packer scripts in `packer/scripts/`
- Add your tools to the installation steps

## Benefits

- ✅ **Fast CI builds** (no more 6-hour timeouts)
- ✅ **Consistent environment** (same tools every time)
- ✅ **Version controlled** (reproducible builds)
- ✅ **Cost effective** (pay once for image build, use many times)