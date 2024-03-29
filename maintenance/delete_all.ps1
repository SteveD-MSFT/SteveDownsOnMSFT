Connect-AzAccount

Get-AzSubscription | ForEach-Object {
    $subscriptionName = $_.Name
    Set-AzContext -SubscriptionId $_.SubscriptionId

    Get-AzResource | Remove-AzResource -force
       
    $rgName = Get-AzResourceGroup | where-object ResourceGroupName -notcontains "cloud-shell-storage-usgovvirginia"

    Foreach($name in $rgName)
    {
    $foo = $name.ResourceGroupName
    Write-Host "Subscription: $subscriptionName"
    Write-Host "Resource Group: $foo"

        Remove-AzResourceGroup -Name $name.ResourceGroupName -Force -verbose
    }
}


    
$storageAccounts = Get-AzureStorageAccount -ResourceGroupName $name.ResourceGroupName

Foreach ($sa in $storageAccounts) {
    Get-AzureStorageContainer -ResourceGroupName $name.ResourceGroupName -AccountName $sa.StorageAccountName | Remove-AzureStorageContainerLegalHold -Tag "audit"
}