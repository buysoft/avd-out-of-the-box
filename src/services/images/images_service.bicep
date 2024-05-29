param location string = resourceGroup().location
param dateTime string = utcNow('yyyy-MM-ddTHH-mm-ssZ')

// Gallery and VM Image Definition Parameters
param galleryName string = 'galautomationdev001'
param vmImageDefinitionName string
param hyperVGeneration string
param architecture string
param osType string
param osState string
param identifier object
param recommended object
param disallowed object

// Image Template Paramaters
param imageTemplateName string = 'avd11ImageTemplate02'
param gallerImageSubscription string
param galleryImageResourceGroup string
param galleryImageName string
param userAssignedIdentityId string
param stagingResourceGroupName string
param buildTimeoutInMinutes int
param vmSize string
param osDiskSizeGB int
param source object
param replicationRegions array
param customize array

module vmImageDefinition '../../modules/Microsoft.Compute/galleries/images/images.bicep' = {
  name: '${vmImageDefinitionName}-${dateTime}'
  params: {
    location: location
    galleryName: galleryName
    vmImageDefinitionName: vmImageDefinitionName
    hyperVGeneration: hyperVGeneration
    architecture: architecture
    osType: osType
    osState: osState
    identifier: identifier
    recommended: recommended
    disallowed: disallowed
  }
}

module imageTemplate '../../modules/Microsoft.VirtualMachineImages/imageTemplates/imageTemplates.bicep' = {
  name: '${imageTemplateName}-${dateTime}'
  params: {
    location: location
    imageTemplateName: imageTemplateName
    gallerImageSubscription: gallerImageSubscription
    galleryImageResourceGroup: galleryImageResourceGroup
    galleryImageName: galleryImageName
    userAssignedIdentityId: userAssignedIdentityId
    stagingResourceGroupName: stagingResourceGroupName
    buildTimeoutInMinutes: buildTimeoutInMinutes
    vmSize: vmSize
    osDiskSizeGB: osDiskSizeGB
    source: source
    replicationRegions: replicationRegions
    customize: customize
  }
  dependsOn: [
    vmImageDefinition
  ]
}
