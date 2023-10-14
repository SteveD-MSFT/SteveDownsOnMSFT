# Define the source and destination paths
#$currentDate = Get-Date
#$dateString = $currentDate.ToString('yyyyMMdd')

$hciIP = '172.16.12.10'
$labadmin = 'lab\scdadmin'
$password = 'CapsFan12!'
$vhdFile = "win11_20231011.vhd"
$vhdXFile = "converted-win11_20231011-b.vhdx"
$localVHDPath = "C:\\temp\\"
$remoteVHDPath = "V:\\clusterVMs\\"
#$destinationVHDXPath = "V:\\clusterVMs\\"

# Define the credentials
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $labadmin, $securePassword

# Import the Hyper-V module
if (-not (Get-Module -ListAvailable -Name Hyper-V)) {
    # If not, import it
    Import-Module Hyper-V
}

# Convert the VHD to VHDX on the local machine
if (-not (Test-Path -Path $localVHDPath$vhdXFile)) {
    # If not, convert the VHD to VHDX on the local machine
    Convert-VHD -Path $localVHDPath$vhdFile -DestinationPath $localVHDPath$vhdXFile -VHDType Dynamic
}

# Create a new PSSession
$session = New-PSSession -ComputerName $hciIP -Credential $credential

# Copy the VHDX file to the remote path using the session created above
Copy-Item -Path $localVHDPath$vhdXFile -Destination $remoteVHDPath -ToSession $session

# Close the PSSession
Remove-PSSession -Session $session
