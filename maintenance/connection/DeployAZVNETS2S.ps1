#Connects to Azure
if (-not (Get-AzContext)) {
    Connect-AzAccount
}

#Resource Group Name
$resourcegrpname = 'S2S-eastus-rg'
#Creates a resource group for the storage account
New-AzResourceGroup -Name $resourcegrpname -Location 'eastus'
# Parameters splat, for Azure Bicep
# Parameter options for the Azure Bicep Template, this is where your Azure Bicep parameters go
$paramObject = @{
'sitecode' = 'scd'
'environment' = 'prod'
'contactEmail' = 'sdowns@stevendowns.com'
'sharedkey' = 'ljk'
'onpremisesgwip' = '9dfsdf'
'onpremisesaddress' = '172.16.0.0/12'
}
# Parameters for the New-AzResourceGroupDeployment cmdlet goes into.
$parameters = @{
'Name' = 'AzureNetwork-S2S'
'ResourceGroupName' = $resourcegrpname
'TemplateFile' = "C:\Users\stdowns\OneDrive - Microsoft\Documents\GitHub\SteveDownsOnMSFT\maintenance\connection\Deploy-AZVNETS2S.bicep"
'TemplateParameterObject' = $paramObject
'Verbose' = $true
}
#Deploys the Azure Bicep template
New-AzResourceGroupDeployment @parameters