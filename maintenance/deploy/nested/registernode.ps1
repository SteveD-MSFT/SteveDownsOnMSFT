#$subscription = '0325dd32-ebf8-403e-86b0-365c7d3306d9';
#$tenant = '97960771-c18f-42a6-89b6-57720ccd169d';
$rg = "lab-eastus-rg" 
$Region = 'eastus'


#Register PSGallery as a trusted repo
#Register-PSRepository -Default -InstallationPolicy Trusted

#Install Arc registration script from PSGallery 
Install-Module AzsHCI.ARCinstaller -force

#Install required PowerShell modules in your node for registration
Install-Module Az.Accounts -Force
Install-Module Az.ConnectedMachine -Force
Install-Module Az.Resources -Force

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

#Invoke the registration script. For this release, eastus and westeurope regions are supported.
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region $Region -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id