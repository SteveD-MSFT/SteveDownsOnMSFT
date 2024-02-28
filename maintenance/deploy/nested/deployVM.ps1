# Set your custom variables here
$your_VHDX_path = "V:\VHDs"
$VM_config_Files_path = "V:\VMs"

#$your_VHDX_path = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks"
#$VM_config_Files_path = "C:\ProgramData\Microsoft\Windows\Hyper-V"

$your_VM_name = "scdnode"
$virtual_switch_name = "extSwitch01"  # Add your desired virtual switch name here
$OSISO = "V:\ISO\HCI23h2.iso"

# Create a new VHDX
New-VHD -Path "$your_VHDX_path\$your_VM_name.vhdx" -SizeBytes 127GB

# Create a new VM
New-VM -Name $your_VM_name -MemoryStartupBytes 20GB -VHDPath "$your_VHDX_path\$your_VM_name.vhdx" -Generation 2 -Path $VM_config_Files_path

# Configure VM settings
Set-VMMemory -VMName $your_VM_name -DynamicMemoryEnabled $false
Set-VM -VMName $your_VM_name -CheckpointType Disabled

# Remove existing network adapters
Get-VMNetworkAdapter -VMName $your_VM_name | Remove-VMNetworkAdapter

# Add new network adapters
1..4 | ForEach-Object {
    Add-VmNetworkAdapter -VmName $your_VM_name -Name "NIC$_"
}

# Connect network adapters to the virtual switch
Get-VmNetworkAdapter -VmName $your_VM_name | Connect-VmNetworkAdapter -SwitchName $virtual_switch_name

# Enable MAC address spoofing
Get-VmNetworkAdapter -VmName $your_VM_name | Set-VmNetworkAdapter -MacAddressSpoofing On

# Set VM key protector
Set-VMKeyProtector -VMName $your_VM_name -NewLocalKeyProtector
Set-VMFirmware -VmName $your_VM_name  -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows

# Enable TPM
Enable-VmTpm -VMName $your_VM_name

# Set VM processor count
Set-VmProcessor -VMName $your_VM_name -Count 8

# Create additional VHDX files
1..6 | ForEach-Object {
    New-VHD -Path "$your_VHDX_path\$your_VM_name\s2d$_.vhdx" -SizeBytes 1024GB
}

# Attach additional VHDX files to VM
1..6 | ForEach-Object {
    Add-VMHardDiskDrive -VMName $your_VM_name -Path "$your_VHDX_path\$your_VM_name\s2d$_.vhdx"
}

# Disable integration services starting with 'T'
Get-VMIntegrationService -VMName $your_VM_name | Where-Object { $_.Name -like "T*" } | Disable-VMIntegrationService

#Added
Set-VmProcessor -VMName $your_VM_name -ExposeVirtualizationExtensions $true

# Start the VM

Add-VMDvdDrive -VMName $your_vm_name -Path $OSISO
#Start-VM $your_VM_name
