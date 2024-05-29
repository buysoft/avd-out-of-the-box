// Parameters
param newOrExisting string = 'new'
param location string = resourceGroup().location
param galleryName string
param vmImageDefinitionName string
param hyperVGeneration string = 'V2'
param architecture string = 'x64'
param osType string = 'Windows'
param osState string = 'Generalized'
param identifier object = {
  publisher: 'MicrosoftWindowsDesktop'
  offer: 'office-365'
  sku: 'win11-23h2-avd-m365'
}
param recommended object = {
  vCPUs: {
    min: 2
    max: 16
  }
  memory: {
    min: 2
    max: 32
  }
}
param disallowed object = {}

// Existing Gallery
resource existingGallery 'Microsoft.Compute/galleries@2022-08-03' existing = if(newOrExisting == 'existing') {
  name: galleryName
}

// New
resource newVMImageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' = if (newOrExisting == 'new') {
  parent: existingGallery
  name: vmImageDefinitionName
  location: location
  properties: {
    hyperVGeneration: hyperVGeneration
    architecture: architecture
    osType: osType
    osState: osState
    identifier: {
      publisher: identifier.publisher
      offer: identifier.offer
      sku: identifier.sku
    }
    recommended: recommended
    disallowed: disallowed
  }
}

// Existing
resource existingVMImageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' existing = if(newOrExisting == 'existing') {
  name: vmImageDefinitionName
}

// Output
output vmImageDefinition object = newOrExisting == 'new' ? newVMImageDefinition : existingVMImageDefinition
output id string = newOrExisting == 'new' ? newVMImageDefinition.id : existingVMImageDefinition.id
output name string = newOrExisting == 'new' ? newVMImageDefinition.name : existingVMImageDefinition.name
