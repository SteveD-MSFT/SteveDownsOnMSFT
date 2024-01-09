$HCIcredential = Get-Credential
$AsHciOUName = 'OU=VALAB,DC=lab,DC=windowsinthe,DC=cloud'
$AsHciPhysicalNodeList = @("VAHCI01")
$DomainFQDN = 'lab.windowsinthe.cloud'
$ashciClusterName = 'VAHCICLUSTER01'
$AsHciDeploymentPrefix = 'VAHCI'

New-HciAdObjectsPreCreation -Deploy -AzureStackLCMUserCredential $HCIcredential -AsHciOUName $AsHciOUName -AsHciPhysicalNodeList $AsHciPhysicalNodeList -DomainFQDN $DomainFQDN -AsHciClusterName $ashciClusterName -AsHciDeploymentPrefix $AsHciDeploymentPrefix