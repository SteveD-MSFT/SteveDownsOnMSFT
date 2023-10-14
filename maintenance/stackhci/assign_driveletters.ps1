$hciIP   = '172.16.12.10'
$labadmin = 'lab\scdadmin'
$password = 'CapsFan12!'

# Specify the credentials for the remote session
$User = $labadmin
$Password = ConvertTo-SecureString -String $password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password

# Create a new PSSession
$Session = New-PSSession -ComputerName $hciIP -Credential $Credential

# Define the script block
$ScriptBlock = {
    # Get the volume with the friendly name "files"
    $volumeFiles = Get-Volume | Where-Object { $_.FriendlyName -eq 'files' }

    # If the volume exists, assign the drive letter "F"
    if ($volumeFiles) {
        Set-Partition -DriveLetter $volumeFiles.DriveLetter -NewDriveLetter 'F'
    } else {
        Write-Output "Volume with the friendly name 'files' not found."
    }

    # Get the volume with the friendly name "VMs"
    $volumeVMs = Get-Volume | Where-Object { $_.FriendlyName -eq 'VMs' }

    # If the volume exists, assign the drive letter "V"
    if ($volumeVMs) {
        Set-Partition -DriveLetter $volumeVMs.DriveLetter -NewDriveLetter 'V'
    } else {
        Write-Output "Volume with the friendly name 'VMs' not found."
    }
}

# Run the script block on the remote computer
Invoke-Command -Session $Session -ScriptBlock $ScriptBlock

# Close the PSSession
Remove-PSSession -Session $Session