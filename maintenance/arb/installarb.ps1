<# 

  This script should install AKS in combination with the Azure Resource Bridge on HCI 
  
  Warning: don't run from top to bottom all at once....
  run in snippets. 
  before you execute code - change names, paths (e.g. CSV location), and most important adopt to your IP address ranges 

    References:
    1) Installing AKS with PS: https://learn.microsoft.com/en-us/azure-stack/aks-hci/aks-hci-evaluation-guide-2b
    2) Installing ARB with PS: https://learn.microsoft.com/en-us/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address

  #>

$hciIP = '172.16.12.10'
$labadmin = "lab\scdadmin"
$password = '!'
$securePW = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($labadmin, $securePW)
$computerIP = $hciIP
$computerName = $computerIP
$vhdFile = "win11_20231011.vhd"
$vhdXFile = "converted-win11_20231011-b.vhdx"
$localVHDPath = "C:\\temp\\"
$remoteVHDPath = "V:\\clusterVMs\\"
$subscriptionName = 'Microsoft Azure'


#Vnet vars
$vNetName = "hci01-edge-vnet"
$vSwitchName = 'HCIVMSWITCH'    
$subscription =  $subscriptionName 
$resourceGroupName = "azure-eastus-rg"
$customLocName = "onpremcluter1-CL" 
$location = "eastus"


#$VMIP_1="<static IP address for Resource Bridge VM>" #(required only for static IP configurations)   
#$VMIP_2="<static IP address for upgrading Resource Bridge VM>" #(required only for static IP configurations)  
#$DNSServers= (Get-DnsClientServerAddress -InterfaceAlias 'vEthernet (HCIVMSWITCH)' | Select-Object -ExpandProperty ServerAddresses) -join ', ' #For example: @("192.168.250.250","192.168.250.255") for a list of DNS servers. Or "192.168.250.250" for a single DNS server" (required only for static IP configurations)
#$IPAddressPrefix="<network address in CIDR notation>" #(required only for static IP configurations)
#$Gateway="<IPv4 address of the default gateway>" #(required only for static IP configurations)
#$CloudServiceIP="<IP-address>" #(required only for static IP configurations)

Install-PackageProvider -Name NuGet -Force 
Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck

#Restart PoSH

Install-Module -Name Moc -Repository PSGallery -AcceptLicense -Force
Initialize-MocNode
Install-Module -Name ArcHci -Force -Confirm:$false -SkipPublisherCheck -AcceptLicense


#Restart Posh
$VswitchName='HCIVMSWITCH'
$ControlPlaneIP="172.16.20.5"
$csv_path="C:\ClusterStorage\VMs"

mkdir $csv_path\ResourceBridge

Set-MocConfig -workingDir $csv_path\ResourceBridge -imageDir $csv_path\imageStore -skipHostLimitChecks -cloudConfigLocation $csv_path\cloudStore -catalog aks-hci-stable-catalogs-ext -ring stable -createAutoConfigContainers $false

Install-Moc

$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi


az extension remove --name arcappliance
az extension remove --name k8s-extension
az extension remove --name customlocation
az extension remove --name azurestackhci

az extension add --upgrade --name arcappliance --version 0.2.33
az extension add --upgrade --name k8s-extension
az extension add --upgrade --name customlocation
az extension add --upgrade --name azurestackhci


$subscription="09951193-852c-44f6-a720-ccb1f897d1bd"
$resource_group="azure-eastus-rg"
$location="eastus"


az login --use-device-code
az account set --subscription $subscription
az provider register --namespace Microsoft.Kubernetes --wait
az provider register --namespace Microsoft.KubernetesConfiguration --wait
az provider register --namespace Microsoft.ExtendedLocation --wait
az provider register --namespace Microsoft.ResourceConnector --wait
az provider register --namespace Microsoft.AzureStackHCI --wait
az provider register --namespace Microsoft.HybridConnectivity --wait
$hciClusterId= (Get-AzureStackHci).AzureResourceUri
$resource_name= ((Get-AzureStackHci).AzureResourceName) + "-arcbridge"
$customloc_name= ((Get-AzureStackHci).AzureResourceName) + "-CL"



New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP -vswitchName $vswitchName

az arcappliance validate hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml

az arcappliance prepare hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml

az arcappliance deploy hci --config-file  $csv_path\ResourceBridge\hci-appliance.yaml --outfile "$csv_path\ResourceBridge\kubeconfig"

az arcappliance create hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --kubeconfig "$csv_path\ResourceBridge\kubeconfig"

az arcappliance show --resource-group $resource_group --name $resource_name --query '[provisioningState, status]'

az k8s-extension create --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --extension-type Microsoft.AZStackHCI.Operator --scope cluster --release-namespace helm-operator2 --configuration-settings Microsoft.CustomLocation.ServiceAccount=hci-vmoperator --config-protected-file $csv_path\ResourceBridge\hci-config.json --configuration-settings HCIClusterID=$hciClusterId --auto-upgrade true

az k8s-extension show --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --out table --query '[provisioningState]'

az customlocation create --resource-group $resource_group --name $customloc_name --cluster-extension-ids "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name/providers/Microsoft.KubernetesConfiguration/extensions/hci-vmoperator" --namespace hci-vmoperator --host-resource-id "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name" --location $location


# Deploy VNET

az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resourceGroupName --extended-location name="/subscriptions/$Subscription/resourceGroups/$resourceGroupName/providers/Microsoft.ExtendedLocation/customLocations/$customLocName" type="CustomLocation" --location $location --ip-allocation-method "Dynamic" --network-type "Transparent" --name $vNetName --vm-switch-name $vSwitchName