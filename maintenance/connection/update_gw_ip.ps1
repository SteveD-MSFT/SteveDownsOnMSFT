# Define the path to the file that contains the current IP
$filePath = 'C:\path\to\your\file.txt'

# Get the current public IP
$publicIP = Invoke-RestMethod -Uri 'http://ipinfo.io/json' | Select-Object -ExpandProperty ip

# Get the current local network gateway IP from the file
$currentGatewayIP = Get-Content -Path $filePath

# Compare the current local network gateway IP with the public IP
if ($publicIP -ne $currentGatewayIP) {
    # If the IPs are different, connect to Azure and update the local network gateway IP

    # Import the required module
    Import-Module Az

    # Login to Azure
    Connect-AzAccount

    # Set the subscription
    Set-AzContext -SubscriptionId <replace_with_your_subscription_id>

    # Update the local network gateway IP
    Set-AzLocalNetworkGateway -Name <local_network_gateway_name> -ResourceGroupName <resource_group_name> -GatewayIpAddress $publicIP
    Write-Output "Local network gateway IP updated to $publicIP"

    # Store the new IP to the file
    $publicIP | Out-File -FilePath $filePath
} else {
    Write-Output "Local network gateway IP is up to date"
}
