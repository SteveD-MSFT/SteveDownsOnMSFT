# Check if Az modules are installed
$requiredModules = "Az.Accounts", "Az.Resources"

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module $module..."
        Install-Module -Name $module -Repository PSGallery -Force
    }
}

# Connect to Azure if not already connected
if (-not (Get-AzContext)) {
    # Not connected, so log in
    Connect-AzAccount -DeviceCode
}

# Retrieve information about the Microsoft.AzureStackHCI resource provider
Get-AzResourceProvider -ProviderNamespace "Microsoft.AzureStackHCI"

Unregister-AzResourceProvider -ProviderNamespace "Microsoft.HybridCompute"
Unregister-AzResourceProvider -ProviderNamespace "Microsoft.GuestConfiguration"
Unregister-AzResourceProvider -ProviderNamespace "Microsoft.HybridConnectivity"
Unregister-AzResourceProvider -ProviderNamespace "Microsoft.AzureStackHCI"

Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridCompute"
Register-AzResourceProvider -ProviderNamespace "Microsoft.GuestConfiguration"
Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridConnectivity"
Register-AzResourceProvider -ProviderNamespace "Microsoft.AzureStackHCI"
