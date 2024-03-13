$HCIcredential = Get-Credential
$AsHciOUName = "OU=VAHCI01,DC=lab,DC=windowsinthe,DC=cloud"
$AsHciPhysicalNodeList = @("hciva02")
$DomainFQDN = 'lab.windowsinthe.cloud'
$ashciClusterName = 'HCICLS1'
$AsHciDeploymentPrefix = 'HCIVA'


# Install the module
#Install-Module -Name AsHciADArtifactsPreCreationTool
Install-Module AsHciADArtifactsPreCreationTool -Repository PSGallery -Force


New-HciAdObjectsPreCreation -Deploy -AzureStackLCMUserCredential $HCIcredential -AsHciOUName $AsHciOUName -AsHciPhysicalNodeList $AsHciPhysicalNodeList -DomainFQDN $DomainFQDN -AsHciClusterName $ashciClusterName -AsHciDeploymentPrefix $AsHciDeploymentPrefix
.\AsHciADArtifactsPreCreationTool.ps1 -AsHciDeploymentUserCredential (get-credential) -AsHciOUName "OU=Hci001,DC=contoso,DC=local,DC=stbtest,DC=microsoft,DC=com" -AsHciPhysicalNodeList @("Physical Machine1", "Physical Machine2") -DomainFQDN "'contoso.local " -AsHciClusterName "s-cluster" -AsHciDeploymentPrefix "Hci001"

#New-HciAdObjectsPreCreation -AzureStackLCMUserCredential $HCIcredential -AsHciOUName $AsHciOUName