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
