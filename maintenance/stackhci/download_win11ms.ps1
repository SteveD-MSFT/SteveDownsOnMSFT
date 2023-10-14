# Define your variables
$hciIP = '172.16.12.10'
$labadmin = 'lab\scdadmin'
$password = 'CapsFan12!'
$fileURL = 'https://md-ln5rdx1jf5n3.z5.blob.storage.azure.net/t4vrdmh4ktnd/abcd?sv=2018-03-28&sr=b&si=a646f2d0-6663-4659-a1bb-f207616a4ffa&sig=GtD9UeqDmnpy7nhOzGzd0tMRtlhSZbIcg1kkfR%2BTtWE%3D'
$vhdFile = 'win11_20231010.vhd'

# Convert password to SecureString
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create PSCredential object
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $labadmin, $securePassword

# Create a new PowerShell session
$session = New-PSSession -ComputerName $hciIP -Credential $cred

# Define the destination path
$destinationPath = "F:\vhd"

# Download the file
Invoke-Command -Session $session -ScriptBlock {
    param($fileURL, $destinationPath, $vhdFile)
    Invoke-WebRequest -Uri $fileURL -OutFile "$destinationPath\$vhdFile"
} -ArgumentList $fileURL, $destinationPath, $vhdFile

# Close the session
Remove-PSSession -Session $session
