# PowerShell script to copy an Azure managed disk to Blob storage

# Step 1: Get the managed disk details
$resourceGroupName = "lab-eastus-rg"
$managedDiskName = "WIN11SSBLOB_OsDisk_1_a220fa2a9449451081601ee0e0b5688f"
$storageAccountName = "vmimagesscd"
$storageAccountKey = "FHOtcJP5jVSPw0eQe8Vw1DlZguzxBLIaK8lF0M020ARKwVwT6QQqmUlMAq/YDA/B3mJnZxEX5LvS+ASt5p+ZSQ=="
$containerName = "vmimages"
$vhdFileName = "win11ss.vhd"

# Replace placeholders with your actual values
#$resourceGroupName = "YourResourceGroup"
#$managedDiskName = "YourManagedDisk"
$storageAccountName = "YourStorageAccount"
#$storageAccountKey = "YourStorageAccountKey"
#$containerName = "YourContainerName"
#$vhdFileName = "YourVHDFileName"

# Generate SAS URI for the managed disk
$sas = Grant-AzDiskAccess -ResourceGroupName $resourceGroupName -DiskName $managedDiskName -DurationInSecond 3600 -Access Read

# Create context for the storage account
$destinationContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Copy VHD to the storage account using Start-AzStorageBlobCopy
Start-AzStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $containerName -DestContext $destinationContext -DestBlob $vhdFileName

# Check the copy status (if needed)
# Verify that the VHD has been successfully copied to the storage account