# Parameters
[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$azDesktopVirtualizationVersion = "4.3.1",
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$region = "West Europe",
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$templateParamterFileLocation,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$subscriptionId,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$HostPoolName,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$HostPoolResourceGroupName
)

# $azDesktopVirtualizationVersion = "4.3.1"
# $region = "West Europe"
# $templateParamterFileLocation = ".\newVM.bicepparam"
# $subscriptionId = "4244f0c4-0776-47a7-a422-885726a8c7b6"
# $HostPoolName = "hostpool-dev-test-001"
# $HostPoolResourceGroupName = "rg-avd-hostpool-dev-001"

# Check prerequisites
if(-not (Get-Module -Name Az.DesktopVirtualization -ListAvailable)) {
    Install-Module -Name Az.DesktopVirtualization -RequiredVersion $azDesktopVirtualizationVersion -Force -Scope CurrentUser
}

# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Get total of session hosts in host pool
$currentHosts = Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $HostPoolResourceGroupName

# Deploy new session hosts
New-AzSubscriptionDeployment -Location $region -TemplateParameterFile $templateParamterFileLocation -Verbose

# Check if new session hosts are ready
$ready = $false

do {
    # Get new session hosts and current status
    $newHosts = Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $HostPoolResourceGroupName | Where-Object {$_.AllowNewSession -eq $true}
    
    if($newHosts.Status -ne "Available") {
        # Set status to false since we are still waiting for new session hosts to be ready
        $ready = $false
        
        # Output status of new session hosts
        Write-Output "Waiting for new session hosts to be ready, current status:"
        $newHosts | Select-Object Name, Status

        # Wait 15 seconds before checking again
        Start-Sleep -Seconds 15
    }
    else {
        # Set status to true since new session hosts are ready
        $ready = $true
    }
} while ($ready -eq $false)

# Here we set current session hosts to not allow new sessions
$currentHosts | ForEach-Object {
    $server = ($_.Name).Replace("$HostPoolName/","")
    Write-Output "Updating $server"
    Update-AzWvdSessionHost -ResourceGroupName $HostPoolResourceGroupName -HostPoolName $HostPoolName -Name $server -AllowNewSession:$false
}