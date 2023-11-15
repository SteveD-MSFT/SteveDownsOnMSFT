$hciIP = '172.16.12.10'
$labadmin = 'lab\scdadmin'
$password = 'CapsFan12!'
$vhdFile = 'win11_20231010.vhd'
$vhdXFile = 'converted-win11_20231010.vhdx'
$localVHDPath = "C:\\temp\\"
$remoteVHDPath = "F:\\VHD\\"
$destinationVHDXPath = "V:\\clusterVMs\\"

# Define the credentials
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $labadmin, $securePassword

# Create a remote session
$session = New-PSSession -ComputerName $hciIP -Credential $credential

# Enter the remote session
Enter-PSSession -Session $session
