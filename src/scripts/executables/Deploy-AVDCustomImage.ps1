# Parameters
[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$userAssignedIdentityName,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$userAssignedIdentityResourceGroup,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$userAssignedIdentitySubscriptionId,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$imageTemplateName,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$resourceGroupName,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$stagingResourceGroupName,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$stagingResourceGroupLocation = "westeurope",
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$subscriptionId,
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$expiresOn = (Get-Date).AddDays(1),
    
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$reason = "Temporary exemption for creating AVD Image Template"
)

# Variables
# $userAssignedIdentityName = "uai-galautomationdev001"
# $userAssignedIdentityResourceGroup = "rg-sharedimagegallery-dev-001"
# $userAssignedIdentitySubscriptionId = "4244f0c4-0776-47a7-a422-885726a8c7b6"
# $imageTemplateName = "avd11ImageTemplate"
# $resourceGroupName = "rg-sharedimagegallery-dev-001"
# $stagingResourceGroupName = "rg-temp-createimageavdwin11"
# $stagingResourceGroupLocation = "westeurope"
# $subscriptionId = "4244f0c4-0776-47a7-a422-885726a8c7b6"
# $expiresOn = (Get-Date).AddDays(1)  # Set the expiration date for the exemption, if temporary. Adjust as needed.
# $reason = "Temporary exemption for creating AVD Image Template"  # Reason for exemption, adjust as needed.

# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Check if the Resource Group exists
$resourceGroup = Get-AzResourceGroup -Name $stagingResourceGroupName -ErrorAction SilentlyContinue

if (-not $resourceGroup) {
    # Create the Resource Group if it does not exist
    $resourceGroup = New-AzResourceGroup -Name $stagingResourceGroupName -Location $stagingResourceGroupLocation
    Write-Output "Resource Group '$stagingResourceGroupName' created in location '$stagingResourceGroupLocation'."
} else {
    Write-Output "Resource Group '$stagingResourceGroupName' already exists."
}

# Get the Resource Group ID
$resourceGroupId = $resourceGroup.ResourceId

# Retrieve the user-assigned identity
$userAssignedIdentity = Get-AzUserAssignedIdentity -Name $userAssignedIdentityName -ResourceGroupName $userAssignedIdentityResourceGroup -SubscriptionId $userAssignedIdentitySubscriptionId
$userAssignedIdentityObjectId = $userAssignedIdentity.PrincipalId

# Assign the Contributor role to the user-assigned identity at the Resource Group level
New-AzRoleAssignment -ObjectId $userAssignedIdentityObjectId -RoleDefinitionName "Contributor" -Scope $resourceGroupId
Write-Output "Contributor role assigned to user-assigned identity at the Resource Group level."

# Function to generate a unique but short exemption name
function Generate-ExemptionName {
    param (
        [string]$policyAssignmentName,
        [string]$resourceGroupName
    )
    # Create a hash based on the policy assignment name and resource group name
    $combinedName = "$policyAssignmentName-$resourceGroupName"
    $hash = (Get-FileHash -InputStream ([System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($combinedName))) -Algorithm MD5).Hash
    # Combine parts of the names with the hash to ensure uniqueness and brevity
    ## Check policy assignment name length
    if($policyAssignmentName.Length -gt 20){
        $policyAssignmentNameLength = 20
    }
    else
    {
        $policyAssignmentNameLength = $policyAssignmentName.Length
    }
    ## Check resource group name length
    if($resourceGroupName.Length -gt 20){
        $resourceGroupNameLength = 20
    }
    else
    {
        $resourceGroupNameLength = $resourceGroupName.Length
    }
    ## Check hash length
    if($hash.Length -gt 20){
        $hashLength = 20
    }
    else
    {
        $hashLength = $hash.Length
    }

    return "$($policyAssignmentName.Substring(0, $policyAssignmentNameLength))-$($resourceGroupName.Substring(0, $resourceGroupNameLength))-$($hash.Substring(0, $hashLength))"
}

# Get all policy assignments at the subscription level
$policyAssignments = Get-AzPolicyAssignment -Scope "/subscriptions/$subscriptionId"

# Loop through each policy assignment and create an exemption for the Resource Group
foreach ($policyAssignment in $policyAssignments) {
    # $policyAssignmentId = $policyAssignment.PolicyAssignmentId
    # $exemptionName = "$($policyAssignment.Name)-$($resourceGroupName)-Exemption"
    $exemptionName = Generate-ExemptionName -policyAssignmentName $policyAssignment.Name -resourceGroupName $resourceGroupName
    
    # Create the exemption
    New-AzPolicyExemption -Name $exemptionName `
        -PolicyAssignment $policyAssignment `
        -Scope $resourceGroupId `
        -ExpiresOn $expiresOn `
        -Description $reason `
        -ExemptionCategory "Waiver"
    
    Write-Output "Exemption created for Policy Assignment: $($policyAssignment.Name)"
}

# Confirm completion
Write-Output "All applicable policy assignments have been exempted for the Resource Group: $resourceGroupName"

# Deploy VM Image Template
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateParameterFile ".\imageTemplate.bicepparam" -Verbose

# Start the Image Builder Template
Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName -NoWait

# Check the status of the Image Builder Template
do {
    # Check the status of the Image Builder Template
    $getStatus = Get-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName

    $dateTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

    # Output the status
    Write-Output "[$dateTime] - Runnig State: $($getStatus.LastRunStatusRunState)"

    if($getStatus.LastRunStatusRunState  -eq "Running")
    {
        # Wait for 30 seconds before checking the status again
        Write-Output "[$dateTime] - Waiting for 30 seconds"
        
        Start-Sleep -Seconds 30
    }

} while ($getStatus.LastRunStatusRunState  -eq "Running")

# Check if the Image Builder Template has succeeded

## If the Image Builder Template has succeeded, remove the Image Template and the Resource Group
if($getStatus.LastRunStatusRunState  -eq "Succeeded")
{
    # Remove the Image Template
    Remove-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName
    
    # Remove the Resource Group
    Remove-AzResourceGroup -Name $stagingResourceGroupName -Force
}