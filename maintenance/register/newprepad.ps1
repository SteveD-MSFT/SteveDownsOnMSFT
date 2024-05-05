#$HCIcredential = Get-Credential
$AsHciOUName = "OU=VAHCI01,DC=lab,DC=windowsinthe,DC=cloud"
#$AsHciPhysicalNodeList = @("hciva02")
#$DomainFQDN = 'lab.windowsinthe.cloud'
#$ashciClusterName = 'HCICLS1'
#$AsHciDeploymentPrefix = 'HCIVA'


# Install the module
#Install-Module -Name AsHciADArtifactsPreCreationTool
Install-Module AsHciADArtifactsPreCreationTool -Repository PSGallery -Force

New-HciAdObjectsPreCreation -AzureStackLCMUserCredential (Get-Credential) -AsHciOUName $AsHciOUName

#New-HciAdObjectsPreCreation -AzureStackLCMUserCredential $HCIcredential -AsHciOUName $AsHciOUName