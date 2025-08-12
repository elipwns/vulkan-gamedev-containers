# Vulkan GameDev VM Usage Guide

## Prerequisites
- Windows 10/11 with Hyper-V enabled
- Run PowerShell/Command Prompt as Administrator
- Vagrant installed

## Quick Start

1. **Create project directory:**
```bash
mkdir my-vulkan-project
cd my-vulkan-project
```

2. **Initialize Vagrant:**
```bash
vagrant init elipwns/vulkan-gamedev-windows
```

3. **Start the VM:**
```bash
vagrant up --provider hyperv
```

4. **Select "Default Switch" when prompted for network**

## Connecting to the VM

### Option 1: Remote Desktop
```bash
# Connect via RDP on localhost:33389
mstsc /v:localhost:33389
```
- Username: `vagrant`
- Password: `vagrant`

### Option 2: Hyper-V Manager
- Open Hyper-V Manager
- Double-click the VM to open console window
- Full desktop access with enhanced session

### Option 3: WinRM (Command Line)
```bash
vagrant winrm
```

### Option 4: SSH (if configured)
```bash
vagrant ssh
```

## VM Management

```bash
# Stop the VM
vagrant halt

# Restart the VM
vagrant reload

# Destroy the VM
vagrant destroy

# Check VM status
vagrant status
```

## Pre-installed Development Tools

- **Vulkan SDK 1.4.321.1** - Complete Vulkan development environment
- **Visual Studio Build Tools 2022** - C++ compiler and build tools
- **CMake** - Cross-platform build system
- **Git** - Version control
- **Chocolatey** - Package manager

## Network Configuration

The VM is configured with:
- RDP: `localhost:33389` → VM:3389
- WinRM: `localhost:55985` → VM:5985
- Use **Default Switch** for network when prompted

## Troubleshooting

### "Administrative privileges required"
Run your terminal as Administrator - Hyper-V requires elevated privileges.

### Network selection
Always choose **Default Switch** when Vagrant prompts for network selection.

### VM won't start
Check Hyper-V is enabled: `Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V`