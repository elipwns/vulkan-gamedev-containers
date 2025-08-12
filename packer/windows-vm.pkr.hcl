# Packer configuration for Vulkan GameDev Windows VM
# Creates a full Windows desktop environment for local development

packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

variable "vulkan_version" {
  type        = string
  default     = "1.4.321.1"
  description = "Vulkan SDK version to install"
}

variable "vm_name" {
  type        = string
  default     = "vulkan-gamedev-windows"
  description = "VM name"
}

variable "output_directory" {
  type        = string
  default     = "output"
  description = "Output directory for VM files"
}

variable "vm_memory" {
  type        = number
  default     = 8192
  description = "VM memory in MB (8192 = 8GB, 16384 = 16GB)"
}

variable "vm_cpus" {
  type        = number
  default     = 4
  description = "Number of CPU cores for VM"
}

variable "vm_disk_size" {
  type        = number
  default     = 80000
  description = "VM disk size in MB (80000 = ~80GB)"
}

# Windows Server 2022 Evaluation ISO
source "virtualbox-iso" "windows" {
  # Windows Server 2022 Evaluation (free for development)
  iso_url      = "https://go.microsoft.com/fwlink/p/?LinkID=2195280&clcid=0x409&culture=en-us&country=US"
  iso_checksum = "none"
  
  # VM Configuration
  vm_name              = var.vm_name
  guest_os_type        = "Windows2019_64"
  memory               = var.vm_memory
  cpus                 = var.vm_cpus
  disk_size            = var.vm_disk_size
  hard_drive_interface = "sata"
  
  # Network
  guest_additions_mode = "upload"
  guest_additions_path = "C:/Windows/Temp/windows.iso"
  
  # Boot configuration
  boot_wait = "2m"
  boot_command = [
    "<spacebar>"
  ]
  
  # Communication
  communicator   = "ssh"
  ssh_username   = "Administrator"
  ssh_password   = "PackerAdmin123!"
  ssh_timeout    = "12h"
  
  # Shutdown
  shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "15m"
  
  # Floppy with unattend and scripts
  floppy_files = [
    "packer/scripts/unattend.xml",
    "packer/scripts/setup-ssh.ps1"
  ]
  
  # Output
  output_directory = var.output_directory
  format           = "ovf"
}

build {
  name = "vulkan-gamedev-vm"
  
  sources = [
    "source.virtualbox-iso.windows"
  ]

  # Wait for Windows to be ready
  provisioner "powershell" {
    inline = [
      "Write-Host 'Windows is ready for provisioning'"
    ]
  }

  # Install Windows Desktop Experience (GUI)
  provisioner "powershell" {
    script = "packer/scripts/install-desktop.ps1"
  }

  # Install Vulkan SDK
  provisioner "powershell" {
    script = "packer/scripts/install-vulkan.ps1"
    environment_vars = [
      "VULKAN_VERSION=${var.vulkan_version}"
    ]
  }

  # Install development tools
  provisioner "powershell" {
    script = "packer/scripts/install-dev-tools.ps1"
  }

  # Configure VM for development
  provisioner "powershell" {
    script = "packer/scripts/configure-vm.ps1"
  }

  # Install VirtualBox Guest Additions
  provisioner "powershell" {
    inline = [
      "if (Test-Path 'C:/Windows/Temp/windows.iso') {",
      "  Mount-DiskImage -ImagePath 'C:/Windows/Temp/windows.iso'",
      "  $drive = (Get-DiskImage -ImagePath 'C:/Windows/Temp/windows.iso' | Get-Volume).DriveLetter",
      "  Start-Process -FilePath \"$drive:/VBoxWindowsAdditions.exe\" -ArgumentList '/S' -Wait",
      "  Dismount-DiskImage -ImagePath 'C:/Windows/Temp/windows.iso'",
      "}"
    ]
  }

  # Final cleanup and optimization
  provisioner "powershell" {
    script = "packer/scripts/cleanup.ps1"
  }

  # Create Vagrant box
  post-processor "vagrant" {
    output = "vulkan-gamedev-windows-{{.Provider}}.box"
    vagrantfile_template = "vagrant/Vagrantfile.template"
  }
}