# Set your custom variables here
#$your_VHDX_path = "V:\VHDs"
#$VM_config_Files_path = "V:\VMs"
$your_VM_name = "hciva01B"
#$virtual_switch_name = "extHyperV01"  # Add your desired virtual switch name here
#$OSISO = "V:\ISO\HCI23h2.iso"



$vmState = (Get-VM -Name $your_VM_name).State
if ($vmState -ne "Running") {
    Start-VM -Name $your_VM_name
    Write-Host "Waiting for VM to start..."
    while ((Get-VM -Name $your_VM_name).State -ne "Running") {
        Start-Sleep -Seconds 5
    }
    Write-Host "VM is now running."
}

$Node1macNIC1 = Get-VMNetworkAdapter -VMName $your_VM_name -Name "NIC1"
$Node1macNIC1.MacAddress
$Node1finalmacNIC1=$Node1macNIC1.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC1

$Node1macNIC2 = Get-VMNetworkAdapter -VMName $your_VM_name -Name "NIC2"
$Node1macNIC2.MacAddress
$Node1finalmacNIC2=$Node1macNIC2.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC2

$Node1macNIC3 = Get-VMNetworkAdapter -VMName $your_VM_name -Name "NIC3"
$Node1macNIC3.MacAddress
$Node1finalmacNIC3=$Node1macNIC3.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC3

$Node1macNIC4 = Get-VMNetworkAdapter -VMName $your_VM_name -Name "NIC4"
$Node1macNIC4.MacAddress
$Node1finalmacNIC4=$Node1macNIC4.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC4

$cred = get-credential

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {param($Node1finalmacNIC1) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC1} | Rename-NetAdapter -NewName "NIC1"} -ArgumentList $Node1finalmacNIC1

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {param($Node1finalmacNIC2) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC2} | Rename-NetAdapter -NewName "NIC2"} -ArgumentList $Node1finalmacNIC2

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {param($Node1finalmacNIC3) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC3} | Rename-NetAdapter -NewName "NIC3"} -ArgumentList $Node1finalmacNIC3

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {param($Node1finalmacNIC4) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC4} | Rename-NetAdapter -NewName "NIC4"} -ArgumentList $Node1finalmacNIC4


Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC1" -Dhcp Disabled}

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC2" -Dhcp Disabled}

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC3" -Dhcp Disabled}

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC4" -Dhcp Disabled}

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Remove-NetIPAddress -InterfaceAlias "NIC1"}
Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {New-NetIPAddress -InterfaceAlias "NIC1" -IPAddress 172.16.60.10 -PrefixLength 12 -AddressFamily IPv4 -DefaultGateway 172.16.0.1 }
#Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {New-NetIPAddress -InterfaceAlias "NIC1" -IPAddress 192.168.12.60 -PrefixLength 24 -AddressFamily IPv4 -DefaultGateway 192.168.12.1} 

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Set-DnsClientServerAddress -InterfaceAlias "NIC1" -ServerAddresses '10.1.0.4'}
#Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Set-DnsClientServerAddress -InterfaceAlias "NIC1" -ServerAddresses '192.168.12.1'}

Invoke-Command -VMName $your_VM_name -Credential $cred -ScriptBlock {Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All }
Restart-VM $your_VM_name -Force