Get-AzSubscription | ForEach-Object {
    $subscriptionName = $_.Name
    Set-AzContext -SubscriptionId $_.SubscriptionId

    $policies = Get-AzPolicyDefinition
    foreach ($policy in $policies){Remove-AzPolicySetDefinition -Id $policy.ResourceId -Force}
}