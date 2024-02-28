# Check if already connected to Azure
if (-not (Get-AzContext)) {
    # Not connected, so log in
    Connect-AzAccount -DeviceCode
}

# Remove the "DoNotDelete" lock on storage accounts in the resource group
$resourceGroupName = "lab-eastus-rg"

# Delete all resources with "hci" in their name
$resourcesToDelete = Get-AzResource -ResourceGroupName $resourceGroupName | Where-Object { $_.Name -like "*hci*" }
foreach ($resource in $resourcesToDelete) {
    Write-Host "Deleting resource $($resource.Name)..."
    try {
        Remove-AzResource -ResourceId $resource.ResourceId -Force
        Write-Host "Resource deleted successfully."
    } catch {
        Write-Host "Failed to delete resource: $_"
    }
}

# Delete AD service principals with "hci" in their name
$servicePrincipalsToDelete = Get-AzADServicePrincipal | Where-Object { $_.DisplayName -like "*hci*" }
foreach ($spn in $servicePrincipalsToDelete) {
    Write-Host "Deleting AD service principal $($spn.DisplayName)..."
    try {
        Remove-AzADServicePrincipal -ObjectId $spn.ID
        Write-Host "AD service principal deleted successfully."
    } catch {
        Write-Host "Failed to delete AD service principal: $_"
    }
}

# Log out of Azure (only if we logged in earlier)
#if ($null -ne (Get-AzContext)) {
#    Disconnect-AzAccount
#}
