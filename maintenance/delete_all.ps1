Get-AzSubscription | ForEach-Object {
    $subscriptionName = $_.Name
    Set-AzContext -SubscriptionId $_.SubscriptionId

    Get-AzResource | Remove-AzResource -force
       
    $rgName = Get-AzureRmResourceGroup | where-object ResourceGroupName -notcontains "cloud-shell-storage-usgovvirginia"

    Foreach($name in $rgName)
    {
    $foo = $name.ResourceGroupName
    Write-Host "Subscription: $subscriptionName"
    Write-Host "Resource Group: $foo"
    
    $storageAccounts = Get-AzureRmStorageAccount -ResourceGroupName $foo

    Foreach ($sa in $storageAccounts) {
        Get-AzureRmStorageContainer -ResourceGroupName $name.ResourceGroupName -AccountName $sa.StorageAccountName | Remove-AzureRmStorageContainerLegalHold -Tag "audit"
    }
    Get-AzResource | Remove-AzResource -force
    Remove-AzureRmResourceGroup -Name $foo -Verbose -Force

    }
}