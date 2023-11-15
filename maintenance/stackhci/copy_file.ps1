# Define the source and destination file paths
$sourceFilePath = 'C:\Users\stdowns\OneDrive - Microsoft\Documents\GitHub\SteveDownsOnMSFT\maintenance\arb\installarb.ps1'
$destinationFilePath = 'C:\users\scdadmin\documents\'

# Define the remote computer name
$remoteComputerName = '172.16.12.10'

$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $labadmin, $securePassword

# Create a new PSSession
$session = New-PSSession -ComputerName $remoteComputerName -Credential $credential

# Copy the file to the remote machine
Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -ToSession $session

# Close the PSSession
Remove-PSSession -Session $session