Get-AzSubscription | ForEach-Object {
    $subscriptionName = $_.Name
    Set-AzContext -SubscriptionId $_.SubscriptionId

       
    Get-AzResourceLock | Remove-AzResourceLock -Force

}