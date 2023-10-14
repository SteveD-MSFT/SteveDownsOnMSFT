# Check if the AzureAD module is installed
if (-not (Get-Module -ListAvailable -Name AzureAD)) {
    # If not installed, install the AzureAD module
    Install-Module -Name AzureAD
}

# Check if the AzureAD module is imported
if (-not (Get-Module -Name AzureAD)) {
    # If not imported, import the AzureAD module
    Import-Module AzureAD
}

# Check if an Azure AD session exists, if not, connect to Azure AD with MFA
try {
    Get-AzureADUser | Out-Null
} catch {
    Connect-AzureAD
}

# Get all groups of type 'Security'
$groups = Get-AzureADGroup -All $true | Where-Object {$_.SecurityEnabled -eq $true}

# Loop through each group and delete
foreach ($group in $groups) {
    Remove-AzureADGroup -ObjectId $group.ObjectId
}