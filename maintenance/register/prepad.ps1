$HCIcredential = Get-Credential
$AsHciOUName = 'OU=VALAB,DC=lab,DC=windowsinthe,DC=cloud'
$AsHciPhysicalNodeList = @("VAHCI01")
$DomainFQDN = 'lab.windowsinthe.cloud'
$ashciClusterName = 'VAHCICLUSTER01'
$AsHciDeploymentPrefix = 'VAHCI'

# Download the module from GitHub
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Azure/AzureStack-Tools/master/HCI/AsHciADArtifactsPreCreationTool.psm1" -OutFile "C:\temp\AsHciADArtifactsPreCreationTool.psm1"

# Import the module
Import-Module "C:\temp\AsHciADArtifactsPreCreationTool.psm1"

# Install the module
Install-Module -Name AsHciADArtifactsPreCreationTool

New-HciAdObjectsPreCreation -Deploy -AzureStackLCMUserCredential $HCIcredential -AsHciOUName $AsHciOUName -AsHciPhysicalNodeList $AsHciPhysicalNodeList -DomainFQDN $DomainFQDN -AsHciClusterName $ashciClusterName -AsHciDeploymentPrefix $AsHciDeploymentPrefix