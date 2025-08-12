# Import VM without checkpoints
param(
    [string]$VMPath = "C:\temp\vm-export\vulkan-gamedev-manual",
    [string]$VMName = "vulkan-gamedev-imported"
)

# Remove any existing VM with same name
$existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if ($existingVM) {
    Write-Host "Removing existing VM: $VMName"
    Stop-VM -Name $VMName -Force -ErrorAction SilentlyContinue
    Remove-VM -Name $VMName -Force
}

# Import VM and copy files (not move)
Write-Host "Importing VM from: $VMPath"
$importedVM = Import-VM -Path "$VMPath\Virtual Machines\*.vmcx" -Copy -GenerateNewId

# Rename the imported VM
Write-Host "Renaming VM to: $VMName"
Rename-VM -VM $importedVM -NewName $VMName

# Remove any checkpoints
Write-Host "Removing any checkpoints..."
Get-VMSnapshot -VMName $VMName -ErrorAction SilentlyContinue | Remove-VMSnapshot

Write-Host "VM imported successfully: $VMName"