# Define Path to the Windows Server 2022 ISO
$ISOFile = "C:\temp\25398.469.231004-1141.zn_release_svc_refresh_SERVERAZURESTACKHCICOR_OEMRET_x64FRE_en-us.iso"

# Create temp diectroy for new image
$newImageDir = New-Item -Path 'C:\Temp\newimage' -ItemType Directory

# Mount iso
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru

# Driver letter
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter

# Copy Files to temporary new image folder 
Copy-Item -Path ($ISODriveLetter +":\*") -Destination C:\Temp\newimage -Recurse

# Split and copy install.wim (because of the filesize)
dism /Split-Image /ImageFile:C:\Temp\newimage\sources\install.wim /SWMFile:C:\Temp\newimage\sources\install.swm /FileSize:4096

 
# Get the USB Drive you want to use, copy the disk number
Get-Disk | Where BusType -eq "USB"
 
# Get the right USB Drive (You will need to change the number)
$USBDrive = Get-Disk | Where Number -eq 1
 
# Replace the Friendly Name to clean the USB Drive (THIS WILL REMOVE EVERYTHING)
$USBDrive | Clear-Disk -RemoveData -Confirm:$true -PassThru
 
# Convert Disk to GPT
$USBDrive | Set-Disk -PartitionStyle GPT
 
# Create partition primary and format to FAT32
$Volume = $USBDrive | New-Partition -Size 8GB -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel WS2022
 
# Copy Files to USB (Ignore install.wim)
Copy-Item -Path C:\Temp\newimage\* -Destination ($Volume.DriveLetter + ":\") -Recurse -Exclude install.wim

# Dismount ISO
Dismount-DiskImage -ImagePath $ISOFile