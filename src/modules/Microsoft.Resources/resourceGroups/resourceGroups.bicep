// Scope
targetScope = 'subscription'

// Parameters
param newOrExistingHostPool string = 'new'
param location string
param resourceGroupName string

// New
resource newResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = if (newOrExistingHostPool == 'new') {
  name: resourceGroupName
  location: location
}

// Existing
resource existingResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' existing = if (newOrExistingHostPool == 'existing') {
  name: resourceGroupName
}

// Output
output applicationGroup object = newOrExistingHostPool == 'new' ? newResourceGroup : existingResourceGroup
output id string = newOrExistingHostPool == 'new' ? newResourceGroup.id : existingResourceGroup.id
output name string = newOrExistingHostPool == 'new' ? newResourceGroup.name : existingResourceGroup.name
