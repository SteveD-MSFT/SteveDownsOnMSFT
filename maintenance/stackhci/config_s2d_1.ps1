$hciIP   = '172.16.12.10'
$hciHost = 'NUC-HCI01'
$labadmin = 'lab\scdadmin'

Enter-PSSession -Computername $hciHost -Credential $labadmin

# Install Roles & features and restart server
Install-WindowsFeature -Name "BitLocker", "Data-Center-Bridging", "Failover-Clustering", "FS-FileServer", "FS-Data-Deduplication", "Hyper-V-PowerShell", "RSAT-AD-Powershell", "RSAT-Clustering-PowerShell", "NetworkATC", "Storage-Replica" -IncludeAllSubFeature -IncludeManagementTools
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
#Restart-Computer
