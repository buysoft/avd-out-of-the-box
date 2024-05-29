// Parameters
param newOrExisting string = 'new'
param location string = resourceGroup().location
param dateTime string = utcNow('yyyyMMddHHmmss')
param imageTemplateName string
param gallerImageSubscription string
param galleryImageResourceGroup string
param galleryImageName string
param userAssignedIdentityId string
param stagingResourceGroupName string
param buildTimeoutInMinutes int = 120
param vmSize string = 'Standard_DS2_v2'
param osDiskSizeGB int = 128
param source object
param replicationRegions array = [
  'westeurope'
]
param customize array

// Variables
var galleryImageSub = empty(gallerImageSubscription) ? subscription().subscriptionId : gallerImageSubscription
var galleryImageRG = empty(galleryImageResourceGroup) ? resourceGroup().name : galleryImageResourceGroup

// New
resource newImageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2023-07-01' = if (newOrExisting == 'new') {
  name: imageTemplateName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: buildTimeoutInMinutes
    stagingResourceGroup: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${stagingResourceGroupName}'
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: osDiskSizeGB
    }
    source: source
    customize: customize
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: resourceId(galleryImageSub, galleryImageRG,'Microsoft.Compute/galleries/images', galleryImageName)
        runOutputName: '${imageTemplateName}-${dateTime}'
        artifactTags: {
          date: dateTime
          baseosimg: source.sku
        }
        replicationRegions: replicationRegions
      }
    ]
  }
}

// Existing
resource existingImageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2023-07-01' existing = if(newOrExisting == 'existing') {
  name: imageTemplateName
}

// Output
output imageTemplate object = newOrExisting == 'new' ? newImageTemplate : existingImageTemplate
output id string = newOrExisting == 'new' ? newImageTemplate.id : existingImageTemplate.id
output name string = newOrExisting == 'new' ? newImageTemplate.name : existingImageTemplate.name
