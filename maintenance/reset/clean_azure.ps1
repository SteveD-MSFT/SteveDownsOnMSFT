$clusterName = 'HCICLS1'
# Authenticate with Azure using device code
if (-not (Get-AzContext)) {
    # Not connected, so log in
    Connect-AzAccount -DeviceCode
}

# Retrieve the subscription ID dynamically
if (-not $subscription) {
    $subscription = (Get-AzContext).Subscription.Id
}

# Retrieve the resource group name dynamically
if (-not $rg) {
    $rg = "lab-eastus-rg"  # Replace with your actual resource group name
}

# Retrieve the tenant ID dynamically

if (-not $tenant) {
    # Set the tenant ID here
    # For example:
    $tenant = (Get-AzContext).Tenant.Id
}

#Get the Access Token for the registration
$ARMtoken = (Get-AzAccessToken).Token

#Get the Account ID for the registration1
$id = (Get-AzContext).Account.Id

# Now you can use the $subscription, $rg, and $tenant variables in your script
Write-Host "Subscription ID: $subscription"
Write-Host "Resource Group: $rg"
Write-Host "Tenant ID: $tenant"

Install-Module -Name Az.StackHCI -Force

Unregister-AzStackHCI -SubscriptionId $subscription -TenantID $tenant -ComputerName $clusterName