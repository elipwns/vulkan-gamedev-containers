# Packer configuration for Vulkan GameDev Windows VM on Hyper-V
# Supports GPU-PV for better Vulkan performance

packer {
  required_plugins {
    hyperv = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hyperv"
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
  default     = "vulkan-gamedev-windows-hyperv"
  description = "VM name"
}

variable "vm_memory" {
  type        = number
  default     = 8192
  description = "VM memory in MB"
}

variable "vm_cpus" {
  type        = number
  default     = 4
  description = "Number of CPU cores for VM"
}

variable "vm_disk_size" {
  type        = number
  default     = 80000
  description = "VM disk size in MB"
}

# Windows Server 2022 Evaluation ISO
source "hyperv-iso" "windows" {
  # Custom Windows Server 2022 ISO with unattend.xml
  iso_url      = "./windows-server-2022-unattended.iso"
  iso_checksum = "none"
  
  # VM Configuration
  vm_name          = var.vm_name
  memory           = var.vm_memory
  cpus             = var.vm_cpus
  disk_size        = var.vm_disk_size
  generation       = 1
  
  # Network
  switch_name = "Default Switch"
  
  # Boot configuration
  boot_wait = "5m"
  boot_command = [
    "<spacebar>"
  ]
  
  # Communication
  communicator     = "winrm"
  winrm_username   = "Administrator"
  winrm_password   = "PackerAdmin123!"
  winrm_timeout    = "12h"
  winrm_use_ssl    = false
  winrm_insecure   = true
  
  # Shutdown
  shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "15m"
  
  # No floppy needed - unattend.xml is baked into the custom ISO
}

build {
  name = "vulkan-gamedev-hyperv"
  
  sources = [
    "source.hyperv-iso.windows"
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

  # Enable GPU-PV (requires host setup)
  provisioner "powershell" {
    inline = [
      "Write-Host 'VM ready for GPU-PV configuration (requires host-side setup)'"
    ]
  }

  # Final cleanup and optimization
  provisioner "powershell" {
    script = "packer/scripts/cleanup.ps1"
  }

  # Create Vagrant box
  post-processor "vagrant" {
    output = "vulkan-gamedev-windows-hyperv-{{.Provider}}.box"
  }
}