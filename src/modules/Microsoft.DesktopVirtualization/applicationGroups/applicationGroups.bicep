// Parameters
param newOrExisting string = 'new'
param location string
param appGroupName string
param hostpoolName string
param friendlyName string
param description string = 'Deskop Application Group created through Abri Deploy process.'

// New
resource newApplicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' = if (newOrExisting == 'new') {
  name: appGroupName
  location: location
  properties: {
    friendlyName: friendlyName
    applicationGroupType: 'Desktop'
    description: description
    hostPoolArmPath: resourceId('Microsoft.DesktopVirtualization/hostpools', hostpoolName)
  }
}

// Existing
resource existingApplicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' existing = if(newOrExisting == 'existing') {
  name: appGroupName
}

// Output
output applicationGroup object = newOrExisting == 'new' ? newApplicationGroup : existingApplicationGroup
output id string = newOrExisting == 'new' ? newApplicationGroup.id : existingApplicationGroup.id
output name string = newOrExisting == 'new' ? newApplicationGroup.name : existingApplicationGroup.name
