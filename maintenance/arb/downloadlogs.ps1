# Local file path
$localFile = "C:\temp\archcilogs.zip"

# Remote file path
$remoteFile = "\\172.16.12.10\C$\ClusterStorage\files\Archci\archcilogs.zip"

# Enable PowerShell remoting on local machine
Enable-PSRemoting -Force

# Create credential object for remote machine
$remoteUser = "lab\scdadmin"
$remotePass = 'CapsFan12!'
$remoteSecPass = ConvertTo-SecureString $remotePass -AsPlainText -Force
$remoteCred = New-Object System.Management.Automation.PSCredential ($remoteUser, $remoteSecPass)

# Create remote session with remote machine
$remoteSession = New-PSSession -ComputerName 172.16.12.10 -Credential $remoteCred

# Invoke command to download file using BITS transfer module
Invoke-Command -Session $remoteSession -ScriptBlock {
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $using:remoteFile -Destination $using:localFile
}

# Remove remote session
Remove-PSSession -Session $remoteSession
