$hciIP   = '172.16.12.10'
$hciHost = 'NUC-HCI01'
$labadmin = 'lab\scdadmin'
$clusterName = 'MyOnPremHCICluster'
$volume1 = 'files'

Enter-PSSession -Computername $hciHost -Credential $labadmin

Update-StorageProviderCache
    Get-StoragePool | ? IsPrimordial -eq $false | Set-StoragePool -IsReadOnly:$false -ErrorAction SilentlyContinue
    Get-StoragePool | ? IsPrimordial -eq $false | Get-VirtualDisk | Remove-VirtualDisk -Confirm:$false -ErrorAction SilentlyContinue
    Get-StoragePool | ? IsPrimordial -eq $false | Remove-StoragePool -Confirm:$false -ErrorAction SilentlyContinue
    Get-PhysicalDisk | Reset-PhysicalDisk -ErrorAction SilentlyContinue
    Get-Disk | ? Number -ne $null | ? IsBoot -ne $true | ? IsSystem -ne $true | ? PartitionStyle -ne RAW | % {
        $_ | Set-Disk -isoffline:$false
        $_ | Set-Disk -isreadonly:$false
        $_ | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false
        $_ | Set-Disk -isreadonly:$true
        $_ | Set-Disk -isoffline:$true
    }
    Get-Disk | Where Number -Ne $Null | Where IsBoot -Ne $True | Where IsSystem -Ne $True | Where PartitionStyle -Eq RAW | Group -NoElement -Property FriendlyName


    # Create single-node cluster
New-Cluster -Name $clusterName -Node $hciHost -NOSTORAGE
# Enable Storage Spaces Direct without storage cache
Enable-ClusterStorageSpacesDirect -CacheState Disabled

New-Volume -FriendlyName $volume1 -Size 200GB -ProvisioningType Thin