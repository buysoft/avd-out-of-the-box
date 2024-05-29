// Parameters
param newOrExisting string = 'new'
param location string
param workspaceName string
param hostpoolName string
param applicationGroupReferences array

// New
resource newWorkspace 'Microsoft.DesktopVirtualization/workspaces@2023-09-05' = if (newOrExisting == 'new') {
  name: workspaceName
  location: location
  properties: {
    applicationGroupReferences: applicationGroupReferences
  }
}

// Existing
resource existingWorkspace 'Microsoft.DesktopVirtualization/workspaces@2023-09-05' existing = if(newOrExisting == 'existing') {
  name: hostpoolName
}

// Output
output workspace object = newOrExisting == 'new' ? newWorkspace : existingWorkspace
output id string = newOrExisting == 'new' ? newWorkspace.id : existingWorkspace.id
output name string = newOrExisting == 'new' ? newWorkspace.name : existingWorkspace.name
