# Step 1: Register Providers
Microsoft.ContainerInstance -> could the User Assigned Identity be granted automatically to register Resource Providers? In this way we can automate that through a custom role perhaps?

# Step 2: get existing context
$currentAzContext = Get-AzContext

# Destination image resource group
$imageResourceGroup = "rg-sharedimagegallery-dev-001"

# Location (see possible locations in the main docs)
$location = "westeurope"

# Your subscription. This command gets your current subscription
$subscriptionID = $currentAzContext.Subscription.Id

# Image template name
$imageTemplateName =" avd10ImageTemplate01"

# Distribution properties object name (runOutput). Gives you the properties of the managed image on completion
$runOutputName = "sigOutput"

$sigGalleryName = "galautomationdev001"
$imageDefName ="win11avd"

# Image template name
$imageTemplateName = "avd11ImageTemplate01"

## Below is used to create a User Assigned Identity
## We will do this with BICEP
# # setup role def names, these need to be unique
# $timeInt = $(get-date -UFormat "%s")
$imageRoleDefName = "Azure Image Builder Image Def"
$identityName = "uai-galautomationdev001"
# 
# ## Add Azure PowerShell modules to support AzUserAssignedIdentity and Azure VM Image Builder
# 'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {Install-Module -Name $_ -AllowPrerelease}
# 
# # Create the identity
# New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location

$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id
$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId

$aibRoleImageCreationUrl="https://raw.githubusercontent.com/azure/azvmimagebuilder/main/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json"
$aibRoleImageCreationPath = "aibRoleImageCreation.json"

# Download the config
Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing

((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath

# Create a role definition
New-AzRoleDefinition -InputFile  ./aibRoleImageCreation.json

# Grant the role definition to the VM Image Builder service principal
New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"

# Next we will create the image gallery, we will do this with BICEP
# Also we will check the image publisher, offer and sku. You can also do this in Get-AVDImages.ps1

# Create the gallery definition
New-AzGalleryImageDefinition -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher 'myCo' -Offer 'Windows' -Sku '10avd'

# Create the image version
$templateFilePath = "C:\Repositories\Azure DevOps\Customers\vck-infra-iac\imageTemplate.bicep"
New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -Verbose

# Optional - if you have any errors running the preceding command, run:
$getStatus=$(Get-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName)
$getStatus.ProvisioningErrorCode 
$getStatus.ProvisioningErrorMessage

# Start Image Builder Template
Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName -NoWait