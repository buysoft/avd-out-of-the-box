// Parameters
param newOrExisting string = 'new'
param location string = resourceGroup().location
param name string

// New
resource newGallery 'Microsoft.Compute/galleries@2022-08-03' = if (newOrExisting == 'new') {
  name: name
  location: location
  properties: {
    identifier: {}
  }
}

// Existing
resource existingGallery 'Microsoft.Compute/galleries@2022-08-03' existing = if(newOrExisting == 'existing') {
  name: name
}

// Output
output gallery object = newOrExisting == 'new' ? newGallery : existingGallery
output id string = newOrExisting == 'new' ? newGallery.id : existingGallery.id
output name string = newOrExisting == 'new' ? newGallery.name : existingGallery.name
