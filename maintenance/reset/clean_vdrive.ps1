# Define an array of items (files and folders) to exclude from deletion
$itemsToKeep = @(
    "V:\VHDs",
    "V:\VMs",
    "V:\ISO"
    # Add more items as needed
)

# Get all items (files and folders) recursively from the V drive
$allItems = Get-ChildItem -Path 'V:\' -Recurse

# Filter out the items that are folders at the root level
$itemsToDelete = $allItems | Where-Object { $_.PSIsContainer -and $_.FullName -notlike 'V:\*\\*' }

# Exclude items from deletion based on the array
$itemsToDelete = $itemsToDelete | Where-Object { $_.FullName -notin $itemsToKeep }

# Exclude files within the V:\ISO folder unless explicitly referenced in itemsToKeep
$itemsToDelete = $itemsToDelete | Where-Object {
    $_.FullName -notlike 'V:\ISO\*' -or $_.FullName -in $itemsToKeep
}

# Delete the remaining items (files) forcefully
$itemsToDelete | Remove-Item -Force -Recurse

Write-Host "All files on the V drive, except for root-level folders, specified exclusions, and V:\ISO (unless explicitly referenced), have been deleted."



# Authenticate to Azure (you'll be prompted to log in)
Connect-AzAccount -DeviceCode

# Get all role assignments with "Identity not found" description
$invalidAssignments = Get-AzRoleAssignment | Where-Object { $_.ObjectType -eq 'Unknown' } | Remove-AzRoleAssignment

# Remove each invalid assignment
foreach ($assignment in $invalidAssignments) {
    Remove-AzRoleAssignment -Scope $assignment.Scope -SignInName $assignment.SignInName -RoleDefinitionName $assignment.RoleDefinitionName
}

# Disconnect from Azure
Disconnect-AzAccount
