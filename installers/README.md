# Installers Directory

This directory contains pre-downloaded installers for reliable container builds.

## Why Pre-download?

Downloading large installers (like Vulkan SDK) during container builds often fails due to:
- Network timeouts
- Slow download speeds in CI environments  
- Intermittent connection issues
- GitHub Actions 6-hour timeout limits

## Usage

Run the download script to populate this directory:

```powershell
# Download Vulkan SDK 1.4.321.1 (default)
.\download-installers.ps1

# Download specific version
.\download-installers.ps1 -VulkanVersion "1.4.321.1"
```

## Files

- `vulkansdk-windows-X64-1.4.321.1.exe` - Vulkan SDK installer (~500MB)

## Git LFS Alternative

For teams using Git LFS, you could track these files:

```bash
git lfs track "installers/*.exe"
git add .gitattributes
```

But the download script approach is simpler for most users.